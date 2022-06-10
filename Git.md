# Git与Github

参考视频：

- [2019年最新 Git&GitHub 从入门到精通视频教程](https://www.bilibili.com/video/BV1f4411Q7aT)。
- [Git与GitHub基础全套完整版教程](https://www.bilibili.com/video/BV1pW411A7a5)。

## 版本控制工具

### 职能

协同修改：多人互不影响的修改服务器端同一个文件。

数据备份：不仅保存目录和文件，还能保存它们的历史提交状态。

版本管理：在保存每一个历史版本的文件信息时都能做到不重复保存，以节约存储空间，提高运行效率。采用方式是文件系统快照。

权限控制：对参与开发的团队人员进行权限控制，对团队外的贡献者的代码进行审核。

历史记录：

- 可以查看修改人、修改时间、修改内容、日志信息。
- 将本地文件恢复到某一历史状态。

分支管理：允许开发团队针对一个项目同时推进多条生产线上的任务，进一步提高效率。

### 分类

工具领域通过版本控制管理工程蓝图的设计过程。在IT开发过程中也可借鉴版本控制思想管理代码的版本迭代。

如果说版本控制是思想，那么版本控制工具就是其实现。

有集中式版本控制工具如CVS、SVN、VSS。示意图如下：

<img src="D:\chaofan\typora\专业\Git.assets\集中式版本控制工具.png" alt="集中式版本控制工具"  />

这有一个明显的缺点-单点故障：服务器一旦宕机了，所有的历史数据都会丢失，每个客户端只有当前的状态。

有分布式版本控制工具如Git、Mercrucial、Bazzar、Darcs。那么git就不存在上述问题，每个开发人员都能在本地对同一个项目进行完整的版本控制。于是任何人都能把任意版本传给其他任何一个人，比如A的数据丢失了，B就可拿他的数据去给A恢复一下。虽然本地库之间确实能做到互相传数据，但一般不建议这样做，而仍需要一个面向全体开发者的远程库，这一点后面会详细展开。

## git概述

### 简史

直接上图：

![git简史](D:\chaofan\typora\专业\Git.assets\git简史.png)

### 优势

官网网址：https://git-scm.com/。

优势：

- 大部分操作在本地就可以完成（本地就能保存完整的版本历史），而无需联网（当然前提是不跟远程库交互）。比如SVN在断网的条件下就不能进行版本控制操作。
- 完整性保证。涉及到哈希映射，能有效避免文件的损坏，后面会详细讨论。
- 分支操作非常快捷流畅。
- 与linux命令全面兼容（毕竟是一个爹）。

### 安装

一路默认即可，除了安装路径和桌面快捷方式这样一看就知道要改的地方。注意安装路径不要出现空格和中文字符。

### 结构

这里特指git在本地库的结构，尚未牵涉到远程。

下面这个图是根据第一个视频里老师所讲的画的：

![git](Git.assets/git.png)

把文件从某区提交到另一个区（向右），是以复制的方式提交的，本区域中仍然存在该文件。

下面这个图是封老师画的更简单的图：

![git本地库结构简图](git.assets/git本地库结构.png)

### 代码托管中心

git的代码托管中心的典型就是github，但不限于github。

- 在局域网环境下，gitlab可作为代码托管中心。
- 在外网环境下，github或码云可作为代码托管中心。

两类团队开发模式：

- 团队内部协作。
- 跨团队协作。

## 命令

想使用命令行先得打开命令行终端。在项目目录中右键打开Bash，或在windows运行窗口输入cmd再回车，还可以在项目目录中右键打开Powershell。

注：在bash里面选中了文本会自动拷贝。

### 本地库操作

#### 初始化

git的命令和linux的命令式兼容的。比如查看当前目录的所有文件或文件夹：

```bash
$ ll
total 12
drwxr-xr-x 1 Van 197609 0  6月  4 20:09 文艺/
drwxr-xr-x 1 Van 197609 0  6月 14 16:05 杂货/
drwxr-xr-x 1 Van 197609 0  6月 17 09:50 专业/
drwxr-xr-x 1 Van 197609 0  6月 15 17:44 最近/
```

查看包含隐藏资源在内的所有资源：

```bash
$ ll -lA
total 16
drwxr-xr-x 1 Van 197609 0  6月  4 20:09 .git/
drwxr-xr-x 1 Van 197609 0  6月  4 20:09 文艺/
drwxr-xr-x 1 Van 197609 0  6月 14 16:05 杂货/
drwxr-xr-x 1 Van 197609 0  6月 17 09:50 专业/
drwxr-xr-x 1 Van 197609 0  6月 15 17:44 最近/
```

更多的linux命令有待于以后自学了。

下面从一个空项目（空仓库）开始一整套命令操作的学习。

```bash
$ mkdir demo

$ cd demo

$ ll
total 0

$ ll -la
total 0
drwxr-xr-x 1 Van 197609 0  6月 17 17:09 ./
drwxr-xr-x 1 Van 197609 0  6月 17 17:09 ../
```

##### 创建

创建本地git仓库（一个项目就是一个仓库）：

```bash
$ git init
Initialized empty Git repository in D:/chaofan/demo/.git/
```

在linux及windows中，以点开头的目录都是隐藏资源。

可以进到.git目录里面看看：

```bash
$ ll .git
total 7
-rw-r--r-- 1 Van 197609 130  6月 17 17:11 config
-rw-r--r-- 1 Van 197609  73  6月 17 17:11 description
-rw-r--r-- 1 Van 197609  23  6月 17 17:11 HEAD
drwxr-xr-x 1 Van 197609   0  6月 17 17:11 hooks/
drwxr-xr-x 1 Van 197609   0  6月 17 17:11 info/
drwxr-xr-x 1 Van 197609   0  6月 17 17:11 objects/
drwxr-xr-x 1 Van 197609   0  6月 17 17:11 refs/
```

本目录中存放的是与本地库相关的目录和文件，不要删除、不要随意修改。

##### 设置签名

签名即用户名和邮箱地址。注意此处签名的作用仅仅是区分不同开发者的身份，而与代码托管中心（如github）的账号-用户名和密码毫无关联。这里的用户名不不跟他人的冲突即可，邮箱地址就更无甚意义，不存在都可。

可从两种级别设置签名：

- 仓库（项目）级别：仅在当前仓库有效。

  ```bash
  $ git config user.name van
  $ git config user.email van@google.com
  ```

- 系统用户级别：只对登录当前操作系统的用户有效。

  ```bash
  $ git config --global user.name van
  $ git config --global user.email van@google.com
  ```

级别优先级：采取就近原则。首先必须存在至少一个级别上的签名。两个级别上的签名都存在的话采用项目级别的。

前者信息会被保存到.git下面的config文件里，打开来瞧瞧：

```bash
$ cat .git/config
[core]
        repositoryformatversion = 0
        filemode = false
        bare = false
        logallrefupdates = true
        symlinks = false
        ignorecase = true
[user]
        name = van
        email = van@google.com
```

后者信息会被保存到系统用户文件即c:\users\van\\.gitconfig中。

那么在通常实际开发中，我们只设置系统用户级别的签名，当然有项目级别的特殊要求的话就另当别论了。

#### 基本操作

基本操作以版本控制为主。

##### 操作的添加与提交

承接上一节。查看配置：

```bash
# 本仓库配置信息
$ git config --list
$ git config -l
diff.astextplain.textconv=astextplain
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.process=git-lfs filter-process
filter.lfs.required=true
http.sslbackend=openssl
http.sslcainfo=D:/Git/mingw64/ssl/certs/ca-bundle.crt
core.autocrlf=true
core.fscache=true
core.symlinks=false
credential.helper=manager
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true
user.name=van
user.email=van@google.com

# 全局（系统用户）配置信息
$ git config --global --list
$ git config  --global -l
# 没弄全局配置的话就显示这个
fatal: unable to read config file 'C:/Users/Van/.gitconfig': No such file or directory
```

查看当前仓库目录结构：

```bash
$ ls --all
total 4
drwxr-xr-x 1 Van 197609 0  6月 17 17:11 ./
drwxr-xr-x 1 Van 197609 0  6月 17 17:09 ../
drwxr-xr-x 1 Van 197609 0  6月 17 17:28 .git/

$ ls -a
./  ../  .git/
```

查看当前各文件的状态：

```bash
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

分析上述结果的三行：master表征当前分支是主分支或主干分支或就叫主干。由于尚未创建文件，也就无提交记录，故而有第二行-目前为止无提交记录，与第三行-无可提交的操作。一句话-无提交，无可提交。

现在就建若干文件然后再来看工作区状态：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210617193153092.png" alt="image-20210617193153092" style="zoom: 67%;" />

可见得仍未有提交记录，也无可提交的操作，但有了可添加到暂存区的文件，且其被标红。

下面将其添加到暂存区然后查看状态：

```bash
$ git add good.txt
```

<img src="D:\chaofan\typora\专业\Git.assets\image-20210617194357633.png" alt="image-20210617194357633" style="zoom: 80%;" />

容易看出，此时无提交记录，且标绿的文件待提交到本地库。

推而广之，我们看看针对多个文件与所有文件的添加：

```bash
#多个文件
$ git add index.html index.css index.js
#所有文件
$ git add . 
$ git add --all
$ git add -A
```

撤销最近一次操作的添加：

```bash
# 在首次commit之前，任何一次add后都提示用此命令
$ git rm --cached good.txt
# 首次commit之后，任何一次add后都提示用此命令
$ git restore --staged good.txt
```

然后再查看状态会发现good.txt又变红。

最后，把暂存区的文件操作提交到历史区（全部文件）：

```bash
$ git commit -m '第一次提交'
$ git commit --message '第一次提交'
[master (root-commit) a2295c2] 第一次提交
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 good.txt
```

分析结果。`a2295c2`可粗略认为是版本号；`0 insertions(+)`表示该文件新增了多少行；`0 deletions(-)`表示该文件减少了多少行。

有另一种提交的写法：

```bash
$ git commit
```

对此命令回车后会进入bash所带的vim编辑器，要在编辑器里面写提交信息。提交信息相当于代码注释，不过代码注释可写可不写，而提交信息必须要写。

再看一下状态：

```bash
$ git status
On branch master
nothing to commit, working tree clean
```

此结果跟初始化的空仓库状态不完全一样，无可提交，工作区干干净净，但就没有“无提交记录”了。

现在比方说把good.txt修改一下，状态就出现新的变化：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210617201148211.png" alt="image-20210617201148211" style="zoom:80%;" />

我们将其同上一张红字图相比，是不完全一样的。

然后又添加并查看状态：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210617201933561.png" alt="image-20210617201933561" style="zoom:80%;" />

将其同上一张绿字图相比较，也是不完全一样的。这里两张图里的`git restore`指令后面会详细说。

再次提交：

```bash
$ git commit --message '第二次提交'
[master 3d69374] 第二次提交
 1 file changed, 1 insertion(+)
```

注意到与上一次提交后的信息比，没有了`(root-commit)`（根提交即首次提交）标识。

##### 版本的前进与后退

用`git log`命令对版本记录产生直观的感受：

```bash
$ git log
commit 3d69374461ace5fd5ac6f940f37503e4bad4fdee (HEAD -> master)
Author: van <van@google.com>
Date:   Thu Jun 17 20:22:15 2021 +0800

    第二次提交

commit a2295c2c494a314dd4dcfac512cd4e1ad7a9a56a
Author: van <van@google.com>
Date:   Thu Jun 17 19:55:36 2021 +0800

    第一次提交
```

从中可以看出哈希值形式的版本号、提交人签名及日期。HEAD是一个指针，指向当前仓库主干。

下面为了方便操作版本前进和后退，我们又新增了几次提交。再用`git log`指令查看的话结果很冗杂，换一个结果更简洁的命令：

```bash
$ git log --pretty=oneline
649da81be2f1598e0ae79425267c0eaf6a58574f (HEAD -> master) 添加李贺
2c49b6767452562428fbd17412f61127019b4726 添加高适
a78706d0f4a61eb525d0f889539d49b09f02e5ee 添加白居易
f0bb80bde401df37ba947f6df7fac14c5cd6888a 添加李白
fe1da220de9a15c520bdb92eebfcfb5ce19eadc6 添加杜甫
e334ef3f596f66a9190852f7492c0d3a4e640a9b 添加苏轼
3d69374461ace5fd5ac6f940f37503e4bad4fdee 第二次提交
a2295c2c494a314dd4dcfac512cd4e1ad7a9a56a 第一次提交
```

这样的结果只显示哈希值和提交信息。自下而上对应时间从最久到最近。HEAD指针指向最新的主干。

还有更简洁的显示命令：

```bash
$ git log --oneline
# 截取哈希值的一部分
649da81 (HEAD -> master) 添加李贺
2c49b67 添加高适
a78706d 添加白居易
f0bb80b 添加李白
fe1da22 添加杜甫
e334ef3 添加苏轼
3d69374 第二次提交
a2295c2 第一次提交
```

此外还有一种`git reflog`命令会显示包括回滚等操作信息在内的全部版本记录（推荐、重要）：

```bash
$ git reflog
649da81 (HEAD -> master) HEAD@{0}: commit: 添加李贺
2c49b67 HEAD@{1}: commit: 添加高适
a78706d HEAD@{2}: commit: 添加白居易
f0bb80b HEAD@{3}: commit: 添加李白
fe1da22 HEAD@{4}: commit: 添加杜甫
e334ef3 HEAD@{5}: commit: 添加苏轼
3d69374 HEAD@{6}: commit: 第二次提交
a2295c2 HEAD@{7}: commit (initial): 第一次提交
# 花括号里的数字也可理解为从当前回退到此版本需多少步
```

从底层理解一下版本前进后退的本质。在底层，git会通过一个指针帮我们管理仓库的历史版本，这个指针就叫HEAD。通过控制HEAD的指向来索引到某个版本。

有三种方式实现版本的变更：

- 基于索引值（推荐）。
- 基于^符号：只能后退。
- 基于~符号。

实现一下。先留个心眼，看看good.txt长啥样：

```bash
$ cat good.txt
I have modified good.txt.
苏轼
杜甫
李白
白居易
高适
李贺
```

然后回退到某一版本：

```bash
# 从长的哈希值截取一部分得到短的索引值，凭此短索引值就可唯一标识某版本
$ git reset --hard f0bb80b
HEAD is now at f0bb80b 添加李白

# 发现文件内容已经变回到之前的版本了
$ cat good.txt
I have modified good.txt.
苏轼
杜甫
李白
```

再来看历史记录的话就也会有些变化：

```bash
$ git reflog
f0bb80b (HEAD -> master) HEAD@{0}: reset: moving to f0bb80b
649da81 HEAD@{1}: commit: 添加李贺
2c49b67 HEAD@{2}: commit: 添加高适
a78706d HEAD@{3}: commit: 添加白居易
f0bb80b (HEAD -> master) HEAD@{4}: commit: 添加李白
fe1da22 HEAD@{5}: commit: 添加杜甫
e334ef3 HEAD@{6}: commit: 添加苏轼
3d69374 HEAD@{7}: commit: 第二次提交
a2295c2 HEAD@{8}: commit (initial): 第一次提交
```

现在前进到某版本：

```bash
$ git reset --hard 2c49b67
HEAD is now at 2c49b67 添加高适

$ cat good.txt
I have modified good.txt.
苏轼
杜甫
李白
白居易
高适

$ git reflog
# 结果全都是历史版本 开头两行体现了版本的变更（非提交造成）
2c49b67 (HEAD -> master) HEAD@{0}: reset: moving to 2c49b67 # 2.定位到2c49b67
f0bb80b HEAD@{1}: reset: moving to f0bb80b # 1.定位到f0bb80b
649da81 HEAD@{2}: commit: 添加李贺
2c49b67 (HEAD -> master) HEAD@{3}: commit: 添加高适 # HEAD永远指向当前版本
a78706d HEAD@{4}: commit: 添加白居易
f0bb80b HEAD@{5}: commit: 添加李白
fe1da22 HEAD@{6}: commit: 添加杜甫
e334ef3 HEAD@{7}: commit: 添加苏轼
3d69374 HEAD@{8}: commit: 第二次提交
a2295c2 HEAD@{9}: commit (initial): 第一次提交
```

上述三坨`git reflog`结果的对比证明了此命令记录包括回滚在内的所有版本。相比之下，`git log --oneline`与`git log`命令不显示回滚，只显示提交：

```bash
# 不记录回滚信息且回退目标版本之后的版本不显示
$ git log --oneline
2c49b67 (HEAD -> master) 添加高适
a78706d 添加白居易
f0bb80b 添加李白
fe1da22 添加杜甫
e334ef3 添加苏轼
3d69374 第二次提交
a2295c2 第一次提交
```

附带提一下另外两种变更方式：

```bash
# 回退一步
$ git reset --hard HEAD^
```

可想而知，一个`^`符号回退一步，n个`^`符号就回退n步。但步数太多的话就不好用了，于是`~`符号上场了：

```bash
# ~后面跟个n，表示回退n步
$ git reset --hard HEAD~3
```

reset命令有三个参数：

- soft：
  - 在本地库移动HEAD指针。
- mixed：
  - 在本地库移动HEAD指针。
  - 重置暂存区。
- hard：
  - 在本地库移动HEAD指针。
  - 重置暂存区。
  - 重置工作区。

关于它们的区别我们就不用实操来认识了，可以参考下面这个图：

<img src="git.assets/reset参数.png" alt="reset参数" style="zoom: 67%;" />

实际应用中以hard为主。

##### 文件的删除与恢复

先建文件garbage.txt并对其执行添加、提交操作，最后删掉它：

```bash
$ rm garbage.txt
```

做后续操作：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210618134003840.png" alt="image-20210618134003840" style="zoom:80%;" />

从上述代码可看出，针对文件的添加不是添加文件本身，而时添加围绕文件的操作，包括新建、更新，当然也包括删除。所以`git add garbage.txt`看似不合理其实很合理，是要添加删除garbage.txt的这项操作，文件名就代表着各种操作而不限于名字本身。

进而，我们可将删除文件的操作提交到本地库：

```bash
$  git commit -m 'delete garbage.txt'
[master 6768be8] delete garbage.txt
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 garbage.txt
```

那么再看看完整的历史记录：

```bash
$ git reflog
6768be8 (HEAD -> master) HEAD@{0}: commit: delete garbage.txt
927519f HEAD@{1}: commit: new garbage.txt
2c49b67 HEAD@{2}: reset: moving to 2c49b67
f0bb80b HEAD@{3}: reset: moving to f0bb80b
649da81 HEAD@{4}: commit: 添加李贺
2c49b67 HEAD@{5}: commit: 添加高适
a78706d HEAD@{6}: commit: 添加白居易
f0bb80b HEAD@{7}: commit: 添加李白
fe1da22 HEAD@{8}: commit: 添加杜甫
e334ef3 HEAD@{9}: commit: 添加苏轼
3d69374 HEAD@{10}: commit: 第二次提交
a2295c2 HEAD@{11}: commit (initial): 第一次提交
```

从下往上看，有更新文件的提交、回滚-前进和后退、新建文件的提交、删除文件的提交。既然有回滚，那么必然有版本号的重复。

进一步地，我们想恢复被删掉的garbage.txt，使用回退操作就好了：

```bash
$ git reset --hard 927519f
HEAD is now at 927519f new garbage.txt

$ ll
total 1
-rw-r--r-- 1 Van 197609  0  6月 18 14:01 garbage.txt
-rw-r--r-- 1 Van 197609 70  6月 18 11:10 good.txt

$ git reflog
927519f (HEAD -> master) HEAD@{0}: reset: moving to 927519f
6768be8 HEAD@{1}: commit: delete garbage.txt
927519f (HEAD -> master) HEAD@{2}: commit: new garbage.txt
2c49b67 HEAD@{3}: reset: moving to 2c49b67
f0bb80b HEAD@{4}: reset: moving to f0bb80b
649da81 HEAD@{5}: commit: 添加李贺
2c49b67 HEAD@{6}: commit: 添加高适
a78706d HEAD@{7}: commit: 添加白居易
f0bb80b HEAD@{8}: commit: 添加李白
fe1da22 HEAD@{9}: commit: 添加杜甫
e334ef3 HEAD@{10}: commit: 添加苏轼
3d69374 HEAD@{11}: commit: 第二次提交
a2295c2 HEAD@{12}: commit (initial): 第一次提交
```

像工作日志一样，围绕本地库的所有操作都会被git不差毫厘地记录下来且不可磨灭（除非把本地库都删了）。

某文件的删除操作已添加到暂存区，但尚未提交，回退到此文件存在的某个版本就可以恢复此文件。

综上所述，文件恢复的本质还是让HEAD指针指向存在该文件的某个版本。

##### 文件的比较

我们修改good.txt，然后使用比较指令：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210618151517243.png" alt="image-20210618151517243" style="zoom:80%;" />

结果显示文件有新增行。

然而将文件更新的操作添加到暂存区之后，执行比较命令会无结果，此时我们可以针对good.txt比较工作区和本地库里的当前版本：

```bash
$ git diff HEAD good.txt
diff --git a/good.txt b/good.txt
index fcabc2e..1d3fefa 100644
--- a/good.txt
+++ b/good.txt
@@ -4,3 +4,4 @@ I have modified good.txt.
 李白
 白居易
 高适
+黄庭坚
```

也可比较工作区和本地库里的其他版本：

```bash
$ git diff HEAD^ good.txt
diff --git a/good.txt b/good.txt
index fcabc2e..1d3fefa 100644
--- a/good.txt
+++ b/good.txt
@@ -4,3 +4,4 @@ I have modified good.txt.
 李白
 白居易
 高适
+黄庭坚
```

那么提交之后，再比较工作区和当前版本就无结果了，因为它们已经统一了。

当我们进行比较，不指定文件名时，会显示所有不同文件的区别。如：

```bash
$ git diff HEAD
$ git diff HEAD^^^
```

#### 分支管理

![分支](git.assets/分支.png)

分支的好处：同步推进项目内多个功能的开发，且互不影响，提高开发效率。当某分支大错特错，可直接删除重新从主干分出来。

上图中的热修复是指，项目一直在服务器上运行，还有大量用户正在使用，某时出现bug。那么我们应该修复项目的bug但不影响项目的运行，于是衍生出hot_fix分支在其上修复。相反地，另有冷修复，即关掉服务器，把项目修复完再开，这种做法对用户很不友好，一般没人这么做。

本地库初始就有一个主干（分支）master，无需手动创建。

查看所有分支：

```bash
$ git branch -v
* master 2bd37b7 添加黄庭坚
```

新旁生一个hot_fix分支：

```bash
$ git branch hot_fix

# 俩分支的版本号一致
$ git branch -v
  hot_fix 2bd37b7 添加黄庭坚
* master  2bd37b7 添加黄庭坚
```

切换到hot_fix分支：

```bash
# 分支名可通过tab键补全
Van@LAPTOP-D74Q9RI2 MINGW64 /d/chaofan/demo (master)
$ git checkout hot_fix
Switched to branch 'hot_fix'
# 从行末可以看出已切换到hot_fix分支
Van@LAPTOP-D74Q9RI2 MINGW64 /d/chaofan/demo (hot_fix)
```

沿着此分支修改文件，再来查看分支：

```bash
$ git branch -v
* hot_fix 6bb63cf 添加孟浩然
  master  2bd37b7 添加黄庭坚
```

发现俩分支的状态就不同了，两分支开始各自前行了。

下面看看合并。要想合并分支，必选先处于接收修改的分支上。这里master接收修改，hot_fix内容不动。

```bash
# 让master接收hot_fix的合并修改
$ git checkout master
Switched to branch 'master'

# 指定修改方的名字
$ git merge hot_fix
Updating 2bd37b7..6bb63cf
Fast-forward
 good.txt | 1 +
 1 file changed, 1 insertion(+)
```

我们来模拟一下文件冲突的情况。沿着两个分支修改同一个文件的同一行，都提交，然后进行合并：

```bash
$ git merge hot_fix
Auto-merging good.txt
# 冲突原因只能是行的不一致
CONFLICT (content): Merge conflict in good.txt
Automatic merge failed; fix conflicts and then commit the result.

# 行末master|MERGING表明当前处于正在合并的状态
Van@LAPTOP-D74Q9RI2 MINGW64 /d/chaofan/demo (master|MERGING)
```

自动合并失败了，需要我们手动合并。git为我们先做了一番准备，体现在good.txt的内容上：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210618164641529.png" alt="image-20210618164641529" style="zoom:80%;" />

然后我们用vim编辑此文件，达到使两分支都满意的状态。改完了，我们查看状态：

```bash
$ git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
        both modified:   good.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

结果提示用添加命令标记当前冲突已解决：

```bash
$ git add good.txt

$ git status
On branch master
All conflicts fixed but you are still merging.
  (use "git commit" to conclude merge)
```

状态结果又提示用提交命令完成合并：

```bash
$ git commit -m 'resolve conflict'
[master 65e2a55] resolve conflict

# 行末表明合并已顺利结束
Van@LAPTOP-D74Q9RI2 MINGW64 /d/chaofan/demo (master)
```

附带看一下本地库的历史记录：

```bash
# 从下往上看
$ git reflog
# 合并时才可能有冲突情况 合并与冲突解决被一起记录
65e2a55 (HEAD -> master) HEAD@{0}: commit (merge): resolve conflict
52c8c89 HEAD@{1}: checkout: moving from hot_fix to master
# hot_fix分支也修改第二行，但这里并不报冲突，两分支各自拥有的good.txt相互独立
40a8f8e (hot_fix) HEAD@{2}: commit: 修改苏神
6bb63cf HEAD@{3}: checkout: moving from master to hot_fix
# master分支修改第二行
52c8c89 HEAD@{4}: commit: 修改苏轼
# 合并另一分支到主干的操作也被记录了，版本号是合并之后被修改方master的
6bb63cf HEAD@{5}: merge hot_fix: Fast-forward
# 版本号是切换后分支master的
2bd37b7 HEAD@{6}: checkout: moving from hot_fix to master
# 另一分支修改文件的操作也被记录了
6bb63cf HEAD@{7}: commit: 添加孟浩然
# 切换分支的操作也记录了，版本号是切换后分支hot_fix的，因为没动，所以跟master的一样
2bd37b7 HEAD@{8}: checkout: moving from master to hot_fix
2bd37b7 HEAD@{9}: commit: 添加黄庭坚
927519f HEAD@{10}: reset: moving to 927519f
6768be8 HEAD@{11}: commit: delete garbage.txt
927519f HEAD@{12}: commit: new garbage.txt
2c49b67 HEAD@{13}: reset: moving to 2c49b67
f0bb80b HEAD@{14}: reset: moving to f0bb80b
649da81 HEAD@{15}: commit: 添加李贺
2c49b67 HEAD@{16}: commit: 添加高适
a78706d HEAD@{17}: commit: 添加白居易
f0bb80b HEAD@{18}: commit: 添加李白
fe1da22 HEAD@{19}: commit: 添加杜甫
e334ef3 HEAD@{20}: commit: 添加苏轼
3d69374 HEAD@{21}: commit: 第二次提交
a2295c2 HEAD@{22}: commit (initial): 第一次提交
```

由上可得，本地库的日志是面向所有分支及它们之间的交互的（之后会看到它还记录与远程库之间的交互）。合并时合并分支的版本号不变，被合并分支-主干的版本号会变。

文件冲突包括某行内容不同（多出的行不算）-修改我本地的内容、文件缺失（对方或远程没有而本地有）-删除我本地的文件。

### 本地库和远程库的交互

github是一个网站，一个开源的源代码管理平台。注册后，用户可在自己的账户中创建仓库，用来管理项目的源代码，源代码由Git本地库上传到远程仓库中。知名的插件、框架、类库都被托管于此平台，我们可以下载、研究源码。

#### 团队内部协作

![团队内部协作](D:\chaofan\typora\专业\Git.assets\团队内部协作.png)

先看一批项目组长的常规命令：

```bash
# 查看本地仓库和远程仓库的连接情况
$ git remote -v

# 新建连接，origin是最常用的连接名（仓库别名），其后接仓库地址
$ git remote add origin https://github.com/Super-Van/Notebook.git

# 修改连接
$ git remote set-url origin https://github.com/Super-Van/notebook.git

# 再查看连接情况，就有了东西
$ git remote -v
origin  https://github.com/Super-Van/notebook.git (fetch)
origin  https://github.com/Super-Van/notebook.git (push)

# 提交之前最好先拉取一下，因为远程可能有改动
$ git pull origin master

# 提交，回车后需在弹框中登录，在英文状态下输入密码
$ git push origin master

# 移除连接
$ git remote rm origin
```

再看一批组员的常规命令：

```bash
# 克隆 将远程库项目复制到本地 不用自建本地库根目录及.git目录，会帮我们生成
$ git clone 远程仓库地址 别名（可不设，默认是仓库名）
$ git clone https://github.com/Super-Van/notebook.git (fetch)
$ git clone https://github.com/Super-Van/notebook.git (fetch) origin

# 拉取中央仓库的更新内容
$ git pull 远程库地址别名 远程分支名
$ git pull origin master
# 推送自己对项目更新的内容
$ git push 远程库地址别名 远程分支名
$ git push origin master
```

clone下载下来的是个目录，其中已有.git目录，故不用另外初始化。

注意到在push的时候，用不同的账号登录就反映了不同的人对远程库所作的修改。那么若组员尚未被邀请，则push会失败，命令行会显示403错误（访问权限不足）。

邀请方法：组长打开远程库，找Settiings->Manage access->Invite a collaborator，在弹出框中输入受邀组员的github用户名，然后会自动向该组员发送确认邮件，该组员接收邀请即可。

之后组员的push就会成功。需注意此时push，不弹出登录框，因为windows10系统帮忙记住了账号密码（见凭据管理器->windows凭据）。（存疑）

下面讲讲pull命令。它包含两个操作：

- fetch（抓取）：仅读，故无登录要求，直接抓取下来。

  ```bash
  # 将远程仓库更新的内容下载到本地，但是不刷新本地内容
  $ git fetch 远程库地址别名 远程分支名
  $ git fetch origin master
  ```

- merge：合并。刷新本地内容。

  ```bash
  $ git merge 远程库地址别名/远程分支名
  $ git merge origin/master
  ```

注：可从本地主干切换到远程库的主干：

```bash
$ git checkout origin/master
```

有时慎重起见（怕有文件冲突），我们先fetch看看，而不直接pull。

pull时可能产生文件冲突，如此则进入MERGING状态，解决办法跟分支冲突的解决方法一样。

下面讲讲push命令。已提交条件下，push前git会先检查本地库是否与远程库保持一致，一致则直接推流，不一致则勒令我们先去pull，pull没问题则用push推流，有问题（文件冲突）则解决完冲突再用push推流。

![团队内部与远程库](git.assets/团队内部与远程库.png)

#### 跨团队协作

另一个团队的组长登录github，选定本团队的某个远程库，单击fork按钮。

![image-20210619173243854](D:\chaofan\typora\专业\Git.assets\image-20210619173243854.png)

如上图所示，成功后对方也拥有此项目（包括全部分支），但其项目名旁边多了个表明来源的fork标记，意味着对方有权读自己的此项目但无权写本方的此项目。

目前无法进行实操，自行回顾[视频-跨团队协作](https://www.bilibili.com/video/BV1pW411A7a5?p=41)或日后去团队中实践。以文字形式归纳步骤如下：

1. 对方fork本方的项目。
2. 对方对自己的此项目提交更新。
3. 对方在自己的此项目里进pull requests，点New pull request。
4. 浏览器自动跳转到本方此项目里，对方Create pull request。
5. 本方进pull request，点开对方发过来的请求。
6. 审核无误，Merge pull request。

![跨团队协作](D:\chaofan\typora\专业\Git.assets\跨团队协作-16495570161372.png)

#### 免密登录

##### SSH

有了这个，每次push就不用输入用户名和密码了，当然只针对一个用户。

不过这种方法暂时不记，因为下面一种更简单的操作可达同样效果。

##### 远程连接

创建远程库后，通过clone操作一箭三雕：下载远程库；建立远程连接；跳过后续验证。

clone时用如下格式可跳过后续push时用户名密码的输入，且添加与远程库的连接。

```bash
$ git clone https://邮箱:密码@仓库地址
# 克隆并建立连接
$ git clone https://xxxxxx%40google.com:123456@github.com/Super-Van/notebook.git
```

2021年暑期，因为github推行更安全的令牌机制，取代以前的密码，所以上述写法有所改变：

```bash
$ git clone https://xxxxxx%40google.com://xxxxxxxxxxxxxxxxxxxx@github.com/Super-Van/notebook.git
```

或者不使用克隆，而是通过修改远程连接设置推送验证的跳过：

```bash
# origin连接尚不存在
$ git remote add origin https://xxxxxxxxxxxxxxxxxxxx@github.com/Super-Van/notebook.git

# origin连接已被添加
$ git remote set-url origin https://xxxxxxxxxxxxxxxxxxxx@github.com/Super-Van/notebook.git
```

关于令牌机制的更多解读，可参见[github开发人员在七夕搞事情](https://blog.csdn.net/weixin_41010198/article/details/119698015)。

## 图形化界面操作

### eclipse

这里仅以eclipse为例，其他IDE中使用git的方法自行找教程学习。

项目右键->Team->Share Project。

<img src="D:\chaofan\typora\专业\Git.assets\image-20210619191222288.png" alt="image-20210619191222288" style="zoom:80%;" />

<img src="D:\chaofan\typora\专业\Git.assets\image-20210619191629983.png" alt="image-20210619191629983" style="zoom:80%;" />

完成之后就能看到项目里诸目录的徽标都变了，且项目名旁边会多一个master文字标记。

可以在Preferences->Team->Git->Configuration的Repository Settings一栏中设置项目级别签名。这一步了解即可。

在Preferences->Team->Git->Label Decorations中能了解图标的解释。

提交的时候，注意不要把项目无关文件也提交（包括追踪）了，比如eclipse的.setting目录、.classpath文件、target目录等等。我们可以全局设置git忽略文件，步骤如下：

1. github官方给了一个[java样例](https://github.com/github/gitignore/blob/master/Java.gitignore)和[eclipse样例](https://github.com/github/gitignore/blob/master/Global/Eclipse.gitignore)。去下载下来。

2. 用一个文件存放样例并放在.gitconfig的同级目录下。

3. 在全局的.gitconfig文件中引入上述文件。具体在文件里编写或在eclipse里配置都行。

   ```ini
   [user]
   	name = van
   	email = van@google.com
   [core]
   	# 必须是正斜杠，因为linux用的是正斜杠
   	excludesfile=c:/users/van/.gitigore
   ```

完成之后，我们就会发现那些无关文件都不带问号（待追踪）了。如果有漏网之鱼，自己手动添加忽略项吧。我们也可以选择在针对特定项目建一个.gitignore文件（与.git同级），而不实行全局忽略。

添加到暂存区。有两种方式：

- 项目右键->Team->Add to Index。

- 项目右键->Team->Commit，然后见下图操作指引：

  <img src="D:\chaofan\typora\专业\Git.assets\image-20210619201556894.png" alt="image-20210619201556894" style="zoom: 67%;" />

写上提交信息，点上述窗口右下角的Commit按钮即成功提交。

推送：项目右键->Team->Remote->Push，在弹窗中填上远程库的地址以及用户名密码（可保存），在又一弹窗中，简便起见就点Add All Branches Spec按钮，最后点Next（附上一些日志）或Finish以完成。注：期间可能看到多条历史记录，因为已经有了多次本地提交，多次本地提交之后才有这次push。

克隆：直接利用eclipse界面完成从下载到转化为eclipse项目。

1. 

<img src="D:\chaofan\typora\专业\Git.assets\image-20210619203642744.png" alt="image-20210619203642744" style="zoom:67%;" />

<img src="D:\chaofan\typora\专业\Git.assets\image-20210619203756316.png" alt="image-20210619203756316" style="zoom:67%;" />

2. 在下一个窗口填写远程库地址等必要信息。

3. 下一个窗口里需要调整一下项目路径。

4. 下一个窗口里应单选最后一项Import as general project。
5. 项目右键->Configure->Convert to Maven Project。

在eclipse中解决冲突的操作这里就不记了，因为没有实操条件，自行回顾封老师视频。值得一提的是，老师做的模拟是在不同的本地库（同一台电脑上的不同目录）向同一个远程库push。

## git工作流

直接上图：

<img src="D:\chaofan\typora\专业\Git.assets\image-20210619210922557.png" alt="image-20210619210922557" style="zoom:80%;" />

## Gitlab服务器环境搭建

linux登场了，暂且不记。

## 注

梯子会影响push时的连接，取消代理：

```bash
git config --global --unset http.proxy
```

## NPM

node package manager-node-模块管理工具。我们可以通过npm快速安装、卸载所需要的资源文件，如jQuery、Vue等。

#### 安装

参见[nodejs笔记](nodejs.md)

#### 用npm管理模块

npm命令下载安装的实质是从npmjs.com平台上下载安装。

```bash
#把模块安装到当前项目中，具体在node_modules文件夹里
$ npm install 模块名
#把模块安装在全局环境中
$ npm install 模块名 -g
#安装指定版本号的模块
$ npm install 模块名@1.0.0
#查看某个模块的版本信息，输出到指定JSON文件中
$ npm view 模块名 versions > 模块名.version.json

#初始化当前项目的配置依赖清单
$ npm init -y
#把模块保存到清单的生产依赖中
$ npm i 模块名 --save
#把模块保存到清单的开发依赖中
$ npm i 模块名 --save-dev
#根据清单里配置的要求跑环境
$ npm i

#查看全局模块的目录
$ npm root -g
#卸载安装在当前项目里的模块
$ npm uninstall 模块名
#卸载全局安装模块
$ npm uninstall 模块名 -g
```

