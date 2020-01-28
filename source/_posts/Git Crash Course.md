---
title: Git Crash Course (deprecated)
date: 2019-04-29 13:56:00
tags:
  - git
categories: 
  - git
mathjax: true
---

Author: @x1aokeHuang

Date: Apr. 28th 2019

# \# deprecated #

Please move to the [new Chinese version]([https://x1aokehuang.github.io/2019/07/22/Git%E5%85%A5%E9%97%A8/](https://x1aokehuang.github.io/2019/07/22/Git入门/)).

## Introduction to Git

- Git is a fast, simple and popular distributed version control system (VCS).
- This is how it was born, somehow sounds very chivalrous:
  1. Linus build the open-source **Linux**, but its version control is so bad that Linus had to receive all the source code via e-mails from volunteers all over the world! 
  2. Then in 2002 a commercial company called BitMover offered their VCS software BitKeeper to Linux community.
  3. For some members in the community wanted to crack the protocol of BitKeepers, BitMover had to get back the free license.
  4. Linus spent **2 weeks** writing a CVS from nothing using C programming language. After a month, the source code of Linux was managed by the newly created Git. Git ends up with a huge success in VCS software.



## Centralization vs. Distribution

- Centralization: 

  version repository is in the **central server**. Users has to fetch files from the server, and commit to it after modifying the files.

- Distribution:

  Each users own a full copy of the files. In reality, we commit files to a so called "central server" to make file-exchanging convenient. 



## Install Git

- Depends on the platform you use

  

## Build Repository

- Initialize a repo:

  Open git bash!

  Firstly, build a empty directory:

  ~~~bash
  $ mkdir learngit
  $ cd learngit
  $ pwd
  /Users/michael/learngit
  ~~~

  Then use `git init`:

  ~~~bash
  $ git init
  Initialized empty Git repository in /Users/michael/learngit/.git/
  ~~~

  PS: **Don't** modify the files in `.git`

- Add files to repo:

  make a file under current path like "readme.txt".

  1. Use `git add` to add file(s):

     ~~~bash
     $ git add readme.txt
     ~~~

  2. Use `git commit` commit file(s) to repo:

     ~~~bash
     $ git commit -m "wrote a readme file"
     [master (root-commit) eaadf4e] wrote a readme file
      1 file changed, 2 insertions(+)
      create mode 100644 readme.txt
     ~~~

  PS:

  1. You can `add` several files at a time before you `commit`.
  2. Encoding setting: **UTF-8 without BOM.**



## Git: A Time Travel Machine

### Modify Files:

- Change `readme.txt`:

  ```bash
  Git is a distributed version control system.
  Git is free software.
  ```

- Run `git status`:

  ```bash
  $ git status
  On branch master
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)
  
      modified:   readme.txt
  
  no changes added to commit (use "git add" and/or "git commit -a")
  ```

  It shows current status of the repo, telling us that `readme.txt` has been modified but not been commit yet.

- Run `git diff`:

  ```bash
  $ git diff readme.txt 
  diff --git a/readme.txt b/readme.txt
  index 46d49bf..9247db6 100644
  --- a/readme.txt
  +++ b/readme.txt
  @@ -1,2 +1,2 @@
  -Git is a version control system.
  +Git is a distributed version control system.
   Git is free software.
  ```

  `git diff` means difference, and its format is from Unix `diff`.

  After knowing what has been changed, we can commit file at ease.

- Then we add file, `git status` to make sure the file we want to commit, finally we commit and final check:

  ```bash
  $ git add readme.txt
  
  $ git status
  On branch master
  Changes to be committed:
    (use "git reset HEAD <file>..." to unstage)
  
      modified:   readme.txt
  
  $ git commit -m "add distributed"
  [master e475afc] add distributed
   1 file changed, 1 insertion(+), 1 deletion(-)
  
  $ git status
  On branch master
  nothing to commit, working tree clean
  ```

  #### Summary:

  1. `git status` shows current status of the repo.
  2. if `git status` shows there is a change in files, use `git diff` to see what's going on.

### Version Rolling Back:

<waiting...>











