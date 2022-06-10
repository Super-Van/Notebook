# Java

参考视频：[Java入门视频教程](https://www.bilibili.com/video/BV1Kb411W75N?spm_id_from=333.999.0.0)。

由于此前上课学过一些知识，有些东西此处就不记了，可参考[菜鸟教程](https://www.runoob.com/java/java-tutorial.html)等。

## 概述

JDK=JRE+开发工具集（编译器javac.exe等）。

JRE=JVM+Java SE标准类库。JVM实现“一次编译，到处运行”。

核心机制是java虚拟机和垃圾回收机制（即使有此机制也不能完全避免内存溢出或内存泄漏等问题）。

我们写代码要追求：

- 正确性：起码语法不错，编译通过，然后面对理想条件达到预期目标。

- 可读性：避免复杂的逻辑，一看就好懂。

- 健壮性：面对复杂条件甚至极端条件，能规避异常，达到预期目标。
- 高效率、底存储：首先关注时间复杂度，其次关注空间复杂度。

## 配置

其实在path里配两个bin目录就没问题，只不过我们约定将JDK根目录记作一个变量，然后用其替换掉之前两个路径中的一截。

```bash
%JAVA_HOME%\bin
%JAVA_HOME%\jre\bin
```

不替换当然也可以。这个变量名要固定为JAVA_HOME，因为后面做web的时候tomcat服务器要找这个名字。

不要走入误区，配CLASSPATH。

## 初探

javac编译得到的class文件名就是类名，每修改一次文件就得重新编译并重新运行。

由于windows不区分大小写，又javac命令的作用对象是源文件，故javac对大小写不敏感。如：

```bash
# javac作用于文件，所以后面要有后缀
javac HelloWorld.java
javac helloworld.java
```

那么文件找不到的问题就不能归咎于大小写，可能是拼错了或路径错了。编译失败就不会产生.class文件

java命令则不同，它的作用对象是字节码文件里的类，就对大小写敏感了。如：

```shell
# java作用于类，故无需后缀
java HelloChina
# 报错：找不到或无法加载主类 （已经写了主方法）
java hellochina
```

源文件中可定义多个类，比如下面这个例子：

```java
/* Hello.java */
class Hello {

}
class Person {

}
```

javac编译之后得到Hello.class和Person.class两个字节码文件。我们再给其中一个加上public修饰符：

```java
class Hello {

}
public class Person {

}
// 编译就报错：类Person是公共的, 应在名为 Person.java 的文件中声明
```

要求一旦加了public，源文件名就应与此类名一致，要么改文件名要么改类名让它们一样。那么当前文件名是Hello，我们再试着把public加到Hello类上：

```java
public class Hello {

}
class Person {

}
// 编译成功
```

一个源文件中最多只能有一个类带上public修饰符，我们不难推出若文件名与public类名相同，则只能存在一个public类。

当所有类都不带public时，文件名就没必要与任何类名相同。如：

```java
/* China.java */ 
class Hello {

}
class Person {

}
// javac china.java成功
```

主方法main是程序的执行入口，其签名的写法相对固定：

```java
// 习惯
public static void main(String[] args)
// 对java这种强类型语言，参数类型远比参数名重要
public static void main(String[] a)
// 数组声明语法的特点：中括号位置灵活
public static void main(String a[])
```

接着上例，现有多个class文件，但它们都没有主方法，于是用java指令运行每个class文件都会报错：

```shell
java Hello
# 错误: 在类 Hello 中找不到 main 方法, 请将 main 方法定义为: public static void main(String[] args) 否则 JavaFX 应用程序类必须扩展javafx.application.Application
# 可见java命令要求类要有主方法
```

注释内容不会被编译，即字节码文件中不包含注释有关的东西。

文档注释可以被JDK提供的javadoc工具解析，生成一套以网页形式呈现的该程序的说明文档。

```shell
javadoc -d myDoc -author -version HelloWorld.java
```

多行注释禁止套娃。

## 基本语法

### 概述

本章记录众多编程语言共有的一些知识，比如关键字和保留字、变量和运算符、条件语句和循环语句等等。

### 关键字与保留字

关键字统统小写，用多了就有印象了。有三个字面量严格来讲不算关键字，但一般被纳入，它们是：true、false、null。

有些单词尚未成为关键字（尚未投入使用），但以后可能是（也可能不是，就一直占着），我们也要避开它们。如goto、const。

### 标识符

自己取名字的地方都叫标识符，如变量名、方法名、类名等。

关于命名规范，虽不强制，建议大家遵守。包名全小写；类、接口名大驼峰；变量、方法名小驼峰；常量名全大写下划线分隔。

### 变量

#### 概述

概念：

- 对应内存中的一块存储区域。

- 程序中最基本的存储单元。

- 要素包括变量类型、变量名及存储的值。值的范围由类型决定。

  ```java
  // 数据类型 变量名 = 变量值 不像C语言，Java要求变量使用前必须被赋值，但可不在声明时赋值
  int age = 23;
  ```

作用：在内存中保存数据。

要点：

- 先声明（定义），后使用，声明就是指明类型。
- 通过变量名访问对应的存储区域。
- 只在作用域内生效，某变量作用域内不能定义同名变量，作用域由一对`{}`确定。

#### 类型

数据类型划分：

<img src="D:\chaofan\typora\专业\Java.assets\image-20220314110556277.png" alt="image-20220314110556277" style="zoom:67%;" />

字符串隶属于类。对于八大基本类型，我们可记成顺口溜-byte int short long, double float boolean char。

4种整型的信息如下表：

| 类型 | 占用空间 | 取值范围                    |
| ---- | -------- | --------------------------- |
| byte | 1B       | [-128, 127]                 |
| shot | 2B       | [-2^15^, 2^15^-1]           |
| int  | 4B       | [-2^31^, 2^31^-1]（约21亿） |
| long | 8B       | [-2^63^, 2^63^-1]           |

声明long时字面值后要跟L或l（小写l跟1很像了，就别用了），不过这个尾缀并不会出现在内存中也不会被打印出来。

Java具有可移植性，一个体现就是不受任何OS影响，上述信息是固定的。

浮点型有两种表示法：

```java
// 十进制形式
5.21 512.0f .521
// 科学计数法形式
5.12e2 512E2 100E-2
```

两种浮点型的信息如下表：

| 类型        | 占用空间 | 取值范围                |
| ----------- | -------- | ----------------------- |
| 单精度float | 4B       | [-3.403E38, 3.403E38]   |
| 双精度      | 8B       | [-1.798E308, 1.798E308] |

声明float时字面值后要跟f或F。

我们发现float（double）与int（long）所占字节数是一样的，但取值范围更大，这就要牺牲取值的精度了，那么整型转浮点型可能造成精度的丢失。

关于char，除转义字符外任何字符只能独自出现，一个字符占用2个字节。

```java
char num = '2';
char ch = '汉';

// 虽然可以，但不要不按套路出牌
char a = 97;

// 转义符
char line = '\n';
char tab = '\t';
char jap = 'の';
```

但Unicode表示法允许“多个字符”的出现，这多个字符即一串代号。这种表示法用得很少，因为记不住这么多长相复杂的代号。

```java
// 表字母A
char c = '\u0041'
```

注：字符集（编码系统）的问题。计算机不断地进行看得懂的字符与看不懂的底层比特流（01序列）的转换，就像电报的翻译需要密码本一样，字符与比特流的转换也就需要一个字符集。如美国人发明的ASCⅡ码，将128个字符映射为128组01序列，如A对应01000001即十进制的65。随着互联网的壮大，吸收更多国家文字的字符集相继问世，如今非常通用的编码方式是UTF-8。我们要在出现设定编码方式的地方做统一设定，避免乱码。

关于boolean，一般不谈占多少字节和取值范围，因为拢共就取两个值-true和false。

最后谈谈String-字符串，它不是基本数据类型，但怎奈出镜率太高，所以先扯一扯。

String是引用数据类型，属类范畴。看一些例子：

```java
String s1 = "a";
String s2 = "abc";

// 含空格的非空串
String space = " ";

// 空串
String blank = "";

// 附带讲，char型字面值长了短了都不行，不允许空字符
char wrongCh = '';
```

String变量同化力超强：能和8种基本类型运算，且只能是拼接运算，结果也是String型。

```java
String base = "不动如山";
String base = "不动如山";
short finger = 5;
boolean on = true;
// 不动如山5
System.out.println(base + finger);
// 不动如山true
System.out.println(base + on);

// 18a 双引号包裹的字面量属String类型 
System.out.println(9 + 9 + "a");
// 9a9
System.out.println(9 + "a" + 9);
// 106a 单引号包裹的字面量属char型
System.out.println('a' + 9 + "a");
// a9a
System.out.println('a' + (9 + "a"));
```

很遗憾控制台打出一个数字时，我们并不能判断它是字符串还是数值，打印一个字符时，也判断不了是字符串还是字符。

#### 转换

7中类型（除开boolean）之间的转换：

- 自动类型提升。
- 强制类型转换。

从大范围向小范围的转换，想来是不合适的。

```java
byte small = 1;
long big = 129L;
// 编译不通过：不兼容的类型，可能会有精度损失
byte sum = small + big;
```

那么反过来就是可行的。

```java
// 可行
long sum = small + big;
// 也可行 130.0
float sumF = small + big;
```

自动类型提升：取值范围小的变量与范围大的变量做运算时结果类型可以向大范围的类型自动转换。

```java
// true
System.out.println((Object) (small + big) instanceof Long);
// 不加L尾缀也能产生自动提升 int->long
long intL = 10000;
```

根据编码表，一些字符是可以等价为数值的，因此char变量有时能参与数值运算。

```java
// 等价于97
char ch = 'a';
int num = 2;
// 99 用大范围类型变量接收，使类型自动提升
num = ch + num;
```

接下来有意思了，char跟byte或short运算，得到的结果都只能由int接收：

```java
char a = 'a';
short sNum = 3;
byte bNum = 3;
// 编译都不通过 
short sSum = sNum + a;
byte bSum = a + bNum;
// 编译通过
int scNum = sNum + a;
```

并且byte跟short运算，得到的结果也只能由int接收：

```java
// 编译失败
short sbNum = sNum + bNum;
// 编译成功
int sbNum = sNum + bNum;
```

由上我们得出byte、short、char这三个类型两两运算，所得结果均为int型，甚至它们内部运算所得结果也是int型。

```java
int ccSum = ch + ch;
int ssNum = sNum + sNum;
```

至于为什么这样规定，一个可能的解释是避免两个小范围变量运算（比如求和）结果的范围超出了那个更大类型的范围，如两个byte型的128相加得到256就超出了byte型的取值范围。

看一些自动类型提升的其他例子：

```java
int i = 10;
char b = 'b';
// 1000000.0 有时可能丢失精度
double doubleI = i * 1E5;
// 245.0
double dobuleB = b * 2.5;
```

我们强制（手动）实现大范围向小范围的转换，某些时候确有此种需求，就产生了强制类型转换。当然强制类型转换除范围从大到小的转换外还有其他的情况，非自动类型提升的情况都属于强制类型转换。

```java
double d = 12.3;
// 12 截断即下取整
int intD = (int) d;

// 同空间容量且跨域的强转，这里说取值范围就没意义了
byte n = 110;
char nCh = (char) n;

// 空间容量从大到小且跨域 
double o = 111;
char oCh = (char) o;

// 晓得强转写法 先提升后强转
byte factor = 2;
byte product = (byte) (factor * 1);

// 编译失败：不加F尾缀，那是让系统帮着实现double->float？当然不行了 修正：要么冠以(float)要么加尾缀F
float wrongF = 120.01;

short minus = 6;
// 编译失败 int->short
minus = 6 - 5;
```

应当理解自动类型提升（int->float long->float long->double）和强制类型转换都可能导致精度损失，前者产生于小数点之前，后者产生于小数点之后。

```java
/* 离谱的精度损失-范围溢出，先溢出成负数，继续下去可能会溢出成0 */ 
int val = 128;
// -128 自己按二进制进位去算
byte bVal = (byte) val;
```

整型字面量默认类型为int，浮点型字面量默认类型为double。

```java
char w = 'w';
int wI = w + 8;
double wD = w + 10.;
```

#### 进制

对不同进制了解一些例子即可：

```java
// 打印出来的都是十进制数
byte decimal = 100;
short binary1 = 0b100;
short binary2 = 0B110;
int octal = 011;
int hex1 = 0x1F;
byte hex2 = 0X3a;
```

API中Integer类提供了一些用于进制转换的方法。

### 运算符

#### 概述

无需多言，只是提一下由于布尔类型不参与类型转换，故某些情况下布尔变量是不参与运算的，编译就不通过。

#### 算术

给一些有趣的例子：

```java
/* 类型转换 */
int num1 = 10;
int num2 = 4;
// 2 先得浮点结果2.5，再截断
int division1 = num1 / num2;
// 从左往右算，还是先的int型的2，再乘上4，而不是以浮点型乘4
int product = num1 / num2 * num2;
// 2.0 先得到int型的2，再自动提升为浮点的2.
double division2 = num1 / num2;
// 2.5 没有自动提升的条件，可以手动强转
System.out.println((double) num1 / num2);
// 2.5 也可以创造自动提升的条件
System.out.println(num1 / (num2 + 0.0));

int m1 = -7;
int m2 = -2;
// -1 余数的符号与被模数符号一致 我们几乎不会离谱到用负的取模
System.out.println(m1 % m2);
```

```java
// 求三位数的各位
int threeFigure = 255;
int bai = threeFigure / 100;
int shi = threeFigure % 100 / 10;
int ge = threeFigure % 10;
```

#### 自增

注意前置自增与后值自增的区别就行了。

```java
short s = 12;
// 自增不涉及int型字面量，规避手动强转，相当于s = (short) (s + 1);
s++;
```

开发中加1减1一般都靠自增。

#### 赋值

即使涉及到更高级的字面量，增强的赋值运算符也能实现隐式强转。

```java
short sNum = 10;
// 不受2的int型影响，仍为short型，相当于sNum = (short) (sNum + 2);
sNum += 2;

int num = 2;
// 0 相当于num = (int) (num * 0.1);
num *= 0.1;
```

```java
// 不初始化而连续赋值
int i1, i2;
i1 = i2 = 0;

// 用逗号
int i3 = 3, i4 = 4;
```

#### 比较

instanceof也是一个比较运算符，不过学到多态时再谈。

关系运算符的结果一定是boolean型的。

```java
int i = 2;
int j = 3;
// 先赋值，再打i
System.out.println(i = j);
```

#### 逻辑

逻辑运算符两侧的变量必须是boolean型。

对比短路和逻辑：

- 短路与`&&`一碰到假就得到假，而逻辑与`&`即使碰到假也要继续判定后面的。

- 短路或`||`一碰到真就得到真，而逻辑或`|`即使碰到真也要继续判定后面的。

```java
boolean x = false;
boolean y = true;
// true 看清单等号与双等号
System.out.println(y && (x = true));
```

#### 位

位运算符用得很少，看源码时会碰到位运算符。

与运算`&`、或运算`|`、异或运算`^`分别与逻辑运算符里的几个长得是一样的，不过它们两侧的变量都是数。

理解位运算时要先把被操作的数转为二进制。我们可总结出如下规律：

- 无论正负，每`<<`1位相当于乘个2，但一旦移到一定程度就物极必反，正（负）数变成负（正）数了。
- 右移时，末尾丢了多少位，开头就补多少个0或1，是正数就补0，负数就补1。每右移1位相当于除以2，下取整。
- 无符号右移`>>>`不管最高位是0还是1（是正数还是负数），开头均补0。
- 取反`~`等其他几个没啥可说的，按位运算即可。

我们看几种交换算法：

```java
// 推荐
int n1 = 10;
int n2 = 20;
int temp = n1;
n1 = n2;
n2 = temp;

// 利用加法 优点：节省内存；缺点：和可能超出范围以及仅限于数的交换 
n1 = n1 + n2;
n2 = n1 - n2;
n1 = n1 - n2;

// 利用按位异或运算 也仅限于数的交换
n1 = n1 ^ n2;
n2 = n1 ^ n2;
n1 = n1 ^ n2;
```

#### 三元

三元（三目）运算符用于简化if语句，要求有返回结果，还要求两种返回结果可统一为一种类型。

```java
int m = 4;
int n = 3;
// 2.0 自动类型提升
double max = m > n ? 2 : 1.0;
// 编译错误 自动提升不了，数和字符串类型不能统一
int max = m > n ? 2 : "1";
```

它还可以嵌套，不过可读性就差了。

```java
String min = m < n ? "m小" : (m == n ? "相等" : "n小");
```

任何三元表达式都可等价替换为if语句，但存在if语句不能等价改为三元表达式，因此if语句更为普遍。对等价的三元表达式和if语句，考虑运行效率我们选择三元表达式，因为if语句毕竟是语句，而前者是运算符。

#### 优先级

想记也记不住，实际开发中也不会写得很残暴，有的考试会考。好奇请参考[Java运算符优先级](https://www.runoob.com/java/java-operators.html)。

### 条件语句

#### if-else

实际开发中自己捋清分支逻辑。

```java
// 编译报错，原因是从左至右，18<=age得到布尔值，而<=两侧一个布尔值，一个数，无法比较
if( 18 <= age <= 35) {
    System.out.println("青年人");
}
```

```java
// 多层嵌套，可读性差
Scanner scanner = new Scanner(System.in);
System.out.println("请输入第一个整数：");
int num1 = scanner.nextInt();
System.out.println("请输入第二个整数：");
int num2 = scanner.nextInt();
System.out.println("请输入第三个整数：");
int num3 = scanner.nextInt();

// 先比较两个数再填第三个数
if (num1 >= num2) {
    if (num3 >= num1) {
        System.out.println(num2 + "," + num1 + "," + num3);
    } else if (num3 < num1) {
        System.out.println(num3 + "," + num2 + "," + num1);
    } else {
        System.out.println(num2 + "," + num3 + "," + num1);
    }
} else {
    if (num3 >= num2) {
        System.out.println(num1 + "," + num2 + "," + num3);
    } else if (num3 < num1) {
        System.out.println(num3 + "," + num1 + "," + num2);
    } else {
        System.out.println(num1 + "," + num3 + "," + num2);
    }
}
scanner.close();
```

```java
/* 依旧是单等和双等的坑 */ 
boolean a = false;
if (a = true) {
    // true
    System.out.println(a);
}
```

不建议省略花括号，如果省略，则语句体中只能有一条语句，但这一条是很耐人寻味的。

```java
boolean b = false;
// 这四行最后的结果就是一条，不过是未定的一条 
if (a)
    if (b)
        System.out.println(b);
    else
        System.out.println(!b);
```

#### switch-case

break是可选的，但一般是每个分支都要的，不要漏写。

default也可选且位置灵活，但一般加上且放在最后。

结构中任意表达式结果的类型只能是这六种之一：byte、short、int、char、Enum、String。switch表达式结果与case表达式结果的类型要统一。

```java
short score = 70;
switch (score / 70) {
case 0:
    System.out.println("不及格");
    break;
case 1:
    System.out.println("及格");
    break;
default:
    break;

// 同语句体case的合并 其实也不是合并，就是语句体没写而已
byte m = 6;
switch (m) {
case 1:
case 2:
case 3:
    System.out.println("spring");
    break;
case 4:
case 5:
case 6:
    System.out.println("summer");
    break;
case 7:
case 8:
case 9:
    System.out.println("autumn");
    break;
default:
    System.out.println("winter");
    break;
}
        
// 利用不中断执行（不加break）倒着写
int month = 12;
int day = 16;
int sumDays = 0;
switch (month) {
case 12:
    sumDays += 30;
case 11:
    sumDays += 31;
case 10:
    sumDays += 30;
case 9:
    sumDays += 31;
case 8:
    sumDays += 31;
case 7:
    sumDays += 30;
case 6:
    sumDays += 31;
case 5:
    sumDays += 30;
case 4:
    sumDays += 31;
case 3:
    sumDays += 28;
case 2:
    sumDays += 31;
case 1:
    sumDays += day;
}
System.out.println(sumDays);
```

任意switch-case结构都能等价转换为if-else结构，但存在if-else结构不能等价转换为switch-case结构。等价条件下switch-case结构执行效率较高。

在没有花括号情况下，多个case处同一作用域，故变量不能在不同case语句体内重复定义。

### 循环语句

#### for

回顾一下基本结构：

```java
// 1234234234...2342 
for (1; 2; 4) {
    3
}
```

除2以外的每个环节都可包含多个语句，用逗号分隔。

```java
int i = 0;
for (System.out.println("初值在外"); i < 3; System.out.println("自增"), i++) {
    System.out.println(i);
}
```

善用break和continue。break可用于循环与switch-case，而continue只能用于循环。

```java
int num1 = 12;
int num2 = 20;
int min = num1 < num2 ? num1 : num2;
int max = num1 > num2 ? num1 : num2;
// 最大公因数
for (i = min; i >= 1; i--) {
    if (num1 % i == 0 && num2 % i == 0) {
        System.out.println(i);
        break;
    }
}
// 最小公倍数
for (i = max; i < num1 * num2; i++) {
    if (i % num1 == 0 && i % num2 == 0) {
        System.out.println(i);
        break;
    }
}
```

#### while

回顾一下基本结构：

```java
// 1234234...2342
1
while (2) {
    3
    4
}
```

切勿漏掉环节4，避免死循环，联系算法的有穷性。

#### do-while

回顾一下基本结构：

```java
// 执行过程就不太一样了：134234234...2342 
1
do {
    3
    4
} while (2)
```

对于能进循环体的情况，三者是等价的，而对于前面两个连一次循环体都进不了的情况，do-while能进一次，即do-while至少进一次循环体，而前面两个至少进0次。

开发中，前面两个用得远多于do-while。

#### 综合

循环变量应是整型的，非整型的自增存在精度问题，可能造成迭代次数与预期的有出入。

结束循环有两种方式：

- 循环条件表达式结果为false。
- 在循环体中碰到break。

那么后者适用于迭代次数未知或循环条件不定的诸循环语句结构：

```java
for (;;) {
    ...
    break;
    ...
}
while (true) {
    ...
    break;
    ...
}
```

我们经常在一些算法题中用到嵌套循环。

```java
/* 求质数 */
int n = 1000;
boolean primeFlag = true;
long start = System.currentTimeMillis();
for (i = 2; i <= n; i++) {
    // 很多循环中都有重置操作
    primeFlag = true;
    for (int j = 2; j <= Math.sqrt(i); j++) {
        if (i % j == 0) {
            primeFlag = false;
            break;
        }
    }
    if (primeFlag) {
        System.out.println(i);
    }
}
long end = System.currentTimeMillis();
System.out.println("运行时间为" + (end - start));
```

break和continue都能跟个标签以退出指定循环，就不限定于最内层了。

```java
// 名字不限于label
label: for(...) {
    for (...) {
        ...
        break label;
    }
}
id: for(...) {
    for (...) {
        ...
        continue id;
    }
}

// 比如借助标签得到求质数更简单的写法
n = 20;
label: for (i = 2; i <= n; i++) {
    primeFlag = true;
    for (int j = 2; j <= Math.sqrt(i); j++) {
        if (i % j == 0) {
            continue label;
        }
    }
    System.out.println(i);
}
```

不能说return是专门用来退出循环的，是函数返回顺带结束所有循环。

## eclipse

插入章，记一些关于eclipse IDE的东西。

保存的时候文件就自动被编译，编译失败则告诉我们哪里有问题。有时候编译通过，运行不通过，报错信息会显示在控制台。

我们发现eclipse为我们设计在一个普通Java工程的根目录中，src目录作为源文件夹，bin目录作为编译文件夹，将src下对各包编译生成的字节码文件按相同结构放在bin中。可以自己试试，在一个文件夹中建两个源文件分别对应两个类，一个主类用到另一个类，那么用javac编译主类时必须带上依赖选项，带选项指令的写法可参见[此文档](https://blog.csdn.net/Jackliu200911/article/details/89842668)。

无论我们引用的jar包在项目内还是项目外，都需要Add to build path（可译作添加进编译路径或告知字节码存放地址），具体地：

- 针对项目目录内的jar包（一般在lib目录下），既可选中它们点击Add to build path，也可打开Java Build Path窗口点Add Jars。
- 针对项目目录外的jar包，可打开Java Build Path窗口点Add External Jars。

## 数组

### 概述

数组是多个相同类型数据按一定顺序排列的集合，用编号方式对它们进行管理。

它有下列要素：

- 数组名。
- 下标或索引。
- 元素。
- 长度。

它有下列属性：

- 有序。
- 数组变量属引用类型。
- 数组变量引用内存中一块连续空间。
- 运行中长度一旦确定不可修改。

数组的分类：

- 按维度分，有一维数组、二维数组……。
- 按元素类型分，元素可以是基本类型，也可以是引用类型。

### 一维

那先来看看一维数组的使用：

```java
/* 回顾普通变量 */ 
int num; // 声明
num = 2; // 初始化
int age = 19; // 声明并初始化

// 声明
int[] ids;
// 静态初始化：引用和元素赋值操作同时进行
ids = new int[] { 101, 102, 103, 104 };

// 动态初始化：引用和元素赋值操作分开进行 适用于元素值事先未知的情况，但长度须指明 
String names[];
names = new String[4];
// 元素的读取 null
System.out.println(names[2]);
// 这一行不会造成编译异常，造成运行异常，因为编译只检查语法错误，不涉及JVM即不涉及内存，故越不越界不知
names[5] = "Bob";

// legnth是数组（对象）的一个属性（静态域）
System.out.println(ids.length);
```

常常用循环遍历数组，例子就不举了。

对动态初始化，不同类型元素有各自的默认初始值，我们来梳理一下：

- 整型（byte、short、ing、long）的是0。
- 浮点型（float、double）的是0.0。
- 字符型的是对应ASCⅡ码中数值0（或Unicode中对应`\u0000`等）的字符。这玩意蛮奇怪，打印出来看不见。
- 布尔型的是false。
- String类型（及之后学到的类，某个类）的是null（不是`"null"`）。

内存解析：解析数组的内存，即研究JVM如何为数组分配空间或者说分配什么样的结构。来看一张<span id="memory">朴素的内存图</span>，我们暂只说明与数组有关的子空间：

<img src="java.assets/朴素内存结构.png" alt="内存简图" style="zoom:67%;" />

我们以一段代码为例，结合内存结构分析执行过程：

```java
int[] arr = new int[] {1, 2, 3};
arr = new int[4];
```

第一行：arr是main方法的一个局部变量，故其空间在栈中，等号右边表示在堆中开辟一个空间存放实际的数组结构，具体是连续的3元素12字节的空间，起初3个4字节的子空间存放的都是0，然后依次换成被赋的值，用首元素首字节的地址（十六进制表示，如`0x55aa`）代表此空间的地址，那么arr空间存放着这个地址，意即arr引用这块堆空间。

第二行：先看等号右边，表示又在堆中开辟一个空间存放又一个数组，三个子空间存放的都是默认值0，然后将arr栈空间存放的值变成这个新空间首元素首字节的地址如`0x3022`，这时JVM会检测到原数组已经没被任何变量引用（原数组堆空间地址没被任何栈空间存放），于是释放原数组空间，此即垃圾回收机制的一种体现。最后，随着主方法结束，arr栈空间也会被释放（地址值出栈）。

这是整型数组的情况，如果是字符串数组或对象数组情况就更为复杂，子空间存放的就也是地址-对应堆空间或常量池空间的地址。

注：内存解析发生在运行期。编译得到的文件还是在硬盘（外存）中，JVM中的类加载器和类解释器对字节码文件进行解释运行，即将其加载到内存中，这才有内存解析的过程。

### 多维

二维数组相当于元素是一维数组的一维数组，三维数组相当于元素是二维数组的一维数组，以此类推，所以从底层看其实没有所谓的多维数组。

透过一些例子看看二维数组的使用：

```java
// 动态初始化
int[][] arr1 = new int[3][4];
int arr[][] = new int[2][];
// 调用 0
System.out.println(arr1[2][1]);
// NullPointerException arr的第二个元素也是引用型（所有元素都是），对应空间尚未存放任何地址，故取得值为null
System.out.println(arr[1][0]);
// 于是给第二个元素赋值，即让其空间存放一个3元素数组的地址
arr[1] = new double[3];
// 元素总数
System.out.println(arr1.length * arr1[0].length);

// 静态初始化
int[] wierd[] = { { 1, 2 }, { 3, 4 } };
```

常用双层循环遍历二维数组，例子省略。

举几个例子看看二维数组的初始化：

```java
// [I@15db9742 由于二维数组的元素是数组，属引用型，在内层数组长度指明的条件下，存放的就是个具体的地址，不过JVM把这个地址用一串代号替换掉了，其中I代表int
System.out.println(arr1[1]);
// 0 内层数组的元素是整型的，故默认值为0
System.out.println(arr1[1][1]);
// null 内层数组长度未指明，故此元素空间未存放任何地址，存null（引用类型默认值）
System.out.println(arr[0]);
```

以下一行代码为例看看二维数组的内存结构。

```java
// 静态初始化
int[][] arr2 = new int[][] { { 1, 2, 3 }, { 2, 3, 4 }, { 3, 4, 5 } };
```

![多维数组](java.assets/多维数组.png)

其中a1、a2、a3是连续的，b、c、d不连续。

学了高维数组，类型就细化了，比如一维数组就不能和二维数组互相赋值（就不存在自动提升）、数组和元素不能互相赋值等等。

数组间的赋值、引用型数据间的赋值不像基本类型数据间的赋值，后者是相当于复制，形成相互独立的关系，前者形成同生共死的关系，你我指向同一块堆空间，操作同一个对象。

那么我们真要想实现数组的复制，不难想到用遍历的方法逐一为新数组的元素赋值。

### Arrays

Java提供了关于数组的工具类Arrays，其下有许多用来操作数组的静态方法，常用的有equals、toString、fill、sort、binarySearch等。

### 异常

关于数组的常见异常就俩：

- ArrayIndexOutOfBoundsException：下标越界。
- NullPointerException：空指针。

负数也属于越界。

null是引用型变量的默认值，表示它不引用任何对象，即其空间不存放任何地址值，存的是null。

## 面向对象

### 概述

详细知识就不赘述了。回顾OOP的三大特征：

- 封装（encapsulization）：将功能封装进对象；成员的隐藏。
- 继承（inheritance）：抽取不同类的公有成员成父类，同时保留各个子类的特有成员。
- 多态（polymorphism）：一个抽象的功能根据不同情况具象成有针对性的功能。

### 类与对象

OOP设计的重点是类的设计，往细里说就是类的成员的设计。类的成员包括属性（又叫域或字段-field或成员变量）与方法（method，又叫成员方法）。

我们逐级扩展类的设计，先就本节标题看一下最基本的结构：

```java
class Person {
	String name;
	int age = 1;
	boolean isMale;

	public void write() {
		System.out.println("人在写字");
	}

	public void paint() {
		System.out.println("人在画画");
	}

	void talk(String language) {
		System.out.println("人在谈论，说的是" + language);
	}
}

/* 测试 */
// 创建类的实例（instance）
Person person = new Person();
// 调用域
System.out.println(person.age);
// 调用方法
person.talk("汉语");
```

对于类从创建到使用，不外乎三大步：

- 创建并设计类，设计域和方法。
- 实例化类，即创建类的对象。
- 由对象调用其方法。

域跟变量不同，在调用之前可不用赋值，而保持默认初始化值，初始化值同数组元素的默认值一致。

辨析域与局部变量：

- 域直接定义在类体内部；局部变量的范畴是：声明在方法（包括构造器）体内及类级代码块内的变量、方法形参。
- 局部变量使用前必须赋值（参数传递也算）；域可不必，被默认初始化。
- 局部变量有作用域的限制；域可在类体内任何地方被读写（暂不考虑static关键字）。
- 域有权限修饰符-private、缺省、protected、public；局部变量没有。
- 局部变量被加载到栈空间；域（不考虑static）被加载到堆空间。

方法有以下组分：

- 权限修饰符：可选，但缺省也指一种权限。后面谈到封装性再细说几个修饰符的效力。
- 关键字：可选，有static、final。
- 返回值类型：必填，但类型为基本类型、某类、数组时表示有返回，类型为void时表示无返回。
- 方法名：应遵循标识符规范。
- 形参列表：可选。方法名和形参列表合起来叫方法的签名。
- 方法体：有返回时体内必有return语句，表示方法执行结束；无返回时return语句可有可无，有的话就写`return;`表结束。

暂不考虑static，方法体内可调用域和方法。

不像JS有闭包，方法体内不能定义方法。

### 内存解析

这里略微展开讲一下JVM运行时数据区内的几个内存区域：

- 堆（heap）：存放对象实体，所有的实例及数组都在这里被分配空间。
- 栈（stack）：通常所说的栈指虚拟机栈（VM stack），存放局部变量，局部变量表存放了编译期可知长度的诸基本数据类型（八大基本类型与对象引用-reference-堆内对象的首地址），方法执行完，自动释放。
- 方法区（method area）：存储已被虚拟机加载的类信息、常量、静态域、即时编译器编译后的代码等。

根据本章第一段代码画个图：

<img src="java.assets/对象内存.png" alt="对象内存"  />

同类不同对象占有各自的堆空间，由各自的声明变量引用，那么一赋值，情况就不同了。

```java
Person p1 = new Person();
Person p2 = new Person();
p1.name = "Zhang";
p2.name = "Chen";
// 将p1变量对应栈空间存放的对象地址值复制到p2变量对应栈空间中，于是p2也引用p1所引用的对象实体
p2 = p1;
// Zhang
System.out.println(p2.name);
```

看一下对象数组的内存情况。

```java
Person[] persons = new Person[3];
for (int i = 0; i < persons.length; i++) {
    persons[i] = new Person();
}
persons[1].age = 18;
persons[2].age = 20;
```

![对象数组](java.assets/对象数组.png)

其中a、b、c三地址并不构成连续空间。数组的三个元素都是引用，存放堆中三个对象实体的地址。然后我们做一次交换：

```java
Person temp = persons[2];
persons[2] = persons[1];
persons[1] = temp;
// 20
System.out.println(persons[1].age);
```

![引用交换](java.assets/引用交换.png)

从图中可看出，交换过程中堆里的对象实体<span id="calm">纹丝不动</span>，变化的只有数组第二个、第三个元素空间所存的地址值。于是再次强调引用类型变量的赋值赋予或复制的是地址值。

### 匿名对象

我们可以不用一个显式变量引用对象实体，这就产生匿名对象。每个匿名对象都是一个独立的对象实体，故只能被调用一次。可以直接通过隐式地址值验证匿名对象的独立性：

```java
// oop.Person@15db9742
System.out.println(new Person());
// oop.Person@6d06d69c
System.out.println(new Person());
```

实际开发中，常见到匿名对象充当方法的实参，不过一经赋给形参，进入方法体，就不再匿名了，就能被重复调用了。作实参时，没变量引用我，进了方法体，形参引用我。

### 方法再探

#### 重载

重载（overload）是指在同一个类中，存在多个同名方法，但它们的参数列表不同，具体可以是参数个数不同、参数类型不同及个数类型都不同。比如下例囊括了这三种情况：两个加法方法参数个数不同；两个减法方法参数类型不同；两个乘法方法个数类型都不同；最后两个除法方法就比较阴间了，本来没有体现重载的意义（方法体改一下可能就有了），但仍属于第二种范畴。

```java
public int add(int a, int b) {
    return a + b;
}

public int add(int a, int b, int c) {
    return a + b + c;
}

public int minus(int a, int b) {
    return a - b;
}

public double minus(int a, double b) {
    return a - b;
}

public int times(int a, int b) {
    return a * b;
}

public double times(int a, double b, double c) {
    return a * b * c;
}

public double divide(int a, double b) {
    return a / b;
}

public double divide(double a, int b) {
    return a / b;
}

/* 测试 */ 
// 都是0.5
System.out.println(calculator.divide(1, 2.));
System.out.println(calculator.divide(1., 2));
```

这种机制归根结底是Java的强类型特点造成的。

不同类的同名方法和同类不同名方法当然构不成重载。返回值和方法体无所谓。我们大可无视参数名，因为相对类型来说参数名意义甚小。

那么我们调用重载方法的时候，系统能根据实参情况选定对应的方法来执行，所以参数列表的唯一性很重要。通过对象调用其方法，方法名可能不唯一，方法的签名一定是唯一的。

顺带看一个坑爹的例子：

```java
int[] intArr = new int[] { 1, 2, 3 };
// [I@15db9742
System.out.println(intArr);
char[] charArr = new char[] { '1', '2', '3' };
// 123
System.out.println(charArr);
```

究其原因，是源码中println方法是重载的，上面那个形参类型是Object，而下面这个是`char[]`（开小灶，专门为字符数组重载一个）。

#### 可变个数形参

JavaSE 5.0提供可变个数形参（variable number of arguments）机制，允许定义能同任意（包括0）个统一类型的实参相匹配的形参，解决了定义方法时形参个数暂不能确定的问题。

5.0以前是借助数组存放多个参数：

```java
public void showName(String[] names) {
    for (int i = 0; i < names.length; i++) {
        System.out.println(names[i]);
    }
}

// 测试
Varargs varargs = new Varargs();
varargs.showName(new String[] { "bob", "lily", "jim" });
```

5.0以后就有了新机制：

```java
public void showName(String... names) {
    for (int i = 0; i < names.length; i++) {
        System.out.println(names[i]);
    }
}

// 测试
varargs.showName("bob", "lily", "jim");
```

它就优化了实参的写法，并没有优化对形参的使用过程。

```java
public void showName(String... names) {
    for (int i = 0; i < names.length; i++) {
        System.out.println(names[i]);
    }
}

public void showName(String name) {
    System.out.println(name);
}

// 测试 
varargs.showName("bob");
```

上面两个方法也是构成重载的，因为前者参数个数不固定，后者固定，满足参数个数不同的条件，传入单实参时优先调用固定的后者。<span id="overload">新方法不能和旧方法构成重载</span>，因为编译器认为尽管长得不一样，但签名一样（参数列表一样）。

可变个数形参只能写在参数列表末尾且至多存在一个。

#### 参数传递

参数传递有两类-值传递（赋值）和址传递（赋址）。

先从变量的赋值谈起：

- 如果变量是基本数据类型，那么赋值赋的是变量保存的数据值。
- 如果变量是引用数据类型，那么赋值赋的是变量保存的数据的地址。

以上就是值传递的两种情况，不管保存的是什么，赋出去的都是存的东西。所谓址传递，可自行复习C++里的引用传递，就是赋另一个变量以自身的地址而非存的东西。

使用一个变量，不管它是基本类型还是引用类型，访问到的都是最终端的数据，只不过前者是直接拿到，后者是透过地址间接拿到。

Java中方法的参数传递机制是值传递。

```java
public void swap(int m, int n) {
    int temp = m;
    m = n;
    n = temp;
}

public void swap(Person p1, Person p2) {
    Person temp = p1;
    p1 = p2;
    p2 = temp;
}

/* 测试 */ 
ArgumentPassing argumentPassing = new ArgumentPassing();
int m = 10, n = 20;
argumentPassing.swap(m, n);
// m = 10, n = 20 没变
System.out.println("m = " + m + ", n = " + n);

Person p1 = new Person();
p1.name = "Zhang";
Person p2 = new Person();
p2.name = "Li";
argumentPassing.swap(p1, p2);
// Zhang 没变
System.out.println(p1.name);
```

对于上述两个交换都有：由于作用域的限定，swap里形参的交换并不影响main里的实参。

还是像<a href="#calm">之前</a>说的，看着swap方法体里的交换，两个Person对象实体纹丝不动，但我们也有办法改变这两个对象的状态：

```java
// 改写上面第二个swap方法
public void swap(Person p1, Person p2) {
    String temp = p1.name;
    p1.name = p2.name;
    p2.name = temp;
}
```

仅指针指来指去如隔靴搔痒，我们干脆直接动堆里的对象实体。

最后依样总结Java参数的值传递机制：

- 如果参数是基本数据类型，那么实参赋给形参的是实参保存的数据值。
- 如果参数是引用数据类型，那么实参赋给形参的是实参保存的数据的地址。

应注意String型变量或参数存放的也是位于常量池中的字符串实例（其实是字符数组），而非简单的“字符串值”。

#### 递归

一言以蔽之递归就是方法在体内调用自己。

递归表达出一种隐式的循环，即亦重复执行一段代码，我们常用判断语句控制递归不要变成等价于死循环的无穷递归。

由于内存溢出的隐患，递归并不常用，我们也很少写，看懂现有递归的逻辑即可。

### 封装

#### 概述

封装体现OOP设计追求高内聚、低耦合思想。

封装的第一层含义：多级整合。将若干行代码整合进方法；将若干个方法整合进类；将若干个类整合进类库……。

封装的第二层含义：成员的隐藏或私有化。从域的隐藏这个角度看，结合实际，类的域有或多或少的限制，比如学生学号就不能是负数，而我们仅围绕域的声明是做不到让这些限制生效的，所以想到的办法是禁止在外部读写域，转而通过方法读写，同时在方法体内让限制生效，这就要求方法公开，最终使得调用者能通过方法读写域但遵循一定规则。

```java
class Student {
	private int id;

	/**
	 * 写学号
	 * 
	 * @param id
	 */
	public void setId(int id) {
		if (id < 0) {
			System.out.println("学号不能为负！");
		} else {
			this.id = id;
		}
	}

	/**
	 * 读学号
	 * 
	 * @return
	 */
	public int getId() {
		return id;
	}
}

/* 测试 */ 
Student student = new Student();
// 编译失败 The field Student.id is not visible
student.id = -5;
student.setId(-5);
```

编译器知道id是Student的域，但告知我们它是不可见的，不能对外暴露，不能读写。

形如getXXX的方法叫访问器（getter），形如setXXX的叫方法叫修改器（setter），这俩是最常见的类方法。

#### 权限修饰符

由成员的隐藏（可见性）引出四种权限修饰符，封装性由这四种修饰符支持，实现不同范围的灵活使用。

- private。
- 缺省。
- protected。
- public。

不同修饰符条件下成员的读写权限如下表：

|           | 本类 | 本包 | 其他包里的子类 | 本工程 |
| --------- | ---- | ---- | -------------- | ------ |
| private   | 可   |      |                |        |
| 缺省      | 可   | 可   |                |        |
| protected | 可   | 可   | 可             |        |
| public    | 可   | 可   | 可             | 可     |

这里的包指的是某个类所在的目录，反映到语法上有package关键字。

protected修饰符涉及子类的问题，这要留待<span id="protected">后面</span>再说。

在类名前也有权限修饰符，不过只有两种情况-public和缺省，缺省的话本包以外都无法使用本类，import语句也会编译不过。

域一般要被隐藏。

### 构造器

任何一个类都有构造器（constructor）或构造方法，至少有一个。

我们回顾一下实例化语句：

```java
Person person = new Person();
```

我们仔细看，等号左边没啥好说的，引用变量所引用的类和变量名，右边除了new关键字就是一个长得像方法的东西而不是想当然的类名（但名字跟类名一致），它就不是这样写：

```java
Person person = new Person;
```

这就说明类的实例化过程跟`Person()`这个东西很有关系，而且这个“方法”在类体中并没有出现。我们把这个东西叫做构造器，创建某类的对象相当于new+该类的构造器。

如果没有显式定义构造器，系统默认提供一个无参构造器，其权限与类的相一致。定义构造器的格式为：

```java
修饰符 类名() {
	...
}

修饰符 类名(参数列表) {
	...
}

// 例子：Person的有参构造器
public Person() {
    System.out.println("有一个人");
}

// Person的有参构造器，满足重载，且这是一种最常见的构造器，为所有域初始化
public Person(String name, int age, boolean isMale) {
    super();
    this.name = name;
    this.age = age;
    this.isMale = isMale;
}
```

须强调构造器（构造方法）不是方法，原因有两点：

- 长得不一样。构造器无返回值类型，无返回值。
- 用处不一样。方法反映类的功能，有了对象（不谈static）才能调用，而构造器是用来构造对象的，一定是先于方法调用的。

构造对象的一个很要紧的工作就是域的初始化，相较于多次调用setter方法提高了效率。

一旦自己写了构造器，系统就不再提供默认的无参构造器。

顺带说一下<span id="order">属性赋值的顺序</span>。目前我们知道了可在声明处、构造函数体内、setter方法体内给属性赋值，它们的顺序如何呢？

1. 默认初始化。
2. 声明处初始化。
3. 构造器体内的赋值。
4. setter体内的赋值。

一次运行期间其中前三个只执行一次，第四个可执行多次。后续会接触到在类级代码块中也能为属性赋值。

### this

this关键字出现在方法体内，是当前对象的引用，对应空间存放当前对象的地址，来验证一下：

```java
package oop.visible;

public class Order {
	private int orderPrivate;
	String orderDeault;
	public double orderPublic;

	public Order() {
		System.out.println(this);
	}
}

/* 测试 */
// oop.visible.Order@6d06d69c
new Order();
```

this的主要作用是区分同名的形参和域。以setter为例：

```java
public void setName(String name) {
    // name = name; 局部变量（形参）屏蔽同名的域
    this.name = name;
}
```

不区分的话，编译器分不清，`name = name`就是形参自己赋自己了。

对于当前对象的含义，在普通方法中this引用的对象已创建，但在构造器中this引用的对象正在创建。

可通过this在一个构造器体内调用其他重载构造器，常用来达到代码复用，降低冗余。

```java
public Order(int orderPrivate, String orderDeault, double orderPublic) {
    // 调用必须在首行 由此也能退出不能同时调用多个，因为这样一来至少存在一个不在首行
    this(orderDeault, orderPublic);
    this.orderPrivate = orderPrivate;
}

public Order(String orderDeault, double orderPublic) {
    this.orderDeault = orderDeault;
    this.orderPublic = orderPublic;
}
```

不难想到this构造器调用链不能形成闭环，形成了则运行得没完没了。<span id="n">若一个类中有n个构造器，则最多存在n-1个this构造器调用。</span>

### package

为了对工程下的所有类分门别类地管理，Java提出包的概念。

我们在源文件首行（那当然只有这一行了），使用package关键字声明类或接口所属的包。

包名两两不相同，同一个包下不能存在同名的类或接口，不同包下则可，这体现了package避免命名冲突的作用。例如：

```java
// 一个源文件Hello.java的首行
package com.van.me;
// 另一个同名源文件Hello.java的首行
package com.van.you;
```

眼见得包名是一长串。

### import

使用本包以外的某个类或接口需要import关键字，导入语句位于包声明和类声明之间，导入多个类的话就存在多行导入语句。

```java
package com.van.service.impl.StudentServiceImpl;

import com.van.entity.Student;
// 使用通配符，表某包下的所有直属元素
import java.utils.*
```

String、System等Java的核心包（java.lang包）下的东西不用显式导入，本包下的东西也不用显式导入。

对比import语句与package语句，前者落脚点是类或接口，后者落脚点是目录。

有时一个类使用了不同包下的同名类，那不得不至少有一个类展开到带包名的全类名：

```java
import com.van.model.Student;
// import com.van.entity.Student; 这当然是没用的

/* 测试 */
Student student = new Student();
com.van.entity.Student stu = new com.van.entity.Student();
```

从这个角度看其实import语句简化了写法，将全限定类名缩略为非限定类名，大大提升了可读性。

子包的问题：像上面的通配符不能匹配子包里的东西，同理java.lang的直属元素才能省略导入语句，比如：

```java
import java.lang.reflect.Field;
```

特别地，static关键字配合下import还可导入类或接口的静态成员，此时落脚点就变为成员了。

```java
import static java.lang.System.*;
import static java.lang.Math.round;

// 测试 调用静态属性和静态方法
out.print("hello");
out.println(round(3.14));
```

### 继承

#### 概述

我们思考一下继承的作用：

- 正向来看，先有父类。顾名思义，子类继承父类的属性和方法而不用重复定义，这能降低代码的冗余度，但是其作用不能仅限于继承，因为单纯的继承只产生一个功能一模一样的类而已，这没有意义。那么另一大作用就是创新，具体有两方面的创新-对现有的父类方法进行创新，这就有了重写（覆盖）；保持继承得来的方法不变而定义自身特有的域与方法。继承并创新才是继承机制的完整作用。

- 反向来看，先有子类。其实跟上面的是等价的，从多个高度相似的类中抽取高度相似的那部分成员形成父类，也是降低代码冗余度。同时各自未被抽取的那部分成员又都体现了各自的特征。

继承性的好处：

- 减少代码冗余。
- 便于功能扩展。
- 为多态作铺垫。

一个类一旦继承另一个类，就会获得它的域和方法。对于父类的私有域，虽不能直接读写，但可通过父类get、set方法间接读写，且注意对一个实例来说继承而来的所有的域都在自己的堆空间中。继承之后，子类还可声明自己特有的属性和方法，实现功能的扩展（关键字extends就很形象），因此子类功能更为强大。

继承性有如下规定：

- 一个父类可以派生出多个子类，但一个子类只能继承一个父类。
- 子类、父类都是相对概念，因为允许多层继承，继承层数越深，末端子类功能越强。子类直接继承的类叫直接父类，间接继承的类叫间接父类，于是子类获得了直接父类和所有间接父类的属性和方法。

补充前面<a href="#protected">protected修饰符</a>的问题。外包下的普通类无法读写本类非公有成员，而一旦这个类是本类的子类，就能读写本类的protected成员，相较于缺省及以下protected就扩大了读写范围。实际开发中protected用得很少。

#### 重写

子类可用根据需要对继承来的实例方法进行改造，也成方法的重写、覆盖（overwrite、override），那么运行时子类的方法将覆盖父类的方法。

关于重写有许多细节性要求：

- 方法签名要完全一致。
- 对返回值类型，基本类型必须一致，引用类型可以不一致但子类的不能高于父类的。
- 对权限，子类的不能低于父类的。故子类不能重写父类私有方法。
- <span id="exception">对异常，子类抛出的不能高于父类抛出的。</span>

当签名业已一致，其他要求任意一个不满足，编译都不通过。父类子类的静态方法毫无关联，不涉及重写。

来看一些例子。下面每个例子中上一个方法是父类Person里的，下一个方法是子类Student里的。

```java
// 静态方法不产生重写，相互独立
public static void eat() {
    System.out.println("I am eating");
}
public static void eat() {
    System.out.println("A student is eating");
}
```

```java
// 编译报错，返回值类型不兼容，基本类型的话必须完全一样
public void eat() {
    System.out.println("I am eating");
}
public int eat() {
    System.out.println("A student is eating");
    return 1;
}

// 编译通过，返回值类型支持向上转型
public Person eat() {
    System.out.println("I am eating");
    return this;
}
public Student eat() {
    System.out.println("A student is eating");
    return this;
}
```

```java
// 编译报错，不能降低重写方法的可见性
Person eat() {
    System.out.println("I am eating");
    return this;
}
private Student eat() {
    System.out.println("A student is eating");
    return this;
}
```

```java
// 编译报错，异常类型应满足向上转型
public Person eat() throws NullPointerException {
    System.out.println("I am eating");
    return this;
}
public Student eat() throws Exception {
    System.out.println("A student is eating");
    return this;
}
```

#### super

重写带来了覆盖，但有时候我们又想调用父类的被重写方法，这时就要靠super关键字。

先看个例子：

```java
public class Circle {
	private double radius;

	public Circle() {
		radius = 1.;
	}

	public double findArea() {
		return Math.PI * radius * radius;
	}
}

public class Cylinder extends Circle {
	private double length;

	public Cylinder() {
		length = 1.;
	}

	public double findVolume() {
		return findArea() * length;
	}

	@Override
	public double findArea() {
		return findArea() * 2 + length * 2 * Math.PI * getRadius();
	}
}

```

这里子类Cylinder的findArea方法体内调用的findArea方法是自己，产生递归了，因为父类的被覆盖掉了。那么可以基于super关键字调用父类被重写方法：

```java
public double findArea() {
    return super.findArea() * 2 + length * 2 * Math.PI * getRadius();
}
```

super专门用来调用父类的实例域、方法及构造器，但它又不像this那样引用某个父类实例。这个调用也是遵守前面提到的权限的。

属性是没有重写的，但也有覆盖的机制，不过这种现象太阴间了，那么我们同样就super来区分同名属性。例如：

```java
/* 我们可先把父类radius属性设为缺省或protected的使得子类可读写 */
public void accessRadius() {
    // 或 this.radius = 1.;
    radius = 1.;
    super.radius = 2.;
}
```

那么对于不同名的属性就没有覆盖的担忧，super就可省略，对方法亦如此。

看调用构造器的例子：

```java
/* 父类Person含属性name与age */
public Student(String name, int age, String major) {
    // 调用父类构造器 必须在首行，this调用本类其他构造器的语句退位让贤
    super(name, age);
    this.major = major;
}
```

执行子类的任意构造器，都有要么调用`this(参数列表)`要么调用`super(参数列表)`，二者必居其一且仅居其一，不手动写的话系统也会隐式地去调。接续前面的<a href="#n">推论</a>，若一个子类有n个构造器，则最少存在1个super构造器调用，此时就有n-1个this构造器调用。

#### 子类实例化过程

从过程上看，子类实例的堆空间中之所以拥有父类的域，正是因为通过子类构造器创建子类对象（执行构造方法体）时，必然直接或间接调用父类的构造方法，从而继承得到父类的域（方法同理）并赋值，如果存在多层继承，那么必然存在多层子对父构造方法的调用，而且最终是对Object类无参构造器的调用。

<img src="java.assets/对象实例化过程.png" alt="对象实例化过程" style="zoom:67%;" />

注意创建子类对象并不能推出已经创建了父类对象，前面也提到super关键字不引用具体的父类实例。实例存不存在还是要看new关键字，子类实例化过程只不过调用了父类构造器，并不涉及new操作。

### 多态

#### 概述

多态展开来说是对象的多态性，简单来说，就是父类变量引用子类对象（或子类对象赋给父类变量）。这个子类对象是不确定的。

```java
public class Animal {
	public void shout() {
		System.out.println("动物喊叫");
	}
}

public class Cat extends Animal {
	@Override
	public void shout() {
		System.out.println("喵喵喵");
	}
    
	public void eat() {
		System.out.println("猫吃鱼");
	}
}

public class Dog extends Animal {
	@Override
	public void shout() {
		System.out.println("汪汪汪");
	}
}

// 测试 重中之重-向上转型，多态性的体现 向上转型是多态的必要不充分条件
Animal animal = new Cat();
```

第22行，我们从右往左看，呈现了一种向上转型-Student->Person。再者由于Person类可能有多个子类，故等号右边new出来的实例可能不一定是Student实例，这就呈现出一种子类对象的不确定性。

多态的用法：当通过此变量调用子父类同签名方法时，实际执行的是子类的重写方法，这叫虚拟方法调用。

```java
// 子父类都有shout方法
animal.shout();
// 编译不过，eat方法仅子类有
animal.eat();
```

同时我们发现，父类变量是不能调用子类特有方法的，它只能调本类中的方法。我们按住Ctrl点eat方法，发现反编译跳到父类eat方法，故编译器关注的是等号左边的类型，而运行起来又去调子类重写了的方法。

多态性成立的充要条件：存在A对B的向上转型（也可以说类的继承是一个必要条件）且存在A对B方法的重写。

至于多态性的意义何在，我们通过例子体会一下：

```java
public static void shout(Animal animal) {
    animal.shout();
}

public static void main(String[] args) {
    shout(new Dog());
    shout(new Cat());
}
```

由于多态性的支持，才能将不同子类实例作实参传递给父类形参。多态性不成立的话就得多出一些代码重载shout方法，一个不够用：

```java
public static void shout(Cat cat) {
    cat.shout();
}
public static void shout(Dog dog) {
    dog.shout();
}
```

典型方法如Object类的equals，其参数类型就是Object，最为通用，派生一切类，那么在做对象对比的时候传进什么类型的对象都可以，就不用针对某类专门又重载一个equals方法。所以多态的一大作用也是降低代码冗余。

#### 不适合域

对象的多态性只适用于方法，不适用于域。

#### 虚拟方法调用

英文是virtual method invocation。概念：子类与父类中定义了可重写方法，在多态机制下，将父类此方法叫做虚拟方法或虚方法，JVM根据具体的子类实例，动态调用该子类重写的方法，而编译器在编译期是无法预知到底哪个子类实例会被父类变量引用。所以说动态调用（或动态绑定）是在运行期确定的，多态又叫运行时多态。

虚方法调用也反映了重载和重写的区别：

- 对于重载，在运行之前编译的时候，编译器就已经根据签名（唯一性）确定所要调用的方法，这叫早绑定或静态绑定，故重载又叫编译期多态。
- 对于多态，由于子类重写的方法和父类的这个虚方法签名是一样的，编译器就无法确定到底要调用哪一个。于是，只有等到运行起来方法被调用的时候，解释运行器才确定到底去调哪个子类重写的方法，这叫晚绑定或动态绑定。重写又叫运行期多态。

由上可知编译器更关注声明类型，按Ctrl点住虚方法就会跳到父类的方法，而解释运行器更关注实际的对象类型。

#### 向下转型

想要通过父类变量调用子类特有的成员，就只有让变量的声明类型由父类变为子类。

```java
// 向上转型
Animal animal = new Cat();
// 使用强制类型转换符，向下转型
Cat cat = (Cat) animal;
```

区分这两组概念，别说扯了：自动类型提升+强制类型转换；向上转型+向下转型。两组都能用强制类型转换符。

向下转型之后，编译器就能确定当前变量类型是具体某个子类了，那么后续调特有的成员就没有问题：

```java
cat.eat();
```

尤其注意，使用向下转型，有时候看着编译没问题，但运行就报类型转换异常（ClassCastException）了。如：

```java
// 编译通过
Animal animal = new Cat();
Dog dog = (Dog) animal;
```

看一些有趣的例子：

```java
/* 编译通过，运行不通过 */
// 猫变狗不行
Animal kitty = new Cat();
Dog spike = (Dog) kitty;
// 动物变猫不一定
Animal an = new Animal();
Cat miao = (Cat) an;

// 编译通过，运行通过 猫变动物可以
Object mi = new Cat();
Animal a = (Animal) mi;

// 编译不通过 猫变狗不行 向下转型的必要条件是存在继承关系
Dog collie = (Dog) new Cat();
```

仔细观察上述例子，有个简单的判定法，只看起点（等号右边的）实体类型和终点（等号左边的）声明类型，要么起点类型是终点类型的子类要么起点类型与终点类型相同。编译器是根据起点声明类型和终点声明类型来要求强转的。

#### instanceof

为了避免类型转换异常，引入instanceof运算符，判断某（变量引用的）对象是否是某类的实例。

```java
Animal animal = new Cat();
if (animal instanceof Dog) {
    Dog d = (Dog) animal;
    d.eat();
} else {
    System.out.println("当前对象不是Dog类的实例");
}
```

`a instanceof B`，a是不是B的实例，要看a引用的对象的类型，而非a声明的类型。

```java
Animal some = new Animal();
// false
System.out.println(some instanceof Cat);
Cat c = new Cat();
some = c;
// true
System.out.println(some instanceof Cat);
// true
System.out.println(some instanceof Animal);
// true
System.out.println(c instanceof Animal);
```

由上可得，某子类实例一定是父类实例，父类实例不一定是某子类实例。

#### 注

补充一些题目：

```java
class Father {
	int num = 1;

	public void show() {
		System.out.println(this.num);
	}
}

class Son extends Father {
    // 还是强调开发中不要在子类中定义同名域，这里只是题目需要
	int num = 2;

	public void show() {
		System.out.println(this.num);
	}
}

/* 测试 */
Father father = new Father();
// 1
System.out.println(father.num);
Son son = new Son();
father = son;
// 针对引用类型变量，==比较的是存放的地址值，要求两侧的类型要匹配（相同或成继承关系）
System.out.println(father == son);
// 1 属性不被覆盖
System.out.println(father.num);
// 2 在被覆盖的方法中，读到的属性是覆盖了的
father.show();
```

往上述类中加一些方法，来看可变数量参数对形参列表的影响。

```java
// 父类中 记作A
public void multiArgs(int solid, int... arr) {
    System.out.println("your father");
}
// 子类中 记作B
public void multiArgs(int solid, int[] arr) {
	System.out.println("your son");
}
```

联系[前面内容](#overload)，对子父类之间的这种情况，编译器同样认为它们的签名是一样的，故可构成重写，不过编译器警告我们不要复杂化，要重写则在参数列表形式上也要一模一样：`Varargs methods should only override or be overridden by other varargs methods`。然后我们在子类中再加一个：

```java
// 子类中 记作C
public void multiArgs(int solid, int a, int b, int c) {
    System.out.println("your son");
}
```

还是联系[前面内容](#overload)，C和B并A签名不同，故与B构成重载，与A不构成重写。

于是可以验证，执行`father.multiArgs(10, 2, 3, 4);`：当仅A、B存在，A被B覆盖，打印`your son`；当仅A、C存在，A不被C覆盖，打印`your father`；当仅B、C存在，编译不过，父类连这个方法都没有；当A、B、C均存在，A被B覆盖，不被C覆盖，B、C构成重载，打印`your son`。

### static

类的实例是相互独立的，即它们各自的成员都占据着独立的空间，互不影响。那么比如诸实例的一个同名属性的值是一样的，这就造成一定的浪费。我们希望能有公共的数据为所有实例共享，比如某个属性，读的话都从一个空间去读同一个值，写的话一个实例改了这个值，其他实例再访问到的改了之后的。

由此引入static关键字。static关键字可修饰域、方法、代码块、内部类，不能修饰构造器，由其修饰的域为本类所有实例共享。从内存上看，这些成员从属于类而非具体实例，跟着类一起加载而必先于实例创建，且一直伴随着类的生命周期存在，相比而言实例域就伴随着实例的生命周期而存在。

有了static，域就分为实例域（实例变量）与静态域（静态变量或类变量）。每个对象独立地拥有一套实例域，自己改自己的某个实例域不影响其他对象的同名实例域；而某对象修改了某静态域，其他对象读此静态域读出来的值会随之变化。

可通过类名直接读写类变量及调用静态方法。

```java
class Chinese {
	String name;
	int age;
	static String nation;

	public static void show() {
		System.out.println("我爱你中国");
	}
}

/* 测试 */
// 类级写静态域
Chinese.nation = "中国";
Chinese chinese1 = new Chinese();
System.out.println(chinese1.nation);
// 对象级改写静态域
chinese1.nation = "中华";
Chinese chinese2 = new Chinese();
// 中华
System.out.println(chinese2.nation);
// 类级调用静态方法
Chinese.show();
```

结合前面的[内存简图](#memory)，类变量就存在方法区的静态域中。

前面说了实例域依附于对象而存在，那么在对象实例化之前，当然就无法通过类调用它：

```java
// 编译不过 Cannot make a static reference to the non-static field
Chinese.name = "zhang";
// 同理得类不能调用实例方法
```

梳理一下，一般而言：

- 对象既可以读写实例域与静态域，又可以调用实例方法与静态方法。
- 实例方法中既可调用实例域与方法，又可调用静态域与方法。
- 类不能调用实例域和方法。
- 静态方法中只能调用静态域与方法，或者说静态方法内不能使用this、super。

类的生命周期与JVM的相一致，对象的生命周期就短得多。先有类后有对象，可能类仍存在而某对象已不存在。后有的能调先有的，而先有的就调不了后有的。

根据静态域的优点，在实际开发中我们常把不随对象共有的数据设为静态域，连带地读写此域的方法一般也设为静态的。工具类里的方法一般是静态的，因为没必要生成一大堆状态、行为相同的工具类实例。

### 代码块

代码块又叫初始化块，是和属性、方法并列的类成员，只不过一般不跟它们一起被提出来，而是单独讨论。

作用是初始化类或对象。修饰符仅static，带上的话即静态代码块，用于初始化类；否则即非静态代码块，用于初始化对象。

- 静态代码块随着类的加载被隐式执行，于是只执行一次且先于非静态代码块的执行，多个代码块按定义顺序执行，代码块内不能调用实例域和方法。
- 非静态代码块随着对象的创建被隐式执行，于是可能执行多次，多个代码块按定义顺序执行，代码块内可调用静态域和方法。

试看一例：

```java
// 其他省略
class Human {
	String name;
	int age;
	static String nation;
	
    // 静态代码块
	static {
		nation = "中国";
	}

    // 非静态代码块
	{
		name = "fan";
		age = 22;
	}
}
```

联系继承，程序一运行，相关所有类的静态代码块按继承关系从父到子、类内按定义顺序（从上到下）被执行，然后有对象创建的话相关所有类的所有非静态代码块就也按继承关系从父到子、类内按定义顺序被执行，且构造函数于非静态代码块之后执行。

联系主方法，虽然它是程序执行的入口，但它也是本类的一个静态方法，故实际上本类的静态代码块会先于它的第一行执行。

有了代码块我们就知道属性也可以在这里赋值，于是我们接续[前面知识](#order)，重新排列一下实例域的赋值顺序：

1. 默认初始化。
2. 声明处初始化（跟3可互换）。
3. 非静态代码块中赋值（跟2可互换）。
4. 构造器中赋值。
5. 通过对象赋值（可见的话）或调用实例方法来赋值。

类体不像方法体，各组分的显示顺序无所谓，但特别地，实例域的声明语句与非静态代码块的顺序影响上述2、3，谁显示在上面谁先做赋值。

### final

final可修饰类、方法、变量（含属性、形参）：

- final类不能被继承。如内置的String、System、StringBuffer。
- final方法不能被重写。如Object的getClass。
- final变量又叫常量，其保存的数据在生命周期内不可更改。具体地基本类型变量保存的值不可变，引用类型变量保存的地址值不可变（但引用的对象实体可变）。

关于第三个多谈一些细节。对final实例域，可以在声明处、代码块中、构造器内显式初始化，但只能在以上三处中的某一处出现一次，且不能被方法赋值。

看一些例子：

```java
// 类中final域的延时初始化，遵从不可变规则，就不能叫覆盖了
class Worker {
	final int age;
	{
		age = 18;
	}
}

// 普通方法内 局部变量的延时初始化
final int num;
num = 10;

// final形参
public void show(final String info) {
    // 编译不过 info = "";
    System.out.println(info);
}
```

理解final形参，这里info是形参，作用域即生命周期是本次show方法的执行，不在本次执行过程中变动就行。至于传进来的实参怎么变都行，因为final修饰的是形参，影响不到实参。故下次调用show，info可以是跟上次不同的字符串。

常见static与final一起修饰域，曰静态常量或全局常量。

### 抽象类

#### 概述

有的父类极端抽象，其对象没有多大意义，故干脆禁止它产生实例，存在的意义就只有被继承，让子类去发挥，由此引入抽象类。

用abstract关键字修饰类使其变为抽象类：

```java
abstract class Geometry {
	private String name;
	private String color;

	public Geometry(String name, String color) {
		super();
		this.name = name;
		this.color = color;
	}
    
    public void show() {
		System.out.println("我是" + name);
	}
    
	// 抽象方法
	public abstract double findArea();
}
```

虽然抽象类不能实例化，但构造器还是有用的，即供子类实例化的时候调用。

抽象类不能产生对象实体，但可以有声明为本类型的变量，于是抽象类常常与多态向配合，即抽象的父类变量引用子类对象。

抽象方法只有声明，没有方法体，一定是非私有的，不能被实例调用。可推出含抽象方法的类必定是抽象类，而抽象类可不含抽象方法（开发中一般是含的），其实例方法可以留给子类用。

子类一旦继承了抽象类，就可能继承得到抽象方法，又因为抽象方法禁止被实例调用，所以要么继续让它抽象，留给子类的子类处理，同时子类也变成抽象类，要么重写，方法就不再抽象了，可调用了，子类也不抽象。

应用场景：如上面经典的几何图形类。几何图形就是个极为抽象的概念，实例中除了一些公共属性外方法不实用，就不妨设为抽象类，由具体的圆类、矩形类等继承。这个findArea方法也是极为抽象，因为不同图形的面积算法差异很大，于是也将其设为抽象方法，由具体图形子类覆盖。

#### abstract

联系重写规则，使用此关键字应当注意一些细节：

- 由于属性与重写无关，故abstract不能修饰属性。
- abstract不能修饰构造器。
- 由于私有性-不可见，更别谈重写，故abstract不能修饰私有方法。
- 由于类方法与重写无关，故abstract不能修饰静态方法。
- 由于abstract倡导重写，final阻止重写，故abstract与final不能一起出现。

#### 匿名子类

```java
// 匿名子类 多态
Geometry geometry = new Geometry("rectangle", "blue") {
    private double width = 10;
    private double height = 20;

    @Override
    public double findArea() {
        return width * height;
    }
};
// 200.0 子类对象调用重写方法
System.out.println(geometry.findArea());
// 我是rectangle
geometry.show();
```

注意首行`new Geometry`不是创建抽象类对象，而是先生成一个抽象类的匿名子类，然后创建这个的子类的对象，再赋给父类变量。至于为什么这么写，目前不好解释，记住就行。匿名子类不能显式定义构造器。

对末行，同样解读为父类变量引用的子类对象调用继承而来的非抽象方法。

`new 抽象类名 () {...}`的写法也可作实参。

## Object

### 概述

java.lang.Object是所有类（除Object自己）的父类，或被直接继承或被间接继承，那么所有类都拥有Object里的成员。

提前扯一下反射，可打印`实例名.getClass().getSuperclass()`看到超类（根父类）是Object。

Object只有一个无参构造器。

它的方法后面诸章节会详细去讲。

### equals

运算符`==`适用于基本数据类型和引用数据类型。它要求两边的类型一样，不过对引用类型，引用的对象实体同类型即可。

对基本类型，它比较的是所保存的数据是否相等，虽要求类型相同，但也支持自动类型提升等。看一些例子：

```java
int a = 2;
double b = 2.;
// true 自动类型提升
System.out.println(a == b);

// 10对应某个字符
char c = 10;
// true 字符等价替换
System.out.println(10 == c);
System.out.println('A' == 65);
// 编译不通过，布尔变量不参与类型转换，故不参与此运算
System.out.println(2 == false);

Student student = new Student();
Person person = new Student();
// false person和student声明类型可以不同，引用的对象类型必须相同
System.out.println(person == student);
person = student;
// true
System.out.println(person == student);
```

对引用类型，它比较的是所保存的地址值是否相等，或者说判断两个引用是否指向同一对象实体。有时候，两个变量引用的对象的状态一模一样，存的地址值不一样，而我们就希望根据状态认定它们是相等的，那么`==`达不到此要求，于是引入equals方法。

承上所述，equals是一个方法，不是运算符，且仅适用于引用数据类型，是Object类的实例方法，默认行为与`==`完全一致。

```java
// Object源码
public boolean equals(Object obj) {
    return (this == obj);
}
```

当然默认的没什么用，于是Java的一些内置类（Date、String、File、包装类等）重写了此方法，以实现对对象状态（诸属性）的比较。那么我们定义自己的类时也应当重写equals方法，此方法也要求对象实体类型一样、声明类型可不同。

```java
class Student {
	private String name;
	private int age;

	@Override
	public boolean equals(Object object) {
		if (this == object) {
			return true;
		}
		if (object == null) {
			return false;
		}
		// 子类实例也是父类的实例，我们要求对象实体类型一致，instanceof保证不了
		if (getClass() != object.getClass()) {
			return false;
		}
		// 这行是否多余？
		if (!(object instanceof Student)) {
			return false;
		}
		Student other = (Student) object;
		return name.equals(other.name) && age == other.age;
	}
}

// 附带eclipse生成的，考虑得更细致，如属性值为null的问题，也不用instanceof
@Override
public boolean equals(Object obj) {
    if (this == obj)
        return true;
    if (obj == null)
        return false;
    if (getClass() != obj.getClass())
        return false;
    Student other = (Student) obj;
    if (age != other.age)
        return false;
    if (name == null) {
        if (other.name != null)
            return false;
    } else if (!name.equals(other.name))
        return false;
    return true;
}
```

由此我们感受到在代码满足正确性的基础上，应向着健壮性继续前进。

equals方法也体现多态性，Object中的equals作为虚方法，不知道子类都有什么属性待比较，只能草草用个`==` 。

### toString

```java
Student student = new Student();
System.out.println(student);
```

我们打印某个引用变量（非null），往println方法里传的是这个变量，但底层会调用此对象的toString方法，然后打印其返回值。

Object中toString方法的实现如下：

```java
public String toString() {
    return getClass().getName() + "@" + Integer.toHexString(hashCode());
}
```

发现返回值字符串含类名及虚拟地址，这个JVM里的虚拟地址由hashCode算出，并非真实内存地址。

toString作用是表达当前对象的状态，默认实现自然不太友好，于是同样地许多内置类重写了此方法，我们定义类时也当重写。

## 单元测试

稍微扯几句。

没有Test注解的方法就是个普通方法。尝试使用Before注解。

## 包装类

### 概述

Java号称万物皆对象，为满足一般性，将类与对象机制推广到八大基本数据类型得到八大包装类（封装类）。它们是：

| byte | short | int     | long | double | float | boolean | char      |
| ---- | ----- | ------- | ---- | ------ | ----- | ------- | --------- |
| Byte | Short | Integer | Long | Double | Float | Boolean | Character |

所谓包装，从结构上说是把基本类型的变量当作一个类的属性，然后围绕此属性及其类型造一些方法，普通变量就进化成类；从操作上说，包装涵盖装箱、拆箱。

除Boolean与Character以外的包装类都是数值型的，都继承Number类。

这些基本类型进化成包装类后，默认值就都变成null了。

### 类型转换

基本类型向包装类的转换（又叫装箱）：

```java
/* 调用包装类的构造器 */
Integer i1 = new Integer(12);
Integer i2 = new Integer("12"); // 带非数字字符（包括空串）就报NumberFormatException
Float f1 = new Float(12.); // 传入是double的12.
Float f2 = new Float("12");
Boolean b1 = new Boolean(true);
// 布尔的这个构造器有点特殊，忽略大小写，传入的长得不是true的字符串都会被包成false
Boolean b2 = new Boolean("true25");
// false
System.out.println(b2);
```

包装类向基本类型的转换（又叫拆箱）：

```java
// 调用包装类的xxxValue方法
int in1 = i1.intValue();
float fo1 = f1.floatValue();
boolean bo1 = b1.booleanValue();
```

JDK 5.0之后，有了新特性-自动装箱和自动拆箱。

```java
int m = 5;
// 自动装，直接赋值的写法
Integer mObj = m;
// 自动拆
int n = mObj;
```

基本类型并其包装类向String转换：

- 最简单的就是字符串拼接（连接运算）。
- 调用String类重载的valueOf方法。

```java
String str1 = 10 + "1";
// 传入基本类型
String str2 = String.valueOf(22.4f);
// 传入包装类型
String str3 = String.valueOf(f1);
```

String向基本类型及包装类转换。

```java
// 调用包装类的parseXxx方法
int num = Integer.parseInt("256");
boolean flag = Boolean.parseBoolean("hello"); // false
// 调用包装类的valueOf方法
Float f = Float.valueOf("123.5"); // 也可利用自动装箱：Float f = Float.parseFloat("123.5");
```

看一些题目：

```java
// 包装类之间确实是不能转换的，但这里又允许2自动提升为2.0使两边类型统一
Object obj = true ? new Integer(2) : new Double(2.0);
System.out.println(obj);
```

```java
Integer i = new Integer(9);
Integer j = new Integer(9);
System.out.println(i == j);

// Integer有个内部类叫IntegerCache，里面有个Integer数组域叫cache，专门存放一组Integer对象，它们封装的整数的范围是-128~127，当不使用new而通过此范围内的字面量创建Integer对象时，变量的值就等于对应元素的值即对应Integer对象的地址
Integer a = 127;
Integer b = 127;
// true
System.out.println(a == b);
Integer x = 128;
Integer y = 128;
// false 超了范围，俩变量就去引用各自new出来的对象
System.out.println(x == y);

Double d1 = 2.4;
Double d2 = 2.4;
// false 其他包装类就无此特性，因为-128~127太常用了
System.out.println(d1 == d2);
```

## 接口

### 概述

接口与类是并列的，一个类可实现多个接口，解决了单继承的局限性。

接口就是规范（标准、契约），定义的是一组规则，继承是一个“是不是”的关系，接口则是一个“能不能”的关系。

来看一个朴素的理念图：

![接口理念](java.assets/接口理念.png)

其中四个类都实现了Fly接口，仅Bullet类多重实现了两个接口。Fly接口制定了飞行的规范，Attack接口制定了攻击的规范，它们都不具备类的特征，没必要作为一个类，因为无需属性，只需通过方法表达某种抽象的功能如起飞-飞行-降落。

### 定义与使用

#### 旧版本

在JDK 7及以前，接口中能定义全局常量与抽象方法。

```java
public interface Flyable {
	public static final int MAX_SPEED = 7900;
    // 由于所有域的修饰统一，故可省略
	int SPEED = 1;

	public abstract void launch();

	public abstract void fly();

    // 由于所有方法的修饰统一，故可省略
	void land();
}
```

尤其不能定义构造器，意味着接口不能实例化-无构造器，不像抽象类构造器还留着。

接口的使用只能依赖类对它的实现。实现用implements关键字，分两种情况：

- 子类不完全重写接口的方法，成为抽象类。
- 子类重写（官方叫实现）了接口的所有方法，成为非抽象类。

```java
class Plane implements Flyable {

	@Override
	public void fly() {
		System.out.println("正在用机翼飞行");
	}

	@Override
	public void land() {
		System.out.println("轮胎伸出，正在降落");
	}

	@Override
	public void launch() {
		System.out.println("发动机启动，正在起飞");
	}

}

abstract class Kite implements Flyable {
	@Override
	public void fly() {
		System.out.println("正在用纸糊翅膀飞行");
	}
}
```

看个多实现的例子：

```java
class Bullet implements Flyable, Attackable {...}
```

继承与实现的联合写法：

```java
class A extends B implements C, D {...}
```

接口之间允许多继承，那么各被继承接口的所有虚方法都会被继承，且也不能由继承接口重写，只能留实现类重写或继续被继承。

```java
interface A extends B, C {...}
```

接口的使用体现并依赖多态性，即接口变量引用实现自己的对象。

```java
Flyable flyable = new Plane();
flyable.fly();
```

关于规范的概念，比如说Flyable接口就是一套规范，具体包括起飞、飞行和降落，那么某类想要飞行，就得遵循这套飞行规范，即实现飞行接口，具体根据本类自身特点覆盖起飞、飞行和降落方法，这些方法的返回值、参数列表都是规范的体现。一套规范或标准可促成通用性，方便统一化、简洁化开发，统一功能的签名等要素，而不做具体实现。

联系后面要学的，JDBC就是一大套规范-一批接口（大部分），各数据库提供的驱动jar包就是实现类。

接口存在的意义就是被实现，体会面向接口编程。

同样地，接口变量也可引用匿名实现类的对象：

```java
Flyable f = new Flyable() {

    @Override
    public void launch() {
        // TODO Auto-generated method stub

    }

    @Override
    public void land() {
        // TODO Auto-generated method stub

    }

    @Override
    public void fly() {
        // TODO Auto-generated method stub

    }
};
```

来看个阴间的问题：

```java
interface A {
	int x = 0;
}

class B {
	int x = 1;
}

class C extends B implements A {
	public void pX() {
        // 编译不过 The field x is ambiguous 由于多继承（实现）且属性同名，编译器不晓得到底取哪一个，用不了就近原则，它们同级
		System.out.println(x);
        // 于是指定调谁的x 1 附带讲没有这样的写法super.super
        System.out.println(super.x);
        // 0 静态常量
		System.out.println(A.x);
	}
}
```

#### 新特性

JDK 8及以后，新增定义静态方法、默认方法。静态方法只能靠接口调用，默认方法重不重写都行，可供实现类的对象可调用。

```java
interface NewFeature {
	static void mine() {
		System.out.println("接口的静态方法");
	}

    // 默认方法必须有方法体，不然实现类不重写的话执行什么
	default void defaultFun1() {
		System.out.println("接口的默认方法1");
	}

	default void defaultFun2() {
		System.out.println("接口的默认方法2");
	}
}

class NewImpl implements NewFeature {
	@Override
	public void defaultFun1() {
		System.out.println("实现类实现默认方法1");
	}
}

/* 测试 */
NewFeature newFeature = new NewImpl();
NewFeature.mine();
// 实现类实现默认方法1
newFeature.defaultFun1();
// 接口的默认方法2
newFeature.defaultFun2();
```

回顾上一节末的阴间问题，针对方法，某类继承的父类与实现的接口含同签名方法（接口里的方法是默认的），此类又没重写，编译器会优先选择父类的此方法，此之谓类优先原则。

```java
class Father {
	public void defaultFun1() {
		System.out.println("父类的默认方法1");
	}
}

class Son extends Father implements NewFeature {}

/* 测试 */
Son son = new Son();
// 父类的默认方法1
son.defaultFun1();
```

然后我们重写一下，并且想同时调重写的、父类的及接口默认的：

```java
class Son extends Father implements NewFeature {
	@Override
	public void defaultFun1() {
		System.out.println("重写默认方法1");
	}

	public void multiCall() {
        // 重写的默认方法1
		defaultFun1();
        // 父类的默认方法1
		super.defaultFun1();
        // 阴间 接口的默认方法1
		NewFeature.super.defaultFun1();
	}
}

/* 测试 */
Son son = new Son();
// 重写默认方法1
son.defaultFun1();
son.multiCall();
```

如果是某类实现多个接口，这些接口含同签名默认方法，又没重写，那么编译器就会晕，不知道到底选哪一个，此之谓接口冲突。

我们看默认方法可以有方法体，那么子接口就可以重写父接口的默认方法。但针对多继承，多个父接口含同签名默认方法，我们不能保证实现类一定实现这个方法，所以就不得不稳妥地由子接口重写。

## 内部类

### 概述

实际开发中内部类出现频率较低，源码里倒是不少。

Java中允许在一个类体内定义另一个类，前者叫外部类，后者叫内部类，两者的名字不能相同。

内部类分为：

- 成员内部类：类体在方法之外。
  - 实例内部类：没有被static修饰。
  - 静态内部类：被static修饰。

- 局部内部类：类体在方法体内、代码块内或者作方法参数，往往这个类的实例作局部变量，不然无用武之地。
  - 匿名内部类：没有类名。


内部类经编译后也会生成字节码文件，成员内部类的形如`外部类$内部类.class`，局部内部类的形如`外部类$数字内部类.class`（数字表示同名局部内部类的编号）。

内部类的加载以外部类的加载为前提，且内部类是延时加载的，即不随着外部类加载而加载，等到使用时才加载。

### 成员内部类

除了类本来的特征外，还可以使用外部类的成员，可以被诸修饰符修饰。

举例说明内部类的使用：

```java
class Individual {
	private String name;
	private int age;
	private static final String ID = "110";
    
    public void useInner() {
        // 在外部类体内实例化实例内部类就不用显式借助外部类实例
        System.out.println(new Pet().name);
        System.out.println(Pet.ID);
        System.out.println(School.AGE);
	}
    
    public static void staticUseInner() {
        // 外部类静态方法使用实例内部类的静态域
		System.out.println(Pet.ID);
        // 这就报错了，可能外部类还没实例化
		// System.out.println(new Pet().name);
	}

    // 实例内部类，设为私有外部就不可见了
	class Pet {
		private String name;
		private int age;
        static final String ID = "000";

		public Pet(String name, int age) {
			super();
			this.name = name;
			this.age = age;
		}

		public void showName(String name) {
            // 形参
			System.out.println(name);
            // 内部类实例域
			System.out.println(this.name);
            // 外部类实例域
			System.out.println(Individual.this.name);
            // 内部类静态域
            System.out.println(ID);
            // 外部类静态域
			System.out.println(Individual.ID);
		}
	}

    // 静态内部类
	static class School {
		private String name;
        private static final int AGE = 100;

		public School(String name) {
			super();
			this.name = name;
		}
        
		public void showName(String name) {
            System.out.println(new School());
			System.out.println(name);
			System.out.println(this.name);
            // 这就报错了，可能外部类还没实例化
			// System.out.println(Individual.this.name);
			System.out.println(Individual.ID);
			Individual.staticUseInner();
		}
	}
}

/* 测试 */
// 内部类、外部类都没有实例化
System.out.println(Individual.Pet.ID);
// 实例化静态内部类，外部类不用实例化
Individual.School school = new Individual.School("中学");
// 在外部类之外实例化实例内部类，要借助外部类的实例
Individual individual = new Individual();
Pet pet = individual.new Pet("小白", 3);
```

静态内部类的实例化不依赖外部类实例，故只能使用外部类的静态成员，因为外部类可能没实例化，可定义实例、静态方法。

实例内部类的实例化依赖外部类实例，故它可使用外部类的所有成员，而且不允许定义静态方法（代码块）。

关于成员内部接口等变体可参考源码。

### 局部内部类

以实现类的例子说明局部内部类：

```java
interface IRun {
	public void run();
}

// 某类的一个实例方法
public IRun getIRun() {
    // 方法体内定义类并实现IRun接口
    class Car implements IRun {
        @Override
        public void run() {
            System.out.println("the car is running");
        }
    }
    return new Car();
}
```

由于作用域的限制，不同方法体内可定义同名的内部类。

匿名内部类是局部内部类的一个特殊形态。我们等价改写上述代码：

```java
// 返回匿名内部类的匿名对象
public IRun getIRun() {
    return new IRun() { // 匿名内部类实现IRun接口，边实现边实例化
        @Override
        public void run() {
            System.out.println("the car is running");
        }
    };
}
```

关于局部内部类有个规定要理解：

```java
/* Individual的一个方法，其他省略 */
public void display() {
    // 局部变量 JDK 8及以后final可省略
    int num = 1;
    // 局部内部类
    class LocalInner {
        public void fun() {
            // 不可修改
            // num = 2;
            System.out.println(num);
        }
    }
}
```

在外部类的方法体或代码块中有局部变量，那么同在其中的局部内部类可以读这个变量但不能写。前面说了内部类和外部类都有独立的字节码，意即本不能跨作用域读写，不过放宽了一点，可以读，故此变量必由final修饰。

## 异常处理

### 概述

程序执行过程中发生的不正常情况叫异常。

异常分两类：

- Error：JVM都无法解决的严重问题。如JVM系统内部错误（栈溢出、堆溢出等）、资源耗尽。对此一般不用针对性代码处理。
- Exception：因偶然的外在因素产生的一般性问题。如空指针、文件不存在、网络连接中断。对此常用针对性代码处理。

对后者，有两种解决方案：

- 不算解决的方案：遇到错误就终止程序。在实际应用中这对用户很不友好。
- 编程时（运行前事先）考虑错误的检测、错误消息的说明、对错误的处理。

按受检性可分为受检异常与不受检异常：它们都发生在运行时，只不过受检异常能为编译器所感知（如读文件它会感知文件可能不存在），于是编译器会要求我们做好处理，而编译器感知不到不受检异常（如零除），故不会提醒我们做好处理，需要我们自行预估。对应源码，后者为RuntimeException及其子类，其他的都是前者。

### 举例

用一些简单的代码验证常见异常：

```java
@Test
void testNullPointer() {
    int[] arr = null;
    // java.lang.NullPointerException
    System.out.println(arr[1]);
}

@Test
void testIndexOutOfBounds() {
    int[] arr = new int[3];
    // java.lang.ArrayIndexOutOfBounds
    System.out.println(arr[3]);
    String str = "china";
    // java.lang.StringIndexOutOfBounds
    System.out.println(str.charAt(5));
}

@Test
void testClassCast() {
    Object obj = new Date();
    // java.lang.ClassCastException
    String str = (String) obj;
}

@Test
void testNumberFormat() {
    // java.lang.NumberFormat
    int num = Integer.parseInt("a");
}

@Test
void InputMismatch() {
    Scanner scanner = new Scanner(System.in);
    // java.lang.InputMismatch
    int num = scanner.nextInt();
    scanner.close();
}
```

在eclipse中受检异常没处理的话，会在行首报红叉。

### 异常处理机制

#### 概述

早年用if-else语句处理异常，可读性差，尤其当可能造成异常的条件很多。

而Java所采用的异常处理机制，是将处理代码集中起来，与主代码分开，使程序简洁、优雅、易于维护。具体方式有两种：try-catch-finally；throws+异常类型。

此机制又叫抓抛（catch and throw）模型：

- 抛：程序执行过程中，一旦出现异常，就在异常代码处生成一个相应异常类的对象，并将其抛出，后续代码不再执行。
- 抓：选定上述两种方式之一处理异常。

那么具体来看这两种处理方式。

#### try-catch-finally

```java
try {
    int[][] a = new int[3][];
    System.out.println(a[1]);
    int[] arr = new int[3];
    // 这里抛出异常
    System.out.println(arr[3]);
    Object obj = new Date();
    String str = (String) obj;
    System.out.println(str);
} catch (NullPointerException e) {
    System.out.println("空指针！");
} catch (ArrayIndexOutOfBoundsException e) { // 这里抓取异常
    System.out.println("数组下标越界！");
} catch (ClassCastException e) {
    System.out.println("类型转换错误！");
} catch (Exception e) {
	System.out.println("其他幺蛾子");
} finally { // 可选 处理完走这里
    System.out.println("累了，毁灭吧");
}
System.out.println("continue...")
```

一旦在try语句体中某处发生异常，就抛出（这里指产生，注意跟下一节的throws相区分），由下面这么多并列的catch语句之一抓取并处理，处理完走finally，完了继续往后，若finally语句体没有，也是继续往后。

关于多catch语句的上下（先后）顺序，同级的异常类型不讲究顺序，而子父类关系的异常类讲究，子类应在父类前面。如上面的Exception是其上诸类型的父类，就必须在后面。

Java提供了一些展示更详细信息的方法：

```java
catch (Exception e) {
	System.out.println(e.getMessage());
    e.printStackTrace();
}
```

try语句体中的定义的变量也是有作用域的。为了后续使用，我们常常把变量声明在其外。

也可以将多catch语句整合成一个，不过如此诸异常类型就不能存在继承关系。

```java
try {
    int[][] a = new int[3][];
    System.out.println(a[1]);
    int[] arr = new int[3];
    System.out.println(arr[3]);
    Object obj = new Date();
    String str = (String) obj;
    System.out.println(str);
} catch (NullPointerException | ArrayIndexOutOfBoundsException | ClassCastException e) { // 不能有Exception了
    e.printStackTrace();
}
```

上例没能体现finally的功能，它的适用情况是：

- catch语句中仍抛异常且未处理，但我还想往后执行。
- try或catch语句中有返回语句，但我想在返回前做些事。

```java
try {
    int a = 2;
    int b = 0;
    System.out.println(a / b);
} catch (ArithmeticException e) {
    System.out.println("零除");
    int[][] arr = new int[3][];
    System.out.println(arr[1][1]);
} finally {
    System.out.println("我执行哦，catch中又有了空指针异常！");
}
System.out.println("可惜我不执行");
```

```java
public static int useFinally() {
    try {
        int a = 2;
        int b = 0;
        System.out.println(a / b);
        return 1;
    } catch (ArithmeticException e) {
        System.out.println(e.getMessage());
        return 0;
    } finally {
        System.out.println("不管报不报错，返回前都得先从我这过");
        // 更有甚者，抛了异常不从catch返回，从我这里返回
        return 2;
    }
}
```

在开发中数据库连接、输入输出流、网络等资源是不能由JVM自动回收的，只能手动释放，那么finally语句体就是绝佳的释放处，不会受到前面任何异常的干扰。

以上三个语句体都能嵌入try-catch(-finally)。

在实际开发中，针对不受检异常我们一般不处理，转而通过其他手段促进代码的健壮性，最大限度避免不受检异常，而由于编译器的要求，受检异常就不得不处理。

#### throws

```java
public static void main(String[] args) {
    try {
        firstHandle();
    } catch (IOException e) {
        e.printStackTrace();
        System.out.println("我主方法再往上抛这处理就没意义了");
    }
    secondHandle();
}

public static void firstHandle() throws IOException {
    readFile();
}

public static void secondHandle() {
    try {
        readFile();
    } catch (IOException e) {
        System.out.println("我不往上抛了");
    }
}

public static void readFile() throws FileNotFoundException, IOException {
    File file = new File("miyuki.txt");
    FileInputStream fis = new FileInputStream(file);
    int data = fis.read();
    while (data != -1) {
        System.out.println((char) data);
        data = fis.read();
    }
    fis.close();
}
```

throws写在方法定义处方法名后面，本方法体内一旦出现异常，就生成一个相应异常类对象，然后向上抛给调用本方法的方法，由它处理，自己不处理，异常处后续代码不再执行。

[前面](#exception)提到过，子类想重写父类方法，要满足的条件之一是抛出异常的类型不高于父类的，找个例子体会一下：

```java
class Father {
	public void fun1() {
		try {
            // 这里实际调用的是子类的fun2，倘若子类所抛的类型高于父类抛的，这里就处理不了
			fun2();
		} catch (Exception e) { // 只能处理父类fun2所抛异常类型及其以下的
			e.printStackTrace();
		}
	}

	public void fun2() throws Exception { // 抛IOException也不行啊

	}
}

class Son extends Father {
	@Override
	public void fun2() throws ArithmeticException {
		int a = 1;
		int b = 0;
		System.out.println(a / b);
	}
}
```

严格来讲，不高于还不够，同级互斥的也不行。

如果父类方法没有向上抛异常，那么子类重写时也不能向上抛，要自行处理。

### 手动抛异常

此前接触的异常对象都是系统生成的，我们还可以自指定抛出（throw，注意跟throws不同，这里的含义是产生）条件，使用throw关键字手动抛出异常对象。

先看下第一层：

```java
class Student {
	private String name;
	private int age;

	public void register(String name, int age) { // 这里写上throws的话就好对比了，一个是产生，一个是真抛
		this.name = name;
		if (age < 0 || age > 100) {
            // Exception是受检异常，如果用它的话就必须往上抛，然后调用处就必须写处理了
			throw new RuntimeException("您的年纪太离谱");
		} else {
			this.age = age;
		}
	}

	@Override
	public String toString() {
		return "Student [name=" + name + ", age=" + age + "]";
	}
}

// 测试 对非受检异常可以不写处理
Student student = new Student();
student.register("li", 109);
```

### 自定义异常

自定义的异常分三步：

1. 融入现有的异常体系，要么继承RuntimeException成非受检异常要么继承Exception成受检异常。
2. 提供静态常量serialVersionUID（类标识，后面学IO时再解释）。
3. 一般提供重载的构造器。

```java
class MyException extends Exception {
	static final long serialVersionUID = -7034897190745766939L;

	public MyException() {

	}

	public MyException(String message) {
		super(message);
	}
}

class Person {
	private String name;
	private int age;

	public void register(String name, int age) throws MyException {
		this.name = name;
		if (age < 0 || age > 100) {
            // 也可以不往上抛，就在这里try-catch
			throw new MyException("您的年纪太离谱");
		} else {
			this.age = age;
		}
	}

	@Override
	public String toString() {
		return "Student [name=" + name + ", age=" + age + "]";
	}
}
```

## IDEA

插入章，记一些IDEA相关内容。

在工程结构上，idea里的project相当于eclipse里的workspace；idea里的module相当于eclipse里的project。

## 多线程

### 概述

程序、进程与线程：

- 程序（program）是为完成特定任务、用特定语言编写的一组指令集合，是一段静态代码。

- 进程（process）是正在运行的程序，是一个动态的过程。既然是过程，那么就有从产生到存在再到消亡的具体阶段，即生命周期。作为资源分配的单位，每个进程被OS分配以不同的内存区域。

- 进程进一步细化为线程，线程是进程内部的一条执行路径。若一个进程中多个线程并行，则它是支持多线程的。作为调度和执行的单位，每个线程拥有独立的运行栈和程序计数器（pc），其切换开销小。一个进程下辖的多个线程共享内存空间，如访问堆中同一个对象、栈中同一个变量，这使得线程间的通信更简便高效，但又带来一定安全隐患。

CPU的单核与多核：

- 单核：单核CPU对应一种假的多线程，因为它在一个时间单元内只能执行一个线程，不过又因为一个时间单元特别短，所以切换执行感觉不出来，造成了同时执行多个线程的假象。
- 多核：多核CPU才能真正发挥多线程的高效。现在的服务器都是多核的。

并行与并发：

- 并行：多个CPU同时执行多个任务，各干各的，多核多线程。
- 并发：一个CPU采用时间片轮转“同时”执行多个任务，同理是假的多任务，单核多线程。

多线程的意义：从上面得知单核多线程（伪多线程）其实比单线程是要慢的，因为线程的切换需要开销，而多核多线程就比单线程要快。那么即使单核多线程更慢，有时候也是必要的（如增强用户体验），且当前单核CPU的主频也是足够高，开销可忽略。

某些程序执行起来时需要分为多个任务的，像需要等待的任务（用户输入、文件读写、网络请求等）、在后台执行的任务等。我们Java应用程序java.exe就至少有三个线程：main()主线程、gc()垃圾回收线程与异常处理线程。

### 创建

#### 继承Thread类

##### 基本使用

上例子：

```java
public class InheritThread {
    public static void main(String[] args) {
        MyThread myThread = new MyThread();
        myThread.start();
        for (int i = 0; i < 10; i++) {
            System.out.println("主线程打印：" + i);
        }
    }
}

class MyThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            System.out.println("自定线程打印：" + i);
        }
    }
}

// 测试 输出
主线程打印：0
主线程打印：1
主线程打印：2
主线程打印：3
自定线程打印：0
自定线程打印：1
自定线程打印：2
主线程打印：4
自定线程打印：3
主线程打印：5
主线程打印：6
主线程打印：7
自定线程打印：4
主线程打印：8
自定线程打印：5
自定线程打印：6
自定线程打印：7
自定线程打印：8
自定线程打印：9
主线程打印：9
```

我们的线程类继承Thread类，所执行的代码在run方法体内，在主方法体内通过start方法创建并启动自己的线程。由输出结果便可看出主方法对应的主线程和run方法对应的自定线程同时进行。

start方法的作用：

> Causes this thread to begin execution; the Java Virtual Machine calls the run method of this thread.

即启动当前线程及让JVM调用此线程的run方法。

若我们不调start转而去调run则依旧是单线程（仅主线程），那么结果永远是run里面的输出完再输出main里的。

当前线程对象不能重复调用start方法，依旧是一个线程对象唯一对应一条线程。想再新建一个线程就先新建一个对象：

```java
MyThread myAnotherThread = new MyThread();
myAnotherThread.start();
```

但是又发现这俩自定线程干的事完全一样，我们想不一样，那简单地能想到造两个子类，各自重写run方法。

```java
// 简便起见，我们用匿名子类（匿名局部内部类）并匿名对象，开发中经常这样做
public static void main(String[] args) {
    new Thread() {
        @Override
        public void run() {
            for (int i = 0; i < 1000; i++) {
                System.out.println("this is thread1");
            }
        }
    }.start();
    new Thread() {
        @Override
        public void run() {
            for (int i = 0; i < 1000; i++) {
                System.out.println("this is thread2");
            }
        }
    }.start();
}
```

##### 常用方法

Thread类的一些重要方法有：

- start：启动当前线程，调用其run方法。
- run：被重写，将想让此线程执行的操作写在方法体中。
- currentThread：静态方法，返回执行当前代码的线程（对象）。
- getName：获得当前线程的名字。
- setName：设定当前线程的名字。
- yield：释放CPU给予当前线程的执行权，那么释放之后很可能执行权又落到自己头上。
- join：在线程a中调用线程b的join方法，使得a阻塞，先等b执行完再结束a的阻塞状态（结束并不意味着立即执行，而是进入就绪状态，等CPU分配资源）。
- stop：强制结束当前线程，已过时，不推荐使用。
- sleep：静态方法，传入毫秒数，让当前线程睡眠（阻塞）一定时间。
- isAlive：判断某线程是否存活（未结束生命周期）。

```java
public class CommonMethods {
    public static void main(String[] args) {
        UseMethods useMethods = new UseMethods();
        useMethods.start();
        for (int i = 0; i < 100; i++) {
            // 主线程默认名字就是main
            System.out.println(Thread.currentThread().getName() + ", print " + i);
        }
    }
}

class UseMethods extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            // 分线程默认名字是Thread-x，x从0开始，可自行查源码
            System.out.println(Thread.currentThread().getName() + ", print " + i);
            // Thread.currentThread()等价于this
        }
    }
}
```

```java
// 设名字要在调用start即线程启动之前
useMethods.setName("分线程 1");
useMethods.start();

/* 也可利用构造器设名字 */
// 构造器
public UseMethods(String name) {
    super(name);
}
// 测试
UseMethods useMethods = new UseMethods("分线程 1");
```

```java
for (int i = 0; i < 100; i++) {
    System.out.println(Thread.currentThread().getName() + ", print " + i);
    if (i == 20) {
        try {
            // 在主线程中调用分线程的join方法，让主线程阻塞
            useMethods.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

```java
@Override
public void run() {
    for (int i = 0; i < 100; i++) {
        // 回顾重写规则，父类run方法没往外抛，这里也不能抛
        try {
            sleep(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(this.getName() + ", print " + i);
    }
```

```java
// 测试 最后一条语句 false
System.out.println(useMethods.isAlive());
```

##### 优先级

线程优先级的背景知识是线程的调度，单核CPU的调度策略有两种：

- 时间片：CPU执行一段时间这个线程，接着执行一段时间另一个线程，如此往复。
- 抢占式：高优先级的线程一定概率下抢占低优先级线程的执行权。

同优先级的线程进入先进先出的队列，CPU使用时间片策略执行。

线程优先级等级（Thread类中的三个int型静态常量）：

- 值为10的MAX_PRIORITY。
- 值为1的MIN_PRIORITY。
- 值为5的NORM_PRIOTITY。

设置、获取优先级的方法分别是setPriority（传入1到10之间的int值）、getPriority。

注意高优先级线程抢占执行权（或时间片）是有一定概率的，所以低优先级线程不一定在高优先级线程执行完才执行。

```java
// 同样应在启动前设定优先级
useMethods.setPriority(Thread.MAX_PRIORITY);
useMethods.start();
```

#### 实现Runnable接口

第二种创建方式的步骤：

1. 创建一个实现Runnable接口的类。
2. 实现此接口的run方法。
3. 实例化此类对象。
4. 将此类对象作为Thread构造器的实参。
5. 实例化Thread对象，调用start方法。

```java
public class ImplementsRunnable {
    public static void main(String[] args) {
        YourThread yourThread = new YourThread();
        // 多态，形参类型是Runnable
        Thread thread = new Thread(yourThread);
        // 从start的调用者看出线程（对象）是thread而非yourThread
        thread.start();
    }
}

class YourThread implements Runnable {
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            System.out.println(i);
        }
    }
}
```

前面说过start方法作用是启动线程及调用当前线程对象thread的run方法，结果怎么调的是yourThread的run方法呢？自行查源码可知：

```java
@Override
public void run() {
    if (target != null) {
        target.run();
    }
}
```

调用thread对象的run方法，等价于实例域target非空的话就调它的run方法，然后我们又发现这个target由构造器初始化了，被赋的值就是传进来的yourThread对象。

一个线程对象唯一对应一条线程，想再搞一个线程的话就再实例化一个Thread对象，不过需要的话可以照旧传入yourThread对象。

```java
new Thread(yourThread).start();
```

#### 注

比较这两种创建方式。由于单继承的局限性，开发中我们优先选择第二种方式，另外方式二天然地体现数据共享性-把一个同一个对象传入多个Thread构造器，也就是把同一份数据提供给多条线程。它们有共通性，一来Thread类也实现了Runnable接口，二来都存在对run方法的覆盖。

### 生命周期

Java用Thread类的实例或其子类的实例表征线程，用成员内部类（枚举）Thread.State表征线程的几种状态。

我们用五个基本状态描述一个线程的完整生命周期：

- 创建：一个线程对象刚被声明出来。
- 就绪：调用此对象的start方法之后，线程进入线程队列等待CPU时间片，它已具备运行条件但没分配到CPU资源。
- 运行：一旦就绪进程被调度并分配资源，就开始运行，体现于run方法所做的操作。
- 阻塞：运行时遇到特殊情况，或主动或被迫地让CPU临时中断线程的运行。
- 死亡：要么顺利完成任务后正常死亡，要么未完成任务因被强制终止或出现异常而非正常死亡。

![线程生命周期](java.assets/线程生命周期.png)

围绕这个图我们要掌握状态和一些方法，后面几节会详细讲。

### 安全与同步

#### 概述

多个线程共同操作同一数据，可能破坏操作的完整性，破坏数据，此即线程的安全问题。

```java
// 共享数据
money = 2000;

// 操作此数据的代码
if (money > 0) {
    money -= 2000;
}
```

现在有两条线程A和B来执行这段代码，A刚到第6行突然阻塞了，记住读到的money值是2000大于0，然后B顺利执行完，money已经变成了0，接着A继续执行第6行，结果money变成了-2000，这就离谱了。

之所以有线程安全问题，就是因为数据共享，包括共写甚至共读，数据不共享就不存在安全问题。

那么容易想到的一个解决方法是让某个线程执行这段代码的时候，无论发生什么，其他线程都不能来执行。对此Java提供同步机制，具体来说最早的方案是同步代码块与同步方法。

#### 同步代码块

前者的形式是：

```java
synchronized (同步监视器) {
    // 需要被同步的代码，即读写共享数据的代码，即同时刻仅允许一个线程执行的代码（本时段内单线程）
}
```

同步监视器俗称锁，即对同步代码的执行权。任何对象（非null）都能充当锁，但要求多线程使用同一把锁，不然同步代码块失效。

对两种方式添加同步代码块：

```java
/* 同步代码块配合方式二 */
public class CodeBlockImplements {
    public static void main(String[] args) {
        Window window = new Window();
        Thread thread1 = new Thread(window);
        Thread thread2 = new Thread(window);
        Thread thread3 = new Thread(window);
        thread1.start();
        thread2.start();
        thread3.start();
    }
}

class Window implements Runnable {
    private static int ticket = 100;
    // private Object object = new Object();

    @Override
    public void run() {
        while (true) {
            // 用this最方便，这里this就是调用run的对象实体window
            synchronized (this) {
                if (ticket > 0) {
                    System.out.println(Thread.currentThread().getName() + "卖出票号为：" + ticket);
                    ticket--;
                } else {
                    break;
                }
            }
        }
    }
}
```

```java
/* 同步代码块配合方式一 */
public class CodeBlockExtends {
    public static void main(String[] args) {
        App app1 = new App();
        App app2 = new App();
        App app3 = new App();
        app1.start();
        app2.start();
        app3.start();
    }
}

class App extends Thread {
    private static int ticket = 100;
    private static Object object = new Object();

    @Override
    public void run() {
        while (true) {
            // 这里就不能用this了，三个对象不相同 可以用反射-App.class-一个唯一（App类仅加载一次）的Class对象
            synchronized (object) {
                if (ticket > 0) {
                    System.out.println(Thread.currentThread().getName() + "卖出票号为：" + ticket);
                    ticket--;
                } else {
                    break;
                }
            }
        }
    }
}
```

同步代码块所含代码要恰如其分，缺了该被同步的就达不到同步效果，多出不该被同步的就降低了效率或不满足要求。

#### 同步方法

如果该被同步的代码完整地形成方法体，那么不妨定义一个同步方法。

```java
/* 同步方法配合方式二 */
public class MethodImplements {
    public static void main(String[] args) {
        TicketCounter ticketCounter = new TicketCounter();
        Thread thread1 = new Thread(ticketCounter, "售票窗1");
        Thread thread2 = new Thread(ticketCounter, "售票窗2");
        Thread thread3 = new Thread(ticketCounter, "售票窗3");
        thread1.start();
        thread2.start();
        thread3.start();
    }
}

class TicketCounter implements Runnable {
    private int ticket = 100;

    // 隐式的同步监视器，即this
    public synchronized boolean book() {
        if (ticket > 0) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + "售出票号：" + ticket);
            ticket--;
            return true;
        } else {
            return false;
        }
    }

    @Override
    public void run() {
        while (true) {
            if (!book()) {
                break;
            }
        }
    }
}
```

上一节提到了同步代码块配合继承方式，this引用不同（线程）对象，故同步监视器就不能是this。同理同步方法配合继承方式，要慎重判断this能不能作隐式的同步监视器，不能的话就该把方法设成静态的，使得隐式锁为同在上节提到的Class对象TicketPoint.class。

```java
/* 同步方法配合方式一 */
public class MethodExtends {
    public static void main(String[] args) {
        TicketPoint ticketPoint1 = new TicketPoint("售票点1");
        TicketPoint ticketPoint2 = new TicketPoint("售票点2");
        TicketPoint ticketPoint3 = new TicketPoint("售票点3");
        ticketPoint1.start();
        ticketPoint2.start();
        ticketPoint3.start();
    }
}

class TicketPoint extends Thread {
    private static int ticket = 100;

    public TicketPoint(String name) {
        super(name);
    }

    @Override
    public void run() {
        while (true) {
            if (!book()) {
                break;
            }
        }
    }
	
    // 静态方法 隐式同步锁为TicketPoint.class
    public static synchronized boolean book() {
        if (ticket > 0) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + "售出票号：" + ticket);
            ticket--;
            return true;
        } else {
            return false;
        }
    }
}
```

综上可知同步方法仍然依赖同步监视器，只不过无需显式声明，实例方法的锁是this，静态方法的锁是当前类对应的Class对象。静态方法的锁一定是通用的，不会出问题，而想不设静态就要仔细观察this指向是否统一。

附带看一个懒汉式单例模式双重检查的写法：

```java
public static Instance getInstance () {
    // 提高单例生成后多线程执行的效率，判断非null就走了，减少等待时间
    if (instance == null) {
        synchronized (Instance.class) {
            if (instance == null) {
                instance = new Instance();
            }
        }
    }
    return instance;
}
```

#### 死锁

概念：不同线程占用对方需要的同步资源不放弃，都在等待对方放弃自己需要的同步资源，形成了线程的死锁。

出现死锁后，不报异常、不出提示，所有相关线程处于阻塞状态。

联系生活实际，比如情侣都占用对方所需的表白但自己都不向对方表白，又比如上帝去地狱饿鬼都拿着对面的人所需的长筷子但都不给对面的人舀菜。

来看一个可能发生死锁的例子：

```java
public class Problem {
    public static void main(String[] args) {
        StringBuffer s1 = new StringBuffer();
        StringBuffer s2 = new StringBuffer();
        new Thread() {
            @Override
            public void run() {
                synchronized (s1) {
                    s1.append("1");
                    s2.append("a");
                    synchronized (s2) {
                        s1.append("2");
                        s2.append("b");
                        System.out.println(s1);
                        System.out.println(s2);
                    } // 这个花括号执行完锁s2才会释放
                } // 这个花括号执行完锁s1才会释放
            }
        }.start();
        new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (s2) {
                    s1.append("3");
                    s2.append("c");
                    synchronized (s1) {
                        s1.append("4");
                        s2.append("d");
                        System.out.println(s1);
                        System.out.println(s2);
                    } // 这个花括号执行完锁s1才会释放
                } // 这个花括号执行完锁s2才会释放
            }
        }).start();
    }
}
```

一个死锁的场景有：线程1走完第10行，s1未释放，等待s2以往下走，与此同时线程二走完第25行，s2未释放，等待s1以往下走，如此它俩就互相卡着对方所需锁，一直僵持都不往下走。

不过这个例子死锁的概率很小，因为CPU运行得太快，总有某个线程先完全跑完run方法，释放s1与s2，另一个线程就顺利拿到两把锁。我们通过强制挂起让死锁的概率增高：

```java
public class DeadLock {
    public static void main(String[] args) {
        StringBuffer s1 = new StringBuffer();
        StringBuffer s2 = new StringBuffer();
        new Thread() {
            @Override
            public void run() {
                synchronized (s1) {
                    s1.append("1");
                    s2.append("a");
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    // 苏醒后握着锁s1，等待锁s2
                    synchronized (s2) {
                        s1.append("2");
                        s2.append("b");
                        System.out.println(s1);
                        System.out.println(s2);
                    }
                }
            }
        }.start();
        new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (s2) {
                    s1.append("3");
                    s2.append("c");
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    // 苏醒后握着锁s2，等待锁s1
                    synchronized (s1) {
                        s1.append("4");
                        s2.append("d");
                        System.out.println(s1);
                        System.out.println(s2);
                    }
                }
            }
        }).start();
    }
}
```

解决方法：

- 改进算法。
- 减少同步的使用。
- 避免同步的嵌套。

有时候死锁不像上例那么容易发现，在开发中即使概率低我们也要避免死锁的发生。

#### Lock

Lock接口是JDK 5.0及以上版本提供的新的更强大的线程同步机制-通过显式定义同步锁对象来实现同步，专门的同步锁接口叫Lock。

java.util.concurrent.locks.Lock通过显式加锁和解锁，控制多个线程对共享资源的读写。常用的实现类是ReentrantLock，它与synchronized作用相同。

```java
public class Lock {
    public static void main(String[] args) {
        TrainTicket trainTicket = new TrainTicket();
        Thread thread1 = new Thread(trainTicket, "窗口A");
        Thread thread2 = new Thread(trainTicket, "窗口B");
        Thread thread3 = new Thread(trainTicket, "窗口C");
        thread1.start();
        thread2.start();
        thread3.start();
    }
}

