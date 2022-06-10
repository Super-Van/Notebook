# Linux

参考视频：

## 概述

Linux系统特点：

- 开放性（开源）。
- 多用户、多任务：允许多个用户同时操作同一个系统，允许多个任务同时进行。
- 良好的用户界面。
- 优异的性能与稳定性：比如那些个服务器长年不关机一直坚挺，在网上处理大量的请求。

linux的分支有很多，有名的有：Ubuntu、Debian、CentOS、Redhat、SUSE等。

关于linux的其他介绍，自行查资料。

## 虚拟机

安装OS的方式有两种：

- 真机安装。
- 虚拟机安装。

如果不搞双系统，真机安装新系统后旧系统就没了，被替换了；如果搞双系统，管理起来很麻烦，如两个系统盘，基本没有人搞双系统了。

虚拟机安装是通过一些特定手段来模拟安装，即在毫不影响旧系统的条件下嵌入新系统。

装真机代价过大，虚拟机是一款承载OS并能使其模拟真实OS运作的软件。著名的有VMware出品的VMware workstation、Oracle出品的Virtual Box。

安装没什么可说的，就是装完之后要检查虚拟机软件是否安装2个虚拟网卡，没有说明安装失败了。他们影响主系统和虚拟系统之间的网络通信。

有了虚拟机，就可继续安装linux，我们选CentOS 6.5，给个[镜像地址](https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.5/isos/x86_64/)，选择其中的CentOS-6.5-x86_64-bin-DVD1.iso。

安装OS前，先在虚拟机软件中新建一个虚拟机，来承载OS，一个虚拟机承载一个OS。关于具体操作自行参考视频。完成之后我们注意到，这个过程只是对硬件方面进行配置，只待OS入机。

关于安装OS的步骤也请参见视频。

防手贱，vmware有备份功能，具体有两种实现方式：

- 快照：又叫还原点，适用于短期频繁的恢复，做快照时虚拟机一般处开启状态。
- 克隆：适用于长期备份，其实就是将当前虚拟机内容目录完整复制一份（这比新建一个状态一模一样的虚拟机要快很多），做克隆时虚拟机必须处关闭状态。

## 终端

### 概述

终端（terminal）是我们使用linux的主工具，要掌握。

先以一些关机命令了解命令行的基本结构：

```shell
# 最常用的 还具有定时等选项 -h是某个选项，now是此选项值 不过这里van用户没有执行shutdown命令的权限
[ van@localhost 桌面 ]$ shutdown -h now
# 关闭内存，间接造成关机
[ van@localhost 桌面 ]$ halt
```

- van：登录的用户。
- localhost：主机名。
- 桌面：终端所处目录。
- `$`：用户身份标识符。`#`代表超级管理员root；`$`代表非root用户。

### 文件系统

我们的命令行操作极大部分是针对文件的。

文件含于文件夹，但本质上linux将文件与文件夹都视作文件，且对软件、硬件也都视作文件。

> linux中一切皆文件。

围绕文件的操作不外乎创建、编辑、保存、关闭、重命名、删除、恢复。

有些目录是极为重要的，不能删的，熟悉一下：

- bin：即binary，里面全是二进制文件，全是可以运行的。
- dev：存放外接设备如磁盘、光盘，外设不能直接使用，要先手动挂载（分配盘符）。
- etc：存放一些配置文件。
- home：存放root之外诸用户的个人文件。
- mnt：联系dev，外设就挂载到此目录。
- proc：存放OS上正在运行的进程。
- root：存放root用户的个人文件，root以外的用户无权访问。
- sbin：即super binary，存放一些可执行程序（二进制文件），不过这些程序（指令）的执行权限仅root拥有。
- tmp：即temporary，存放OS运行时产生的一些临时文件，如日志。
- usr：存放用户安装的软件。
- var：存放日志文件。

### 指令与选项

#### 概述

在终端中输入的一行内容就是一条指令（command）linux普遍的命令行格式如下：

```shell
# 指令主体 [选项] [操作对象]
```

主体仅一个，选项可多个，操作对象可多个。

下面学习具体的诸多指令。提前说明一下tab键可帮助补全文档名，要常用tab键。

#### ls

即list，列出本目录下所有文件和文件夹，再根据选项展示具体信息。

