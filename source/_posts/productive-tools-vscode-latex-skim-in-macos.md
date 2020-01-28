---
title: 【生产力工具】VScode + LaTeX + Skim：配置基于 macOS 的科研写作环境
date: 2020-01-28 18:06:15
categories:
    - [生产力工具, latex]
tags:
    - 生产力工具
    - latex
    - vscode
---

# 背景

趁着超长寒假的空档，赶完自己在去年挖的 paper 坑。那么没有一个好的科研协作环境怎么行呢？:sunglasses: 

查了查 LaTeX 写作的相关软件，发现大家主要推荐 TeXsudio 或者 VSCode+latex-workshop。作为一个忠实的 VSCode 粉，自然就选择了 VSCode+latex-workshop 的环境。

# 环境配置流程

主要包含软件安装、VSCode 配置以及正反向查找设置。

## 安装

1. 安装 [MacTeX](http://www.tug.org/mactex/mactex-download.html)

2. 在 VSCode 中安装 `LaTeX Workshop` 插件

3. 安装 Skim 

    ```shell
    brew cask install skim
    ```

    安装时遇到了 brew 连接 github 的问题 {% post_link Github-API-token-for-Homebrew %}

## VSCode 设置

1. 使用 XeFLaTeX 编译中文

    在 `setting.json` 文件中添加如下代码

    ```json
    {
        // other rules...

        // latex-workshop
        "latex-workshop.latex.tools": [
            {
                "name": "xelatex",
                "command": "xelatex",
                "args": [
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-file-line-error",
                    "%DOC%"
                ]
            },
            {
                "name": "pdflatex",
                "command": "pdflatex",
                "args": [
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-file-line-error",
                    "%DOC%"
                ]
            },
            {
                "name": "latexmk",
                "command": "latexmk",
                "args": [
                    "-synctex=1",
                    "-interaction=nonstopmode",
                    "-file-line-error",
                    "-pdf",
                    "%DOC%"
                ]
            },
            {
                "name": "bibtex",
                "command": "bibtex",
                "args": [
                    "%DOCFILE%"
                ]
            }
        ],
        "latex-workshop.latex.recipes": [
            {
                "name": "XeLaTeX",
                "tools": [
                    "xelatex"
                ]
            },
            {
                "name": "PDFLaTeX",
                "tools": [
                    "pdflatex"
                ]
            },
            {
                "name": "latexmk",
                "tools": [
                    "latexmk"
                ]
            },
            {
                "name": "BibTeX",
                "tools": [
                    "bibtex"
                ]
            },
            {
                "name": "xelatex -> bibtex -> xelatex*2",
                "tools": [
                    "xelatex",
                    "bibtex",
                    "xelatex",
                    "xelatex"
                ]
            },
            {
                "name": "pdflatex -> bibtex -> pdflatex*2",
                "tools": [
                    "pdflatex",
                    "bibtex",
                    "pdflatex",
                    "pdflatex"
                ]
            },
        ],
    }
    ```

2. 配置外部 pdf 预览工具

    ```json
    {
        // other rules...

        // external pdf viewer
        "latex-workshop.view.pdf.viewer": "external",
        "latex-workshop.view.pdf.external.synctex.command": "/Applications/Skim.app/Contents/SharedSupport/displayline",
        "latex-workshop.view.pdf.external.synctex.args": [
            "-r",
            "%LINE%",
            "%PDF%",
            "%TEX%"
        ],
        "latex-workshop.view.pdf.external.viewer.command": "displayfile",
        "latex-workshop.view.pdf.external.viewer.args": [
            "-r",
            "%PDF%"
        ],
        "editor.wordWrap": "on",
    }
    ```

## 外部 pdf 预览与正反向跳转

1. `displayfile` 可执行文件

    创建 `displayfile` 文件，输入下列代码:

    ```shell
    #!/bin/bash

    # displayfile (Skim)
    #
    # Usage: displayfile [-r] [-g] PDFFILE
    #
    # Modified from "displayline" to only revert the file, not jump to a given line
    #

    if [ $# == 0 -o "$1" == "-h" -o "$1" == "-help" ]; then
    echo "Usage: displayfile [-r] [-g] PDFFILE
    Options:
    -r, -revert      Revert the file from disk if it was open
    -g, -background  Do not bring Skim to the foreground"
    exit 0
    fi

    # get arguments
    revert=false
    activate=true
    while [ "${1:0:1}" == "-" ]; do
    if [ "$1" == "-r" -o "$1" == "-revert" ]; then
        revert=true
    elif [ "$1" == "-g" -o "$1" == "-background" ]; then
        activate=false
    fi
    shift
    done
    file="$1"
    #shopt -s extglob
    #[ $# -gt 2 ] && source="$3" || source="${file%.@(pdf|dvi|xdv)}.tex"

    # expand relative paths
    [ "${file:0:1}" == "/" ] || file="${PWD}/${file}"

    # pass file arguments as NULL-separated string to osascript
    # pass through cat to get them as raw bytes to preserve non-ASCII characters
    /usr/bin/osascript \
    -e "set theFile to POSIX file \"$file\"" \
    -e "set thePath to POSIX path of (theFile as alias)" \
    -e "tell application \"Skim\"" \
    -e "  if $activate then activate" \
    -e "  if $revert then" \
    -e "    try" \
    -e "      set theDocs to get documents whose path is thePath" \
    -e "      if (count of theDocs) > 0 then revert theDocs" \
    -e "    end try" \
    -e "  end if" \
    -e "  open theFile" \
    -e "end tell"
    ```

    更改为可执行文件：
    
    ```shell
    chmod 744 displayfile
    ```

    放置此文件至某环境变量路径中:

    ```shell
    mv displayfile /usr/local/bin/
    ```

2. 配置 Skim

    在 设置 -> 同步中，勾选“检查文件更新” 和 “重新加载”；

    同时更改 PDF-TeX 同步支持为 "Visual Studio Code"；

# 使用指南

1. 正反向查找快捷键

    - 在 TeX 中：`command + option + j` 转跳到预览的 PDF 文件对应位置；

    - 在预览的 PDF 文件中：`command + shift + mouse` 转跳 TeX 代码对应位置；

2. 编译 TeX 代码

    在编辑 TeX 文件时，点击右方边栏的 TeX 按钮 -> 点击 Build LaTeX project

    - 注：VSCode 在保存 TeX 文件时自动编译。如果希望关闭此功能，在 `setting.json` 中添加 `"latex-workshop.latex.autoBuild.run": "never"`