class TrainTicket implements Runnable {
    private int ticket = 100;
	// 同样地，对同一段同步代码要保证锁对象唯一，若采用继承方式创建线程则应将此域设为静态的
    private ReentrantLock lock = new ReentrantLock();

    @Override
    public void run() {
        while (true) {
            // 加锁
            lock.lock();
            if (ticket > 0) {
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + "卖出票号 " + ticket);
                ticket--;
            } else {
                break;
            }
            // 解锁
            lock.unlock();
        }
    }
}
```

Lock接口与synchronized关键字都能实现线程同步，解决线程安全问题，都有同步监视器或锁的概念。不同之处在于前者要求手动加锁及解锁，而后者是自动根据花括号加、解锁。

使用Lock的话JVM调度线程所花的开销更少，性能更好，并且Lock可以有多个实现类，扩展性更好。所以在开发中想实现同步，优先使用Lock方式，其次是同步代码块，最后考虑同步方法。

### 通信

这个名字不好，应该叫线程的交替，多个线程交替做某件事，比如规律性地交替打印1-100。落实到Java理解线程通信就是了解熟悉方法的使用。

```java
public class Communication {
    public static void main(String[] args) {
        Number number = new Number();
        Thread thread1 = new Thread(number, "一号选手");
        Thread thread2 = new Thread(number, "二号选手");
        thread1.start();
        thread2.start();
    }
}