```shell
# 绝对路径
[ root@localhost boot]# ls /boot
[van@localhost /]$ ls boot
config-2.6.32-431.el6.x86_64         lost+found
efi                                  symvers-2.6.32-431.el6.x86_64.gz
grub                                 System.map-2.6.32-431.el6.x86_64
initramfs-2.6.32-431.el6.x86_64.img  vmlinuz-2.6.32-431.el6.x86_64
# 相对路径 当前在root目录
[ root@localhost ~]# ls ../boot/grub
```

```shell
# 带上-l，以列表形式展现诸文件详细信息 当前在根目录（文件系统）
[van@localhost /]$ ls -l /boot
总用量 23948
-rw-r--r--. 1 root root   105195 11月 22 2013 config-2.6.32-431.el6.x86_64
drwxr-xr-x. 3 root root     1024 3月   5 01:55 efi
drwxr-xr-x. 2 root root     1024 3月   5 01:57 grub
-rw-------. 1 root root 17551558 3月   5 17:22 initramfs-2.6.32-431.el6.x86_64.img
drwx------. 2 root root    12288 3月   5 01:51 lost+found
-rw-r--r--. 1 root root   193758 11月 22 2013 symvers-2.6.32-431.el6.x86_64.gz
-rw-r--r--. 1 root root  2518236 11月 22 2013 System.map-2.6.32-431.el6.x86_64
-rwxr-xr-x. 1 root root  4128368 11月 22 2013 vmlinuz-2.6.32-431.el6.x86_64
```

理解每列的含义：

- 第一列的首字符表示文档类型，`-`指文件，`d`指文件夹，其他类型以后再见到。
- 第二列先不管。
- 第三列表示文档所属用户。
- 第四列表示文档所属用户组。
- 第五列表示文档大小，单位是字节。
- 第六、七、八列表示上次修改的日期时间。
- 第九列表示文档名称。

```shell
# 带上-la，包括隐藏文件 隐藏文件以.开头，隐藏目录是..
[van@localhost /]$ ls -la /boot
总用量 23956
dr-xr-xr-x.  5 root root     1024 3月   5 01:57 .
dr-xr-xr-x. 26 root root     4096 3月   5 17:27 ..
-rw-r--r--.  1 root root   105195 11月 22 2013 config-2.6.32-431.el6.x86_64
drwxr-xr-x.  3 root root     1024 3月   5 01:55 efi
drwxr-xr-x.  2 root root     1024 3月   5 01:57 grub
-rw-------.  1 root root 17551558 3月   5 17:22 initramfs-2.6.32-431.el6.x86_64.img
drwx------.  2 root root    12288 3月   5 01:51 lost+found
-rw-r--r--.  1 root root   193758 11月 22 2013 symvers-2.6.32-431.el6.x86_64.gz
-rw-r--r--.  1 root root  2518236 11月 22 2013 System.map-2.6.32-431.el6.x86_64
-rwxr-xr-x.  1 root root  4128368 11月 22 2013 vmlinuz-2.6.32-431.el6.x86_64
-rw-r--r--.  1 root root      166 11月 22 2013 .vmlinuz-2.6.32-431.el6.x86_64.hmac
# 更人性化的列表 -lah也可用 容量单位灵活变化 这里文件夹的容量不随内部文档多少而变化
[van@localhost /]$ ls -lh /boot
总用量 24M
-rw-r--r--. 1 root root 103K 11月 22 2013 config-2.6.32-431.el6.x86_64
drwxr-xr-x. 3 root root 1.0K 3月   5 01:55 efi
drwxr-xr-x. 2 root root 1.0K 3月   5 01:57 grub
-rw-------. 1 root root  17M 3月   5 17:22 initramfs-2.6.32-431.el6.x86_64.img
drwx------. 2 root root  12K 3月   5 01:51 lost+found
-rw-r--r--. 1 root root 190K 11月 22 2013 symvers-2.6.32-431.el6.x86_64.gz
-rw-r--r--. 1 root root 2.5M 11月 22 2013 System.map-2.6.32-431.el6.x86_64
-rwxr-xr-x. 1 root root 4.0M 11月 22 2013 vmlinuz-2.6.32-431.el6.x86_64
```

我们可以由列出来的名称的颜色得到一些信息：

