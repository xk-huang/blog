---
title: 简单图像风格迁移——MXNet/gluon实现
date: 2019-06-09 23:39:40
tags:
  - neural style
  - mxnet
  - gluon
  - 风格迁移
categories:
  - deep learning
---

1. You can see more details in my [github repository](<https://github.com/x1aokeHuang/Neural-style-MXNet>)

2. This demo is based on [Gatys, L. A., Ecker, A. S., & Bethge, M. (2016). Image style transfer using convolutional neural networks. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (pp. 2414-2423).](https://www.cv-foundation.org/openaccess/content_cvpr_2016/papers/Gatys_Image_Style_Transfer_CVPR_2016_paper.pdf)

3. This simple demo is implemented with MXNet/gluon.

4. Here are some samples:

   <div align="center">
    <img src="/images/neural_style/Forest.jpg" height="223px">
    <img src="/images/neural_style/style_0.jpg" height="223px">
    <img src="/images/neural_style/out_3.png" width="670px">
   </div>

   <div align="center">
    <img src="/images/neural_style/Forest.jpg" height="223px">
    <img src="/images/neural_style/style_1.jpg" height="223px">
    <img src="/images/neural_style/out_4.png" width="670px">
   </div>

   <div align="center">
    <img src="/images/neural_style/BNU.jpg" height="223px">
    <img src="/images/neural_style/style_0.jpg" height="223px">
    <img src="/images/neural_style/out_1.png" width="633px">
   </div>

   <div align="center">
    <img src="/images/neural_style/BNU.jpg" height="223px">
    <img src="/images/neural_style/style_1.jpg" height="223px">
    <img src="/images/neural_style/out_2.png" width="633px">
   </div>

5. Training on:

   | GPU             | OS                           |
   | --------------- | ---------------------------- |
   | NVIDIA TITAN Xp | Windows Server 2016 Standard |