class Number implements Runnable {
    private int number = 0;

    @Override
    public void run() {
        while (true) {
            synchronized (this) {
                // 唤醒另一个线程
                notify();
                if (number < 100) {
                    number++;
                    System.out.println(Thread.currentThread().getName() + "打印" + number);
                    try {
                        // 当前同步执行的线程阻塞，且释放同步监视器
                        wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } else {
                    break;
                }
            }
        }
    }
}
```

描述一下交替过程：现有两个线程A和B，A进入同步代码块，握着锁，打印1，当执行到wait方法，阻塞并释放锁给B，于是B得以进入同步代码块，当执行到notify方法，唤醒阻塞着的A，但锁还在自己这，打印2，当执行到wait方法，阻塞并释放锁给A，于是A再进入同步代码块，执行到notify唤醒B，锁也还是自己拿着，打印3，执行到wait方法阻塞并释放锁给B，如此往复。

由此理解三个方法的作用：

- wait：让当前同步执行的线程阻塞并释放同步监视器。
- notify：唤醒一个正被wait阻塞的线程，有多个阻塞线程的话唤醒优先级较高的，同优先级的话随机唤醒。
- notifyAll：唤醒所有被wait阻塞的线程。

关于这三个方法有一些注意点：

- 只能出现在同步代码块或同步方法中。
- 它们都是java.lang.Object的实例方法。
- 它们的调用者必须是同步监视器，否则会报java.lang.IllegalMonitorStateException。特别地，同步监视器即调用者由this充当时，调用处this就可省略，这也证明它们是从Object类那里继承得来的。

顺带比较wait和sleep的异同：相同点就一个-让进程由运行状态变成阻塞状态。不同点就多了，定义位置不同-sleep是Thread类的静态方法，wait是Object类的实例方法；调用位置不同-sleep哪里都能调，wait只能在同步代码块或同步方法里调；对锁的控制不同：执行sleep时不会释放同步监视器，执行wait时会释放。

### Callable

5.0及以上版本又提供另外一些线程创建方式，这里谈一下实现java.util.concurrent.Callable接口。与Runnable相比，Callable的功能更强大，体现于被重写的call方法：

- 提供返回值。
- 抛异常。
- 返回值可带泛型。

Callable的使用要辅以FutureTask类。

```java
public class ImplementsCallable {
    public static void main(String[] args) {
        NumberThread numberThread = new NumberThread();
        // 传入Callable对象
        FutureTask futureTask = new FutureTask(numberThread);
        // 仍要用到Thread FutureTask也实现了Runnable接口，故可作Thread构造器的参数
        Thread thread = new Thread(futureTask);
        thread.start();
        // 无需返回值的话就不用调get方法
        try {
            // get的返回值就是Callabel实现类重写的call方法的返回值
            Object sum = futureTask.get();
            // 无拆箱，调Integer对象的toString方法，打印包装的int值
            System.out.println("总和为：" + sum);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
}

class NumberThread implements Callable {

    @Override
    public Object call() throws Exception {
        int sum = 0;
        for (int i = 0; i <= 100; i++) {
            System.out.println(Thread.currentThread().getName() + "打印" + i);
            sum += i;
        }
        // 自动装箱+向上转型：int->Integer->Object
        return sum;
    }
}
```

### 线程池

经常创建、销毁线程这类的资源，对性能影响很大。

我们可以提前创建好多个线程，置于线程池中，使用时直接去拿，用完再放回线程池，就可以避免频繁创建销毁，实现重复利用。线程池提高运行效率（节省时间），降低资源消耗（节省空间），还可以管理线程，故在开发中用得最多的就是线程池。

5.0及以上版本提供的相关API为ExecutorService与Executors，均在java.util.concurrent下。

ExecutorService是线程池接口，常见实现类是ThreadPoolExecutor，含一些重要方法：

- execute：执行任务，无返回值，一般用于执行实现Runnable而产生的线程。
- submit：执行任务，有返回值，一般用于执行实现Callable而产生的的线程。
- shutdown：关闭线程池。

Executors是一个产生线程池的工厂类，含一些重要静态方法：

- newCachedThreadPool：返回一个可不断创建线程的线程池。
- newFixedThreadPool：返回一个线程数额定的线程池。
- newSingleThreadExecutor：返回一个单线程线程池。
- newScheduledThreadPool：返回一个可定时执行任务的线程池。

```java
public class ThreadPool {
    public static void main(String[] args) {
        // 此静态方法的返回值类型是ExecutorService接口，实际返回的是其实现类的对象，向上转型
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        // 传入Runnable或Callable对象，以执行其重写的run或call方法并生成线程
        executorService.execute(new UseRunnable());
        // 传入Callable对象，返回类型为Future接口，强转为实现类，拿call返回值的代码这里就不例举了
        FutureTask futureTask = (FutureTask) executorService.submit(new UseCallable());
        // 关闭线程池 一般不关闭
        executorService.shutdown();
    }
}

class UseRunnable implements Runnable {
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            if (i % 2 == 0) {
                System.out.println(Thread.currentThread().getName() + "打印" + i);
            }
        }
    }
}

class UseCallable implements Callable<Integer> {
    @Override
    public Integer call() throws Exception {
        int sum = 0;
        for (int i = 0; i < 100; i++) {
            if (i % 2 == 1) {
                System.out.println(Thread.currentThread().getName() + "打印" + i);
                sum += i;
            }
        }
        return sum;
    }
}
```

前面谈到线程池能对线程进行管理，即设置线程池的相关域，具体是通过线程池接口的实现类进行的：

```java
// 直接强转
ThreadPoolExecutor threadPoolExecutor = (ThreadPoolExecutor) Executors.newFixedThreadPool(10);
// 设定属性
threadPoolExecutor.setCorePoolSize(15);
threadPoolExecutor.setMaximumPoolSize(30);
```

### 注

补充经典的生产者-消费者问题：调度员（Commander）通知生产者（Producer）生产产品，通知消费者（Customer）消费产品，调度员持有固定限额的产品（如20），若生产者试图生产更多的产品，则店员会叫生产者暂停生产，等产品数低于限额再通知生产者继续生产；若当前没有产品，则调度员会通知消费者暂停消费，等有产品了再通知消费者继续消费。

```java
public class ProducerAndCustomer {
    public static void main(String[] args) {
        Commander commander = new Commander();
        Producer producer = new Producer(commander);
        Customer customer1 = new Customer(commander);
        Customer customer2 = new Customer(commander);
        producer.setName("生产者");
        customer1.setName("消费者1");
        customer2.setName("消费者2");
        // 一个生产者
        producer.start();
        // 两个消费者
        customer1.start();
        customer2.start();
    }
}

class Product {
    private String name = "红楼梦";
}

class Commander {
    private Product[] products = new Product[20];
    private static final int MAX_NUM = 20;
    private int count;