- 蓝色的表示文件夹。
- 黑色的表示文件。
- 绿色的表示当前用户对其拥有全部权限。
- 红色的表示？

#### pwd

即print working directory-打印当前工作目录。

```shell
[van@localhost /]$ pwd
/
[van@localhost grub]$ pwd
/boot/grub
```

#### cd

即change directory-切换到某目录（路径）。

```shell
cd /usr/local
cd ..
cd ../home/van
cd ./boot/grub
cd mnt
# 去往当前用户的home目录
cd ~
```

#### mkdir

即make directory-创建目录。

```shell
# 当前目录中创建
mkdir olympic
# 指定目录中创建
mkdir /boot/olympic
# 层递创建 从a开始往下一级级创建，就不用输4次指令
mkdir -p /boot/olympic/a/b/c/d
# 一次创建多个
mkdir ~/a ~/b ~/c
```

#### touch

创建文件。

```shell
# 当前目录下创建
touch books.txt
# 指定目录下创建 但没有像mkdir那样多级创建目录的能力，只能依赖现存目录
touch van/文档/a.txt
# 创建多个
touch van/a.txt van/b.txt van/c.txt
```

#### cp

即copy-复制文件或目录到指定路径。

```shell
# 复制当前目录下的某文件，只用写文档名 虽然克隆出的文件名可以变，但最好不要
cp dog.txt /home/van/dog.txt
# 指定其他目录下的某文件
cp boot/duck.txt /home/van/duck.txt
# 拷贝目录时要加-r选项 -r表示递归（recursion），穷尽目录里面的文档，其他一些命令也有此选项
cp -r monkey root/monkey # 执行前无monkey，执行后有了
cp -r monkey root/monkey # 执行前有了money，执行后就得到root/monkey/monkey
# 同名称的话也可不写名称
cp -r paper-master/* pre-training/ # 要求执行前有pre-training，复制文件不能帮我们创建新目录
cp -r paper-master pre-training # 上一行的等价写法，执行前无pre-training，复制单级目录可顺带创建新目录，多级不行
```

#### mv

即move-移动文件或目录到指定路径，用法与上同。

另外一个用处就是重命名。

```shell
mv duck.txt chicken.txt
mv root/a.txt root/b.txt
```

#### rm

即remove-移除文件或目录。

```shell
# 针对文件，不带选项，可能会提示是否删除……？输入y/yes-确定或n/no-取消
rm a.txt
# 针对文件，带-f，即force-强制，不会冒出提示
rm -f boot/b.txt
# 针对目录，带-rf，即递归且强制，不会冒出任何提示，删除此目录及其所有内容 仅-r会递归询问是否删除，啥都不带会冒出无法删除
rm -rf boot/animal
# 删除多个文件
rm -f boot/animal/duck.txt boot/animal/dog.txt
# 删除多个 文件并目录
rm -rf boot/animal root/a.txt root/animal
# 借助通配符，删除linux开头的所有文件
rm -f ~/linux*
```

一般我们不想看见任何提示或询问，删就完了。

删除有风险，动手需谨慎。

#### vim

vim是个指令，但又常作为一款文本编辑器，功能强大，这里只认识一下，后面会详细讲。

打开一个可有可无的文件，有则打开，无则自动创建再打开。

```shell
# 对象不能是目录
vim install.log
```

这样就进入了一个编辑界面，后续操作以后再说。

#### 输出

有时我们想把指令的执行结果保存到文件中，通过下列指令：

- `>`：覆盖输出，覆盖掉文件原来的所有内容。
- `>>`：追加输出，在文件末尾添加。

```shell
# 文件可有可无，无则先自动创建
ls -la > ls.txt
ls -lh >> boot/animal/ls.txt
```

#### cat

即concatenate-合并。

一个功能是打开文件，与vim不同，它并不弄出一个编辑界面，而是以只读的方式打开。

```shell
[van@localhost animal]$ cat dog.txt
I am a dog.
# 展示完直接跟命令行的头
[van@localhost animal]$
```

另一个功能是合并文件内容，往往输出到一个新文件。

```shell
[van@localhost animal]$ cat dog.txt  cat.txt > mix.txt
[van@localhost animal]$ cat mix.txt 
I am a dog.
I am a cat.
```

#### df

查看磁盘空间。
