---
title: 【paper reading note】8-bit Inference with TensorRT
date: 2019/07/27 17:00:00
categories:
  - paper reading note
  - quantization
tags:
  - tensorrt
  - quantization
  - paper reading note
---



# 1. 量化的背景

尽管模型大小正在不断地被压缩，但其计算量通常在100M - 200M FLOPS，对于目前移动端CPU算力来说还是太大。因此，不论从提高推理速度还是减少能耗的方面考虑，对模型进行量化都是必要的。

接下来是对 NVIDIA 的 TensorRT [8-bit Inference with TensorRT](http://on-demand.gputechconf.com/gtc/2017/presentation/s7310-8-bit-inference-with-tensorrt.pdf)  的总结。希望对 TensorRT 的总结可以启发未来的工作。

# 2. 算法流程

![1564138349681](https://x1aokehuang.github.io/images/tensorrt/1564138349681.png)

TensorRT 对模型的每一层的 activations 做量化：

- 获得该layer激活值的直方分布图。

> 比如直方分布bins的个数设多少个？
> 直方分布bins的宽度设置多少？
> 激活值一般是指ReLU之后的值，但是收集这样的激活值对于我们得量化任务一定有效？

- 在不同的截断阀值下产生许多的量化分布。

> 截断之后选择多少个bins压入一个bin，边界bin如何处理？
> 尾数(被截断的数据)如何处理？

- 选择KL散度最小的阀值。

> 为什么选择KL散度？
> 计算KL散度前对分布做 smooth 处理，其数学原因是什么？

# 3. 获得Activations的概率分布

在代码中实现求得bins：寻找数据的最大值，直接调用numpy函数，histogram直接在0 ～ +max范围内求得2048个bins，那么每个bins对应的宽度为: +max / 2048;

```python
def initial_histograms(self, blob_data):
    # collect histogram of every group channel blob
    th = self.blob_max
    hist, hist_edge = np.histogram(blob_data, bins=2048, range=(0, th))
    self.blob_distubution += hist
```

注意bins数目的选取，导致精度和量化速度的权衡。

# 4. 最大值映射导致显著精度损失

![1564138380427](https://x1aokehuang.github.io/images/tensorrt/1564138380427.png)

数据分布不均匀的时候，应该主动地选择丢掉一部分数据，保留信息的主体部分。

# 5. 激活值的直方分布选取

TensorRT选取激活值的正半区，原因是模型的激活函数使用ReLU，每层conv的输出为正数。

注意如果使用其他激活函数，可能需要考虑负半区的激活值。

# 6. 依据饱和截断的直方图分布计算量化分布

![1564138433970](https://x1aokehuang.github.io/images/tensorrt/1564138433970.png)

首先利用 Activations 的最大值 把 Activations 分配到2048个bins中，得到改率分布：

```python
hist, hist_edge = np.histogram(blob_data, bins=2048, range=(0, max))
```

第二步，对伪代码中的尾数(截断数据)求和，保证两个分布具有相同的采样空间：

```python
threshold_sum = sum(distribution[i:])
```

最后把量化后的 128 bins 反展开为 i 个 bins，具体细节参考 NCNN 的实现：

```python
def threshold_distribution(distribution, target_bin=128):
    """
    Return the best threshold value.
    Ref: https://github.com//apache/incubator-mxnet/blob/master
                    /python/mxnet/contrib/quantization.py
    Args:
        distribution: list, activations has been processed by 
        histogram and normalize,size is 2048
        target_bin: int, the num of bin that is used by quantize,
        Int8 default value is 128
    Returns:
        target_threshold: int, num of bin with the minimum KL
    """
    distribution = distribution[1:]
    length = distribution.size
    threshold_sum = sum(distribution[target_bin:])
    kl_divergence = np.zeros(length - target_bin)

    for threshold in range(target_bin, length):
        sliced_nd_hist = copy.deepcopy(distribution[:threshold])

        # generate reference distribution p
        p = sliced_nd_hist.copy()
        p[threshold - 1] += threshold_sum
        threshold_sum = threshold_sum - distribution[threshold]

        # is_nonzeros[k] indicates whether hist[k] is nonzero
        is_nonzeros = (p != 0).astype(np.int64)
        #
        quantized_bins = np.zeros(target_bin, dtype=np.int64)
        # calculate how many bins should be merged to generate 
        # quantized distribution q
        num_merged_bins = sliced_nd_hist.size // target_bin

        # merge hist into num_quantized_bins bins
        for j in range(target_bin):
            start = j * num_merged_bins
            stop = start + num_merged_bins
            quantized_bins[j] = sliced_nd_hist[start:stop].sum()
        quantized_bins[-1] += sliced_nd_hist[target_bin * num_merged_bins:].sum()

        # expand quantized_bins into p.size bins
        q = np.zeros(sliced_nd_hist.size, dtype=np.float64)
        for j in range(target_bin):
            start = j * num_merged_bins
            if j == target_bin - 1:
                stop = -1
            else:
                stop = start + num_merged_bins
            norm = is_nonzeros[start:stop].sum()
            if norm != 0:
                q[start:stop] = float(quantized_bins[j]) / float(norm)
        # q[p == 0] = 0
        p = _smooth_distribution(p) 
        q = _smooth_distribution(q)
        # p[p == 0] = 0.0001
        # q[q == 0] = 0.0001

        # calculate kl_divergence between q and p
        kl_divergence[threshold - target_bin] = stats.entropy(p, q)

    min_kl_divergence = np.argmin(kl_divergence)
    threshold_value = min_kl_divergence + target_bin

    return threshold_value
```

# 7. 对分布做 Smooth 处理

![1564138478050](https://x1aokehuang.github.io/images/tensorrt/1564138478050.png)

防止 q 的某个 bin 统计值为 0，导致 KL 散度为无穷。具体方法是对值为 0 的 bins 赋一个很小的 eps 。

参考 MxNet 的实现：

```python
def _smooth_distribution(p, eps=0.0001):
    """Given a discrete distribution (may have not been normalized to 1),
    smooth it by replacing zeros with eps multiplied by a scaling factor 
    and taking the corresponding amount off the non-zero values.
    Ref: http://web.engr.illinois.edu/~hanj/cs412/bk3/KL-divergence.pdf
    """
    is_zeros = (p == 0).astype(np.float32)
    is_nonzeros = (p != 0).astype(np.float32)
    n_zeros = is_zeros.sum()
    n_nonzeros = p.size - n_zeros
    if not n_nonzeros:
        raise ValueError('The discrete probability distribution is malformed. All entries are 0.')
    eps1 = eps * float(n_zeros) / float(n_nonzeros)
    assert eps1 < 1.0, 'n_zeros=%d, n_nonzeros=%d, eps1=%f' % (n_zeros, n_nonzeros, eps1)
    hist = p.astype(np.float32)
    hist += eps * is_zeros + (-eps1) * is_nonzeros
    assert (hist <= 0).sum() == 0
    return hist
```

# 8. 思考

NVIDIA 并没有给出具体的校准算法，留下了很多坑，个中细节还需要不断实验才能确定，才能最终达到加速模型且少掉精度的目的。