    public synchronized void commandProduct(Producer producer) {
        if (count < MAX_NUM) {
            // 消费线程唤醒生产线程
            notify();
            products[count] = producer.produce();
            System.out.println(Thread.currentThread().getName() + "可以生产第" + (count + 1) + "个产品");
            count++;
        } else {
            // 叫停生产线程，释放锁给消费线程
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized Product commandPurchase() {
        if (count > 0) {
            // 生产线程唤醒消费线程
            notify();
            System.out.println(Thread.currentThread().getName() + "可以消费第" + count + "个产品");
            count--;
            return products[count];
        } else {
            // 叫停消费线程，释放锁给生产线程
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return null;
        }
    }
}

class Producer extends Thread {
    private Commander commander;

    public Producer(Commander commander) {
        this.commander = commander;
    }

    public Product produce() {
        Product product = new Product();
        return product;
    }

    @Override
    public void run() {
        // 一直生产，直到被调度员叫停
        while (true) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            // 锁控制着这个方法
            commander.commandProduct(this);
        }
    }
}

class Customer extends Thread {
    private Commander commander;
    private Product product;

    public Customer(Commander commander) {
        this.commander = commander;
    }

    @Override
    public void run() {
        // 一直消费，直到被调度员叫停
        while (true) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            // 同一把锁也控制着这个方法
            product = commander.commandPurchase();
        }
    }
}
```

这个例子太精彩了。这里我们让生产者生产得慢一些，消费者消费得快一些，且有两个消费者，那么生产者一生产出一个就被两个消费者抢。注意sleep方法的调用位置，不用它的话极大概率是生产者一次性完成20个产品，因为高主频执行while循环的时候即使放了锁消费线程也难以夺过来。

然后梳理一下会释放锁和不释放锁的操作：

- 释放锁：同步代码块、同步方法执行完毕，包括break、return等起作用；同步代码块、同步方法执行时遇到异常，线程直接死亡；wait方法被执行。
- 不释放锁：sleep、yield、suspend方法被执行。附带讲suspend、resume不建议使用。

## 常用类

### 字符串相关

#### String

String即字符串，所有字符串字面值都是String类的实例。

查源码可知String是一个final类，即不可被继承。它实现了Serializable接口和Comparable接口。它通过其对象的一个final、char数组类型的实例域表征字符序列。

字符串对象不可变，即运行起来对象实体的状态不可更改亦即字符内容丝毫不可更改。但String类型的变量可引用不同地址。

```java
String str1 = "123";
// 引用不同对象实体 对象实体不可变
str1 = "456";
String str2 = "456";
System.out.println(str1);
// 认识常量池
System.out.println(str1 == str2);
```

以上段代码为例，认识字符串常量池。在字符串常量池中不允许出现相同内容的两个对象实体（字符数组）。

<img src="java.assets/字符串常量池.png" alt="字符串常量池"  />

现存的字符串实体都是不可变的，像拼接等操作得到的新字符串都是新的对象实体。

```java
System.out.println(str1.hashCode());
str1 += "abc";
// 引用新的地址
System.out.println(str1.hashCode());
// 没有引用新地址，内容也没变，替换后的内容给了str3引用的对象实体
String str3 = str1.replace('a', 'e');
System.out.println(str1.hashCode());
```

通过下面一些其他实例化方式，进一步了解字符串的内存情况。

```java
String str = "hello";
// 底层this.value = new char[0];
String s1 = new String();
// 底层this.value = str.value;
String s2 = new String(str);
// 底层this.value = Arrays.copyOf(chs, chs.length); copyOf底层又返回Object数组然后强转为字符数组置于常量池
char[] chs = new char[]{'1', '2', '3'} // 右侧字符数组在堆里
String s3 = new String(chs);
// 截取 从下标1开始取1个
String s4 = new String(new char[]{'a', 'b', 'c'}, 1, 1);
```

字符串字面量存储在字符串常量池，而非字面量对象（new出来的）存储在堆中。

![非字面量对象](java.assets/非字面量对象.png)

由上图可知`str == s2`的结果是false。

关于拼接运算。只有当`+`两侧都是字符串常量（包括字面量与声明常量）时才先去检索常量池，有匹配对象的话取其地址，否则去堆里开辟对象空间，让value引用字符串对象的地址；只要有非常量就直接去堆里开辟新空间。

```java
String first = "余";
String last = "华";
String name = "余华";
String name1 = "余" + "华";
// 以下都涉及非常量
String name2 = first + "华";
String name3 = "余" + last;
String name4 = first + last;
```

![拼接与内存](java.assets/拼接与内存.png)

可看出name1、name2、name3、name4所存地址值两两不相同。我们可以通过实例调intern方法得到value属性所存地址值，如：

```java
// name5就存了常量池里的地址值c
String name5 = name2.intern();
// true
System.out.println(name == name5);
```

声明常量就是带final的变量：

```java
final String firstF = "余";
// name6存的地址值是c
String name6 = firstF + "华";
```

注：JVM规范随JDK版本变化而更新，且落地的JVM也不唯一，如Sun自己的HotSpot（最流行，本地装的就是它）、IBM的J9 VM等，且这些JVM也都有各自的更新。从规范上讲，堆分为三个区-新生区、养老区及永久区，这个永久区就是方法区，但从实践上看，永久区（方法区）就不属于堆了。1.7版本以前，字符串常量池在方法区中；1.7及以上版本，它归入堆。

关于常用方法，请参考[菜鸟教程 String 方法](https://www.runoob.com/java/java-string.html)，再次强调字符串对象的不可变性，不管调什么方法原对象都不改变。

String类型与char型数组、byte型数组之间的转换：

```java
@Test
public void convert() throws UnsupportedEncodingException {
    char[] chars = "hello".toCharArray();
    String fromChars = new String(chars);
    // 编码-将看得懂的字符译为看不懂的二进制数 默认编码方式为IDE所统一的UTF-8
    byte[] bytes1 = "love中国".getBytes();
    byte[] bytes2 = "love中国".getBytes("gbk");
    /* 解码：将看不懂的二进制数译为看得懂的字符 */ 
    // [108, 111, 118, 101, -28, -72, -83, -27, -101, -67] 按UTF-8，一个字符对应3个字节 这里是逐字节打印的
    System.out.println(Arrays.toString(bytes1));
    // [108, 111, 118, 101, -42, -48, -71, -6] 按GBK，一个字符对应2个字节
    System.out.println(Arrays.toString(bytes2));
    // 编码解码方式不统一的话解码时就会出现乱码
    String fromBytes = new String(bytes2, "GBK");
    System.out.println(fromBytes);
}
```

#### 可变字符串

即StringBuffer与StringBuilder，比较一下：

- String：不可变字符序列，底层由final的char型数组支持。
- StringBuffer：可变字符序列，底层由非final的char型数组支持。线程安全，效率较低。
- StringBuilder：可变字符序列，底层由非final的char型数组支持。线程不安全，效率较高。5.0版本新增的。

浅析源码：后两者以非final为基础，再由数组元素的增删改实现可变，但不能一直原位修改，加字符加到预估越界的时候，就得（按2x+2）扩容并迁移，实例化时底层字符数组也会按长度16实例化。

开发中若频繁拼接字符串，则最好使用后两者，且熟悉了底层逻辑就得考虑预知大概最多拼接多少个字符，然后使用指定底层数组长度的构造器。

```java
// 预估拼接100个字符
StringBuilder stringBuilder = new StringBuilder(100);
stringBuilder.append("hello");
stringBuilder.append("world");
System.out.println(stringBuilder.toString()); // 可直接打印对象
```

关于常用方法，请参考[StringBuffer 方法](https://www.runoob.com/java/java-stringbuffer.html)。注意有些方法如substring有返回值，不原位修改，不支持可变性。

做大规模字符串拼接，按效率从低到高排：String<<StringBuffer<StringBuilder，大规模新建对象，累积开销是很大的。

补充一个有趣的例子：

```java
String str = null;
// 会把null这个单词拼进来
System.out.println("" + null);
StringBuilder stringBuilder = new StringBuilder();
// 同样地把单词null拼进来，查源码
System.out.println(stringBuilder.append(str));
// 编译通过，运行报错，查源码
StringBuffer stringBuffer = new StringBuffer(str);
```

### 时间相关

#### JDK8以前

java.lang.System类提供currentTimeMills方法返回long型毫秒数（又叫时间戳），常用于计算时间差，有时也用于生成编号。

```java
long start = System.currentTimeMillis();
int sum = 0;
for (int i = 0; i < 100000000; i++) {
    sum += i;
}
long end = System.currentTimeMillis();
// 27
System.out.println(end - start);
```

Date类有两个-java.util.Date和java.sql.Date，后者继承前者。

```java
// Date类能把时间精确到毫秒，只不过针对外部展示，给秒
Date date1 = new Date();
// Thu Mar 31 20:43:43 CST 2022 Date类重写了toString方法
System.out.println(date1);
// 时间戳 1648730623980
System.out.println(date1.getTime());
// 根据指定时间戳实例化
Date date = new Date(26561551698452L);
// Wed Sep 14 16:48:18 CST 2811
System.out.println(date);

// 同文件下同名的类要区分开了
java.sql.Date date3 = new java.sql.Date(2348234827L);
// 1970-01-28 java.sql.Date当然也能精确到毫秒，不过为了对接数据库，它重写toString只给出年月日
System.out.println(date3);
// java.util.Date向java.sql.Date的转化，就以时间戳为桥梁
java.sql.Date date4 = new java.sql.Date(new Date().getTime());
```

java.text.SimpleDateFormat用于解析日期时间型文本及对日期时间格式化。

```java
// 无参构造器，默认模板，不好看
SimpleDateFormat simpleDateFormat = new SimpleDateFormat();
// 从Date对象到字符串叫格式化
String currentFmt = simpleDateFormat.format(new Date());
// 22-4-1 上午9:46
System.out.println(currentFmt);
// 被解析的字符串也应符合此模板，不然抛异常
String dateStr = "2020-4-3 下午02:08";
try {
    // 从字符串到Date对象叫解析
    Date date = simpleDateFormat.parse(dateStr);
    System.out.println(date);
} catch (ParseException e) {
    e.printStackTrace();
}
// 指定模板，模板有很多，文档给了一些例子，这是中国常见的
SimpleDateFormat readableFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
// 2022-04-01 09:46:16
currentFmt = readableFormat.format(new Date());
System.out.println(currentFmt);
try {
    // 同样不符合模板就抛异常 Thu Oct 01 06:30:20 CST 1998
    System.out.println(readableFormat.parse("1998-10-01 06:30:20"));
} catch (ParseException e) {
    e.printStackTrace();
}
```

java.util.Calendar日历类，是一个抽象类。

```java
// Calendar calendar = Calendar.getInstance(); 一种实例化方式
// 另一种实例化方式，通过子类
GregorianCalendar calendar = new GregorianCalendar();
// 当年第几天
int day = calendar.get(Calendar.DAY_OF_MONTH);
// 当月第几天
day = calendar.get(Calendar.DAY_OF_YEAR);
// 定位到当月第几天
calendar.set(Calendar.DAY_OF_MONTH, 10);
// 往后走几天
calendar.add(Calendar.DAY_OF_YEAR, 3);
// 往前走几天
calendar.add(Calendar.DAY_OF_YEAR, -1);
// Calendar对象转Date对象
System.out.println(calendar.getTime());
// Date对象转Calendar对象
calendar.setTime(new Date());
```

注意与上述类相关的月号的起始是0，每周里的日号的起始是1，且指星期日，不过相关获取方法都弃用了。

#### JDK8以后

引入新的意义在于解决遗留问题：

- 可变性：日期时间应该是不可变的。Calendar却是可变的，原位修改。
- 偏移性：Date中年份自1900开始，月份自0开始。我们构造对象传入年份月份前还得麻烦地算一下。
- 格式化：格式化只为Date所拥有，Calendar则无。
- 线程安全：这些都不满足线程安全。

Java 8吸收Joda-Time框架，新增了一系列API，归于java.time包下，我们一般只用到里面的1/3。

先联合来看time包下的LocalDate、LocalTime、LocalDateTime类（类似旧的Calendar）：

```java
LocalDate localDate = LocalDate.now();
LocalTime localTime = LocalTime.now();
LocalDateTime localDateTime = LocalDateTime.now();
// 2022-04-01
System.out.println(localDate);
// 11:23:37.115
System.out.println(localTime);
// 2022-04-01T11:23:37.115
System.out.println(localDateTime);
// 根据指定日期时间生成对象
LocalDateTime dateTime = localDateTime.of(2020, 1, 23, 8, 10, 10);
// get系列，获取年月日时分秒相关内容 THURSDAY
System.out.println(dateTime.getDayOfWeek());
// with系列，修改某对象并返回新对象
LocalDateTime dateTime1 = dateTime.withDayOfMonth(22);
```

time包下的Instant类（类似旧的Date）：

```java
Instant instant = Instant.now();
// 以本初子午线为标准的当前日期时间 2022-04-01T03:34:55.120Z
System.out.println(instant);
// 若与本时区不匹配，则可做偏移 OffsetDateTime和ZoneOffset均在time包下
OffsetDateTime offsetDateTime = instant.atOffset(ZoneOffset.ofHours(8));
// 2022-04-01T11:34:55.120+08:00
System.out.println(offsetDateTime);
// 由对象拿到时间戳
long timestamp = instant.toEpochMilli();
// 根据指定时间戳生成对象
Instant instant1 = Instant.ofEpochMilli(238273982739489L);
```

java.time.formatter.DateTimeFormatter（类似旧的SimpleDateFormat）：

```java
// 预定义格式
DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
// 按预定义格式格式化 2022-04-01T13:23:36.727
System.out.println(formatter.format(LocalDateTime.now()));
// 指定日期时间来解析，注意写法要符合预定义格式
System.out.println(formatter.parse("1999-01-04T00:30:59.022"));
// 下面两种都是本地相关格式，另指定了具体样式，短型长型等
DateTimeFormatter localFormatter1 = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT);
System.out.println(localFormatter1.format(LocalDateTime.now()));
DateTimeFormatter localFormatter2 = DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM);
System.out.println(localFormatter2.format(LocalDateTime.now()));
// 开发中最常用的，自定义格式
DateTimeFormatter commonFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
System.out.println(commonFormatter.format(LocalDateTime.now()));
System.out.println(commonFormatter.parse("2008-08-08 20:00:00"));
```

更详细的时间日期相关知识请参考文档。

### 比较器

#### 概述

比较是一个常见的操作，也是排序的基础。对基本类型的数据使用比较运算符比较，但对引用类型数据就不可行了，就要引入比较器。比较器指两个接口-内部比较器java.lang.Comparable与外部比较器java.util.Comparator，它们的功能是等价的。

#### Comparable接口

```java
String[] strings = new String[]{"dd", "aa", "gg", "bb", "ee", "cc"};
// String的重写做法是逐字符逐级比较，英文字母的比较是按ASCⅡ码值相减，汉字的比较是按Unicode码值相减
Arrays.sort(strings);
System.out.println(Arrays.toString(strings));
```

String、包装类等实现了此接口，使得执行sort等方法时，在底层会调用compareTo方法，这个重写的方法对对象的属性按某种规则进行比较，以此充当对象的比较。针对从小到大排序的重写规则为：

- 若本对象大于形参对象，则返回正整数。
- 若本对象小于形参对象，则返回负整数。
- 若本对象等于形参对象，则返回0。

我们让自定义类实现此接口：

```java
class Good implements Comparable {
    private String name;
    private double price;

