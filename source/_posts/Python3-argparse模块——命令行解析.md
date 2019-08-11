---
title: Python3 argparse模块——命令行解析
date: 2019-06-07 14:00:00
tags:
  - Python3
  - argparse
categories:
  - Python3
---

# 简介

[argparse](<https://docs.python.org/3.7/howto/argparse.html>)模块是Python标准库推荐的命令行解析模块。

[getopt](<https://docs.python.org/3.7/library/getopt.html#module-getopt>)模块与C语言的getopt()等价；optparse已经被Python废除，但argparse基于optparse，且两者具有相似的语法。

# 基础

```python
import argparse
parser = argparse.ArgumentParser()
parser.parse_args()
```

输出结果为

```shell
$ python3 prog.py
$ python3 prog.py --help
usage: prog.py [-h]

optional arguments:
  -h, --help  show this help message and exit
```

其中 `-h`和`--help`为默认的帮助选项

# Arguments and Postional Arguments

```python
import argparse
def parse_args():
    parse = argparse.ArgumentParser("My argparser.")
    parse.add_argument("echo",type=str, help="echo something.")
    parse.add_argument("-i","--input_file", type=str, help="name of the input file.")
    parse.add_argument("-o","--output_file", type=str, help="name of the output file")
    return parse.parse_args()
opt = parse_args()
print(opt)
```



```shell
$ python my_argparse.py -h
usage: My argparser. [-h] [-i INPUT_FILE] [-o OUTPUT_FILE] echo

positional arguments:
  echo                  echo something.

optional arguments:
  -h, --help            show this help message and exit
  -i INPUT_FILE, --input_file INPUT_FILE
                        name of the input file.
  -o OUTPUT_FILE, --output_file OUTPUT_FILE
                        name of the output file

$ python my_argparse.py hello
Namespace(echo='hello', input_file=None, output_file=None)
```

其中`add_argument()`方法指定了程序希望接受的命令行参数，`type`指定接收参数的类型；`help`为帮助指令；在参数名称中，如果不加`--`则为必须传递的参数，加`--`为可选参数，在可选参数之前加上另一个`-`为可选参数的短参数。

parse_args()方法返回一个'argparse.Namespace'对象，具体可通过其名称访问。