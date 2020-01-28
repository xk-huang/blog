---
title: Linux 学习记录
date: 2019/07/07 15:05:00
categories: 
	- Linux
tags:
 	- Linux
---

# 背景

这是一个很好的学习Linux的[资源](<http://www.ee.surrey.ac.uk/Teaching/Unix/index.html>)。

记录一些看教程时发现的自己还不了解的点。

注：

1. 【申时】哺时，又名日铺、夕食等（15时至17时）。

2. 【拾遗】采补缺漏遗佚。《南齐书．卷九．礼志上》：吴则太史令丁孚拾遗汉事，蜀则孟光、许慈草建众典。

# 重定向 Redirection

## 1. Redirecting input/output

```bash
command > file
```

redirect standard output to a file.

```bash
command >> file
```

append standard output to a file.

```bash
command < file
```

redirect standard input from a file.

## 2. Pipes

```bash
command1 | command2	
```

pipe the output of command1 to the input of command2.

```bash
cat file1 file2 > file0
```

concatenate file1 and file2 to file0.

# Wildcards

## 1. The * (asterisk) wildcard

- `*` match any number of characters.

## 2. The ? (question mark) wildcard

- `?` match one character.

# Some Uesful Commands

| commands                                                  | Funcition                                                    |
| --------------------------------------------------------- | ------------------------------------------------------------ |
| df                                                        | reports on the space left on the file system                 |
| quota                                                     | check amount of disk space quota you have                    |
| du                                                        | outputs the number of kilobyes used by each subdirectory     |
| apropos                                                   | not sure of the exact name of a command                      |
| gzip                                                      | compress the file to *.gz                                    |
| gunzip                                                    | expand the *.gz file                                         |
| tar -cvf file                                             | **c**ompress the file tot *.tar                              |
| tar -xvf file                                             | e**x**pand the *.tar file                                    |
| file                                                      | classifies the named files according to the type of data they contain |
| diff file1 file2                                          | compares the contents of two files and displays the differences |
| find;  find . -name "\*.txt" -print; find . -size +1M -ls | searches through the directories for files and directories with a given name, date, size, or any other attribute you care to specify |

# UNIX Variables

## 1. Intro

- Variables are a way of passing information from the shell to programs when you run them.

- Standard UNIX variables are split into two categories, **environment variables** and **shell variables**.

  1. Shell variables apply only to the current instance of the shell and are used to set short-term working conditions; Shell variables have **lower case** names.
2. Environment variables have a farther reaching significance, and those set at login are valid for the duration of the session. Environment variables have **UPPER CASE**.
  3. Variables all start with a "$" mark.

## 2. Environment Variables

### Show environment variables

```bash
% echo $OSTYPE
```

More e.g.:

- USER (your login name)
- HOME (the path name of your home directory)
- HOST (the name of the computer you are using)
- ARCH (the architecture of the computers processor)
- DISPLAY (the name of the computer screen to display X windows)
- PRINTER (the default printer to send print jobs)
- **PATH** (the directories the shell should search to find a command)

### Check values of the variables

- `setenv` set environment variables.

- `unsetenv` unset environment variables.

- `printenv` & `env` display:

  ```bash
  % printenv | less
  ```

## 3. Shell Variables

### Show

```bash
% echo $history
```

More e.g.:

- cwd (your current working directory)
- home (the path name of your home directory)
- prompt (the text string used to prompt for interactive commands shell your login shell)
- **path** (the directories the shell should search to find a command)

### Check values of the variables

- `set`

- `unset`

- ```bash
  % set | less
  ```

## 4. Setting shell variables in `.cshrc`

- `set history=200 ` only works in current shell, so it works for only once.

-  `gedit ~/.cshrc` add the lines **after** all other lines:

  `set history = 200`

  Save the file and reload it:

  `source ~/.cshrc`

  Check whether it works or not:

  `echo $history`

## 5. Setting the path

- path/PATH variable defines in which directories the shell will look to find the cmommand you typed.

- `set path = ($path ~/units174/bin)`  only works for once

- add the following line to `.cshrc ` to add path permanently

  `set path = ($path ~/units174/bin)`