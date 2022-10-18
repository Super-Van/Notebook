# Linux

参考视频：[Linux入门教程](https://www.bilibili.com/video/BV1nW411L7xm?p=1)。

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

- 依托真机：对于真机，不搞双系统，安装新系统后旧系统就被替换了；搞双系统，管理起来很麻烦，如存在两个系统盘。
- 依托虚拟机：推荐。

依托于虚拟机是指在毫不影响旧系统的条件下嵌入新系统。虚拟机是一款承载OS并能使其模拟真实OS运作的软件。著名的有VMware出品的VMware workstation、Oracle出品的Virtual Box。

先安装虚拟机软件，装完后要检查是否装有2个虚拟网卡，没有说明安装失败。它们影响主系统和虚拟系统间的网络通信。

有了虚拟机，才可继续安装linux，我们选CentOS 6.5，给个[镜像地址](https://mirrors.tuna.tsinghua.edu.cn/centos-vault/6.5/isos/x86_64/)，选择其中的CentOS-6.5-x86_64-bin-DVD1.iso。

接着在虚拟机软件中新建一个虚拟机，来承载OS，一个虚拟机承载一个OS。完成之后我们注意到这个过程只是对硬件方面进行配置，只待OS上机，故其后安装OS。详细步骤参见视频。

防手贱，vmware有备份功能，具体有两种实现方式：

- 快照：又叫还原点，适用于短期频繁的恢复，做快照时虚拟机一般处开启状态。
- 克隆：适用于长期备份，其实就是将当前虚拟机内容完整复制一份，这比新建一个状态一模一样的虚拟机要快很多，做克隆时虚拟机须处关闭状态。

## 终端

### 概述

终端（terminal）是我们使用linux的主工具，必须掌握。

先以一些关机命令了解命令行的基本结构：

```sh
# 最常用的，还具有定时等选项，-h即定时选项，now是选项值 不过这里van用户没有执行shutdown命令的权限
[ van@localhost 桌面 ]$ shutdown -h now
# 关闭内存，间接造成关机
[ van@localhost 桌面 ]$ halt
# 还有一种
[ van@localhost 桌面 ]$ init 0
```

- van：登录的用户。
- localhost：主机名。
- 桌面：终端所处目录。
- `$`：用户身份标识符。`#`代表超级管理员root；`$`代表普通用户。

### 文件系统

我们的命令行操作绝大部分是针对文件的。

文件含于文件夹，但本质上linux将文件与文件夹都视作文件，且将软件、硬件也都视作文件。

> linux中一切皆文件。

围绕文件的操作不外乎创建、删除、恢复、编辑、保存、打开、关闭、重命名。

有些目录是极为重要的、不能删的，熟悉一下：

```
bin：即binary，里面全是二进制文件，全是可以运行的
dev：存放外接设备如磁盘、光盘，使用外设前要先手动挂载。
etc：存放一些配置文件。
home：存放root之外诸用户的个人文件
mnt：联系dev，外设就挂载到此目录
proc：存放当前进程相关文件
root：存放root用户的个人文件，root以外的用户无权访问
sbin：即super binary，存放一些可执行程序（二进制文件），不过这些程序（指令）的执行权限仅root拥有
tmp：即temporary，存放OS运行时产生的一些临时文件，如日志
usr：存放用户安装好的软件
var：杂项
opt：软件安装包
```

### 指令

#### 概述

在终端中输入的一行内容就是一条指令（command），linux通用命令行格式如下：

```sh
# 指令主体 [选项] [操作对象]
```

主体仅一个，选项可多个且无序，操作对象可多个。

下面学习一些具体的指令。说明：

- tab键可帮助补全文件名，常用。
- 大量指令有权限，就不一一说明了。
- 有的指令不具有普适性，随不同的linux分支、同分支的不同版本变化。

#### ls

即list，列出本目录下所有文件和文件夹。

```sh
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

```sh
# 带上-l，以列表形式展现诸文件详细信息，等价于ll
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

- 第一列的首字符表示文档类型，`-`指文件，`d`指文件夹，其他字符留待[权限](#权限)一节再说。
- 第二列先不管。
- 第三列表示文档所属用户。
- 第四列表示文档所属用户组。
- 第五列表示文档大小，单位是字节。
- 第六、七、八列表示上次修改的日期时间。
- 第九列表示文档名称。

```sh
# 带上-la，包括隐藏文件 隐藏文件以.开头，隐藏目录以..开头
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
# 更人性化的列表 容量单位灵活变化 展示出来的文件夹的容量不由内部文档多少决定即非真实容量
[van@localhost /]$ ls -lh /boot
总用量 24M # 同理总容量也不准确
-rw-r--r--. 1 root root 103K 11月 22 2013 config-2.6.32-431.el6.x86_64
drwxr-xr-x. 3 root root 1.0K 3月   5 01:55 efi
drwxr-xr-x. 2 root root 1.0K 3月   5 01:57 grub
-rw-------. 1 root root  17M 3月   5 17:22 initramfs-2.6.32-431.el6.x86_64.img
drwx------. 2 root root  12K 3月   5 01:51 lost+found
-rw-r--r--. 1 root root 190K 11月 22 2013 symvers-2.6.32-431.el6.x86_64.gz
-rw-r--r--. 1 root root 2.5M 11月 22 2013 System.map-2.6.32-431.el6.x86_64
-rwxr-xr-x. 1 root root 4.0M 11月 22 2013 vmlinuz-2.6.32-431.el6.x86_64
```

我们可以由列出来的名称的颜色得到一些信息，例如：

- 蓝色的表示文件夹。
- 黑色的表示文件。
- 绿色的表示当前用户对其拥有全部权利。

#### pwd

即print working directory-打印当前工作目录。

```sh
[van@localhost /]$ pwd
/
[van@localhost grub]$ pwd
/boot/grub
```

#### cd

即change directory-切换到某目录（路径）。

```sh
cd /usr/local
cd ..
cd ../home/van
cd ./boot/grub
cd mnt
# 去往当前用户的home目录
cd ~
# 同上
cd
```

#### mkdir

即make directory-创建目录。

```sh
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

```sh
# 当前目录下创建
touch books.txt
# 指定目录下创建 但没有像mkdir那样多级创建目录的能力，只能依赖现存目录
touch van/文档/a.txt
# 创建多个
touch van/a.txt van/b.txt van/c.txt
```

#### cp

即copy-复制文件或目录到指定路径。

```sh
# 复制当前目录下的某文件，只用写文档名 虽然克隆出的文件名可以变，但最好不要
cp dog.txt /home/van/dog.txt
# 指定其他目录下的某文件
cp boot/duck.txt /home/van/duck.txt
# 拷贝目录时要加-r选项 -r表示递归（recursion），穷尽目录里面的文档，其他一些命令也有此选项
cp -r monkey root/monkey # 执行前无monkey，执行后有了
# 要求执行前有pre-training，因为它后面跟了/表它已经存在
cp -r paper-master/* pre-training/
# 上一行的等价写法，执行前无pre-training，自动创建
cp -r paper-master pre-training 
```

#### mv

即move-移动文件或目录到指定路径，用法与上同。

另外一个用处就是重命名。

```sh
mv duck.txt chicken.txt
mv root/a.txt root/b.txt
```

#### rm

即remove-移除文件或目录。

```sh
# 针对文件，不带选项，可能会提示是否删除……？输入y/yes-确定或n/no-取消
rm a.txt
# 针对文件，带-f，即force-强制，不会冒出提示
rm -f boot/b.txt
# 带-rf，即递归且强制，不会冒出任何提示，针对目录则一并删除其下所有东西，仅-r会递归询问是否删除，无-r会冒出无法删除
rm -rf boot/animal
# 删除多个文件
rm -f boot/animal/duck.txt boot/animal/dog.txt
# 删除多个文件并目录
rm -rf boot/animal root/a.txt root/animal
# 借助通配符，删除linux开头的所有文件或目录
rm -r ~/linux*
```

删除有风险，动手需谨慎。

#### vim

vim是个指令，但又常作为一款文本编辑器，功能强大，这里只认识一下，后面会详细讲。

打开一个可有可无的文件，有则打开，无则自动创建再打开。

```sh
# 对象不能是目录
vim install.log
```

这样就进入编辑模式，后续操作以后再说。

#### 输出

有时我们想把指令的执行结果保存到文件中，通过下列指令：

- `>`：覆盖输出，覆盖掉文件原来的所有内容。
- `>>`：追加输出，在文件末尾添加。

```sh
# 文件可有可无，无则先自动创建
ls -la > ls.txt
ls -lh >> boot/animal/ls.txt
```

#### cat

即concatenate-合并。

一个功能是打开文件，与vim不同，它并不弄出一个编辑界面，而是以只读的方式打开。

```sh
[van@localhost animal]$ cat dog.txt
I am a dog.
# 展示完直接跟命令行的头
[van@localhost animal]$
```

另一个功能是合并文件内容，往往输出到一个新文件。

```sh
[van@localhost animal]$ cat dog.txt  cat.txt > mix.txt
[van@localhost animal]$ cat mix.txt 
I am a dog.
I am a cat.
```

#### df

查看磁盘使用情况：

```sh
# 最后一列指磁盘对应的路径 中间两个盘是预留盘
[van@localhost 桌面]$ df -h
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root   18G  4.1G   13G  25% /
tmpfs                         491M   80K  491M   1% /dev/shm
/dev/sda1                     485M   35M  426M   8% /boot
/dev/sr0                      4.2G  4.2G     0 100% /media/CentOS_6.5_Final
```

#### free

查看内存使用：

```shell
# 本例中已用600，剩余672，实际可用380, 26+265是缓存缓冲 因单位影响，存在舍入情况，380+26+265=671约等于672, 671+308=979约等于980
[van@localhost 桌面]$ free -m
             total       used       free     shared    buffers     cached
Mem:           980        600        380          0         26        265
-/+ buffers/cache:        308        672
Swap:         1983          0       1983
# 最后一行指交换空间，把部分外存临时用作内存，当然不宜过大
```

选项中`m`指单位MB，同理可用`g`等，但一般用`m`，因为最合适。

#### head

查看一个文件的前n行，n默认为10。

```shell
head ./article.txt
head -5 article.txt
```

#### tail

与head相反。

常用`tail -10 文件路径`查看文件的实时变化，如检查日志。

#### less

以内容占满一窗口的形式查看文件，配合以一些按键，如数字-从某行开始、空格-滚动到下一窗口（页）、上（下）键-滚动到上（下）一行。

```shell
less temp/log.txt
```

与Vim类似，窗口末端显示的是`:`，意思是处非命令行模式，用q键退回到命令行模式。

#### wc

统计文件内容，如行数、单词数、字节数。

```sh
# lines
wc -l log.txt
# words
wc -w log.txt
# bytes
wc -c log.txt
# 一箭三雕
wc log.txt
```

#### date

读取日期、时间：

```sh
[root@localhost ~]# date
2022年 07月 18日 星期一 22:54:49 CST
[root@localhost ~]# date +%F
2022-07-18
[root@localhost ~]# date +%y-%m-%d
22-07-18
[root@localhost ~]# date +%Y-%m-%d
2022-07-18
[root@localhost ~]# date "+%F %T"
2022-07-18 22:59:47
[root@localhost ~]# date "+%Y-%m-%d %H:%M:%S"
2022-07-18 23:00:13
# 时间推移
[root@localhost ~]# date -d "-30 day" "+%Y-%m-%d %H:%M:%S"
2022-06-18 23:14:43
[root@localhost ~]# date -d "-2 year" "+%Y-%m-%d %H:%M:%S"
2020-07-18 23:16:28
```

#### cal

展示日历：

```sh
# 本月
cal -1
# 上月、本月、下月
cal -3
# 2018年全年
cal -y 2018
```

#### clear

清屏-把前置内容滚到上面去，等价于快捷键CTRL+L。

#### 管道符

即`|`，不能单独使用，只能辅助其他命令。

用于过滤：

```sh
# grep：字符串匹配，本例旨在找出文件名含y的文件
[root@localhost ~]# ls / | grep y
sys
```

用于构造复杂命令，前一个命令的输出作后一个命令的输入：

```sh
# 统计/目录下的文件数
[root@localhost ~]# ls -la / | wc -l
28
```

#### hostname

读取及临时修改主机名。windows上的主机名见于此电脑->属性里的计算机名，安装OS后自动生成，可更改。

```sh
# 主机名
[root@localhost ~]# hostname
localhost.localdomain
# FQDN-全限定域名
[root@localhost ~]# hostname -f
localhost
```

#### id

查看某用户的基本信息：用户id、用户组id、附加组id等，默认是当前用户。

```sh
[root@localhost ~]# id
uid=0(root) gid=0(root) 组=0(root) 环境=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[root@localhost ~]# id van
uid=500(van) gid=500(van) 组=500(van)
```

验证：

```sh
cat /etc/passwd
cat /etc/group
```

#### whoami

指代执行此命令的用户：

```sh
# 不能说是登录的用户，因为可能多用户登录
[root@localhost ~]# whoami
root
```

从命令行来看多此一举了，它一般参与shell脚本。

#### ps

即process status-查看服务进程的信息。

```sh
# 展示所有的行-进程
ps -e
# 展示所有的列-指标
[root@localhost ~]# ps -f
UID         PID   PPID  C STIME TTY          TIME CMD
root       3076   3074  0 Jul18 pts/0    00:00:00 /bin/bash
root      13888   3076  0 02:25 pts/0    00:00:00 ps -f
# 全行全列
ps -ef
# 全行全列参与匹配
ps -ef | grep firefox
```

表头各指标梳理：

- UID：启动此进程的用户，别忘了linux支持多用户操作。
- PID：process id。
- PPID：parent process id。
- C：占用CPU的比率，隐藏%。
- STIME：start time-进程的启动时间。
- TTY：发起此进程的终端设备的标识符，`?`值表示此进程并非由终端发起而由OS发起。
- TIME：进程的执行时间。
- CMD：进程对应的原始程序的路径或发起进程的命令

当前进程被父进程调用，若无父进程即PPID分量在PID全列中不存在，则叫做僵尸进程。

#### top

每隔3秒刷新OS的状况及诸进程对系统资源的占用情况：

```sh
# 同样按q退回到命令行模式
[root@localhost ~]# top

top - 02:49:33 up  3:55,  2 users,  load average: 0.00, 0.00, 0.00
Tasks: 152 total,   1 running, 151 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.0%us,  0.0%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1004412k total,   694168k used,   310244k free,    49948k buffers
Swap:  2031608k total,        0k used,  2031608k free,   282824k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
  2423 root      20   0  296m  40m 9092 S  1.3  4.1   0:10.99 Xorg              
  3074 root      20   0  347m  16m  11m S  0.7  1.7   0:02.30 gnome-terminal    
     1 root      20   0 19364 1552 1228 S  0.0  0.2   0:00.86 init              
     2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd          
     3 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0       
     4 root      20   0     0    0    0 S  0.0  0.0   0:00.10 ksoftirqd/0       
     5 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/0       
     6 root      RT   0     0    0    0 S  0.0  0.0   0:00.01 watchdog/0        
     7 root      20   0     0    0    0 S  0.0  0.0   0:08.10 events/0          
     8 root      20   0     0    0    0 S  0.0  0.0   0:00.00 cgroup            
     9 root      20   0     0    0    0 S  0.0  0.0   0:00.00 khelper           
    10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 netns             
    11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 async/mgr         
    12 root      20   0     0    0    0 S  0.0  0.0   0:00.00 pm                
    13 root      20   0     0    0    0 S  0.0  0.0   0:00.06 sync_supers       
    14 root      20   0     0    0    0 S  0.0  0.0   0:00.04 bdi-default       
    15 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kintegrityd/0
```

各指标梳理：

- USER：启动此进程的用户。

- PR：即page rank，本义是网页级别，这里引申为进程的优先级。
- VIRT：virtual-虚拟内存，如谷歌浏览器启动时申请500M内存，但实际用了300M，那么虚拟内存是500M。
- RES：resident-常驻内存，如上例中的300M。
- SHR：shared-共享内存，如上例中的300M里面含有依赖的其他进程的占用空间，假如含100M，那么这100M就是共享内存。故实际占用内存=RES-SHR。
- S：sleeping，表示当前进程是否正在睡眠，S-挂起，R-运行。
- %CPU：进程占用百分之多少的CPU。
- %MEM：进程占用百分之多少的内存。
- TIME+：进程执行时间。
- COMMAND：同前面的CMD。

运维人员着重关注S及其后两个百分比，外加COMMAND。关注高占用率进程，可通过快捷键M对实时结果就%MEM列进行降序排列，通过快捷键P对实时结果就%CPU列进行降序排列，通过快捷键1展示多核CPU每个核的状况。

#### du

即directory usage，往往配合以几个选项查看目录的真实外存空间占用情况。

```sh
# summarize
[root@localhost ~]# du -s /etc
38868	/etc
[root@localhost ~]# du -sh /etc/
38M	/etc
```

#### find

查找文件，包括隐藏的。

```sh
# 从当前目录中找名字以.log结尾的文件 可见支持通配符，f表文件、d表目录
[root@localhost ~]# find ./ -name *.log -type f
./install.log
# 允许多级查找
[root@localhost ~]# find /etc -type d | wc -l
281
```

#### service

控制软件提供的服务的启动、停止与重启。

```sh
# 启动apache
[root@localhost ~]# service httpd start
正在启动 httpd：httpd: Could not reliably determine the server's fully qualified domain name, using localhost.localdomain for ServerName
                                                           [确定]
# 重启apache
[root@localhost ~]# service httpd restart
停止 httpd：                                               [确定]
正在启动 httpd：httpd: Could not reliably determine the server's fully qualified domain name, using localhost.localdomain for ServerName
                                                           [确定]
# 停止apache
[root@localhost ~]# service httpd stop
停止 httpd：                                               [确定]
```

附带讲，文件的可执行是成为服务的必要不充分条件，是成为进程的充要条件，进程不一定是服务。

#### kill

杀死进程及级联依赖它的子进程。

一种做法是先执行ps命令找出进程号，再执行`kill PID分量`。

另一种做法是执行`killall 进程名称（服务名）`。

#### ifconfig

获取网卡信息。

```sh
# eth-ethernet-以太网 lo-loop-环回地址 inet addr指IPV4 可见有两块网卡
[root@localhost ~]# ifconfig
eth0      Link encap:Ethernet  HWaddr 00:0C:29:79:21:5F  
          inet addr:192.168.44.128  Bcast:192.168.44.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:29ff:fe79:215f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:32969 errors:0 dropped:0 overruns:0 frame:0
          TX packets:276 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:8970487 (8.5 MiB)  TX bytes:30830 (30.1 KiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:2098 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2098 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:105026 (102.5 KiB)  TX bytes:105026 (102.5 KiB)
```

#### reboot

重启计算机（虚拟机）。

特殊用法是`reboot -w`，并不重启，只是模拟重启时往系统日志中写关、开机的日志，常用于测试。

#### shutdown

关机，对单位的服务器慎用。

```sh
# 立即关，加提示
shutdown -h now "要关机了哦"
# 定时关
shutdown -h 15:30
# shutdown -c或CTRL+C以取消
```

#### uptime

展示计算机本次运行时间。

```sh
# 8小时13分，当前有2个用户正在操作OS，最后一项指最近1分钟、5分钟、15分钟的平均负载
[root@localhost ~]# uptime
 01:52:35 up  8:13,  2 users,  load average: 0.00, 0.00, 0.00
```

#### uname

获取OS的相关信息，类似windows里的systeminfo。

```sh
[root@localhost ~]# uname
Linux
[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.32-431.el6.x86_64 #1 SMP Fri Nov 22 03:15:09 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
```

#### netstat

查看网络的连接状态：

```sh
[root@localhost ~]# netstat -tnlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 0.0.0.0:36559               0.0.0.0:*                   LISTEN      2086/rpc.statd      
tcp        0      0 0.0.0.0:111                 0.0.0.0:*                   LISTEN      2036/rpcbind        
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      2243/sshd           
tcp        0      0 127.0.0.1:631               0.0.0.0:*                   LISTEN      2116/cupsd          
tcp        0      0 127.0.0.1:25                0.0.0.0:*                   LISTEN      2323/master         
tcp        0      0 :::111                      :::*                        LISTEN      2036/rpcbind        
tcp        0      0 :::22                       :::*                        LISTEN      2243/sshd           
tcp        0      0 ::1:631                     :::*                        LISTEN      2116/cupsd          
tcp        0      0 :::45368                    :::*                        LISTEN      2086/rpc.statd      
tcp        0      0 ::1:25                      :::*                        LISTEN      2323/master 
```

四个选项往往一起出现：

- t：仅展示基于TCP协议的连接。
- n：针对Local Address、Foreign Address两列生成易读的套接字。
- l：过滤得到State分量为LISTEN-监听中的行，分量非LISTEN的连接拿来看没意义。
- p：展示出PID/Program name一列。

#### man

即manual，囊括全部linux命令的英文手册。按Q返回到命令行模式。

```sh
man cp
man ps
man man
```

#### 注

清空光标前的内容：CTRL+U。

清空光标后的内容：CTRL+K。

## Vim

### 概述

号称编辑器之神。Vi编辑器是Unix和Linux上的标准通用编辑器。Vim是Vi的升级版，后者仅适用于普通文本，适合写代码，命令集是前者的子集。

一般来说vim对文件的操作有三种模式：命令（默认）、末行、编辑。

操作前当然先得打开啦，有四种方式：

```sh
# 默认光标定位到上次退出时停留的地方，首次即首行
vim ./User.java
# 按路径打开并定位到第3行
vim +3 ./User.java
# 按路径打开并高亮显示指定单词
vim +/User ./User.java
# 同时打开多个
vim ./User.java Student.java
```

### 命令模式

光标移动：

- 行首：shift+6即^（联系正则表达式）或Home。
- 行末：shift+4即$或End。
- 首行行首：gg。
- 末行行首：G。
- 指定行：数字+G。
- 向上下跨若干行：数字+上下键。
- 向左右跨若干字符：数字+左右键。

翻屏：

- 向上：CTRL+B或PgUp。
- 向下：CTRL+F或PgDn。

拷贝：

- 复制当前行：yy。
- 赋值从当前行（含）开始往下数若干行：数字+yy。
- 可视化复制：CTRL+V，随后按上下左右选中文本就高亮显示，最后仍按yy。
- 粘贴到定位行的下一行：p。

剪切或删除：

- 剪切当前行，之后不粘贴就是删除了：dd。后续行向上补位。
- 剪切或删除从当前行（含）开始往下数若干行：数字+dd。
- 剪切或删除当前行，但后续行不补位，成空行：D。

撤销：输入`:u`（属末行模式了）或`u`，即undo。

恢复：CTRL+R。

### 末行模式

在窗口最后一行以`:`或`/`开始的命令处于末行模式。

光标移动：

- 指定行：数字+回车。

保存：

```sh
# 保存
:w
# 另存为
:w ~/doc/new.txt
```

退出：

```sh
# 退出，要求此前已保存或未修改
:q
# 保存并退出
:wq
# 不保存并退出
:q!
# 灵活根据文件是否被修改，等价成:q或:wq
:x
```

调用外部命令：

```sh
# 临时退回到命令行执行命令，执行完后按任意键回到vim操作界面
! ls . -ah
```

查找：

```sh
# 搜索rpc 按N往上，按n往下，光标移动到前一个或后一个目标词，可循环查
/rpc
# 取消目标词的高亮
:nohl
```

替换：

```sh
# 将本行内找到的第一个var替换为const
:s/var/const
# 将本行内找到的所有var替换为const
:s/var/const/g
# 将每行中找到的第一个var替换为const
:%s/var/const
# 将每行中找到的所有var替换为const
:%s/var/const/g
```

行号的显隐：

```sh
# 临时显示，下次打开就没有
:set nu # number
:set nonu
```

多文件切换：

```sh
# 打开了哪些文件
:files
  1 %a   "dynamic.txt"                  第 1 行
  2      "passwd"                       第 0 行
  3      "test.properties"              第 0 行
# a表正在操作的文件，#表上次操作的文件，行号指光标所在行，0表未打开过
# 切换到passwd
:open passwd
# 根据上述列表，切换到上一个、下一个
:bp # previous
:bn # next
```

### 编辑模式

关于三种模式的切换，末行模式与编辑模式不能互相切：

- 命令模式->末行模式：输入`:`；反之：双击Esc。
- 命令模式->编辑模式：按i-光标前插入或a光标后插入；反之：按Esc。

### 其他功能

代码着色：

```sh
:syntax on
:syntax off
```

还有计算器等稀奇古怪的就不赘述了。

### 配置

像行号的显隐等命令都是临时的，想弄成永久有效的可求助配置文件。配置文件分：

- 个人配置文件：地址是`~/.vimrc`，只对相应用户有效。
- 全局配置文件：地址是`/etc/vimrc`，对所有用户有效。

对同名配置，个人压过全局。

### 异常退出

编辑文件之后不用正常的命令退出，而用关闭窗口等方式退出，就属异常退出。那么下次打开时就询问怎么处理，有必要把交换文件`.xxx.swap`删掉，异常退出前的修改不会被保存。

### 命令别名

就比如为clear命令取别名cls。

对同一命令不同用户各取各的别名，依靠home下各人个人文件夹下的`.bashrc`配置文件。

```sh
# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# 添加一条
alias cls='clear'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
```

还得用`source .bashrc`命令使其生效。

## 运行级别

又叫运行模式。

linux中存在一个很重要的进程叫init，其id为1：

```sh
[root@localhost ~]# ps -ef | grep init
root          1      0  0 Jul20 ?        00:00:00 /sbin/init
root      31123  26472  0 02:55 pts/0    00:00:00 grep init
```

它对应一个配置文件`/etc/inittab`，叫系统运行级别配置文件。

我们主要看下面这一段：

```ini
# Default runlevel. The runlevels used are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode
#   4 - unused
#   5 - X11
#   6 - reboot (Do NOT set initdefault to this)
# 
id:5:initdefault:
```

逐一理解为：

0. 关机级别。
1. 单用户级别。
2. 多用户离线级别。
3. 多用户在线级别。
4. 预留级别。
5. 图形化界面模式。
6. 重启级别。

可见首尾都不建议作id值，一个是一开机就关机，一个是一开机就重启。它俩作init命令的选项有用。

```sh
# 重启
init 6
# 临时切换到多用户模式，非5自然都是纯命令行模式
init 3
```

执行init命令即是调用init进程，选项值即是上述7个级别，调用时会读配置文件。

那么后续将永久用命令行，须改配置文件中的id值为3。

## 用户

### 概述

linux是多用户多任务系统，须对用户进行管理，不外乎账号管理、权限控制、文件组织、安全性保护。

对用户的管理依赖三个重要文件：

```
/etc/passwd：用户的信息
/etc/group：用户组的信息
/etc/shadow：用户的密码信息
```

### 用户管理

添加用户：

```sh
# -g：将用户归入一个已有的主组，必须且只能属于一个主组，默认OS创建一个名字同此用户名的主组并让其归入
useradd -g 2 Bob # 主组号
useradd -g CN Bob # 主组名
# -G：将用户归入多个已有的附加组，主组以外的组均为附加组
useradd -G UN Bob
# -u：uid-标识符，默认系统分配500之后的某个数
useradd -g 2 -G UN -u 521 Bob
# -c：注释
useradd -g 2 -G UN -u 521 -c "a good friend" Bob
```

执行完毕可查看三个文件验证新账号是否创建成功。

比如执行了`useradd -g 500 -G 72 -u 666 Bob`。查看passwd文件：

<img src="D:\chaofan\typora\专业\Linux.assets\image-20220721095654768.png" alt="image-20220721095654768" style="zoom:80%;" />

仅截取了一部分。梳理冒号分割的每一项：用户名、密码占位符、uid、主组号、注释、个人文件夹路径、解释器。解释器负责解释此用户输入的指令，随后将结果传递给内核去处理。

查看group文件：

<img src="D:\chaofan\typora\专业\Linux.assets\image-20220721100458327.png" alt="image-20220721100458327" style="zoom:80%;" />

可见此文件存了Bob的附加组，没存主组，上一文件没存附加组。

修改用户的相关设定：

```sh
usermod -G 42 Bob
usermod -l Tom Bob
```

设置密码。不设的话是处锁定状态、不被允许登录的。设置之后passwd里的占位符就变成一串加密字符。

```sh
passwd Bob
```

切换当前用户。从root切到别的用户无需输密码。

```sh
# switch user 缺省用户名则切换到超级管理员root
su Bob
```

删除用户：

```sh
# -r：连带删除个人文件夹
userdel Bob
userdel -r Bob
# 当前用户删自己是删不掉的，可借助kill，杀死名字匹配用户名的进程的父进程
kill 3151
userdel -r Bob
```

### 用户组管理

组的增删改均与group文件相关。某个组可能是这个用户的主组而是另一个用户的附加组。

分析上一张截图的配置项：组名、密码（一般不设）、组号，组内用户名（有的组带有的不带）-表示此组是此用户的附加组。

添加组：

```sh
# -g：组号，缺省从500之后累加
groupadd -g 626 Administrator
```

修改组：

```sh
# -n：改组名
groupmod -n admin Administrator
```

删除组。当被改组是某用户的主组，删不了，得先清空用户-修改组内用户的主组。

```sh
groupdel admin
```

### 权限管理

linux将操作文件的权限分为三种：  read、write、execute。

- 读权限影响查看文件夹内的结构、查看文件内容。
- 写权限影响在文件夹内操作（创建、删除、移动、重命名文件（夹）等）文件、编辑文件内容。
- 执行权限影响文件的执行，尤其是脚本。

linux将将操作文件的身份分为以下三个：

- owner：文件所有者。从文件创建伊始到手动修改所有者之前指创建者。
- group：与owner同组的用户。
- others：与owner不同组的用户。

root其实也算一种身份，凌驾于一切权限之上。

查看的文件的相关权限仍是用ls，回顾一下：

```sh
[root@supervan Packages]# ll ~
总用量 100
-rw-------. 1 root root  1641 3月   5 01:57 anaconda-ks.cfg
-rw-r--r--. 1 root root 47276 3月   5 01:57 install.log
-rw-r--r--. 1 root root 10033 3月   5 01:56 install.log.syslog
drwxr-xr-x. 2 root root  4096 3月   5 16:26 公共的
```

之前这第一列没详细说，就是等在这里交待。我们看除了首字符文档类型外，还有9个位子，分析如下：

- 前三个指owner的权限。
- 又三个指group的权限。
- 后三个指others的权限。

各位可取四种值：`r`-read（可写）、`w`-write（可读）、`x`-execute（可执行）、`-`-以上三值的替换值，表不允许。上述各组三个位子均有序地由`rwx`填充，附带讲只要存在一组`rwx`此文件被列出来时名称就呈绿色。文件创建后初始的权限是`-rw-r--r--`。

设置文件权限。设置者要么是root，要么是owner。

```sh
# 字母方式 
chmod u+x,g+rx,o+r anaconda-ks.cfg # 给owner（u）添加（+）可执行权利，给group（g）添加可读及可执行权利，给others（o）添加可读权利
chmod u=rwx,g=rx,o=r anaconda-ks.cfg # 另一种赋权方式
chmod g-rx,o-r anaconda-ks.cfg # 剥夺权利
chmod a=--- # 剥夺所有身份的所有权利 a=可省略
chmod -R a=rwx animals # 使下辖各级文件、目录权限同此目录
```

字母方式之外，还有数字方式，分别将`r`、`w`、`x`、`-`表示为4、2、1、0，由此得到$(C_2^1)^3=8$个值如下表：

| 数值    | 权限            |
| ------- | --------------- |
| 0=0+0+0 | `---`           |
| 1=0+0+1 | `--x`           |
| 2=0+2+0 | `-w-`（不合理） |
| 3=0+2+1 | `-wx`（不合理） |
| 4=4+0+0 | `r--`           |
| 5=4+0+1 | `r-x`           |
| 6=4+2+0 | `rw-`           |
| 7=4+2+1 | `rwx`           |

例如`chmod 777 num.txt`。

上述2、3是不合理的，能写但不能读，就只能是追加的情况了，我们应避免设置这两个值。

上面讨论的是文件相关的权限，命令也有权限，像reboot、shutdown、init、halt、用户管理这些很要命的命令普通用户是执行不了的，而有时他们又需要用，且不能泄露root的密码，由此引出sudo（switch user do）指令。

root事先将某些命令的执行权赋给特定用户，通过修改`/etc/sudoers`配置文件：

```sh
# 此文件只读，用visudo解禁并打开，结尾给了一些样板
visudo
# 赋权 格式：a b=(c) d a：赋给谁，取用户名或组名，b：允许登录此服务器的主机的域名，ALL表所有，c：以何种身份执行，ALL表root，d：命令，建议写命令的原路径（可用which获取），ALL表所有
van ALL=(ALL) /usr/sbin/useradd,!/user/sbin/passwd,/user/sbin/passwd *,!/user/sbin/passwd root # 不能修改root的密码
# 切换到特定用户，执行获执行权的命令
sudo useradd tiger
sudo passwd tiger
```

普通用户查看被授予的执行权利：

```sh
sudo -l
```

### 属主与属组

见ls结果的第三、四列，分别指属主-文件的所有者和属组-所有者的主组。

任一文件的这两个分量在创建时生成。当文件的owner被删，这两个分量都不对了，就得改，相当于把这个文件托付给下家。

```sh
# -R：级联影响子文件，托付给van用户及van组
chown -R van ./codes
chgrp -R van ./codes
# 合二为一
chown -R van:van codes
```

## 网络

### 配置

查看网卡配置文件。

```sh
# 找ifcfg-开头的，跟的是网卡名
ls /etc/sysconfig/network-scripts
```

发现有两个：ifcfg-eth0与ifcfg-lo，分别打开它们。

```sh
[root@supervan network-scripts]# cat ifcfg-eth0 
DEVICE=eth0
TYPE=Ethernet
UUID=cad2c8c2-4d51-4965-8bb1-641f80112ab5
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=dhcp
HWADDR=00:0C:29:79:21:5F
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
NAME="System eth0"

[root@supervan network-scripts]# cat ifcfg-lo
DEVICE=lo
IPADDR=127.0.0.1
NETMASK=255.0.0.0
NETWORK=127.0.0.0
# If you're having problems with gated making 127.0.0.0/8 a martian,
# you can change this to something else (255.255.255.255, for example)
BROADCAST=127.255.255.255
ONBOOT=yes
NAME=loopback
```

可见以太网技术、随开机启动、基于DHCP的IP地址分配、MAC地址等要素。

重启所有网卡：

```sh
# network是一个可执行文件的快捷方式
/etc/init.d/network restart
```

附带看文件快捷方式（软链接）的创建：

```sh
# 在当前目录下给网卡配置文件放一个快捷方式
ln -s /etc/sysconfig/network-scripts/ifcfg-eth0 ifcfg-eth0
```

执行`ls -l`发现快捷方式的第一列分量的首字符是`l`，表示link。

开关单个网卡：

```sh
ifdown ifcfg-eth0
ifup ifcfg-eth0
```

### SSH

#### 概述

即secure shell-安全外壳协议，用于远程连接及延伸操作，如文件传输。端口号是22，是协议的同时对应一项服务。其配置位于`/etc/ssh/ssh_config`。

服务的开关与重启：

```sh
# 不通用
service sshd start
service sshd stop
service sshd restart
# 通用
/etc/init.d/sshd start
/etc/init.d/sshd stop
/etc/init.d/sshd restart
```

#### 远程终端

前面的联系基于的OS都在虚拟机上，本机是可以直接访问的，而开发中OS是在远程服务器上，那么需要遵循SSH协议的远程终端来帮我们访问。常见的工具有XShell、secureCRT、Putty等。

我们看到，用虚拟机登录同时用XShell登录，这就证明了linux的多用户性，甚至可以都用root登录。像windows的远程连接同一时刻仅允许一个用户占用。

#### 文件传输

文件传输可由多种协议实现：FTP、SFTP（更安全）等。同样有必要使用终端工具，如filezilla、pscp等。

### 主机名

接续[hostname](#hostname)一节。

临时修改主机名，切换用户才能生效。

```sh
hostname supervan
# 从root切换到root是可行的
su
```

永久修改主机名。找到主机名所处配置文件`/etc/sysconfig/network`，然后改配置项，最后重启生效。

```properties
HOSTNAME=supervan
```

回顾hostname命令得到主机名与全限定域名，后者是从`etc/hosts`文件中查出来的。像apache等软件就是把主机名当域名，故有必要把修改后的主机名与域名统一，修改此文件。

```sh
# 127.0.0.1右边任何一个值都是域名，只是带-f查找域名，仅取第一列分量
  1 127.0.0.1   supervan localhost localhost.localdomain localhost4 localhost4.localdomain4 # 加哪儿都行
  2 ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
# 可用ping验证
```

### 指令

ping：检测当前主机与目标主机之间的连通性，有的主机禁用此命令，后面可跟IP地址、域名、主机名（常用于内网），跨平台。

```sh
ping www.baidu.com
```

```sh
# netstat补充
netstat -an
```

traceroute：跟踪路由，查询IP包经过哪些网关，有的主机禁用此命令，非内置。

```sh
traceroute www.bilibili.com
```

arp：关乎地址解析协议，获得目标主机的硬件地址。

```sh
arp 192.168.44.128
```

tcpdump：抓包。

```sh
# 查看由22端口出入的数据包
tcpdump port 22
# 查看与指定主机交互的数据包
tcpdump host 192.168.21.1
# 查看通过指定网卡的数据包
tcpdump -i eth0
```

## 常用服务

### chkconfig

这是一个开机启动管理服务。

查看现有的随开机启动的服务：

```sh
# 截取开头一部分结果 --list可省
[root@supervan ~]# chkconfig --list
NetworkManager 	0:关闭	1:关闭	2:启用	3:启用	4:启用	5:启用	6:关闭
abrt-ccpp      	0:关闭	1:关闭	2:关闭	3:启用	4:关闭	5:启用	6:关闭
abrtd          	0:关闭	1:关闭	2:关闭	3:启用	4:关闭	5:启用	6:关闭
acpid          	0:关闭	1:关闭	2:启用	3:启用	4:启用	5:启用	6:关闭
```

结果展示了诸服务在不同运行级别下随开机启动的情况。

删除表中服务：

```sh
chkconfig --del httd
# 验证
chkconfig --list | grep httpd
```

添加随开机启动的服务：

```sh
chkconfig --add httpd
```

修改某服务在某运行级别下随开机启动与否：

```sh
# 自己添加的默认在任何级别下都是关闭
chkconfig --level 35 httpd on
chkconfig --level 06 httpd off
```

### ntp

这是时间同步服务，解决时间误差问题，时间对网站用户而言很重要。

一般让每次开机时OS自动联网同步时间：

```sh
service ntpd start 
# 或
/etc/init.d/nptd start
# 随开机启动
chkconfig --add ntpd
```

### iptables

防火墙于防范网络上的攻击，分硬件防火墙和软件防火墙，我们要学的是后者，操作是选择性地让请求通过。

cent OS中自带的防火墙服务叫iptables。

```sh
# 开启服务
[root@supervan ~]# service iptables start
# 查看状态
[root@supervan ~]# service iptables status
表格：filter
Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         
1    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
2    ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           
3    ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
4    ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:22 
5    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

Chain FORWARD (policy ACCEPT)
num  target     prot opt source               destination         
1    REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

Chain OUTPUT (policy ACCEPT)
num  target     prot opt source               destination
# 其他查看状态的命令
[root@supervan ~]# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED 
ACCEPT     icmp --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:ssh 
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited 

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited 

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
[root@supervan ~]# iptables -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED 
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0           
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:22 
REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
REJECT     all  --  0.0.0.0/0            0.0.0.0/0           reject-with icmp-host-prohibited 

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```

目前只需了解一些关于进站、出战、端口、协议等因素的拦放规则。看个例子：

```shell
# -A：尾插，-I：头插
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# 保存相应配置文件，也可直接去修改文件
/etc/init.d/iptables save
```

### rpm

这是一个软件管理服务，遵照红帽制定的包管理规范管理软件包（特定文件集合），包括查询、卸载、安装（更新）。rpm文件相当于windows下的exe文件。

查询：

```shell
# -q：查询，-a：所有
[root@supervan ~]# rpm -qa | grep firefox
firefox-17.0.10-1.el6.centos.x86_64
```

卸载：

```shell
# 此包被其他包依赖则报错
[root@supervan ~]# rpm -e httpd
error: Failed dependencies:
	httpd >= 2.2.0 is needed by (installed) gnome-user-share-2.28.2-3.el6.x86_64
# 忽略依赖
rpm -e httpd --nodeps
```

安装。先得有安装包，要么去软件官网下载，要么去ISO文件里读取。附带看硬盘、光盘等的挂载与解挂，前者较为常见。

```shell
#查看块状设备的信息-list block devices
[root@supervan ~]# lsblk
NAME                        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0                          11:0    1  4.2G  0 rom  
sda                           8:0    0   20G  0 disk 
├─sda1                        8:1    0  500M  0 part /boot
└─sda2                        8:2    0 19.5G  0 part 
  ├─VolGroup-lv_root (dm-0) 253:0    0 17.6G  0 lvm  /
  └─VolGroup-lv_swap (dm-1) 253:1    0    2G  0 lvm  [SWAP]
```

各列说明：

- NAME：设备名。
- SIZE：设备容量。
- TYPE：设备类型。
- MOUNTPOINT：挂载点，可类比盘符理解。

```shell
# 以光盘为例，解挂，解挂完会发现原行仍在，不过MOUNTPOINT分量为空，相当于U盘弹出但没拔下来
umount /media/CentOS_6.5_Final
# 挂载 设备原始地址统一在/dev下，找名字，挂载地址约定在/mnt下
mkdir /mnt/dvd
mount /dev/sr0 /mnt/dvd
# 安装
cd /mnt/dvd/Packages
# -i：install，-v：进度条
rpm -ivh firefox-17.0.10-1.el6.centos.i686.rpm
```

### cron

这是一个计划任务服务，又叫crontab，方便用户无需长期值守服务器，只需让诸任务定时进行。

查询计划任务：

```shell
# -l：列出计划任务，-u：指定用户，默认当前，-r：删除所有计划任务
crontab -l
```

制定任务执行计划：

```shell
# 分（0—59） 时（0-23） 日（1-31） 月（1-12） 周几（1-7，星期一到星期天） *：范围内的每个值， -：整数区间， /：隔段时间一次，,：多值
0 0 * * * reboot
45 4 1,10,22 * * service network restart
10 1 * * 6,7 /etc/init.d/network restart
*/30 18-23 * * * service network restart
3,15 8-11 */2 * * reboot
*/1 * * * * date +"%F %T" >> /root/RT.txt # */1等价于*
```

`/etc/cron.deny`是黑名单，所记录的用户被禁止制定计划，`/etc/cron.allow`（自创建）是白名单，权重高于前者。

## Shell

### 概述

关于它的介绍，参见[菜鸟教程](https://www.runoob.com/linux/linux-shell.html)，当中也有详尽的使用方法。

使用shell无非三步：

1. 创建脚本，用touch或vim。
2. 编代码。
3. 执行。前提是有执行权。

```sh
[root@supervan ~]# touch test.sh
[root@supervan ~]# vim test.sh
[root@supervan ~]# ll test.sh 
-rw-r--r-- 1 root root 32 Jul 23 15:23 test.sh
[root@supervan ~]# chmod +x test.sh 
# 要带斜杠，成一个路径，否则被当成命令，不想带的话就得去配命令别名
[root@supervan ~]# ./test.sh # 或/bin/bash test.sh
hello world!
```

```sh
#!bin/bash
echo "hello world!"
```

首行`#!`不是注释，而用于指定脚本解释器的路径，这里指定的解释器是bash。

shell的简单写法即命令的堆叠，方便命令的多次批量执行。

### 语法

语法就不系统地记了，参考文档，通过一些例子熟悉。

变量：

```sh
#!bin/bash
dt=`date +"%F %T"`
only_read=10
readonly only_read
will_del=20
read -p '请输入待创建的文件的路径' filepath
touch $filepath
echo "文件创建成功"
unset $will_del
echo $dt
echo $only_read
```

分支语句与运算符：

```sh
#!bin/bash
var=`expr 1 + 1`
a=10
b=10
echo "a=$a"
echo "b=$b"
echo 'a*b=' `expr $a \* $b` # 转义*为乘号
if [$a == $b] then
	echo "a is equals to b"
else
	echo "a is not equals to b"
fi
echo [$a -eq "10"]
echo [$a -le $b]
echo [!false]
echo [$a -lt $b -o $b -gt 8]
echo [ 1 != 2 -a 2 -ge ]
echo ["cat" = "Cat"]
echo [-z "cat"]
echo [-n "cat"]
blank=""
echo [$blank]
file="/root/miyuki.css"
dir="/root/authors"
echo [-d $dir]
echo [-f $file]
echo [-r $file]
echo [-w $file]
echo [-x $file]
echo [-e $dir]
```

带选项：

```sh
#!bin/bash
# 位置参数
echo $1 $2 $3

#!bin/bash
if [$1 = "-add"] then
	useradd $2
else
	userdel -r $2
```

不光能给命令取别名，也可给脚本文件甚至任意可执行文件取别名（像环境变量了，但真正的环境变量在[后面](#env)）：

```sh
alias userabout="/root/userabout.sh"
```

## 软件安装

### 概述

安装有这几种方式：

- 编译源码。方便查看源码，但安装较慢，且易出错-涉及配置、依赖。
- 用到rpm命令，执行二进制文件。安装较快，也方便升级、卸载，但无法洞悉源码，要自行解决依赖问题。
- 用到yum等命令，傻瓜式安装。极其简捷，自动解决依赖问题，但不具备自定义性。
- 官网提供的二进制安装包，已编译，只需解压、配置。

```sh
tar -zxvf ncurses-6.1.tar.gz
# 配置：config、configure、bootstrap三选一
./configure --prefix=/usr/local/ncurses # 自动创建软件根目录ncurses
# 编译：make或bootstrapd，软件根目录内
make
# 安装：make install或bootstrapd install，软件根目录内
make install
```

查看文件是从哪个安装包分出来的。

```sh
rpm -qf /etc/httpd/conf/httpd.conf
```

```sh
# 查看线上资源
yum list
yum search mysql
# -y可省，表一路确认
yum -y install mysql
# 不带包名则更新全部
yum -y update mysql
# 卸载，看出yum与rpm作用的对象不同，一个是rpm文件，一个是软件名
yum -y remove mysql
yum -y install git
```

用wget在服务端下载安装包到当前目录：

```sh
wget https://nginx.org/download/nginx-1.13.11.tar.gz
```

具体软件的安装举一些例子。

### JDK

去[官网](https://www.oracle.com/java/technologies/downloads/)下载压缩包到服务器。

解压并去`/etc/profile`配置<span id="env">环境变量</span>：

```ini
JAVA_HOME=/usr/local/jdk1.8.0_341
PATH=$JAVA_HOME/bin:$PATH
```

别忘了source。

### Tomcat

从[镜像站](https://repo.huaweicloud.com/apache/tomcat/tomcat-9/v9.0.10/bin/)下载压缩包到服务器。

解压并运行：

```sh
# 两种都可，联系window下此文件的后缀是bat
sh startup.sh
./startup.sh
```

`软件根目录/logs/catalina.out`含启动日志。或用ps命令查找tomcat进程。

关停服务要么通过`sh shutdown.sh`等要么通过kill命令（当前者无用）。

### Maven

从[镜像站](https://repo.huaweicloud.com/apache/maven/maven-3/3.3.9/binaries/)下载压缩包到服务器，解压即可。

配置环境变量：

```ini
MAVEN_HOME=/usr/local/apache-maven-3.3.9
PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
```

修改settings.xml，包括本地仓库地址、JDK、中央仓库镜像。

### Redis

从[官网](https://redis.io/download/)下载压缩包到服务器并解压。

```sh
# 安装依赖的编译环境
yum -y install gcc-c++
# 编译式安装
make install
# 启动前台运行服务，命令
redis-server
# 由redis.conf配置文件启动后台服务
daemonize yes # 修改配置文件，开启守护线程，即在后台运行
redis-server ./redis.conf # 带配置文件路径选项
# 客户端连接，命令
redis-cli
# 默认连接服务端没密码限制，打开客户端后可设密码及认证
config set requirepass "root@123456"
auth root@123456
```

### Nginx

```sh
# 依赖
yum -y install gcc pcre-devel zlib-devel openssl openssl-devel
# 本地下载nginx压缩包（未编译）挪过去或直接用wget命令下载到当前目录
wget http://nginx.org/download/nginx-1.22.0.tar.gz
# 解压并进入解压所得目录
# 编译式安装
./configure --prefix=/usr/local/nginx
make && make install
```

## 部署

买服务器，要么买断真机，维护成本很高，要么买云（租赁）服务器，享受一站式服务。

云服务器的购买与域名注册此处就不赘述了。

我们使用shell实现自动化部署-依靠git、maven的拉取、编译、测试、打包、运行。

```sh
#!bin/bash
echo "==============="
echo "自动化部署脚本启动"
echo "==============="

APP_NAME=takeout

echo "停止此前服务"
# 杀死项目上次启动产生的进程
pid=`ps -ef | grep $APP_NAME | grep -v grep | grep -v kill | awk '{print $2}'`
if [ $pid ]
then
    echo "停止成功"
    kill -15 $pid
fi
sleep 2
# 怕没有杀死
pid=`ps -ef | grep $APP_NAME | grep -v grep | grep -v kill | awk '{print $2}'` 
if [ $pid ]
then
    echo "杀死进程"
    kill -9 $pid
fi

echo "从github拉取最新代码"
cd /usr/program/$APP_NAME
# 已经自行克隆了
git pull
echo "拉取完成"

echo "开始打包"
# 本例跳过测试
output=`mvn clean package -Dmaven.test.skip=true`
cd target

echo "启动服务"
# 在后台运行，将日志输出到文件
nohup java -jar $APP_NAME-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &> $APP_NAME.log &
echo "服务已启动"
```

可能要开放脚本的执行权限，如`chmod a+x /usr/local/autoDeploy.sh`。

到了前后端分离，便关注nginx。其根目录结构如下：

```
conf/nginx.conf：配置文件
html：存放静态文件，html、css等
logs：存放日志，如访问日志access.log、错误日志error.log
sbin/nginx：二进制文件，开关服务
```

必会命令：

```sh
# 版本
sbin/nginx -v
# 检查配置文件正常与否
./nginx -t
# 启动
./nginx
ps -ef | grep nginx
# 停止
./nginx -s stop
# 重新加载配置
./nginx -s reload
# 最好给sbin/nginx建立别名或环境变量
```

前后端分离配置：

```conf
server_name  8.130.37.35;
# 静态资源
location / {
    root   html/takeout-dist;
    index  index.html;
}
# 反向代理
location ^~ /api/ {
    rewrite ^/api/(.*)$ /$1 break;
    proxy_pass http://8.130.37.35:8080;
}
```

关于接口文档，有YAPI、Swagger等工具，项目用的是支持Swagger的[knife4j](https://doc.xiaominfo.com/docs/quick-start)，由控制层方法生成文档。
