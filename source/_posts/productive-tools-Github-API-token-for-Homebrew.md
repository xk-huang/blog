---
title: 【生产力工具】为 Homebrew 配置 Github API token
date: 2020-01-28 17:34:57
categories:
    - [生产力工具, homebrew]
tags: 
    - 生产力工具
    - homebrew
    - github
---
# 背景

为了配置以 vscode 为主的 LaTeX 写作环境，使用 `homebrew` 安装开源 pdf 浏览软件 `skim` —— `brew cask install skim`， 在安装失败的同时收到了来自 github 的邮件：

{% blockquote %}
Hi @x1aokeHuang,

You recently used a password to access an endpoint through the GitHub API using Homebrew/2.2.2 (Macintosh; Intel Mac OS X 10.14.6) curl/7.54.0. We will deprecate basic authentication using password to this endpoint soon:

https://api.github.com/search/code?q=user%3AHomebrew+path%3AFormula+path%3ACasks+path%3A.+filename%3Askim+extension%3Arb&per_page=100

We recommend using a personal access token (PAT) with the appropriate scope to access this endpoint instead. Visit https://github.com/settings/tokens for more information.

Thanks,
The GitHub Team
{% endblockquote %}

最初认为问题是 `brew` 源配置出错，但是 `brew` 已经配置了国内源。抱着试一试的心态更新了 token。之后便成果安装了 `skim`。

# 解决方法

1. 在 https://github.com/settings/tokens/new 中创建新的 token。

    注意通常情况下不要勾选任何一个 scopes，原因参见[此处](https://stackoverflow.com/questions/20130681/setting-github-api-token-for-homebrew)

2. 针对自己使用的 shell，在对应的 shellrc 中添加环境变量 `HOMEBREW_GITHUB_API_TOKEN`

    例如使用 `zsh`, 则使用 `export` 命令在 `~/.zshrc` 中添加如下语句：

    {% codeblock lang:shell line_number:false%}
    export HOMEBREW_GITHUB_API_TOKEN=[YOUR_TOKEN]
    {% endcodeblock%}