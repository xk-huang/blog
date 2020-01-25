---
title: 【Paper Reading Note】Quantizing deep convolutional networks for efficient inference A whitepaper
date: 2019/08/16 18:00:00
categories:
  - paper reading note
  - quantization
tags:
  - paper reading note
  - quantization
---

URL: https://arxiv.org/pdf/1806.08342.pdf

## TL;DR
作者介绍了 TensorFlow 最早的量化工具。工具提供了三种量化方式：只量化 weights 、同时量化 weights 和 activations 、量化训练 [(B. Jacob 2017)](https://arxiv.org/pdf/1712.05877.pdf)。
此工具同时也支持了 [B. Jacob 2017](https://arxiv.org/pdf/1712.05877.pdf) 的量化实验。

作者比较了不同量化颗粒度下，训练后量化 (post-training quantization) 以及模拟训练量化 (quantization aware training) 的实验结果。

作者推荐使用对 weights 做逐通道量化 (per-channel quant.)、对 activations 做逐层量化 (per-layer quant.)。如果观察到较大的精度损失，使用量化训练减少损失。

## Dataset/Algorithm/Model/Experiment Detail

### 量化算子
使用 uniform quantizer：
-  Uniform Affine Quantizer (asymmetry)：非对称量化，参数包括 scale 和 zero-point。
-  Uniform symmetric quantize：对称量化，参数包括 scale，此时 zero-point 为 0。
- Stochastic quantizer：对 fp32 加入 [-1, 1] 的随机扰动，对计算梯度有益。（私以为此方法包容了超出范围的数值，使其不被 clip，求出非零梯度）
- Simulated quantizer：通过一对 quantizer 和 de-quantizer，模拟量化时的 effect，由于 quantizer 的梯度为 0 ，所以反向传播时将其梯度近似为 1 。
![image](/images/quant-whitepaper/f7352a14f96e03c31e748aec5dec5fe1e198d82f.png)

### 量化参数
- 作者对 weights 使用最大、最小值计算 scale。
- 对 activations 使用其最大、最小值的 EMA 计算 scale 。

### 量化颗粒度
- 对 weights，可以使用 per-channel 量化或者 per-layer 量化。
- 对 activations，使用 per-layer 量化（per-channel 量化导致复杂的点积、卷积运算）。

### 实验结果
- 参数多的模型 (ResNet) 即使不使用量化训练，精度的损失也很小。
- 参数少的模型 (MobileNet) 如果不使用量化训练，精度损失大；使用量化训练后，精度损失小。

### 量化训练
- 对 weights 仍使用浮点数计算，若使用 int8，可能因为梯度过小而下溢，无法更新 weights。
![image](/images/quant-whitepaper/5d45469107790eea0eb91855d4451fbe5f8b6406.png)
- 对 Add、Concat 算子需要额外处理：需要输入的 scale range 相同。
![image](/images/quant-whitepaper/aee87d92901d698056fd0025d23937dcbe1bd19c.png)
- 对 BN 的处理。由于训练时每个 batch 数值扰动很大，单纯的 BN 效果不佳。
解决方法：把训练分为三个阶段，在一阶段使用单纯的 BN，二阶段使用移动平均的 BN 统计值，三阶段 freeze 统计值。
![image](/images/quant-whitepaper/324a2dec0f8a8ad464b545bdc15bc75cbb8c9dd6.png)
作者观察到，相对于使用单纯的 BN或者使用移动平均的 BN 统计值，上述的改进不仅减少了训练时扰动，而且提高了精度。

### 实践经验
- 在量化训练中，使用预训练模型比从头训练效果更好。
- 不要截断 activations 的数值，实验观察到 ReLU 效果比 ReLU6 效果好。
- 在 BN 中使用移动平均时要小心（作者推荐文章的方法）。

### 展望
- 更多种类的算子的量化
- 在线地解压模型中的 weights 和 activations 的数值以压缩访存。

## Thoughts
- 可以使用正则化提升量化精度。（暂时没有找到文章）
- 知识蒸馏提升量化精度 [(Asit Mishra & Debbie Marr, 2017)](https://arxiv.org/pdf/1711.05852.pdf)。
- 除了 uniform 量化算子，还有 non-uniform 量化技巧，比如 KNN [(Song Han, 2015)](https://arxiv.org/pdf/1510.00149.pdf)。
- 强化学习在 per-layer 量化中的应用 [(Yihui He, 2018)](https://arxiv.org/pdf/1802.03494.pdf)。