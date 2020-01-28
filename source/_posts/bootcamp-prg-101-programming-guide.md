---
title: 【Bootcamp】 编程指南
date: 2019/07/11 14:00:00
categories: 
  - bootcamp
tags:
  - bootcamp
  - 编程指南
---



# python快速上手

## 1. 类和实例

### 类

- 类也是对象
- 类对象持有@classmethod修饰的函数，类函数
- 类对象持有属性，类属性
- 类对象持有函数，实例函数
- 初始化函数为self赋值属性，实例属性
- 类对象持有特殊函数：
  - `__new__` `__init__`
  - `__enter` `__exit__`
  - `__iter__` `__next__`

### 实例化

- 从Object类

## 2. import 

- site-packages -> find module 

## 3. 修饰器

- 修饰器f1修饰了g1

- 定义修饰器函数：接收一个函数，执行逻辑，之后返回函数 functools

## 4. 生成器

- 定义函数，有yeild

- 调用无效，返回gererator object

- 使用next()

- 各个generator维护各自的PC
- DataProvider

## 5. Code Style

- 语义化：

  Boolean函数/变量语义化：check_uploaded, is_uploaded

  函数映射变量的语义化：path = key2path('string')，nori_key2lable = {}; label = nori_key2label['key']dd

  单复数：face, Object; faces, List or Iterable

  词性：submit => submission， 动词是函数、可调用，名词是对象、实例

- 函数 空一行 空两行

- [Code Style](https://docs.python-guide.org/writing/style/)

# 多进程

## 1. 并发库与GIL

- 多线程(Thread)

  threading

  多进程(Process)

  multiprocessing

  fork

  subprocess

  高层封装

  concurrent.futures

- GIL

  全局锁，多线程的数据

  CPU密集并行，只能**多进程**

  IO密集并行，可多进程or多线程

## 2. 多进程

- 例子：

  使用multiprocessing.Process创建进程

  p.deamon=True

  p.start()

  p.join()

  multiprocessing.Pipe 进程间的通信

- 逻辑需自己编写

# Numpy Vectorize opeation

numpy 调用底层的c openblas， intel mlk

特性：对数据块的操作，原地执行

## 1. 两vec相加

np.add

## 2. 点积

np.dot(a,b.T)

## 3. **两组**向量的L2距离

(a-b)^2 = a^2 - 2*a*b + b^2

## 更多链接

见PPT

# 常用工具库

## functools

标准库，修饰器

functools.wraps(f)

functools.partial()

functools.lru_cache

## collections

collections.defaultdict 简化代码，不用检查不存在的key，不存在的key为默认值

collections.deque list

collections.Counter 统计list，在线动态维护，快速合并相减，histgrams

## itertools

itertools.chain 串联多个迭代器为一个迭代器，节省内存，如chain多个list

itertools.cycle 构造无限的循环迭代器

itertools.heapq 堆

## subprocess

执行python之外的指令，如cmd指令， out = subprocess.call('ls -l', shell=True)

## logging

配置log

结构化组织l多个log：rootLogger

## cv2

OpenCV

cv2.imshow， cv2.imread

## glob

路径匹配

## profile

查找性能瓶颈

cProfile.run()

## timeit

重复执行一段code的时间