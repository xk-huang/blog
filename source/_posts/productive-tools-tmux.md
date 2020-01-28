---
title: 【生产力工具】Tmux 极速入门
date: 2019/07/18 13:00:00
categories: 
 - [生产力工具, tmux]
tags:
 - tmux
 - 生产力工具
---



# 概念

Tmux是一个 BSD 协议发布的终端复用软件，用来在服务器端托管同时运行的 Shell。这意味着一些需要实时在线的服务（如SSH，10min无数据流通自动断线）可通过Tmux的session保留工作空间。每个Session含有若干window，每个window可分为若干Pane。

参考资料：

- https://harttle.land/2015/11/06/tmux-startup.html
- https://tmuxcheatsheet.com/

外: 推荐 oh-my-zsh + oh-my-tmux 终端全家桶组合 :cool:

# 常见指令

## Sessions

### start new session

```bash
$ tmux
$ tmux new 
$ tmux new -s session-name
```

### show all sessions

```bash
$ tmux ls
$ tmux list-sessions
ctrl+b s
```

### attach to session

```bash
$ tmux a # attach to last session
$ tmux a -t session-name
```

### kill session

```bash
$ tmux kill-session -t session-name
$ tmux kill-session -a  # kill all but the current
$ tmux kill-session -a -t session-name # kill all but session-name
```

### miscellaneous

```
ctrl+b $ # rename session
ctrl+b d # detach from session
ctrl+b ( # Move to previous session
ctrl+b ) # move to next session
```

### How to search in Tmux?

```bash
ctrl + b , [ # enter copy mode
/pattern # vim-like searching
```