    public Good(String name, double price) {
        this.name = name;
        this.price = price;
    }

    @Override
    public String toString() {
        return "Good{" +
                "name='" + name + '\'' +
                ", price=" + price +
                '}';
    }

    @Override
    public int compareTo(Object object) {
        // 我这里没用instance，要求引用类型也要一样了，用instance也行，因为子类属性个数只会更多
        if (object.getClass() == getClass()) {
            Good other = (Good) object;
            // 注意此处other.price语法正常哦，说明在实例中读写其他本类实例的私有域不违背私有性
            if (price > other.price) {
                return 1;
            } else if (price < other.price) {
                return -1;
            } else {
                return 0;
            }
        } else {
            throw new RuntimeException("传入的数据类型不一致");
        }
    }
}

// 测试
Good[] goods = {new Good("联想", 100), new Good("小米", 80), new Good("华为", 90), new Good("苹果", 120)};
Arrays.sort(goods);
```

属性一多，就可能存在多级排序，存在if语句的嵌套。

#### Comparator接口

通过此接口创建更高级（其实差不多）的比较方式或排序方式。同样是执行sort等方法时底层调用重写的compare方法。

对compare方法的重写规则与上一节中的一致，只不过不是比当前实例与形参实例，而是比两个形参实例。

```java
Good[] goods = {new Good("Lenovo", 100), new Good("MI", 80), new Good("HUAWEI", 90), new Good("iPhone", 120)};
Arrays.sort(goods, new Comparator<Good>() {
    @Override
    public int compare(Good good1, Good good2) {
        if (!good1.getName().equals(good2.getName())) {
            // 按名字从小到大排列
            return good1.compareTo(good2);
        } else {
            // 名字相等的话按价格从高到低排列
            return -Double.compare(good1.getPrice(), good2.getPrice());
        }
    }
});
```

### System

本类含三个静态域-in、out、error，皆为流类型，含常用方法-exit、gc（garbage collector）、getProperty。

### Math类

本类提供一系列静态方法用于科学计算，它们的参数和返回值类型一般是double。

### Big系列

即BigInteger类与BigDecimal类，它们专用于计算而非存值。

引入java.math.BigInteger解决整数溢出问题，它可表示不可变的任意精度整数。

引入java.math.BigDecimal解决精度损失问题，它表示不可变的任意精度的浮点数。

## 枚举

枚举是一种特殊的类，其实例个数有限且各实例不可变、状态也不可变。如：人的两性、一周的七天、四季、线程的五种状态。

JDK 1.5之前，没有enum关键字，可自实现枚举类：

```java
public class Season {
    // 实例域不可变，故用final设为常量
    private final String NAME;
    private final String DESC;

