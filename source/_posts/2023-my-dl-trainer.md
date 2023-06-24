---
title: Check list for Pytorch Runner (Especially Distributed Training & Evaluation)
date: 2023-06-24 20:22:41
categories:
tags:
---

(A check list for myself. At least human-readable :thinking:)

## Initialization
1. DDP arguments and device
	1. `torch.cuda.set_device(ddp_local_rank)`
2. output directory: make dir
3. logger
	1. file handler
		1. if you want to log w/ datetime, remember to `barrier`
	2. (optional) log the output directory
4. save config files
5. seed
	1. each process gets a different seed (`seed + ddp_rank`)
	2. NOTE: the seed should be the same during data split (maybe not exists) and model initialization.
	3. However, DDP forces the parameters to be the same across processes, so we do not need to
	4. https://github.com/pytorch/pytorch/blob/1dba81f56dc33b44d7b0ecc92a039fe32ee80f8d/torch/nn/parallel/distributed.py#LL798C63-L798C63#
6. initialize context for amp training
	1. depending on the chosen dtype
7. data loader
	1. create dataset
		1. If there are data downloading action, remember to barrier other process,  We only need the master process of each node (`local_ddp_rank==0`) to download the dataset
		2. split dataset, if using Huggingface's `datasets`. 
			1. The split sub-dataset may have different length. This may be problematic for epoch-based trainer, while step-based trainer, it is fine.
	2. create dataloader (by default, `DataLoader` uses `RandomSampler`)
		1. The yield of dataloader is a **list** of samples if `collate_fn=lambda x: x`
		2. If you do not use Huggingface's `dataset`, you need to use `DistributedSampler` in `Dataloader` 
			1. the difference between `DistributedSampler` and `RandomSampler`
				1. DistributedSampler(https://pytorch.org/docs/stable/_modules/torch/utils/data/distributed.html#DistributedSampler) generate a `torch.Generator` every time it is iterated. Thus it needs `set_epoch` to change the seed value each time. 
					1. it is a compromise to the design which split the data inside the sampler, then the index of all the data is shuffled globally.
					2. It needs a base seed which is same for all the processes.
				2. RandomSampler(https://pytorch.org/docs/stable/_modules/torch/utils/data/sampler.html#RandomSampler) get a generator when it is initialized, not changed every time it is iterated.
		3. If you incorporate **numpy** randomness in `Dataset`, set `worker_fn` to break the problem of same randomness among processes
		4. if you use **`opencv`** in `Dataset`, set the thread to one, or some function occupies all the threads.
	3. a helper function to **move data from CPU to GPU** form HuggingFace's `transformers`
8. model
	1. initialization
		1. from scratch
		2. from resume
			1. note that in DDP, the `map_location` must specify or the tensors woule be loaded to the original device; 
			2. set to `map_location=cpu` may crash the VRAM
		3. Free the memory for the loaded file `ckpt=None` or `del ckpt`
	2. move to device
9. grad scaler for amp training **if `dtype=float16`**
10. optimizer
	1. set `param.requires_grad={True,False`} to determine trainable parameters
	2. to gather `param_groups = List[param_dict]`
		1. get all parameters
		2. filter: keep `requires_grad == True`
		3. decay: `p.dim() >= 2`  Any parameters that is 2D will be weight decayed
	3. (optional) try "fused" AdamW `"fused" in inspect.signature(torch.optim.AdamW).parameters`
11. (optional) compile model
12. wrap model in to DDP container
	1. get `raw_model` to save ckpt w/o `"module."`

## Training
(note about global variable, if it is non-editable variable and is modified in a function, use `global` to claim it is global)
1. `model.train()`
2. adjust lr based on step, change lr manually `for param_group in optimizer.param_groups: param_group["lr"] = lr`
3. eval model and save weight
	1. eval: distributed eval (check below)?
	2. log: only the master process log?
	3. save weight: **only** the master process save
4. training step
	1. gradient_accumulation_steps
	2. in **model forward and loss computation**, **use amp context**
		1. `loss is float32 because ``mse_loss`` layers ``autocast`` to float32.`; `output is float16 because convertable layers ``autocast`` to float16.`
		2. You don't need to manually change inputs' ``dtype`` when enabling mixed precision.
		3. if use `gradient_accumulation_steps`, the loss need to be **divided** by `gradient_accumulation_steps`
	3. **scale the loss** then **backward gradients**
	4. clip gradient: first `unscale_` optimizer, then `clip_grad_norm_`
	5. update model w/ scaler
		1. to update model  `scaler.step(optimizer)`
		2. update scaler: `scaler.update()`
	6. flush the gradients `optimizer.zero_grad(set_to_none=True)`
	7. log: training metrics and **time for model and data**

Evaluation: tips about distributed evaluation
The results of each card might be different (if use amp/float16)
1. `model.eval()`
2. in loss computation, we sum up all the loss per mini-batch
	1. if one average the loss for a batch, then the loss needs to multiply back the **divided numbers**
	2. the **divided numbers** may not be the same as back size. 
		1. e.g., the number of masks per sample, the number of tokens per caption per sample
3. We also need to track and sum up the divided numbers
4. reduce all the tracked and summed values. `dist.all_reduce`

