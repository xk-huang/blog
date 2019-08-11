---
title: IPython小试
date: 2019/07/14 13:40:00
categories:
  - 生产力工具
tags:
  - IPython
---

# 与python shell的区别

当我们需要快速验证代码运行结果是否符合预期。最快捷方便的做法就是使用Python自带的交互模式，但是这个Python Shell有非常多的弊端：

- 不能在退出时保存历史记录以备未来查询。
- 不支持Tab自动补全。
- 不能快速获得模块/函数/类的信息，如参数、文档、原始代码等。
- 不方便在交互环境下执行Shell命令。

# IPython使用

IPython是一个基于Python Shell的交互式解释器，但是有比默认Shell强大得多的编辑和交互功能。

## 编辑交互功能

1. 获得对象信息：在想要查看的对象之前加上一个或者两个问号，就能获得多种对象信息。
  - 一个问号只是显示对象的签名，文档字符串以及代码文件的位置
  - 二个问号可以直接显示源代码，这样直接节省了用编辑器打开代码文件然后搜索对应代码的时间。
2. 调用系统Shell命令。只需要在命令前加!即可：
3. Tab自动补全：IPython可以自动检查对象的属性，通过`object_name.<TAB>`列出全部的子属性，再使用Tab切换到对应的属性上，然后回车就可以了。
4. 历史记录。IPython把输入的历史记录存放在个人配置目录下的`history.sqlite`文件中，并且可结合%rerun、%recall、%macro、%save等Magic函数使用。尤为有意义的是，它把最近的三次执行记录绑定在_、__和___这三个变量上。搜索历史记录时，还支持Ctrl-r、 Ctrl-n和Ctrl-p等快捷键。

## Magic函数

第二类是IPython有很多Magic函数（可以使用%lsmagic获得全部可用的Magic函数）

1. `%run`：运行python脚本，并把变量保存在目前shell环境中
2. `%debug`：激活交互的调试器，可以直**pdb**或者**ipdb**去调试问题了。
3. `%hist`：`%history`的别名，查看历史记录。
4. `%load`：把外部代码加载进来。
5. `%rehashx`：把$PATH中的可执行命令都更新进别名系统，这样就可以在IPython中不加感叹号而调用命令行指令
6. `%timeit`：获得程序执行时间。`timeit`是Python内置的库，用来测量小代码片的执行时间。
7. `%save`：把某些历史记录保存到文件中。
8. `%logstart/logoff`：记录会话。退出IPython后还可以回到之前的状态。
9. `%edit`：使用编辑器打开，但需要设定EDITOR这个环境变量。假如写了一个很复杂的函数，代码
    很长，执行后发现不符合预期，用历史记录找到这个函数，然后用鼠标移到对应的位置修改很不方
    便。其实这时应该使用edit来编辑
10. `%macro`：把历史记录、文件等封装为宏，以便未来重新执行。

# 在程序中使用ipdb交互式debug

``

```python
from IPython.core.debugger import set_trace

# ...
set_trace()
# ...

```

在`set_trace()`处设置断点，使用IPython进行ipdb

## 一些基本指令

- h(elp) 帮助
- n(ext) 运行下一行
- q(uit) / exit 离开ipdb
- locals() 查看变量

