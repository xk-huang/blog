---
title: pandas 学习记录
date: 2019-05-02 21:00:18
tags:
  - pandas
categories: 
  - pandas
mathjax: true
---

五一节参加学校的数学建模比赛，我们队伍选择了大数据题：通过社交网络（微博）数据，分析居民对“平安宜居”社会建设的满意度。为了处理数据，我们快速入门了pandas，一个基于**numpy**开发的数据分析软件。以下内容是对学习过程中要点的记录。

# 1. 按列更改值时

按列更改值时，如对定义的df，尝试修改"B"标签（后文将延续这种假设和表达），则需要调用`df.B[statement] = pandas.core.series.Series`。

注意修改某列时，左值一定要包含被修改的列名(列标)。

# 2. 对字符类型的处理

对于object对象，我们可以使用`df.B.str.*`类方法完成对字符数据的处理。

包括`cat`连接，`contains`是否包含，`match`正则表达式等。

 # 3. 对NaN值（缺失值）的处理

由布尔矩阵`df.B.isnull()`得出的布尔表达式筛选即可；

或使用`dropnull()`方法。

# 4. 快速加一行

`df.loc[df.shape[0]] = [the same length list]`

或

`df.loc[df.shape[0]] = {the same length dictionary}`

注意，此方法仅适用于数字列标。非数字列标需要调用`df.loc[other type index]`。

# 5.快速加一列

优雅的行尾添加方法，下方法适用于行标是index；行标是标签同理。

`df['new column name'] = [the same length list]`

# 6. 对行\列索引

pandas的列索引十分方便，`df['B']`或`df.B`即可取出一列，type为`pandas.core.series.Series`；

列索引则使用基于索引的`df.iloc[]`或基于标签的`df.loc[]`：

- `df.iloc[0:3,'a':'b']`(pandas.core.frame.DataFrame)

- `df.loc[2]`(pandas.core.series.Series)

**注意**`df.loc[]`的区间范围是左闭右闭，而`df.iloc[]`的区间范围是左闭右开。

# 5. 保存为CSV格式时的编码问题

如果希望使用Excel打开CSV格式文件，且不出现编码问题，则保存文件时需要调用`df.to_csv("name",encoding = 'ansi')`，即使用ansi编码文件。

`encoding`的可选参数还包括`utf-8`。

`to_csv`的类方法的常用参数还包括：

- `header = Boolean`，表示是否保存表头。
- `index = Boolean`，表示是否保存数字列标。