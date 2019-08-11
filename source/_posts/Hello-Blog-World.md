---
title: Hello Blog World
date: 2019-04-28 21:36:20
tags:
  - hello world
categories: 
  - new start
mathjax: true
---

## Hello World！

For the first time I build my own blog !

Let's **write** something!

- Add a hyper-link:

  [MXNet: A Scalable Deep Learning Framework](https://mxnet.apache.org/)

- Use a Block:

  My best function in C++ is `lower_bound`.

- Try a piece of code:

  ```C++
  printf("Hello World");
  ```

- **Tips on Typora:**  行内公式属于LaTeX扩展语法，并非Markdown的通用标准，需要在Typora的“文件”-“偏好设置”中，勾选“内联公式”一项，Typora才会予以解析。

# Optimizer: Momentum

- **EMA** (Exponential-weighted moving average):
  $$
  y^{(t)}:= {\rho}*y^{(t-1)} + {(1-\rho)}*x^{t}
  $$
  This is a way to "remember" a period-time of the arguments:

- **Momentum**

  $\vec{v}$ is velocity:
  $$
  {\vec{v}} := {\gamma}*{\vec{v}}+{\eta}*{\nabla}{f_\beta}{(\vec x)}
  $$
  also can be written as :

$$
{\vec{v}} := {\gamma}*{\vec{v}}+{(1-\gamma)}*{\frac {\eta}{(1-\gamma)}}*{\nabla}{f_\beta}{(\vec x)}
$$

​		then we update the arguments $\vec x$ :
$$
\vec x := \vec x - \vec v
$$

# To Do List

- Maybe get used to **writing a post or report** everyday.
- Now I have to learn to **write  docs for my malaria project**!
- ~~Still don't know what to do.~~

# Intern

- Join **MEGVII** at July.

