---
title: Bat 脚本快速入门
date: 2019-05-11 15:00:01
tags:
  - bat script
  - cmd
categories:
  - bat script
---

# 简介

- Bat脚本，也就是大众熟知的批处理脚本，它运行在windows系统上。使用cmd.exe打开bat脚本，解释器会运行脚本里每一条命令。现在微软已经开发了功能更强的powershell。在Linux系统中也有对应的shell脚本。熟练掌握bat可以大大简化日常工作量，提高工作效率。
- 我学习bat的另一个原因，是在实验室的windows server上批量训练神经网络。

# 学习资源汇总

- [How To Write A Simple Batch (.bat) File](http://www.makeuseof.com/tag/write-simple-batch-bat-file/)  bat入门
- [Batch Script Samples](http://www.ericphelps.com/batch/)  bat进阶
- [Batch Script Tutorial](http://www.tutorialspoint.com/batch_script/index.htm)   bat入门
- [Windows Batch Scripting](https://en.wikibooks.org/wiki/Windows_Batch_Scripting)  wikibooks，权威精简且全面
- [Guide to Windows Batch Scripting](http://steve-jansen.github.io/guides/windows-batch-scripting/)   github博客

# 快速入门

1. 掌握常用命令：

   - `echo`

     `echo [sentence] `可以直接输出sentence的内容，不必在句子两旁加引号

     `echo` 显示此行之后的命令

     `echo off` 不显示此行之后的命令

   - `@`

     添加至某行命令之前，表示不显示此行命令

   - `call`

     调用其他文件(.bat、python脚本等) ，被调用文件执行结束后，**返回**当前执行文件

     注意，如果不使用`call`，被调用文件执行结束后，**不会**返回当前执行文件

   - `pause`

     在此行暂停批处理文件，并在屏幕上显示"Press any key to continue..."，按下`press`则批处理文件继续执行。

   - `REM`

     不执行此行，即此行为注释

2. `goto` 转跳指令

   - 调用`goto`，批处理文件将转跳至**指定的标号处**， 可以与if配合。

     ~~~powershell
     :start
     REM do something...
     goto start
     ~~~
   
3. 重定向（待填坑）

# 几个小例子

1. 实验室的服务器配置不完善，导致每次只能连接两个用户。我需要实时查询是否有其他用户在线（在线的话就用teamviewer）：

   ~~~powershell
   @echo off
   :start
   query user
   choice /t 5 /d y /n >nul
   goto start
   ~~~

2. 实时监控显卡的使用情况

   ~~~powershell
   @echo off
   nvidia-smi --format=csv --query-gpu=utilization.gpu,fan.speed,temperature.gpu,memory.used,power.draw -l -s
   ~~~
   
3. 神经网络训练脚本。由于服务器管理员的水平问题，他的配置被添加到了系统路径，导致我每次使用conda的activate文件都需要传入绝对路径

   ~~~powershell
   @echo off
   call D:\user_name\Anaconda3\Scripts\activate gluon
   
   call python test1.py
   call python test2.py
   ...
   
   pause
   ~~~

# 小结

批处理文件bat拥有很久远的历史。当比尔盖茨开发MS-DOS时，就在它的Command.com命令解释器中，纳入了批处理功能：把命令保存在.bat扩展名的文本文件中，命令解释器会运行它里面的每一个命令。

现在，微软开发了Powershell来代替cmd，并将PowerShell定位为Windows操作系统和微软企业应用程序的默认管理工具。

PowerShell比cmd要简单地多。许多时候，一行PowerShell命令行，能够替代成百上千的批处理代码。

