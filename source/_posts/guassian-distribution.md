---
title: 标准正态分布的方差 (对标准正态分布 PDF 验证)
date: 2019-06-03 17:22:00
tags:
  - 数学
  - 概率
  - 正态分布
  - 方差
  - 积分
categories: 
  - 数学
mathjax: true
---

------

背景：求标准正态分布的方差：

原问题为：
$$
\int_{-\infty}^{\infty}{\frac 1 {\sqrt {2\pi}}}t^2e^{\frac {-t^2} 2} \mathrm{d}t
$$
通过对$e^{\frac {-t^2} 2}$的分部积分,问题变为求：
$$
\int_{-\infty}^{\infty}{\frac 1 {\sqrt {2\pi}}}e^{\frac {-t^2} 2} \mathrm{d}t
$$

实际上，被积函数为标准正态分布的概率密度函数(Probability Density Function, PDF)。

这里侧面验证了标准正态分布的PDF的正确性(即从负无穷到正无穷的积分为1)。

------

Let, $f(x) = {\frac 1 {\sqrt {2\pi}}}e^{\frac {-x^2} 2}$
$$
Let, I = {\int_{-\infty}^{\infty} f(x)\mathrm{d}x}
$$

$$
then, I =\int_{-\infty}^{\infty}{\frac 1 {\sqrt {2\pi}}}e^{\frac {-x^2} 2} \mathrm{d}x = \int_{-\infty}^{\infty}{\frac 1 {\sqrt {2\pi}}}e^{\frac {-y^2} 2} \mathrm{d}y
$$

$$
then,I^2 = \int_{-\infty}^{\infty}\int_{-\infty}^{\infty}{\frac 1 {\sqrt {2\pi}}}e^{\frac {-x^2} 2} {\frac 1 {\sqrt {2\pi}}}e^{\frac {-y^2} 2} \mathrm{d}x \mathrm{d}y
$$

$$
then, I^2 = \int_{-\infty}^{\infty}\int_{-\infty}^{\infty}{\frac 1  {2\pi}}e^{\frac {-(x^2+y^2)} 2} \mathrm{d}x \mathrm{d}y
$$

------

Let, x = $r\cos\theta$, y = $r\sin\theta$:
$$
so, dxdy = abs(jacobian)*\mathrm{d}r\mathrm{d}\theta
$$

$$
where,jacobian = \begin{vmatrix}\cos\theta & \sin\theta \\ -r\sin\theta & r\cos\theta \end{vmatrix}
$$

$$
so,abs(jacobian) = r
$$

$$
so,dxdy = r\mathrm{d}r\mathrm{d}\theta
$$

$$
so, I^2 = {\frac 1 {2\pi}} {\int_0^{2\pi}\int_0^\infty e^{-r^2/2}r\mathrm{d}r\mathrm{d}\theta}
$$

$$
then, I^2 =\int_0^\infty e^{-r^2/2}r\mathrm{d}r
$$

$$
then,I^2= {\frac 1 2}\int_0^\infty e^{-r^2/2}\mathrm{d}r^2 = \int_0^\infty e^{-t^2/2}\mathrm{d}t = 1
$$

$$
so, I = 1
$$

------

总结：反常积分。通过极坐标变化为二重积分求解。