    // 诸对象唯一，外部不能实例化，故将构造器设为私有
    private Season(String name, String desc) {
        this.NAME = name;
        this.DESC = desc;
    }

    // 诸对象不可变，又要从外部有访问的接口，故由类提供，声明公有的静态常量域作为诸对象
    public static final Season SPRING = new Season("Spring", "warm");
    public static final Season SUMMER = new Season("Summer", "warm");
    public static final Season AUTUMN = new Season("Autumn", "warm");
    public static final Season WINTER = new Season("Winter", "warm");

    public String getNAME() {
        return this.NAME;
    }

    public String getDESC() {
        return this.DESC;
    }
}

// 测试
System.out.println(Season.SPRING.getNAME() + " is " + Season.SPRING.getDESC());
```

看起来类似单例，不过单例是唯一状态唯一对象，枚举是状态各异的唯一对象。

用enum关键字定义枚举：

```java
public enum SeasonEnum {
    // 必须在开头就定义好诸公有静态常量，用逗号分隔 这里对对象实体既做了初始化+实例化又做了引用
    SPRING("春天", "温暖"),
    SUMMER("夏天", "炎热"),
    AUTUMN("秋天", "凉爽"),
    WINTER("冬天", "寒冷");

    private final String NAME;
    private final String DESC;

    private SeasonEnum(String name, String desc) {
        this.NAME = name;
        this.DESC = desc;
    }
    // 其他省略
}

/* 测试  */
// SUMMER
System.out.println(SeasonEnum.SUMMER);
// class java.lang.Enum
System.out.println(SeasonEnum.SPRING.getClass().getSuperclass());
```

默认toString方法返回的不是地址值而是引用对象的常量名，说明枚举类继承的不是Object，而是java.lang.Enum类。

关注Enum类的常用方法：

- values：返回枚举对象数组，便于后续遍历。
- valueOf：根据传入的字符串内容获取对应名称的枚举对象。
- toString：上面说了。

```java
SeasonEnum[] seasons = SeasonEnum.values();
for (SeasonEnum season : seasons) {
    System.out.println(season);
}
// 找不到这个名字就抛java.lang.IllegalArgumentException
SeasonEnum winter = SeasonEnum.valueOf("WINTER");
```

枚举实现接口就很有趣了，各枚举对象既能调用统一重写的方法，又能调用各自重写的方法：

```java
public enum SeasonEnum implements Show {
    SPRING("春天", "温暖") {
        @Override
        public void show() {
            System.out.println("迎春");
        }
    },
    SUMMER("夏天", "炎热") {
        @Override
        public void show() {
            System.out.println("那个夏天");
        }
    },
    AUTUMN("秋天", "凉爽") {
        @Override
        public void show() {
            System.out.println("秋日私语");
        }
    },
    WINTER("冬天", "寒冷") {
        @Override
        public void show() {
            System.out.println("冬季恋歌");
        }
    };

    private final String NAME;
    private final String DESC;

    private SeasonEnum(String name, String desc) {
        this.NAME = name;
        this.DESC = desc;
    }

    // ...

    @Override
    public void showCommon() {
        System.out.println("一年有四个季节");
    }
}

interface Show {
    void showCommon();

    void show();
}

// 测试
Show[] seasons = SeasonEnum.values(); // 套上数组的向上转型哦
for (Show season : seasons) {
    season.showCommon();
    season.show();
}
```

## 注解

### 概述

JDK 5开始，增加了对元数据（meta data）的支持，也就是Annotation。

注解在代码里是特殊标记，这些标记可以编译、类加载、运行时被读取并进行相应处理。可修饰包、类、构造器、域、方法、参数声明、变量声明。

在JavaSE中，注解的用处不大，如标记过时、标记覆盖、忽略警告等，因此对注解的学习要求不高。但在JavaEE中，注解的功能特别强大，未来的开发都是基于注解的，所以要认真学。框架=注解+反射+设计模式。

### 常见注解

我们将注解分成这几类：

- 生成文档。
- 在编译时检查代码。有Overrride-校验重写条件是否满足、Deprecated-提示元素已过时、SuppressWarnings-抑制编译器警告。
- 跟踪依赖，替代配置文件。如@WebServlet等。

注解是一种特殊的类，可以像调用构造器那样往里面传值。如：

```java
@SuppressWarnings({"unused", "rawtypes"})
```

### 自定义注解

自定义的情况很少，我们常用现成的。

以无参方法的形式声明域，方法的名字与返回值类型就确定了域的名字及类型。当仅有一个域，建议命名为value。可以为域指定默认值，若指定了则使用时可不赋值。没有域的注解叫做标记。

使用注解时，以`name = "value"`的形式为域赋值。当仅有一个域，赋值时可不指明域名；当某域有默认值，可不对此域赋值。

```java
public @interface MyAnnotation {
    String value() default "pig";
}

@MyAnnotation(value = "cat")
class Person {

}

@MyAnnotation()
class Animal {
    
}
```

后面学到反射才渐渐明白注解的妙处，注解跟所修饰的元素是息息相关的。自定义注解必须配上基于反射的信息处理才有意义。

### 元注解

JDK 5.0提供了4个标准的元注解（meta-annotation），用于修饰其他注解。

- Retention：指定注解的生命周期。含一个RetentionPolicy枚举类型的域，可取值SOURCE（默认）、CLASS、RUNTIME这几个，想通过反射获取注解，就得指定最后一个。
- Target：指定所修饰的注解能修饰哪些元素。含一个ElementType枚举数组类型的域，数组元素可取值TYPE（类、接口、枚举）、FIELD、METHOD、PARAMETER、CONSTRUCTOR、LOCAL_VARIABLE、ANNOTATION_TYPE、PACKAGE。默认能修饰一切元素。
- Documented：让所修饰的注解能出现在java文档中，一般javadoc解析的元素不包括注解，特殊的如Deprecated。
- Inherited：让所修饰的注解拥有继承性，即父类被某注解修饰，子类也会被它修饰。

```java
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.*;

// 后两个很少用
@Target({TYPE, FIELD, METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    String value() default "pig";
}

// 其他省略

/* 测试 */
// 通过反射拿注解
Annotation[] annotations = Person.class.getAnnotations();
for (Annotation annotation : annotations) {
    // 就一个 @annotation.MyAnnotation(value=cat)
    System.out.println(annotation);
}
```

### 新特性

可重复注解，仅作了解。

类型注解：Target的那个数组域的元素可取的值多了俩-TYPE_PARAMETER与TYPE_USE，用在类型或泛型前面。

## 集合

### 概述

本章同数据结构大有关联。想操作多个对象，就要先按一定的组织形式存放（内存层面非硬盘层面）它们，普通的数组存在一些弊端，于是Java新增集合的概念，动态地将多个引用对象实体的变量放入集合这个容器中。

传统数组的弊端有：

- 运行起来长度确定，不能动态增长。
- 增删效率不高。
- 相关方法少。如没有返回实际元素个数的方法。
- 不能满足无序、不重复的需求。

当然数组还是很重要的，集合框架底层就用到了数组。

Java集合框架的分类：

- Collection接口：针对单列数据，有子接口，无实现类。
  - List接口：元素有序、可重复。
  - Set接口：元素无序、不重复。
- Map接口：针对双列数据，有实现类。保存多个映射（键值对）。

集合框架API的总包是java.util。

### Collection

这个List和Set的父接口准备了一些通用功能。

```java
// 子接口的实现类向上转型
Collection collection = new LinkedList();
// 元素类型可不一致
collection.add("A");
collection.add(2);
collection.add(LocalDate.now());
Collection other = new ArrayList();
other.add(new String("hello"));
// 吞并另一个Collection
collection.addAll(other);
// [A, 2, 2022-04-03, hello]
System.out.println(collection);
// 4 实际元素个数
System.out.println(collection.size());
System.out.println(collection.isEmpty());
// true contains(Object obj) 执行contains（这里执行LinkedList重写的）时底层会调obj.equals(元素)，逐元素传进来
System.out.println(collection.contains(new String("hello")));
collection.add(new Person());
// false 承上注释，那么一般存放自定义类的对象时，要重写equals方法
System.out.println(collection.contains(new Person()));
// 传入另一个Collection，判断是否本集合的子集
System.out.println(collection.containsAll(Arrays.asList("A", "hello")));
// true 执行重写的remove，底层也调equals
System.out.println(collection.remove(2));
// 求差集
collection.removeAll(Arrays.asList("hello", "world"));
// 求交集
collection.retainAll(Arrays.asList("A", 20, 30));
// true 宽泛地讲是比较集合相不相同，具体List要求有序，Set无需有序
System.out.println(collection.equals(Arrays.asList("A")));
// 96
System.out.println(collection.hashCode());
// 集合转数组
Object[] arr = collection.toArray();
// 数组转集合 类型必须是某个类，如此基本类型对应包装类，这里有自动装箱
List<Integer> list = Arrays.asList(1, 2, 3);
// 清空元素，并非自己变为null
list.clear();
```

还有一个蛮重要的iterator方法留下一节展开来讲。

### Iterator

即迭代器，用于遍历集合元素，且仅适用于集合，不适用于映射。

迭代器是设计模式的一种，制定了一个统一的迭代规范，即java.lang.Iterator接口提供iterator方法，此接口由Collection实现，那么Collection的所有间接的实现类们都要实现iterator方法。iterator方法返回值类型是Iterator。

看个例子：

```java
List<String> list = new ArrayList<>();
list.add("hello");
list.add("world");
list.add("one world");
list.add("one dream");
// 通过调用iterator方法拿到迭代器
Iterator iterator = list.iterator();
while (iterator.hasNext()) {
    System.out.println(iterator.next());
}
```

迭代原理：每调一次iterator都会得到一个新的迭代器，生成一个游标指向首元素之前的空位，调hasNext判断下一个位置有无元素，有则调next让游标后移指向下一个元素并返回，再调hasNext判断，如此往复，直到hasNext返回false，游标最终指向尾元素。

迭代器对象不是容器，是个工具，所遍历的是原容器list自身。

Iterator也提供了一个remove方法，用于遍历元素时顺带移除：

```java
List<String> list = new ArrayList<>();
list.add("hello");
list.add("world");
Iterator iterator = list.iterator();
while (iterator.hasNext()) {
    String str = (String) iterator.next();
    if ("hello".equals(str)) {
        iterator.remove();
    }
    // 从这里看出移除的不是对象实体，而是对象的引用，这个对象还存在，也说明容器保存的是引用
    System.out.println(str);
}
```

next方法可能抛NoSuchElementException-游标超出，移除时可能抛IllegalStateException-逻辑有误，如删两次、在首元素之前删。

JDK 5.0新增增强型for循环或叫foreach。在底层就利用了迭代器的方法。

```java
int[] arr = {1, 2, 3, 4, 5};
for (int i : arr) {
    System.out.println(i);
}
// 没有跟泛型，形如Collection<String>
Collection collection = new ArrayList();
collection.add("I");
collection.add("love");
collection.add("me");
// 编译器只会看左边集合类型后面有没有跟泛型，没有就认定元素类型为Object，即使在右边写了new ArrayList<String>也不成，这也反映了多态处于运行期的特点，编译器只认声明类型
for (Object o : collection) {
    System.out.println(o);
}
```

增强for循环与普通for循环的读操作等价，但写操作不等价。迭代时获取元素并赋给一个变量，那么对变量的修改并不会影响元素。

```java
int[] ints = {1, 2, 3, 4, 5};
for (int i : ints) {
    // 如果元素是对象，通过调用方法修改属性那就另当别论了
    i = 0;
}
// [1, 2, 3, 4, 5]
System.out.println(Arrays.toString(ints));
```

### List

List接口是Collection的子接口，又叫动态数组，我们通常用其替代数组，其元素有序可重复。

常用实现类有ArrayList、LinkedList、vector，要理解他们仨的异同：

- 同：都存放有序、可重复数据。
- 异：
  - ArrayList：主要实现类；线程不安全，效率高；底层用Object数组域elementData存数据。
  - LinkedList：底层用双向链表存数据，增删效率较高；线程不安全。
  - vector：古老实现类，很少用；线程安全，效率低；底层用Object数组域存数据。

浅析源码：JDK 7中，ArrayList实例化时底层数组也会按长度10实例化（饿汉式），添加元素时会预估越界与否，是则按1.5倍扩容并迁移元素。因此创建对象时最好预计元素个数上限，调用指定底层数组长度的构造器。

```java
ArrayList<Double> list = new ArrayList<>(200);
```

JDK 8中，ArrayList略有变化：实例化时底层数组会实例化为一个空数组（懒汉式），首次调add时才新建一个数组。一定时间内节省内存空间。

浅析源码：LinkedList用Node（结点）作存数据的单元，Node有三个域-item（数据）、next（下一个结点）、prev（上一个结点），每调add底层就带传入的数据实例化一个Node对象并挂到链表上，LinkedList有两个Node域-first与last，分别引用头尾结点。

浅析源码：Vector没啥好说的，几乎被弃用了，底层数组初始长为10，按2倍扩容，虽然ArrayList线程不安全，但遇到安全问题时也不用Vector。

常用方法：

```java
// 声明处不接泛型的话，后续int统统都要变成Object
ArrayList<Integer> list = new ArrayList<>();
/* 下面的都是基于索引操作 */
list.add(1);
list.add(2);
list.add(3);
list.add(0, 0);
list.addAll(Arrays.asList(4, 5, 5, 5));
int first = list.get(0);
int first_ind = list.indexOf(5);
int last_ind = list.indexOf(5);
// 重载的remove
int res = list.remove(0);
list.set(4, 6);
List subList = list.subList(1, 3);
```

遍历可通过迭代器、增强for循环、普通for循环。

我们这俩重载的remove的参数一个是int型一个是Object（泛型没指明），传入整型值是不会自动装箱的，想调后者只能手动装箱。

```java
// AbstractList的remove
int res = list.remove(2);
// 父接口Collection的remove
list.remove(new Integer(2));
```

### Set

#### 概述

Set接口相对父接口Collection无额外方法，存放无序、不重复元素。

常用实现类有HashSet、TreeSet：

- HashSet：主要实现类；线程不安全；可存null。
  - LinkedHashSet：可以按添加的顺序遍历元素。
- TreeSet：要求元素类型统一，以便能对多个对象进行排序。底层使用红黑树。

#### HashSet

以此实现类为例理解Set的两大特性（与下一节对照着看）：

- 无序性：底层用的也是数组，但是并非逐位置填元素也非按概率随机填入，而是根据哈希值算出位置让元素填入。

- 不重复性：添加元素时，底层也会调equals方法，保证返回值为false，同样最好重写自定义类的equals方法。

浅析源码：元素非常多的话，用equals逐元素比较效率是很低的，于是转而考虑更高效的方式来判重，即哈希值。哈希值是通过调用元素所属类的hashCode方法、基于对象属性算出来的，这个哈希值再通过散列函数等算法映射为底层数组的某个位置。那么添加一个对象元素会就会计算其哈希值，再计算存放位置，然后分情况讨论：

- 如果此位置无元素，那么存进去。无链表生成。
- 如果此位置有以链表形式存在的元素，那么依次先比较哈希值：
  - 若与现有元素的哈希值均不同，则将新元素挂上链表。
  - 遇到一次哈希值相同情况，就调一次equals方法继续比较：
    - 若结果为true，则添加失败。
    - 若结果为false，则接着去下一个元素的哈希值比较。

对于链表的延长，JDK 7使用头插法，JDK 8使用尾插法。

底层数组初始长为16，当利用率超过75%，扩容为原来的2倍并迁移数据（对象引用）。

由上述解读看下例：

```java
Set<Double> set = new HashSet<>();
set.add(2.5);
set.add(3.6);
set.add(4.8);
// 永远是[4.8, 3.6, 2.5] 因为计算哈希值的算法固定、映射位置的算法固定、底层数组元素有序
System.out.println(set);
```

默认hashCode方法算出的是个随机的数，当然不符合上一节的要求，因为按随机数算的话相同状态的对象哈希值大概率不一样，那么本来应挂在同一条链表上却分在不同位置。

对象状态相当于x，哈希值相当于y，一对一、多对一的情况均存在。

我们重写的hashCode方法要实现尽量少用equals或少用链表，尽量让元素在底层数组中分散开来，提高运行效率。

看IDEA自动生成的两个方法：

```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Person person = (Person) o;
    if (age != person.age) return false;
    // 跳入工具类java.util.Objects的equals方法发现 return (a == b) || (a != null && a.equals(b)); 很巧妙哦
    return Objects.equals(name, person.name);
}

@Override
public int hashCode() {
    int result = name != null ? name.hashCode() : 0;
    result = 31 * result + age;
    return result;
}
```

自定义类实例充当HashSet的元素，要求我们重写hashCode与equals，并保证相同状态对象哈希值相同，具体指同一个对象多次调用hashCode方法返回同一个值，调用equals比较两个对象返回true时，它们的hashCode返回值也应相等。

分析下例。一来练练脑子，二来警示我们不要修改元素状态。牢记先算哈希值，再算映射位置，最后调equals。

```java
// 假定算出的哈希值是m
Person p1 = new Person("li", 20);
// 属性值不同，大概率哈希值不同，假定算出的哈希值是n
Person p2 = new Person("wu", 18);
Set<Person> set = new HashSet<>();
set.add(p1);
set.add(p2);
// [Person{name='wu', age=18}, Person{name='li', age=20}]
System.out.println(set);
// 改了属性值
p1.setAge(22);
// false 计算传入参数的哈希值，因为属性值变了，所以大概率哈希值不一样，假定为x，映射的位置也大概率不一样，故删除失败
System.out.println(set.remove(p1));
// 删除失败，它还在，只不过属性值变了 [Person{name='wu', age=18}, Person{name='li', age=22}]
System.out.println(set);
// 计算传入参数的哈希值为x，映射得到的位置无元素，可以加进来
set.add(new Person("li", 22));
// 于是得到个假集合 [Person{name='wu', age=18}, Person{name='li', age=22}, Person{name='li', age=22}]
System.out.println(set);
// 计算传入参数的哈希值为m，映射到的位置有元素了，则继续比equals，返回false，加进来
set.add(new Person("li", 20));
// [Person{name='wu', age=18}, Person{name='li', age=22}, Person{name='li', age=20}, Person{name='li', age=22}]
System.out.println(set);
```

#### LinkedHashSet

虽然此类也满足添加元素时无序存放，但能实现按添加顺序遍历元素。它为元素结点附加两个指针，来记录前驱后继添加的结点。

```java
Set<Double> set = new LinkedHashSet<>();
set.add(2.5);
set.add(3.6);
set.add(4.8);
// [2.5, 3.6, 4.8]
System.out.println(set);
```

此外对频繁的遍历操作，由于双向链表的辅助，LinkedHashSet的效率高于父类HashSet。

#### TreeSet

此类要求元素（对象实体）类型相同，便于排序。由于结构与HashSet的不同，不需要重写那两个方法。

注意TreeSet底层判重用的不是equals而是compareTo（返回0即重复了），所以我们重写compareTo时要进行多级排序，单级的话部分属性重复的元素会被误判为完全重复。

```java
// 其他省略
@Override
public int compareTo(Person person) {
    int compare = name.compareTo(person.name);
    if (compare != 0) {
        return compare;
    } else {
        return Integer.compare(age, person.age);
    }
}

