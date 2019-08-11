---
title: SSH：远程登录与端口转发(2)
date: 2019/07/07 20:46:00
categories:
  - SSH
tags:
  - SSH
---

# SSH

Secure Shell（安全外壳协议，简称**SSH**）是一种加密的网络传输协议，可在不安全的网络中为网络服务提供安全的传输环境。 **SSH**通过在网络中建立安全隧道来实现**SSH**客户端与服务器之间的连接。

1995年，芬兰学者Tatu Ylonen设计了SSH协议，将登录信息全部加密，成为互联网安全的一个基本解决方案，迅速在全世界获得推广，目前已经成为Linux系统的标准配置。

老样子，先推荐教材：《SSH权威指南》

# 远程登录

```bash
ssh user@host
```

SSH的默认端口是22，如果SSH端口是其他端口，使用 p 参数

```bash
ssh -p 8080 user@host
```



# 口令(密码)登录

## 中间人攻击

- 如果攻击者插在用户与远程主机之间（比如在公共的wifi区域），用伪造的公钥，获取用户的登录密码。再用这个密码登录远程主机，那么SSH的安全机制就荡然无存了。这种风险就是著名的["中间人攻击"](http://en.wikipedia.org/wiki/Man-in-the-middle_attack)（Man-in-the-middle attack）。

## 解决中间人攻击

- 第一次登录对方主机，系统会出现提示：无法确认host主机的真实性，只知道它的公钥指纹，问你还想继续连接吗？远程主机必须在自己的网站上贴出公钥指纹，以便用户自行核对。

- 假定经过风险衡量以后，用户决定接受这个远程主机的公钥。然后，会要求输入密码。如果密码正确，就可以登录了。

- 当远程主机的公钥被接受以后，它就会被保存在文件`~/.ssh/known_hosts`之中。下次再连接这台主机，系统就会认出它的公钥已经保存在本地了，从而跳过警告部分，直接提示输入密码。

  每个SSH用户都有自己的known_hosts文件，此外系统也有一个这样的文件，通常是`/etc/ssh/ssh_known_hosts`，保存一些对所有用户都可信赖的远程主机的公钥。

# 公钥登录

## 生成公钥

```bash
ssh-keygen
```

按下回车后，系统会出现一系列提示，可以一路回车。其中有一个问题是，是否对私钥设置口令（passphrase），如果担心私钥的安全，可以设置。(军事应用会对私钥设置口令)

`~/.ssh/`目录下，会新生成两个文件：其中**id_rsa.pub为公钥**，**id_rsa为私钥**

## 传送公钥

```bash
ssh-copy-id user@host
// 或者手动
ssh user@host 'mkdir -p .ssh && cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub
```

将公钥传送到远程主机user@host，输入密码后，会在host的`~/.ssh/`产生（或者追加写入）一个权限为600的`authorized_keys`文件，内容与id_rsa.pub相同。从此再登录，就不需要输入密码了。

## 重启服务（非必须）

如果还是不行，就打开远程主机的/etc/ssh/sshd_config这个文件，检查下面几行前面"#"注释是否取掉。

```bash
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```

之后重启服务

```bash
// ubuntu系统
service ssh restart

// debian系统
/etc/init.d/ssh restart
```

# 远程操作

SSH可以在用户和远程主机之间，建立命令和数据的传输通道，因此很多事情都可以通过SSH来完成。

# 绑定本地端口

既然SSH可以传送数据，那么我们可以让那些**不加密的网络连接**，全部改走SSH连接，从而提高安全性。

假定我们要让8080端口的数据，都通过SSH传向远程主机：

```hash
ssh -D 8080 user@host
```

# 本地端口转发

## 原理

有时，绑定本地端口还不够，还必须指定数据传送的**目标主机**的端口，从而形成点对点的"端口转发"。

假定host1是本地主机，host2是远程主机，两台主机之间无法连通。但是，另外存在另外一台host3，可以同时连通前面两台主机。因此，很自然的想法就是，通过host3，将host1连上host2。

即：host1 <---> host3 <---> host2

在host1执行

```bash
ssh -L 2121:host2:21 host3
```

L参数："本地端口:目标主机:目标主机端口"

指定SSH绑定本地端口2121，然后指定通过host3将所有的数据，转发到目标主机host2的21端口（假定host2运行FTP，默认端口为21）。

这样我们只要连接本地host1的2121端口，就等于连上了host2的21端口。

```bash
ftp localhost:2121
```

"本地端口转发"使得host1到host2之间仿佛通过host3形成一个数据传输的秘密隧道，因此又被称为"**SSH隧道**"。

## 两个例子

```bash
ssh -L 9001:localhost:5900 host3
```

这里的localhost指的是host3，因为目标主机是相对host3而言，即将本机的5900端口绑定host3的5900端口。

```bash
ssh -L 9001:host2:22 host3
ssh -p 9001 localhost
```

通过host3的端口转发，ssh登录host2。只要ssh登录本机的9001端口，就相当于登录host2了。

# 远程端口转发

既然"本地端口转发"是指绑定本地端口的转发，那么"远程端口转发"（remote forwarding）当然是指绑定远程端口的转发。

还是接着看上面那个例子，host1与host2之间无法连通，必须借助host3转发。但是，特殊情况出现了，host3是一台内网机器，它可以连接外网的host1，但是反过来就不行，外网的host1连不上内网的host3。这时，"本地端口转发"就不能用了，怎么办？

解决办法是，既然host3可以连host1，那么就从host3上建立与host1的SSH连接，然后在host1上使用这条连接就可以了。

我们在host3执行下面的命令：

```bash
ssh -R 2121:host2:21 host1
```

R参数也是接受三个值，分别是"远程主机端口:目标主机:目标主机端口"。这条命令的意思，就是让host1监听它自己的2121端口，然后将所有数据经由host3，转发到host2的21端口。由于对于host3来说，host1是远程主机，所以这种情况就被称为"远程端口绑定"。

绑定之后，我们在host1就可以连接host2了：

```bash
ftp localhost:2121
```

这里必须指出，"远程端口转发"的前提条件是，host1和host3两台主机都有sshD和ssh客户端。

# SSH的其他参数

```bash
ssh -NT -D 8080 host
```

N参数，表示只连接远程主机，不打开远程shell；T参数，表示不为这个连接分配TTY。这个两个参数可以放在一起用，代表这个SSH连接只用来传数据，不执行远程操作。

```bash
ssh -f -D 8080 host
```

f参数，表示SSH连接成功后，转入后台运行。这样一来，你就可以在不中断SSH连接的情况下，在本地shell中执行其他操作。要关闭这个后台连接，就只有用kill命令去杀掉进程。

# X11转发

```bash
ssh -X user@host
```

可在本地执行host上的GUI程序，最为关键的是这些图形窗口由本地窗口管理器(Window Manager)管理。这一场景对于经常在内网登录工作站进行CAD的用户而言，相当常见。

X11 的劣势似乎是远程用户和本地用户不能共享同一个 sessions，即 X11 登录会启动一个新的 session，而不是接管当前用户正在用的那个，所以不能同时操作，甚至看不到对方的操作。与Tmux可公用一个session相区分。