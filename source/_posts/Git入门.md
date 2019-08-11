---
title: Git 入门 && 指令方法速查
date: 2019/07/22 13:00:00
categories:
  - git
tags:
  - git
  - 入门
---



# 0. 引入

多说无益，Show you the code :sunglasses:。

参考资料：[廖雪峰 GIt教程](<https://www.liaoxuefeng.com/wiki/896043488029600>) 强烈推荐

# 1. 用户配置

- 安装完成后，设置用户，`--global`表示机器上所有git仓库使用此配置

  ```bash
  $ git config --global user.name "Your Name"
  $ git config --global user.email "email@example.com"
  ```

# 2. 创建版本库

```bash
$ git init # 把当前目录初始化为git仓库
```

```bash
$ git add readme.txt
$ git commit -m "wrote a readme file"
$ git status # 查看当前工作区状态
$ git diff readme.txt # 查看工作区的修改
```

# 3. 仓库管理

### 版本回退

git使用SHA1计算版本号`commit id`

```bash
$ git log --pretty=oneline # 查看提交日志
$ git reflog # 查看历史命令
```

```bash
$ git reset --hard HEAD^
 # 上一个版本就是HEAD^，上上一个版本就是HEAD^^，上100个版本就是HEAD~100
$ git reset --hard 1094a
# 回退到指定版本（包括未来版本)，使用版本号前几位即可
```

### 工作区, 暂存区, 版本库

- 工作区(Working Directory)：本地可见目录
- 版本库(Repository)：`.git`
  - 暂存区：`stage`/`index`
  - 当前分支：`master`

前面讲了我们把文件往Git版本库里添加的时候，是分两步执行的：

1. 第一步是用`git add`把文件添加进去，实际上就是把文件从**工作区**修改添加到**暂存区**；
2. 第二步是用`git commit`提交更改，实际上就是把**暂存区**的所有内容提交到**当前分支**，即提交到**版本库**。

因为我们创建Git版本库时，Git自动为我们创建了唯一一个`master`分支，所以，现在，`git commit`就是往`master`分支上提交更改。

### 撤销修改

```bash
$ git checkout -- filename ## 务必带上 -- ，`git chechout` 用于切换分支
```

命令`git checkout -- readme.txt`意思就是，把`readme.txt`文件在**工作区的修改**全部撤销，这里有两种情况：

一种是`readme.txt`自修改后还**没有被放到暂存区**，现在，撤销修改就**回到和版本库一模一样的状态**；

一种是`readme.txt`**已经添加到暂存区**后，又作了修改，现在，撤销修改就**回到添加到暂存区后的状态**。

```bash
$ git reset HEAD readme.txt
```

`git reset`命令既可以回退版本，也可以**把暂存区的修改回退到工作区**。当我们用`HEAD`时，表示最新的版本。

**场景1：**当你改乱了**工作区**某个文件的内容，想直接丢弃工作区的修改时，用命令`git checkout -- file`。

**场景2：**(add)当你不但改乱了工作区某个文件的内容，还**添加到了暂存区**时，想丢弃修改，分两步，第一步用命令`git reset HEAD <file>`，就回到了场景1，第二步按场景1操作。

**场景3：**(commit)已经提交了不合适的修改到**版本库**时，想要撤销本次提交，参考[版本回退](https://www.liaoxuefeng.com/wiki/896043488029600/897013573512192)一节，不过前提是**没有推送到远程库**。

### 删除文件

删除本地文件，再删除版本库中的文件

```bash
$ rm test.txt # 本地删除
$ git rm test.txt
$ git commit -m "remove test.txt"
```

如果本地(工作区)误删除

```bash
$ git checkout -- test.txt
```

`git checkout -- `其实是用**版本库里的版本替换工作区的版本**，无论工作区是修改还是删除，都可以“一键还原”。

# 3.远程仓库

### 配置SSH

```bash
$ ssh-keygen -t rsa -C "youremail@example.com"
# 直接 ssh-keygen
```

在用户主目录里找到`.ssh`目录，里面有`id_rsa`和`id_rsa.pub`两个文件，这两个就是SSH Key的秘钥对，`id_rsa`是私钥，不能泄露出去，`id_rsa.pub`是公钥，可以放心地告诉任何人。

**注意：**支持SSH的应用只要知道里用户的公钥，就可以确定通讯的对象是正确的。所以一定要确定本地使用SSH的用户名称，如`scp`指令，服务器使用的是`user_a`的公钥，而本地尝试`sudo scp`，由于`sudo`使用root用户，不是user_a，所以返回`permission deny(public key)`的错误

```bash
$ cat ~/.ssh/id_ras.pub
```

获得公钥，复制到远程仓库。（小心多余空行）

### 添加远程库

在github上“Create a new repo”

```bash
$ git remote add origin git@github.com:username/reponame.git
```

!!! `orgin`为**远程库的名字**, 为git默认叫法

```bash
$ git add *
$ git commit -m "first commit"
```

添加文件到版本库

```bash
$ git push -u origin master
```

把本地库内容推送到远程库

把本地库的内容推送到远程，用`git push`命令，实际上是把当前分支`master`推送到远程。

由于远程库是空的，我们第一次推送`master`分支时，加上了`-u`参数，Git不但会把本地的`master`分支内容推送的远程新的`master`分支，还会把本地的`master`分支和远程的`master`分支关联起来，在以后的推送或者拉取时就可以简化命令。

从现在起，只要本地作了提交，就可以通过命令：

```bash
$ git push origin master
```

把本地`master`分支的最新修改推送至GitHub

### 克隆远程库

```bash
$ git clone git@github.com:username/userrepo
```

git还支持https等多种协议: https慢而且需要口令, http不加密

# 4. 分支管理

### 创建与合并分支

`HEAD`指针指向`master`分支, `master`指向分支内的具体提交.

- 创建分支: 新建一个指针`dev`, 再把`HEAD`指向`dev`
- 合并分支: 把`HEAD`指向`master`, 再把`master` 指向当前`dev`指向分支
  - `Fast-forward` 合并模式
- 删除分支: 删除`dev`指针 

```bash
$ git branch # 查看分支
$ git branch <name> # 以当前分支创建分支name

$ git checkout <name> # 切换分支name
$ git checkout -b <name> # 以当前分支创建并切换分支name

$ git merge <name> # 合并分支name到当前分支
$ git branch -d <name> # 删除分支name
```

### 解决冲突

创建feature1分支, 修改文件并提交

```bash
$ git checkout -b feature1
# modify file
$ git add file
$ git commit -m "file_feature1"
```

切回master分支(git自动提示当前master分支比远程master分支超前一个提交), 修改相同文件并提交

```bash
$ git checkout master
# modify file
$ git add file
$ git commit -m "file_master"
```

尝试合并, 产生冲突

```bash
$ git merge feature1
Auto-mergeing file
CONFLICT (content): Merge conflict in file
Automatic merge failed; fix conflicts and then commit the result.
```

手动解决分支master的冲突, git使用`<<<<<<<`,`=======`,`>>>>>>>`标记不同分支内容

```markdown
# ...
<<<<<<< HEAD
change master
=======
change feature1
>>>>>>> feature1
# ...
```

再提交:

```bash
$ git add file
$ git commit -m "conflict fixed"
```

使用`git log`查看分支合并情况:

```bash
$ git log --graph --pretty=oneline --abbrev-commit
```

最后删除`feature1`分支

```bash
$ git branch -d feature1
```

### 分支管理策略

**分支策略**

- `master`分支稳定, 仅用作发布新版本
- `dev`分支不稳定, 在发布新版本时间才merge到`master`
- 每个开发者拥有自己的分支, 向dev合并

**禁用Fast forward模式**

`Fast forward`模式删除分支后, 会导致分支信息丢失.

如果禁用`Fast forward`模式, git在merge时会生成一个新commit. `git merge --no-ff -m`

```bash
$ git checkout -b dev
$ git add file
$ git commit -m "add merge"

$ git checkout master
$ git merge --no-ff -m "merge with no-ff" dev
Merge made by the 'recursive' strategy.
file | 1 +
1 file changed, 1 insertion(+)
$ git log --graph --pretty=oneline
```

### Bug分支/保存工作现场

**场景：**接到修复代号101的bug，但当前在`dev`分支的工作未完成，还未提交。

`git stash`可以保额当前工作现场储藏

```bash
$ git stash
Saved working directory and index state WIP on dev: f52c633 add merge
```

使用`git status` 查看工作区，干净整洁。

假定需要修改`master`分支的bug，从`master`创建临时分支`issue-101`

```bash
$ git checkout master
Switched to branch 'master'
Your branch is ahead of 'origin/master' by 6 commits.
  (use "git push" to publish your local commits)

$ git checkout -b issue-101
Switched to a new branch 'issue-101'
```

在`issue-101`分支修复bug

```bash
$ git add readme.txt 
$ git commit -m "fix bug 101"
[issue-101 4c805e2] fix bug 101
 1 file changed, 1 insertion(+), 1 deletion(-)
```

修复完成，切回`master`分支，merge

```bash
$ git checkout master
Switched to branch 'master'
Your branch is ahead of 'origin/master' by 6 commits.
  (use "git push" to publish your local commits)

$ git merge --no-ff -m "merged bug fix 101" issue-101
Merge made by the 'recursive' strategy.
 readme.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

切回`dev`分支，`git status`，工作区干净整洁

```bash
$ git checkout dev
Switched to branch 'dev'

$ git status
On branch dev
nothing to commit, working tree clean
```

`git stash list`查看储藏的工作现场

```bash
$ git stash list
stash@{0}: WIP on dev: f52c633 add merge
```

- 使用 `git stash pop` 恢复现场，同时删除stash的内容

  ```bash
  $ git stash pop
  ```

- 使用`git stash apply` 恢复现场，`git stash drop` 删除stash中的内容

  ```bash
  $ git stash list # 查看stash标签
  $ git stash apply stash@{0}
  $ git stash drop stash@{0}
  ```

  

### Feature分支/删除已修改但未合并的分支

添加新feature

由于某原因，需要销毁新feature的内容

```bash
$ git branch -d new-feature
error: The branch 'new-feature' is not fully merged.
If you are sure you want to delete it, run 'git branch -D new-feature'.
```

由于`new-feature`分支未被合并，需要强行删除

```bash
$ git branch -D new-feature
```



### 多人协作/git remote

直接clone，git自动把本地`master`分支与远程`master`分支对应，远程仓库默认名称是`origin`

要查看远程库的信息，用`git remote`：

```bash
$ git remote
origin
```

或者，用`git remote -v`显示更详细的信息：

```bash
$ git remote -v
origin  git@github.com:username/gitrepo.git (fetch)
origin  git@github.com:username/gitrepo.git (push)
```

上面显示了可以抓取和推送的`origin`的地址。如果没有推送权限，就看不到push的地址。

**推送分支**

```bash
$ git push origin <branch_name>
```

- `master`主分支，需要随时与远程同步
- `dev`开发分支，需要随时与远程同步
- bug分支，通常不用
- feature分支，看情况

**抓取建立分支**

直接clone，默认情况下只能看见本地`master`分支。

如果需要在远程`dev`上开发，就必须在本地创建远程库`origin`的`dev`分支

```bash
$ git checkout -b dev origin/dev
```

**提交冲突**

小伙伴的最新提交和你试图推送的提交有冲突

先用`git pull`把最新的提交从`origin/dev`抓下来，然后，在本地合并，解决冲突，再推送

如果`git pull`失败，提示`no tracking information`，则需要指定本地`dev`到远程`origin/dev`分支的链接，之后再`git pull`

```bash
$ git pull
There is no tracking information for the current branch.
Please specify which branch you want to merge with.
See git-pull(1) for details.

    git pull <remote> <branch>

If you wish to set tracking information for this branch you can do so with:

    git branch --set-upstream-to=origin/<branch> dev
    
$ git branch --set-upstream-to=origin/dev dev
Branch 'dev' set up to track remote branch 'dev' from 'origin'.
```

**多人工作模式**

1. 首先，可以试图用`git push origin <branch-name>`推送自己的修改；
2. 如果推送失败，则因为远程分支比你的本地更新，需要先用`git pull`试图合并；
3. 如果合并有冲突，则解决冲突，并在本地提交；
4. 没有冲突或者解决掉冲突后，再用`git push origin <branch-name>`推送就能成功！

如果`git pull`提示`no tracking information`，则说明本地分支和远程分支的链接关系没有创建，用命令`git branch --set-upstream-to <branch-name> origin/<branch-name>`。

**小结**

- 查看远程库信息，使用`git remote -v`；
- 本地新建的分支如果不推送到远程，对其他人就是不可见的；
- 从本地推送分支，使用`git push origin branch-name`，如果推送失败，先用`git pull`抓取远程的新提交；
- 在本地创建和远程分支对应的分支，使用`git checkout -b branch-name origin/branch-name`，本地和远程分支的名称最好一致；
- 建立本地分支和远程分支的关联，使用`git branch --set-upstream branch-name origin/branch-name`；
- 从远程抓取分支，使用`git pull`，如果有冲突，要先处理冲突。

### Rebase

rebase操作的特点：把分叉的提交历史“整理”成一条直线，看上去更直观。

如果push时需要解决冲突，现pull，再push会有分叉。

先`git rebase` ，再push

### 本地删除文件，同步到远程库，同步删除

没有commit 进版本库
建议在项目根目录使用命令`git add -A`然后使用命令`git commit -m "del"` 再然后要使用 `git push`推送到远程服务器

建议每一次add之后再次使用`git status`命令来查看是否已经stage

# 5. 标签管理

tag就是一个让人容易记住的有意义的名字，它跟某个commit绑在一起。

### 创建修改标签

对某分支打标签

- 命令`git tag <tagname> [<commit id>]`用于新建一个标签，默认为`HEAD`，

  与`git log --pretty=oneline --abbrev-commit`配合，也可以指定一个commit id；

- 命令`git tag -a <tagname> -m "blablabla..."`，可以指定标签信息；

- 命令`git tag`可以查看所有标签。

- 命令`git push origin <tagname>`可以推送一个本地标签；

- 命令`git push origin --tags`可以推送全部未推送过的本地标签；

- 命令`git tag -d <tagname>`可以删除一个本地标签；

- 命令`git push origin :refs/tags/<tagname>`可以删除一个远程标签。

# 6. 自定义Git

让Git显示颜色，会让命令输出看起来更醒目：

```bash
$ git config --global color.ui true
```

### 忽略特殊文件

`.gitignore` 所有配置文件可以直接在线浏览：https://github.com/github/gitignore

- 一个例子

  ```
  # Windows: 忽略缩略图
  Thumbs.db
  ehthumbs.db
  Desktop.ini
  # Python: 忽略Python编译产生的文件、目录
  *.py[cod]
  *.so
  *.egg
  *.egg-info
  dist
  build
  
  # My configurations:
  db.ini
  deploy_key_rsa
  ```

  把`.gitignore`提交到Git (版本库)

- 强制提交被忽略文件

  ```bash
  $ git add -f ignore_file
  ```

  

- 检查`.gitignore`的规则

  ```bash
  $ git check-ignore -v ignore_file
  ```

### 配置别名

```bash
$ git config --global alias.st status
$ git st
```

```bash
$ git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
$ git lg
```

**配置文件**

**每个仓库**的Git配置文件都放在`.git/config`文件中

当前用户的Git配置文件放在**用户主目录**下的一个隐藏文件`.gitconfig`

### 搭建Git服务器

假设你已经有`sudo`权限的用户账号，下面，正式开始安装。

第一步，安装`git`：

```
$ sudo apt-get install git
```

第二步，创建一个`git`用户，用来运行`git`服务：

```
$ sudo adduser git
```

第三步，创建证书登录：

收集所有需要登录的用户的公钥，就是他们自己的`id_rsa.pub`文件，把所有公钥导入到`/home/git/.ssh/authorized_keys`文件里，一行一个。

第四步，初始化Git仓库：

先选定一个目录作为Git仓库，假定是`/srv/sample.git`，在`/srv`目录下输入命令：

```
$ sudo git init --bare sample.git
```

Git就会创建一个裸仓库，裸仓库没有工作区，因为服务器上的Git仓库纯粹是为了共享，所以不让用户直接登录到服务器上去改工作区，并且服务器上的Git仓库通常都以`.git`结尾。然后，把owner改为`git`：

```
$ sudo chown -R git:git sample.git
```

第五步，禁用shell登录：

出于安全考虑，第二步创建的git用户不允许登录shell，这可以通过编辑`/etc/passwd`文件完成。找到类似下面的一行：

```
git:x:1001:1001:,,,:/home/git:/bin/bash
```

改为：

```
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell
```

这样，`git`用户可以正常通过ssh使用git，但无法登录shell，因为我们为`git`用户指定的`git-shell`每次一登录就自动退出。

第六步，克隆远程仓库：

现在，可以通过`git clone`命令克隆远程仓库了，在各自的电脑上运行：

```
$ git clone git@server:/srv/sample.git
Cloning into 'sample'...
warning: You appear to have cloned an empty repository.
```

剩下的推送就简单了。

#### 管理公钥

如果团队很小，把每个人的公钥收集起来放到服务器的`/home/git/.ssh/authorized_keys`文件里就是可行的。如果团队有几百号人，就没法这么玩了，这时，可以用[Gitosis](https://github.com/res0nat0r/gitosis)来管理公钥。

这里我们不介绍怎么玩[Gitosis](https://github.com/res0nat0r/gitosis)了，几百号人的团队基本都在500强了，相信找个高水平的Linux管理员问题不大。

#### 管理权限

有很多不但视源代码如生命，而且视员工为窃贼的公司，会在版本控制系统里设置一套完善的权限控制，每个人是否有读写权限会精确到每个分支甚至每个目录下。因为Git是为Linux源代码托管而开发的，所以Git也继承了开源社区的精神，不支持权限控制。不过，因为Git支持钩子（hook），所以，可以在服务器端编写一系列脚本来控制提交等操作，达到权限控制的目的。[Gitolite](https://github.com/sitaramc/gitolite)就是这个工具。

#### 小结

- 搭建Git服务器非常简单，通常10分钟即可完成；
- 要方便管理公钥，用[Gitosis](https://github.com/sitaramc/gitolite)；
- 要像SVN那样变态地控制权限，用[Gitolite](https://github.com/sitaramc/gitolite)。