/* 测试 */
Set<Person> personSet = new TreeSet<>();
personSet.add(new Person("Tom", 20));
personSet.add(new Person("Bob", 16));
personSet.add(new Person("Jim", 23));
// 仅就name单级排序的话最后一个就会丢弃
personSet.add(new Person("Jim", 20));
Iterator iterator = personSet.iterator();
while (iterator.hasNext()) {
    System.out.println(iterator.next());
}
```

可以往构造器里传入一个Comparator对象，那么TreeSet底层就不再使用元素所属类的compareTo比较，而使用compare。

```java
// 这里只按age排
Set<Person> persons = new TreeSet<>(new Comparator<Person>() {
    @Override
    public int compare(Person p1, Person p2) {
        return Integer.compare(p1.getAge(), p2.getAge());
    }
});
persons.add(new Person("Tom", 20));
// 丢了
persons.add(new Person("Bob", 20));
persons.add(new Person("Jim", 23));
// 也丢了，不过是因为年龄重复而非名字重复
persons.add(new Person("Jim", 20));
iterator = persons.iterator();
while (iterator.hasNext()) {
    System.out.println(iterator.next());
}
```

### Map

#### 概述

Map接口：存放映射，有三个实现类。

- HashMap：主要实现类；线程不安全，但效率高；null可作键或值。
  - LinkedHashMap：相对于父类，为键值对附加两个指针，可按添加顺序遍历键值对且频繁遍历时提升效率。
- Hashtable：类似Vector，古老的实现类，线程安全；键与值均不能为null。
  - Properties：常用来处理配置文件，键和值都是字符串。
- SortedMap：
  - TreeMap：实现基于键的排序。底层使用红黑树。

键无序、不重复；由键映射，值也是无序的，但可重复。键值对用Entry类型表示，具体由其中两个域-key和value表示（另有俩域hash与next），一个键值对就是一个Entry对象，Entry对象是Map接口的成员内部接口，无序、不重复。

#### HashMap

同HashSet，我们要重写键所属类的equals与hashCode方法，对值所属类只需重写equals。

关于HashMap底层使用到的数据结构，JDK 7及以下有数组+链表，JDK 8及以上有数组+链表+红黑树。

浅析源码：以JDK 7为例，实例化时初始化长度为16的Entry数组域table。某次添加Entry对象时，调用新键对象的hashCode方法计算其哈希值，然后通过某种算法（table长度掩码）得到数组里的存放位置，接着也分情况讨论：

- 若此位置无元素，则存进去。
- 若此位置有以链表形式存在的元素，则依次先比哈希值：
  - 若与现有元素哈希值均不同，则将新元素头插到链表上。
  - 遇一次哈希值相同，就调一次新键所属类的equals方法：
    - 返回true，说明键重复，那么用新值覆盖旧值。
    - 返回false，继续去比下一个元素的哈希值。

添加到临界位置且该位置有元素就按2倍扩容并迁移数据，这个临界值等于数组长度乘加载因子如16*3/4=12。加载因子小了，数组的利用率就会低；大了链表就会变多（长），都不好。

JDK 8有所不同：数组域类型是实现Entry的静态内部类Node；采用懒汉式，实例化时没有创建数组，首次调用put时才新建一个数组；当某位置上的链表元素个数大于8且数组长度超过64，将此链表替换成红黑树，以提高查找效率；替换前采用尾插法。

注：HashSet本质就是HashMap，有个HashMap域map，执行add时就调map的put方法，将元素作为键、值统一为同一个Object实例存进map的数组。

#### LinkedhashMap

为了记录添加顺序、提高遍历效率，它定义了静态内部类Entry，继承父类HashMap的内部类Node，在定义中新增两个Entry域-before与after，分别指向前驱后继添加的结点。

#### 使用

以HashSet为实现类。

```java
// 没写泛型，那键和值都是Object型的，那其实什么类型都可，但一般要求键类型一致，且多为String
Map map = new HashMap();
// 添加
map.put("name", "li");
map.put("age", 20);
// 替换值
map.put("name", "zhang");
// {name=zhang, age=20}
System.out.println(map);
System.out.println(map.size());
Map other = new HashMap();
other.put("gender", "man");
other.put("grade", 6);
// 吞并另一个map，成为并集
map.putAll(other);
// 找不到就得null
Object value = map.get("age");
System.out.println(map.containsKey("birthday"));
// 这就体现了重写值所属类的equals方法的必要性，只返回找到的第一个
System.out.println(map.containsValue("zhang"));
Object removedValue = map.remove("grade");
map.clear();
System.out.println(map.isEmpty());
```

尤需掌握遍历操作：

```java
// 写了泛型就避免后面从Object向下转型
Map<String, Object> map = new HashMap<>();
map.put("name", "li");
map.put("age", 22);
map.put("gender", "woman");
// 键集合
Set<String> keys = map.keySet();
Iterator iterator = keys.iterator();
while (iterator.hasNext()) {
    System.out.println(iterator.next());
}
// 值集合
Collection values = map.values();
for (Object value : values) {
    System.out.println(value);
}
// Set底层用的是Map，那么这里就好玩了，一个键值对作一个键
Set<Map.Entry<String, Object>> entrySet = map.entrySet();
// 想省略Map.可以借助import语句，import java.util.Map.Entry-导入内部接口
Iterator<Map.Entry<String, Object>> iter = entrySet.iterator();
while (iter.hasNext()) {
    // 18行写了泛型，这里右边就不用强转
    Map.Entry<String, Object> entry = iter.next();
    System.out.println(entry.getKey() + "=" + entry.getValue());
}
```

#### TreeMap

要求所有键是同类实例。类似TreeSet，仅基于键对多个键值对进行排序，底层键的比较与判重依赖键所属类的compareTo方法或Comparator接口实现类的compare方法。

例子就不举了。

#### Properties

不像父类Hashtable存在感极低，Properties经常用于处理硬盘里的配置文件，比如我们定义一个jdbc.properties：

```java
name=Thomas
password=123456
```

```java
@Test
public void testProperties() throws IOException {
    Properties properties = new Properties();
    // 文件流相对路径起始于当前module（IDEA）或当前项目（eclipse）
    FileInputStream fis = new FileInputStream("jdbc.properties");
    // 加载文件流
    properties.load(fis);
    // 根据键取值
    String name = properties.getProperty("name");
    String password = properties.getProperty("password");
    System.out.println(name + "," + password);
    // 此处对IO流的操作并不严谨
}
```

### Collections

像Arrays是操作数组的工具类，Collections是操作List、Set与Map的工具类。当中提供了一系列用于排序、修改等操作的方法，还提供了让集合元素不可变、对集合实例实现同步的方法。

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(1);
numbers.add(2);
numbers.add(3);
numbers.add(4);
Collections.reverse(numbers);
// 定制比较，从而按从大到小排
Collections.sort(numbers, new Comparator<Integer>() {
    @Override
    public int compare(Integer i1, Integer i2) {
        return -Integer.compare(i1, i2);
    }
});
// 根据索引交换
Collections.swap(numbers, 2, 3);
// 可传入Comparator接口，定制比较
Integer max = Collections.max(numbers);
Integer min = Collections.min(numbers);
// 元素出现的频率
int frequency = Collections.frequency(numbers, 1);
// 用copy时要满足新集合的长度不能小于旧集合的
List<Integer> newNums = Arrays.asList(new Integer[numbers.size()]);
Collections.copy(newNums, numbers);
// 11替换所有旧值1
Collections.replaceAll(numbers, 1, 11);
// 同步化，让内部类实现List接口，重写方法让它们都变成同步的，返回内部类实例
List<Integer> synchronizedList = Collections.synchronizedList(numbers);
```

由于是线程不安全的，必要时ArrayList、LinkedList、HashMap都要通过此工具类同步化。

## 泛型

### 概述

设计背景：集合（容器）类在声明（定义）阶段不能确定要存的数据是什么类型的，于是在JDK 5.0之前用Object来统一，这就使得最终存进来的数据类型可以不一致。5.0之后引入了泛型（generic），让类型抽象化地统一（避免漏洞，加进不该加的东西），即虽然类型不确定但是一致的。我们把不确定的元素类型设成一个参数，这个参数就是泛型，又叫类型参数或参数化类型（parameterized type）。到我们使用这个类（声明类变量）的时候，就传入具体的元素类型。

```java
List scores = new ArrayList();
scores.add(90);
scores.add(88);
// 有抛ClassCastException的隐患
int score = (Integer) scores.get(1);
```

如上所示，用Object的话，万一进了不该进的东西，强转就会抛异常。我们希望非目标类型的数据不进来，就引入泛型解决：

```java
List<Integer> genericScores = new ArrayList();
genericScores.add(90);
genericScores.add(88);
// 编译就报错，阻止我们胡乱添加 genericScores.add(80D);
int genericScore = (Integer) genericScores.get(1);
// 但是元素类型也可以是实际类型的子类
```

由于初衷跟容器有关，而容器所存数据的类型不能是基本类型，故泛型的实际类型是能是引用类型，基本的用包装类替代。

一旦带泛型的类被实例化，里面出现泛型的地方类型就会确定下来。

5.0之后所有容器类或接口都带上了泛型，另有比较器等也带上泛型。如果我们不指明类型，自动指明为Object。

泛型不能充当异常类，怕实际类型不是异常类。

```java
// 编译不过
T t = new T();
T[] arr = new T[];
// 编译通过
T t = (T) new Object();
T[] arr = (T[]) new Object[1]; 
```

### 自定义

有泛型类、泛型接口、泛型方法等。

自定义泛型类：

```java
public class Mate<T> {
    private int id;
    private String name;
    private T appendix;

    // 这里不用加<T>
    public Mate(int id, String name, T appendix) {
        this.id = id;
        this.name = name;
        this.appendix = appendix;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public T getAppendix() {
        return appendix;
    }

    public void setAppendix(T appendix) {
        this.appendix = appendix;
    }

    // ...
}

/* 测试 */
// 这里不指明类型，Java帮我们指明为Object，那么Mate下的所有出现T的地方都会固定为Object
Mate david = new Mate(1, "david", "worker");
System.out.println(david);
// 重点在左侧，在声明处指明类型，右边的可省略
Mate<Integer> larson = new Mate<>(2, "larson", 10);
System.out.println(larson.getAppendix());
```

关于泛型与类继承相结合问题，情况太繁杂，给一些例子：

```java
// 子类继承父类时指明泛型
class StudentDao extends Dao<Student> {}
// 继承时指明泛型，同时有自己的泛型
class StudentDao<E> extends Dao<Student> {}
// 不指明父类泛型
class StudentDao<T> extends Dao<T> {}
// 不保留父类泛型，有自己的泛型
class StudentDao<E> extends Dao {} // 等价于...Dao<Object>
// 不指明父类泛型，有自己的泛型
class StudentDao<E, T> extends Dao<T> {}
```

已指明泛型不同的变量不能互相赋值，编译都过不了：

```java
// 即使是父子关系也不行
Mate<Object> mate1 = null;
Mate<Integer> mate2 = null;
// incompatible types 
mate1 = mate2;
```

关于泛型方法。上例中的构造器、setAppendix方法等都不是泛型方法，因为没有属于本方法的泛型。

```java
// 这才是泛型方法，在返回值类型前定义一个针对此方法的泛型E，与类的泛型T区分开
public <E> void showDesc(E desc) {
    System.out.println(desc);
}

// 主方法体内调用泛型方法，无需指明类型，自动根据上下文（实参类型、接收返回值的变量类型）确定
larson.showDesc(521);
```

泛型方法可以是静态的。由于类的泛型在实例化时才确定，而类加载又在前，故仅含类泛型的方法不能是静态的；由于方法的泛型在调用时确定，故泛型方法可以是静态的。

### 通配符

通配符让功能更灵活。

```java
// 看起来跟泛型方法是等价的
public void showList(List<?> list) {
    Iterator<?> iterator = list.iterator();
    while (iterator.hasNext()) {
        Object obj = iterator.next();
        System.out.println(obj);
    }
}

// 测试
List<Integer> list = new LinkedList<>();
list.add(10);
list.add(20);
larson.showList(list);
```

改写前面的例子：

```java
Mate<Object> mate1 = null;
Mate<Integer> mate2 = null;
Mate<?> common = null;
// 这样就可以
common = mate1;
common = mate2;
```

除了null之外，带通配符的对象不能调用add方法，如`common.add(null)`，可调用get方法，返回数据的类型是Object。

另外有一些变体：

```java
// 仅接收Person或其子类作指明类型的Mate对象
Mate<? extends Person> variant1 = new Mate<Student>();
// 那么最低用Person接收读到的数据，只是这里越界了
Person p = variant1.get(0);
// 那么是不能调add的，因为不清楚下限
Mate<Object> oMate = new Mate<>();
// 仅接收Person或其父类作指明类型的Mate对象
Mate<? super Person> variant2 = oMate;
// 那么只能用Object接收读到的数据 越界
Object o = oMate.get(0);
// 那么调add，只能加Person或其子类对象
variant2.add(new Student());
```

## IO流

### 概述

本章相关API的总包为java.io。

I/O全写为Input/Output，用于设备之间的数据传输，包括内存向外层的文件读写、一台主机向另一台主机的网络通讯等。

Java程序中数据的输入输出以流（stream）的方式进行。java.io包下提供了各种流类与接口，用来操作不同种类的数据，即通过一组标准的方法来输入输出。

流的分类：

- 按数据流向：

  - 输入：读取外部设备（磁盘、光盘等）数据到程序中。

  - 输出：将程序（内存）里的数据写到磁盘等存储设备中。

- 按被操作的数据单位：
  - 字节流：以8bit的单字节为单位，适合多媒体等。
  - 字符流：以16bit的2字节为单位，适合文本等。
- 按流的角色：
  - 节点流：原始的流，直接作用于文件与程序。
  - 处理流：封装原始的流，达到加速传输等目的。

四个重要的抽象基类：

|        | 字节流       | 字符流 |
| ------ | ------------ | ------ |
| 输入流 | InputStream  | Reader |
| 输出流 | OutputStream | Writer |

io包下40个多个类均由上述四类派生，这体现在它们的名字均以这几个基类名为后缀。归纳一下：input表输入、output表输出；stream表字节、reader/writer表字符。

### File

File类是IO的基石，一个File类对象表示一个文件或一个文件夹。

```java
/* 皆为内层层面的对象，用于生成文件（夹）路径，硬盘中存不存在无所谓 */
File file1 = new File("start.txt");
File file2 = new File("D:\\start.txt");
File file3 = new File("D:" + File.separator + "temp" + File.separator + "start.txt");
File file4 = new File("D:\\temp", "today");
File file5 = new File(file4, "today.txt");
```

常用方法：

```java
/* 对前面几个来说，依然是文件存不存在无所谓 */
// 相对于工程所处目录开始找
File file = new File("temp\\log.txt");
System.out.println(file.getAbsoluteFile());
// log.txt
System.out.println(file.getName());
// temp 找不到得null
System.out.println(file.getParent());
// 15 是字节数非字符数 找不到得0
System.out.println(file.length());
// 1649220112175（时间戳） 找不到得0
System.out.println(file.lastModified());
File dir = new File("D:\\programData");
// 下属文件名数组与File对象数组，这里找不到就报错
String[] names = dir.list();
File[] files = dir.listFiles();
// 文件迁移 要求源文件存在且目标文件不存在，否则返回false
File src = new File("D:\\users\\log.txt");
File dist = new File("D:\\temp\\log.txt");
boolean shifted = src.renameTo(dist);
// 下面的除exists以外，找不到就报错
System.out.println(dir.isFile());
System.out.println(dir.isDirectory());
System.out.println(dir.exists());
System.out.println(dir.canRead());
System.out.println(dir.canWrite());
System.out.println(dir.isHidden());
File newFile = new File("hello.txt");
/* 文件（夹）创建与删除 */
if (!newFile.exists()) {
    // 这里把IOException往上抛了
    boolean created = newFile.createNewFile();
} else {
    // 这里的删除不经回收站 文件夹非空的话删除失败，返回false
    boolean deleted = newFile.delete();
}
// 目录、多级目录创建
File mk1 = new File("D:\\io");
boolean made1 = mk1.mkdirs();
File mk2 = new File("D:\\io\\test");
boolean made2 = mk2.mkdir();
```

上述方法并未涉及对文件内容的读写，这要依靠IO流。File类对象常作为参数传入流的构造器，指定读写的路径。

### 节点流

这里谈四个节点流-FileInputStream、FileOutputStream、FileReader、FileWriter作为样板，它们又叫文件流。

```java
@Test
public void testFileReader() throws IOException {
    File file = new File("temp\\log.txt");
    System.out.println(file.getAbsoluteFile());
    // 实例化流
    FileReader fileReader = new FileReader(file);
    int data;
    // 注意写法 达到文件末尾才返回-1
    while ((data = fileReader.read()) != -1) {
        // 输出到控制台
        System.out.print((char) data);
    }
    fileReader.close();
}
```

一定别忘了手动关闭流，Java的自动回收不针对IO流、数据库连接、Socket连接等。

我们要保证流资源能正常关闭，所以用上try-catch-finally语句：

```java
@Test
public void testFileReader() {
    FileReader fileReader = null;
    try {
        File file = new File("temp\\log.txt");
        System.out.println(file.getAbsoluteFile());
        fileReader = new FileReader(file);
        int data;
        while ((data = fileReader.read()) != -1) {
            System.out.print((char) data);
        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        try {
            // 可能文件找不到，它就还是个null，调close就报空指针异常，还是个null就没关闭的必要
            if (fileReader != null) {
                fileReader.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

读入操作要求文件一定要存在，不然读个寂寞。

归纳读操作的套路：

1. 创建文件对象（可选）。
2. 创建流对象（可直接传入文件路径）。
3. 读入操作。
4. 关闭资源。

下面看一下更高效的重载的read方法。

```java
FileReader fileReader = null;
try {
    File file = new File("temp\\log.txt");
    System.out.println(file.getAbsoluteFile());
    fileReader = new FileReader(file);
    // 借助字符数组成批的读入
    char[] cbuf = new char[5];
    // 用len记录每次读入的字符个数
    int len;
    while ((len = fileReader.read(cbuf)) != -1) {
        // 注意退出条件不能用length，会冗余
        for (int i = 0; i < len; i++) {
            System.out.println(cbuf[i]);
        }
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (fileReader != null) {
            fileReader.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}

// 另外一种借助String的写法，其他代码省略
char[] cbuf = new char[5];
int len;
while ((len = fileReader.read(cbuf)) != -1) {
    String string = new String(cbuf, 0, len);
    System.out.println(string);
}
```

写出操作的例子：

```java
@Test
public void testFileWriter() throws IOException {
    File file = new File("temp\\poem.txt");
    FileWriter fileWriter = new FileWriter(file);
    fileWriter.write("一蓑烟雨任平生\n");
    fileWriter.write("也无风雨也无晴");
    fileWriter.close();
}
```

同样归纳写出的套路：

1. 创建文件对象。
2. 创建流对象。
3. 写出操作。
4. 关闭资源。

文件路径可以不存在，不存在的话帮我们创建然后写入，存在的话新内容覆盖原内容，我们可通过调用另一个构造器实现追加：

```java
// true表追加，false表覆盖
FileWriter fileWriter = new FileWriter(file, true);
```

然后我们合并读入和写出，复制文件。注意先写最简单的逻辑，随后再改造成try-catch形式。

```java
@Test
public void testFileReaderAndWriter() throws IOException {
    File src = new File("temp\\poem.txt");
    FileReader fileReader = new FileReader(src);
    File dist = new File("temp\\word.txt");
    FileWriter fileWriter = new FileWriter(dist);
    char[] cbuf = new char[5];
    int len;
    while ((len = fileReader.read(cbuf)) != -1) {
        // fileWriter.write(new String(cbuf, 0, len));
        // 重载的write方法
        fileWriter.write(cbuf, 0, len);
    }
    // 建议从后往前关闭
	fileWriter.close();
    fileReader.close();
}
```

改造：

```java
File src = new File("temp\\poem.txt");
FileReader fileReader = null;
File dist = new File("temp\\word.txt");
FileWriter fileWriter = null;
try {
    fileReader = new FileReader(src);
    fileWriter = new FileWriter(dist);
    char[] cbuf = new char[5];
    int len;
    while ((len = fileReader.read(cbuf)) != -1) {
      fileWriter.write(new String(cbuf, 0, len));
        fileWriter.write(cbuf, 0, len);
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    // 并列
    try {
        if (fileWriter != null) {
            fileReader.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (fileReader != null) {
            fileWriter.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

我们把第1行与第3行都改成图片是没有效果的，文件打不开（已损坏），证明字符流不适用于非文本。

于是转而看字节流。照猫画虎，把上面出现字符流的地方都改成字节流，相关地方也都改一下：

```java
File src = new File("temp\\coalball.png");
FileInputStream fis = null;
File dist = new File("temp\\coal.png");
FileOutputStream fos = null;
try {
    fis = new FileInputStream(src);
    fos = new FileOutputStream(dist);
    // 通常设长度为1024
    byte[] buffer = new byte[1024];
    int len;
    while ((len = fis.read(buffer)) != -1) {
    	fos.write(buffer, 0, len);
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (fos != null) {
            fos.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (fis != null) {
            fis.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

字节流也能处理文本文件，不过只能复制，如果读的话不支持汉字，UTF-8中一个汉字占3字节，形成字节数组时汉字可能会被劈开，显示到控制台上就乱码。字符流是一定无法对非文本文件作任何有效处理，复制出的文件一定是损坏的。

使用字符流处理文本文件，如txt、java、c、cpp等；使用字节流处理非文本文件，如jpg、mp3、mp4、doc等。

### 缓冲流

缓冲流是处理流的一种，能提升流读入、写出的速度。

符合装饰器模式，处理流封装已有的流，不一定是节点流。

先看缓冲字节流BufferedInputStream、BufferedOutputStream的例子：

```java
File src = new File("temp\\coalball.png");
File dist = new File("temp\\ball.png");
FileInputStream fis = null;
FileOutputStream fos = null;
BufferedInputStream bis = null;
BufferedOutputStream bos = null;
try {
    fis = new FileInputStream(src);
    fos = new FileOutputStream(dist);
    // 两个节点流对象分别传入缓冲流构造器
    bis = new BufferedInputStream(fis);
    bos = new BufferedOutputStream(fos);
    byte[] buffer = new byte[1024];
    int len;
    while ((len = bis.read(buffer)) != -1) {
        bos.write(buffer, 0, len);
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    // 要求从外往内关，但关闭缓冲流时底层会帮我们关闭内部的节点流对象，毕竟它们传进了外层流构造器
    try {
        if (bos != null) {
            bos.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (bis != null) {
            bis.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

提速原因：类内部提供了一个缓冲区，一个域DEFAULT_BUFFER_SIZE定义了缓冲区字节数，默认固定为8192，每当缓冲区满了就整个地读入或写出，若我们调用flush方法，则可能缓冲区还没满就读入或写出。

```java
// 其他省略
while ((len = bis.read(buffer)) != -1) {
    bos.write(buffer, 0, len);
    // 每读入一批字节就写出
    bos.flush();
}
```

再看缓冲字符流-BufferedReader、BufferedWriter的例子：

```java
BufferedReader bufferedReader = null;
BufferedWriter bufferedWriter = null;
try {
    bufferedReader = new BufferedReader(new FileReader(new File("temp\\poem.txt")));
    bufferedWriter = new BufferedWriter(new FileWriter(new File("temp\\sentence.txt")));
    char[] charBuffer = new char[1024];
    int len;
    while ((len = bufferedReader.read(charBuffer)) != -1) {
        bufferedWriter.write(charBuffer, 0, len);
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    // 被封装的流在内部被自动关闭
    try {
        if (bufferedWriter != null) {
            bufferedWriter.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (bufferedReader != null) {
            bufferedReader.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}

// 使用特有的readLine方法 其他省略
String data;
while ((data = bufferedReader.readLine()) != null) {
    bufferedWriter.write(data);
    // 写出一个换行符
    bufferedWriter.newLine();
}
```

### 转换流

转换流是一种处理流，具体地：

- 输入转换流InputStreamReader将字节输入流转为字符输入流，继承Reader。
- 输出转换流OutputStreamWriter将字符输出流转为字节输出流，继承Writer。

感性理解：联系解码，字符是看得懂的东西，是输入的落脚点；联系编码，字节是看不懂的东西，是输出的落脚点。

字节流转字符流：

```java
@Test
public void testInputStreamReader() throws IOException {
    FileInputStream fis = new FileInputStream(new File("temp\\poem.txt"));
    // 因为编码采用的字符集是UTF-8，故解码（读入）也采用这个
    InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
    char[] cbuf = new char[1024];
    int len;
    while ((len = isr.read(cbuf)) != -1) {
        System.out.println(new String(cbuf, 0, len));
    }
    isr.close();
}
```

字符流转字节流：

```java
@Test
public void testAll() throws IOException {
    // 两个转换流构造器的参数都是字节流
    FileInputStream fis = new FileInputStream(new File("temp\\poem.txt"));
    InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
    FileOutputStream fo = new FileOutputStream(new File("temp\\text.txt"));
    OutputStreamWriter osw = new OutputStreamWriter(fo, "GBK");
    char[] cbuf = new char[1024];
    int len;
    // 读入-字节转字符
    while ((len = isr.read(cbuf)) != -1) {
        // 写出-字符转字节
        osw.write(cbuf, 0, len);
    }
    // 同样只需关外层的流
    isr.close();
    osw.close();
}
```

### 编码方式

罗列一下诸编码方案：

- ASCⅡ码：美国标准信息交换码，每个字符占一个字节里的7位。
- ISO8859-1：拉丁码表、欧洲码表，每个字符占一个字节。
- GB2312：中文码表，单字符最多占2字节，用标志位区分单字节字符与双字节字符。
- GBK：升级的中文码表，单字符最多占2字节。
- Unicode：国际标准码，囊括了目前全球所有字符，每个字符占2字节。但无法推广。
- UTF-8（UCS transfer format）：单字符最多占6字节。
- ANSI（美国国家标准学会）：通常指当前平台的默认编码。

### 标准输入输出流

标准的输入流InputStream类型的System.in默认从键盘输入，标准的输出流PrintStream类型的System.out默认从控制台输出。

```java
/* 用转换流将System.in转为字符流，再包上缓冲流，来逐行读键盘输入，读到e则退出，否则将读到的都转成大写输出到控制台 */
BufferedReader br = null;
try {
    br = new BufferedReader(new InputStreamReader(System.in));
    char[] cbuf = new char[1024];
    String data;
    // 注意仅敲个换行，读入的字符串可不是null，而是长度为0的空串""；敲空格、制表符的话长度就不是0，它们都是字符
    while ((data = br.readLine()) != null) {
        if ("e".equalsIgnoreCase(data)) {
            break;
        }
        System.out.println(data.toUpperCase());
    }
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (br != null) {
        try {
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

System.out就没啥好说的了。

### 打印流

打印流有PrintStream与PrintWriter，它们提供了一系列重载的print、println方法，将各种基本类型的数据转为字符串打印出来。

```java
/* 将标准输出流由控制台输出改成文件输出 */
PrintStream ps = null;
try {
    // PrintStream套上FileOutputStream才能改流向 第二个参数对应底层autoFlush属性，为true则每当写出换行符就倾空缓冲区
    ps = new PrintStream(new FileOutputStream(new File("temp\\out.txt")), true);
    System.setOut(ps);
    for (int i = 1; i <= 256; i++) {
        // 控制台就不会显示了
        System.out.print((char) i);
        if (i % 50 == 0) {
            System.out.println();
        }
    }
} catch (FileNotFoundException e) {
    e.printStackTrace();
} finally {
    // PrintStream不会抛IO异常
    if (ps != null) {
        ps.close();
    }
}
```

### 数据流

数据流有DataInputStream与DataOutputSteam，用于各种基本类型数据的读入和写出。与后续对象流一样，写出的东西是肉眼看不懂的，用于下一次读入。

```java
/* 写出诸数据 */
DataOutputStream dos = null;
try {
    dos = new DataOutputStream(new FileOutputStream("temp\\data.txt"));
    // 这里把字符串当基本类型了
    dos.writeUTF("中国");
    dos.writeDouble(33);
    dos.writeChar('f');
    dos.writeBoolean(true);
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (dos != null) {
        try {
            dos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
/* 读入诸数据 */
@Test
public void testDataInput() throws IOException {
    DataInputStream dis = new DataInputStream(new FileInputStream("temp\\data.txt"));
    // 要按照写出的顺序读入，先写先读
    String nation = dis.readUTF();
    double digital = dis.readDouble();
    char ch = dis.readChar();
    boolean flag = dis.readBoolean();
    dis.close();
    System.out.println(nation);
}
```

对象流侧重引用类型变量的持久化，可用于读入、写出基本类型数据或对象，这涉及到序列化、反序列化的概念：

- 序列化：用ObjectOutputStream保存基本类型数据或对象。
- 反序列化：用ObjectInputStream读取基本类型数据或对象。

static或transient修饰的变量不支持序列化，前者不支持是因为序列化针对对象而非类，后者不支持是为了迎合不想序列化的要求。

对象序列化机制：把内存里的Java对象转为平台无关的二进制流，然后把二进制流持久地保存到磁盘中，或者通过网络传输到另一个主机上；随后可以反序列化，把磁盘里的或通过网络接收到的二进制流转为Java对象。

序列化是JavaEE的一大基础，具体来说是RMI（remote method invoke-远程方法调用）的基础。

想让某对象支持序列化，则要求其所属类及下面的域（级联地）支持序列化。那么想让类支持序列化，则要求它实现Serializable或Externalizable接口，并含一个公有静态常量serialVersionUID（序列版本号）。

```java
public class Student implements Serializable {
    public static final long serialVersionUID = 234234234209809L;
    // 基本类型及一些内置类已经支持序列化
    private String name;
    private int age;
    // 若有其他域是自定义类型的，则此类也要支持序列化
    // ...
}

// 序列化到文件
ObjectOutputStream oos = null;
try {
    oos = new ObjectOutputStream(new FileOutputStream("temp\\student.dat"));
    oos.writeObject(new Student("van", 23));
    oos.flush();
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (oos != null) {
        try {
            oos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// 反序列化到内存
ObjectInputStream ois = null;
Student student = null;
try {
    ois = new ObjectInputStream(new FileInputStream("temp\\student.dat"));
    student = (Student) ois.readObject();
    System.out.println(student);
} catch (ClassNotFoundException | IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (ois != null) {
            ois.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

如果我们不自己设serialVersionUID的话，底层会自动生成一个，但有隐患。比方说现已序列化一个A类对象，其serialVersionUID为a，接着我把A的类体给改一改，其serialVersionUID就会变成b，那么反序列化的时候就抛异常，因为读入对象的serialVersionUID为a，而我现在没有serialVersionUID为a的类。如果显式指定，那么类体变动不会导致serialVersionUID变化。

在实际开发中序列化一般指先将对象转成JSON字符串，再将JSON字符串转成二进制流。因为不是所有类都支持序列化，但任何对象都能转为jSON格式的字符串，又字符串可序列化，故以字符串为媒介。

### 任意文件存取流

RandomAccessFile虽在java.io包下，但继承的是Object类，并实现DataInput、DataOutput接口，用于文件读写，属字节流。random是指可以定位到某文件的任意位置。

```java
@Test
public void testRandomAccessFile() throws IOException {
    // 根据模式而非类名来决定输入还是输出，就一个类，当然输入对象和输出对象应当分开
    RandomAccessFile rafIn = new RandomAccessFile(new File("temp\\poem.txt"), "r"); // 读
    RandomAccessFile rafOut = new RandomAccessFile(new File("temp\\word.txt"), "rw"); // （读和）写
    byte[] buffer = new byte[1024];
    int len;
    while ((len = rafIn.read(buffer)) != -1) {
        rafOut.write(buffer, 0, len);
    }
    rafOut.close();
    rafIn.close();
}
```

它的覆盖机制不是完全覆盖，而是按内容覆盖，写出多少覆盖多少，所以可能从头开始部分改变旧有内容。

可以指定位置写出：

```java
// 从第4个字符开始覆盖
rafOut.seek(3);
rafOut.write(buffer, 0, len);
// 其他省略
```

### NIO

Java NIO（new IO, non-blocking IO-非阻塞IO）自Java 1.4引入，用于替代原有Java IO API。其作用与原有的相同，但操作方式更胜一筹，原有的是面向流的，NIO是面向缓冲区的、基于通道的，效率更高。具体有两套NIO-一套是针对输入输出的，一套是针对网络编程的。

由于NIO使用起来不太方便，后面在JDK 7又来个NIO 2，对NIO进行极大扩展，增强了文件处理。

File类功能有限，不够好用，如找不到文件时不提供异常信息。NIO 2引入Path接口以优化File。

Paths、Files等API在框架中用得较多，这里就不举例了，请查看源码。

### 第三方

Apache等第三方提供了文件操作相关的jar包，开发中我们经常用到。

## 网络编程

### 概述

网络编程的大头在JavaWeb部分，这里只略微讲一下。Java实现了一个跨平台的网络库。

计网的相关知识此处略过。

落地的计算机网络体系结构-TCP/IP协议栈：

| TCP/IP参考模型  | 协议                |
| --------------- | ------------------- |
| 应用层          | HTTP FTP Telnet DNS |
| 传输层          | TCP UDP             |
| 网络层          | IP ICMP ARP NAT     |
| 数据链路+物理层 | Link                |

InetAddress类对IP地址进行了封装。

```java
try {
    // 域名和IP地址字符串都传进这个方法
    InetAddress inet1 = InetAddress.getByName("192.168.31.167");
    System.out.println(inet1);
    InetAddress inet2 = InetAddress.getByName("www.baidu.com");
    InetAddress inet3 = InetAddress.getByName("127.0.0.1");
    // 获取本地IP地址
    InetAddress inet4 = InetAddress.getLocalHost();
    System.out.println(inet1.getHostName());
    System.out.println(inet2.getHostAddress());
    System.out.println(inet4.getHostAddress());
} catch (UnknownHostException e) {
    e.printStackTrace();
}
```

IP地址和端口号拼起来叫套接字（socket）。

### TCP

TCP传输前，为什么是三次握手？因为一次两次传输失败的风险过高，而四次以上传输成功率又提升得很小。

实现TCP网络编程的例子：

```java
/* 客户端 后运行 */
Socket socket = null;
OutputStream os = null;
try {
    // 创建套接字，指明服务端的端口号
    socket = new Socket(InetAddress.getLocalHost(), 8899);
    // 创建输出流
    os = socket.getOutputStream();
    // 写出
    os.write("你好，这里是客户端".getBytes());
} catch (IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (os != null) {
            os.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (socket != null) {
            socket.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}

/* 服务端 先运行 */
ByteArrayOutputStream bos = null;
InputStream is = null;
Socket socket = null;
ServerSocket serverSocket = null;
try {
    // 创建套接字，指明自己的端口号
    serverSocket = new ServerSocket(8899);
    // 接收来自客户端的套接字对象
    socket = serverSocket.accept();
    // 等待客户端发送，从此对象中获取输入流
    is = socket.getInputStream();
    // 这里使用了ByteArrayOutputStream，将数据写出到内存，就是一个字节数组
    bos = new ByteArrayOutputStream();
    byte[] buffer = new byte[1024];
    int len;
    while ((len = is.read(buffer)) != -1) {
        // 读一批字节，就写一批字节
        bos.write(buffer, 0, len);
    }
    // 把写完的数组转成字符串
    System.out.println(bos.toString());
    System.out.println("已收到来自于" + socket.getInetAddress().getHostName() + "的数据");
} catch (IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (bos != null) {
            bos.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (is != null) {
            is.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (socket != null) {
            socket.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (serverSocket != null) {
            serverSocket.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

还可以写文件传输等例子。

Socket对象就是传送数据的载体。需要分析一下，客户端调`os.close()`时服务端知道传输通道关闭了，这才执行56行往后的代码。我们再通过下面这个例子看客户端显式声明发完了，基于此继续交互：

```java
@Test
public void client() throws IOException {
    Socket socket = new Socket(InetAddress.getLocalHost(), 8899);
    OutputStream os = socket.getOutputStream();
    os.write("from client：你好，这里是客户端".getBytes());
    // 向服务端表示发完了
    socket.shutdownOutput();
    // 等待服务端向这里发反馈，然后读入
    InputStream is = socket.getInputStream();
    // 使用转换流
    InputStreamReader isr = new InputStreamReader(is);
    char[] cbuf = new char[5];
    int len;
    while ((len = isr.read(cbuf)) != -1) {
        System.out.print(new String(cbuf, 0, len));
    }
    // 得知通道关了，向后执行
    isr.close();
    os.close();
    socket.close();
}

@Test
public void server() throws IOException {
    ServerSocket serverSocket = new ServerSocket(8899);
    Socket socket = serverSocket.accept();
    InputStream is = socket.getInputStream();
    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    byte[] buffer = new byte[1024];
    int len;
    while ((len = is.read(buffer)) != -1) {
        bos.write(buffer, 0, len);
    }
    System.out.println(bos.toString());
    System.out.println("已收到来自于" + socket.getInetAddress().getHostName() + "的数据");
    // 得知客户端表示发完了，向客户端写出反馈
    OutputStream os = socket.getOutputStream();
    os.write("from server：我已收到，谢谢客户端".getBytes());
    // 关闭通道
    os.close();
    bos.close();
    is.close();
    socket.close();
    serverSocket.close();
}
```

### UDP

了解一下用法：

```java
// 不像TCP，这里的发送方先运行不抛异常，但发个寂寞
@Test
public void send() throws IOException {
    DatagramSocket socket = new DatagramSocket();
    byte[] data = "东风快递，使命必达".getBytes();
    // 不管对方状态，不管成功与否，发就完事了
    DatagramPacket packet = new DatagramPacket(data, 0, data.length, InetAddress.getByName("localhost"), 8989);
    socket.send(packet);
    socket.close();
}

// 先运行接收方才能接收到
@Test
public void receive() throws IOException {
    DatagramSocket socket = new DatagramSocket(8989);
    byte[] buffer = new byte[1024];
    DatagramPacket packet = new DatagramPacket(buffer, 0, buffer.length);
    // 先运行起来，就在这等着，收到对方发过来的东西，再往后执行
    socket.receive(packet);
    System.out.println(new String(packet.getData(), 0, packet.getLength()));
    socket.close();
}
```

### URL

URL由五部分组成：协议、主机名、端口号、路径名、参数列表。

看一个下载图片的例子：

```java
@Test
public void testURL() throws IOException {
    URL url = new URL("https://s1.ax1x.com/2022/03/31/qWqVG4.png");
    HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
    urlConnection.connect();
    InputStream is = urlConnection.getInputStream();
    FileOutputStream fos = new FileOutputStream("temp\\totoro.png");
    byte[] buffer = new byte[1024];
    int len;
    while ((len = is.read(buffer)) != -1) {
        fos.write(buffer, 0, len);
    }
}
```

## 反射

### 概述

反射（reflection）被视为动态语言的关键。反射机制允许程序执行期间借助reflection API取得类的内部信息并操作内部成员。

加载完类之后，堆的方法区中会产生一个与此类相对应的Class类型的对象，它记录着完整的类信息，它像一面镜子，虽不是原始的类体本身，但能反映出类的结构信息，所以叫反射。

反射API集中于java.lang.reflect下，另有java.lang.Class，描述类的内部结构。

来个例子感受一下反射：

```java
public class Student {
    private String name;
    public int age;
    private String gender;

    private void showNation(String nation) {
    	System.out.println(nation);
    }
    
    // ...
}

// 测试
@Test
public void testSimple() throws IllegalAccessException, InvocationTargetException, InstantiationException, NoSuchMethodException, NoSuchFieldException {
    Student student = new Student("wang", 30, "man");
    Class<Student> cls = Student.class;
    // 也有对应基本类型的Class实例
    Constructor<Student> cons = cls.getConstructor(String.class, int.class, String.class);
    Student stu = cons.newInstance("li", 24, "woman");
    System.out.println(stu);
    Field age = cls.getDeclaredField("age");
    // 直接赋值，不是调setter
    age.set(stu, 18);
    Method getGender = cls.getDeclaredMethod("getGender");
    System.out.println(getGender.invoke(stu));
    // 由于重载，只传入方法名无法唯一确定方法，要辅以参数列表
    Method showNation = cls.getDeclaredMethod("showNation", String.class);
    // setAccessible作用是关闭安全检查（同时临时解除私有性），以提升执行速度，不会改变原本的可见性
    showNation.setAccessible(true);
    showNation.invoke(stu, "China");
}
```

通过普通方式和反射方式都能创建对象及调用成员，那么到底采用哪一种取决于具体场景。前者适合静态场景，后者适合动态场景，在静态场景中无法统一地、灵活地进行对象构造、方法调用等，这只能靠反射实现，联系一些经典例子去理解：

- 动态代理-AOP的原理。
- JDBC中BaseDao的通用查询方法。

### Class

Class是反射的源头。

类加载过程：程序经javac.exe执行以后，得到字节码（class）文件，接着用java.exe命令对字节码文件解释运行，相当于将字节码文件加载到内存中，此即类加载。加载到内存里的类叫运行时类，这个类本身就是Class类的一个实例（类也成了对象，故万物皆对象），这个Class实例将缓存一段时间，且在此期间对应这个类的Class实例就它一个，后续可能被JVM回收。

虽然类是实例，但是语法不允许将类名赋给Class变量，于是上例转而用等价的`类名.class`，也有其他方式。Class对象是无法new出来的，只能由某个运行时类充当。有四种方式获取Class实例：

```java
@Test
public void testGetClass() throws ClassNotFoundException {
    // 方式一：通过类的隐含的class属性 可以指明泛型
    Class<Student> cls1 = Student.class;
    Student stu = new Student();
    // 方式二：通过实例调getClass方法 这里可用通配符泛型，因为stu可能属Student的子类
    Class<? extends Student> cls2 = stu.getClass();
    // 方式三：通过全限定类名
    Class cls3 = Class.forName("reflect.Student");
    // class reflect.Student
    System.out.println(cls3);
    // true 这几种方式得到的Class对象实体都是同一个，也体现了某类的唯一性
    System.out.println(cls1 == cls2);
    // 方式四：使用系统类加载器
    ClassLoader classLoader = ReflectTest.class.getClassLoader();
    Class cls4 = classLoader.loadClass("reflect.Student");
}
```

比较这些方式。最后一种用得很少；第二种没能表现反射的意义，因为对象都出来了，我们就是要通过反射隐式地造对象；第一种是不适合动态场景，受编译器检查；第三种用得最多，类名更自由，编译期不知道要造什么类的对象，运行期才知道，所以会抛类找不到的异常，体现了动态性。

其他元素都算Class实例，包括接口、成员、数组、枚举、基本数据类型、void、注解。具体地如数组Class实例的唯一性由类型和维数决定。

### 类的加载

广义的类加载包括以下三个阶段：

![类的加载](java.assets/类的加载.png)

类加载器的作用是把类（字节码）装载进内存。JVM规范定义了以下几种类加载器：

- 引导类加载器（bootstrap classloader）：由c++编写，用来装载Java核心类库。
- 扩展类加载器（extension classloader）：负责将指定目录下的jar包装入工作库。
- 系统类加载器（system classloader）：负责将指定目录下的类（字节码）与jar包装入工作库，最为常用。

利用类加载器加载配置文件：

```java
Properties props = new Properties();
ClassLoader classLoader = ReflectTest.class.getClassLoader();
// 相对路径起始于classpath（字节码根路径，对应所有源码包下的东西）
InputStream is = classLoader.getResourceAsStream("db.properties");
try {
    props.load(is);
    String name = props.getProperty("name");
    String age = props.getProperty("age");
    System.out.println(name + " " + age);
} catch (IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (is != null) {
            is.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

### 应用

通过反射创建对应运行时类对象：

```java
@Test
public void testNewInstance() throws IllegalAccessException, InstantiationException {
    Class<Student> cls = Student.class;
    Student student = cls.newInstance();
    System.out.println(student);
}
```

底层仍然用到构造器，所以构造器是创建对象的必要条件，那么就推出通过反射创建对象的两点要求：

- 运行时类提供了无参构造器。上例中的InstantiationException反映了这一点。
- 无参构造器还得是非私有的。上例中的IllegalAccessException反映了了这一点。

无参构造器更为通用，因为各类有参构造器的参数列表不统一。

关于获取运行时类的完整结构，例子就不举了，太繁琐了。众多框架的底层使用这些API。

要掌握调用运行时类的指定成员，可参考本章第一个例子。

## Lambda表达式

注：Java 8是5以来最具革命性的版本，在语法、编译器、类库等方面产生大量新特性。

这个东西是从别的语言那里抄过来的。

```java
// lambda表达式
Runnable runnable = () -> System.out.println("我在调用run方法");
runnable.run();
Comparator<Integer> comparator1 = (i1, i2) -> -Integer.compare(i1, i2);
System.out.println(comparator1.compare(10, 20));
// 方法引用
Comparator<Integer> comparator2 = Integer::compareTo;
System.out.println(comparator2.compare(80, 60));
```

它的本质是接口的匿名实现类的匿名实例，没有接口它就没意义了。

它要求接口只能含一个抽象方法。这个能理解，是唯一性的问题，假定可存在两个抽象方法，它们参数列表、返回值类型都相同，就名字不同，那都转成lambda表达式名字都省略了，编译器就分不清了。

格式：

- `->`：lambda操作符或箭头操作符。
- `->`左边：接口中抽象方法的形参列表对应的形参列表，形如`(类型1 参数名1, 类型2 参数名2...)`。
- `->`右边：对抽象方法重写的方法体，形如`{...}`。

关于具体格式：

- 参数类型可省略，可根据接口里的方法参数列表推断。
- 当仅有一个参数，小括号可省略。
- 当仅有一条语句，花括号可省略。
- 当仅有一条语句且为返回语句，花括号、return可省略。

仅含一个抽象方法的接口叫函数式接口。我们自定义函数式接口时可带上@FunctionalInterface以让编译器帮着检查，跟@Override同理。lambda表达式依赖函数式接口。

Java内置一些函数式接口于java.util.function下，其中有四个基本的：

- 消费：`Consumer<T> 含 void accept(T t) `。
- 供给：`Supplier<T> 含 T get()`。
- 函数：`Function<T, R> 含 R apply(T t)`。
- 断定：`Predicate<T> 含 boolean test(T t)`。举个例子：

```java
/**
 * @param list      被筛选的字符串列表
 * @param predicate 断定器
 * @return
 */
public static List<String> filterString(List<String> list, Predicate<String> predicate) {
    List<String> filteredList = new ArrayList<>();
    for (String string : list) {
        // 具体调用断定器下的test方法判定
        if (predicate.test(string)) {
            filteredList.add(string);
        }
    }
    return filteredList;
}

/* 测试 */
List<String> strings = Arrays.asList("中国", "美国", "法国", "俄罗斯", "英国");
// 重写、定义Predicate接口的test方法
List<String> filteredList = LambdaTest.filterString(strings, string -> string.contains("国"));
System.out.println(filteredList);
```

另有它们衍生出的变体。

下面看方法引用（method reference）：针对某函数式接口隐式定义匿名实现类，在实现方法体内调用被引用方法，被引用方法的返回值作实现方法的返回值。

可以将lambda表达式进一步简化为方法引用的写法。具体有以下几种形式：

- `对象::实例方法`：通过现有对象调用被引用方法，实现方法的实参作被引用方法的实参。
- `类::静态方法`：通过类调用被引用方法，实现方法的实参作被引用方法的实参。
- `类::实例方法`：通过此类实例调用被引用方法，实现方法的实参划分成此类实例和被引用方法的实参。

```java
public class Citizen {
    private Integer age;
    private static String nation = "China";

    public Citizen() {
        age = 18;
    }

    public Citizen(Integer age) {
        this.age = age;
    }

    public static String getNation() {
        return nation;
    }

    public Integer getAge() {
        return age;
    }
}

/* 测试 */
Consumer<String> consumer = System.out::println;
consumer.accept("我爱你中国");

// getNation是静态方法
Supplier<String> supplier = Citizen::getNation;
System.out.println(supplier.get());

// String是类而equals又是实例方法
BiPredicate<String, String> biPredicate = String::equals;
System.out.println(biPredicate.test("too", "to"));
Function<Citizen, Integer> function = Citizen::getAge;
System.out.println(function.apply(new Citizen(23)));
```

发现被引用方法都不用加括号，原因就是被隐式调用。我们通过等价写法来对照一下：

```java
/* 第一种形式：通过System.out对象调用println方法 */
Consumer<String> consumer = new Consumer<String>() {
    @Override
   	// 实现accept，调用println
    public void accept(String s) {
        System.out.println(s);
    }
};
// accept的实参作println的实参，println的返回值作accept的返回值
consumer.accept("我爱你中国");
/* 第二种形式：通过Citizen类调用getNation方法 */
Supplier<String> supplier = new Supplier<String>() {
    @Override
    // 实现get，调用getNation
    public String get() {
        return Citizen.getNation();
    }
};
// get的实参作getNation的实参（只不过这里空参），getNation的返回值作get的返回值
System.out.println(supplier.get());
/* 第三种形式：通过String类的实例调用equals方法 */
BiPredicate<String, String> biPredicate = new BiPredicate<String, String>() {
    @Override
    // 实现test，调用equals
    public boolean test(String s1, String s2) {
        return s1.equals(s2);
    }
};
// equals的实参与String实例一起组成test的实参，equals的返回值作test的返回值
System.out.println(biPredicate.test("too", "to"));
/* 第三种形式：通过Citizen类的实例调用getAge方法 */
Function<Citizen, Integer> function = new Function<Citizen, Integer>() {
    @Override
    // 实现apply，调用getAge
    public Integer apply(Citizen citizen) {
        return citizen.getAge();
    }
};
// getAge的实参与Citizen类的实例一起组成apply的实参
System.out.println(function.apply(new Citizen(23)));
```

构造器引用与方法引用同理，我们设定构造器的返回值类型是本类。

```java
Supplier<Citizen> supplier = Citizen::new;
System.out.println(supplier.get());
```

还有数组引用：

```java
Function<Integer, Double[]> function = Double[]::new;
System.out.println(Arrays.toString(function.apply(3)));
```

## Stream

### 概述

Java 8有两大重大革新-lambda表达式与Stream API。

Stream API（java.util.stream）真正引入函数式编程（OOF）风格，让写代码更高效，让代码更简洁。

具体它优化对集合的操作，如查找、过滤、映射，还支持并行操作。

Stream与Collection的区别：后者是面向内存的数据结构，前者是面向CPU的计算方式。

Stream本身不负责存储元素，不改变原容器，支持链式调用且调用到终止操作时才执行中间操作链。

练多了就越来越觉得Stream很像SQL，确实它借鉴了SQL的思想。

### 使用

#### 中间操作

中间操作都是延迟执行的，即链式调用到终止操作才会按序或并行执行。

筛选与切片：

```java
/* 准备一个列表属性employees */
/* filter方法：按条件过滤元素 */
Stream<Employee> stream = employees.stream();
// filter传入断定器 forEach属终止操作，传入的是消费器
stream.filter(employee -> employee.getSalary() > 5000).forEach(System.out::println);

/* limit方法：仅保留前若干元素 */
// 传入长整型数
employees.stream().limit(2).forEach(System.out::println);

/* skip方法：跳过前若干个元素 */
// 传入长整型数
employees.stream().skip(3).forEach(System.out::println);

/* distinct方法：去除重复元素，这个重复性依赖hashCode与equals方法 */
// 元素所属类别忘了重写俩方法，不然按默认的地址值去比了
employees.add(new Employee(10, "元稹", 24, 3200));
employees.add(new Employee(10, "元稹", 24, 3200));
employees.add(new Employee(10, "元稹", 24, 3200));
employees.stream().distinct().forEach(System.out::println);
```

映射：

```java
/* 出现了链式调用 map方法传入的是函数器 */
employees.stream().filter(employee -> employee.getSalary() > 5000).map(Employee::getName).forEach(System.out::println);
// 用了并行（多线程）打出来的顺序就不一定了。。
employees.parallelStream().map(employee -> {
    employee.setSalary(employee.getSalary() + 1000);
    return employee.getSalary();
}).forEach(System.out::println);
```

排序：

```java
IntStream intStream = Arrays.stream(new int[]{2, 7, 3, 1, 6, 5, 0, 4, 8});
intStream.sorted().forEach(System.out::println);
employees.stream().sorted((employee1, employee2) -> {
    int salary = Double.compare(employee1.getSalary(), employee2.getSalary());
    if (salary != 0) {
        return salary;
    } else {
        return Integer.compare(employee1.getAge(), employee2.getAge());
    }
}).forEach(System.out::println);
```

#### 终止操作

Stream对象是不可重用的，即一旦调用终止操作就不可再调用中间操作，只能重新获取一个Stream对象。

匹配与查找：

```java
// 以下三个传入的是断定器
boolean allMatch = employees.stream().allMatch(employee -> employee.getAge() > 20);
boolean anyMatch = employees.stream().anyMatch(employee -> employee.getAge() > 50);
boolean noneMatch = employees.stream().noneMatch(employee -> employee.getName().contains("江"));
Optional<Employee> first = employees.stream().findFirst();
Optional<Employee> any = employees.stream().findAny();
long count = employees.stream().count();
// 以下两个传入的是外部比较器 注意两个方法引用，说明不同形式能达到相同效果，底层智能实现
Optional<Integer> max = employees.stream().map(Employee::getAge).max(Integer::compareTo);
Optional<Double> min = employees.stream().map(Employee::getSalary).min(Double::compare);
// 内部迭代
employees.stream().forEach(employee -> System.out.println(employee.getId()));
// 外部迭代 forEach是Iterable接口的默认方法，Collection继承此接口
employees.forEach(System.out::println);
```

归约：

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);
// reduce参数类型是BiFunction接口，重写的是apply方法，此方法有两个参数，想做累加就要保证俩参数、返回值三者类型一致
Optional<Integer> sum = nums.stream().reduce(Integer::sum);
Optional<Double> totalSalary = employees.stream().map(Employee::getSalary).reduce(Double::sum);
```

收集：

```java
// 将filter返回的Stream对象转成集合
List<Employee> collect1 = employees.stream().filter(employee -> employee.getSalary() > 8000).collect(Collectors.toList());
Set<Employee> collect2 = employees.stream().filter(employee -> employee.getSalary() > 9000).collect(Collectors.toSet());
```

### Optional

一个容器类，从谷歌那抄来的，保存单个数据，即其下名为value的泛型final域，作用是避免空指针异常。

```java
/* outerName是测试类的一个属性，充当未知是否为null的字符串 */
Employee employee = new Employee();
// 调用静态ofNullable方法，将一个可能为null的值封装进Optional对象，作value域
Optional<String> nameOpt = Optional.ofNullable(outerName);
// 再由此对象调orElse方法，传入一个备胎，若所存值真是null，则返回备胎，否则返回所存值
String name = nameOpt.orElse("无名氏");
employee.setName(name);
System.out.println(employee.getName().length());
```

