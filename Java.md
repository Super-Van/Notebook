# Java

参考视频：[尚硅谷Java入门视频教程](https://www.bilibili.com/video/BV1Kb411W75N?spm_id_from=333.999.0.0)。

由于此前上课学过一些知识，有些细节此处就不记了，可参考[菜鸟教程](https://www.runoob.com/java/java-tutorial.html)等教程。

## 概述

JDK=JRE+开发工具集（编译器javac.exe等）。

JRE=JVM+Java SE标准类库。JVM实现“一次编译，到处运行”。

核心机制是java虚拟机和垃圾回收机制（即使有此机制也不能完全避免内存溢出或内存泄漏等问题）。

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

那么文件找不到的问题就不能归咎于大小写，可能是拼错了或路径错了。

java命令则不同，它的作用对象是字节码文件里的类，就对大小写敏感了。如：

```shell
# java作用于类，故无需后缀
java HelloChina
# 报错：找不到或无法加载主类 报错就当然不会产生.class文件
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
// China.java
class Hello {

}
class Person {

}
// javac china.java编译成功
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
java hello
# 错误: 在类 Hello 中找不到 main 方法, 请将 main 方法定义为: public static void main(String[] args) 否则 JavaFX 应用程序类必须扩展javafx.application.Application
```

注释内容不会被编译，即字节码文件中不包含注释有关的东西。

文档注释可以被JDK提供的javadoc工具解析，生成一套以网页形式呈现的该程序的说明文档。

```shell
javadoc -d myDoc -author -version HelloWorld.java
```

多行注释禁止套娃。

## 基本语法

### 概述

本章记录众多编程语言共有的一些知识，比如关键字和保留字、变量和运算符、分支语句和控制语句（流程控制）等等。

### 关键字与保留字

关键字统统小写，用多了就有印象了（IDE也会盯死你的）。有三个用于定义数据的字面值严格来讲不算关键字，但常被纳入关键字，它们是：true、false、null。

有些单词尚未成为关键字（尚未投入使用），但以后可能是（也可能不是，就一直占着），我们也要避开它们。如goto、const。

### 标识符

自己取名字的地方都叫标识符，如变量名、方法名、类名等。

关于命名规范，虽不强制，建议大家遵守。包名全小写；类、接口名大驼峰；变量、方法名小驼峰、常量名全大写下划线分隔。

### 变量与运算符

#### 变量

##### 概述

概念：

- 对应内存中的一块存储区域。

- 程序中最基本的存储单元。

- 要素包括变量类型、变量名及存储的值。值的范围由类型决定。

  ```java
  // 数据类型 变量名 = 变量值 不像C语言，Java要求边定义边初始化
  int age = 23;
  ```

作用：在内存中保存数据。

要点：

- 先声明（定义），后使用，声明就是指明类型。
- 通过变量名访问对应的存储区域。
- 只在作用域内生效，某变量作用域内不能定义同名变量，作用域由一对`{}`确定。

##### 类型

数据类型划分：

<img src="D:\chaofan\typora\专业\Java.assets\image-20220302194956774.png" alt="image-20220302194956774" style="zoom:67%;" />

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

但Unicode表示法允许“多个字符”的出现，我们应当把这多个字符理解为一串代号。这种表示法用得很少，因为记不住这么多如此复杂的代号。

```java
// 表字母A
char c = '\u0041'
```

附带讲一下字符集（编码系统）的问题。计算机不断地进行我们认识的字符与肉眼看不懂的底层比特流（01序列）的转换，就像电报的翻译需要密码本一样，字符与比特流的转换也就需要一个字符集。如美国人发明的ASCⅡ码，将128个字符映射为128组01序列，如A对应01000001即十进制的65。随着互联网的壮大，吸收更多国家文字的字符集相继问世，如今非常通用的字符集是UTF-8，它是Unicode的一种实现方式。我们编程时要在出现字符集设定的地方做到统一设定，避免乱码。

关于boolean，就不谈占多少字节和取值范围，因为拢共就去两个值-true和false。

最后谈谈String-字符串，它不是基本数据类型，但怎奈出镜率太高，所以先行在此谈谈，之后会专门开一章展开谈。

String是引用数据类型，属类范畴。看一些例子：

```java
String s1 = "a";
String s2 = "abc";
// 含空格的非空串
String space = " ";
// 空串
String blank = "";
// 附带讲，char型字面值多了少了都不行，不允许空字符
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

##### 转换

7中类型（除开boolean）之间的转换：

- 自动类型提升。
- 强制类型转换。

从大范围向小范围的转换，想来是不合适的。

```java
byte small = 1;
long big = 129L;
// 编译不通过：不兼容的类型，可能会有损失
byte sum = small + big;
```

那么反过来就是合适的。

```java
// 可行
long sum = small + big;
// 也可行 130.0
float sumF = small + big;
```

向上（取值范围从小到大）的类型转换是自动的，即范围小的变量与范围大的变量做运算时结果类型可以像大范围的类型自动转换。

```java
// true
System.out.println((Object) (small + big) instanceof Long);
// 不加L尾缀也能产生自动向上转型 int->long
long intL = 10000;
```

根据字符集，一些字符是可以等价为数值的，因此char变量有时也能参与数值运算。

```java
// 译为97
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
// 编译不通过
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

至于为什么这样规定，尚未找到合理解释。一个可能的解释是避免两个小范围变量运算（比如求和）后结果的范围超了那个更大类型的范围，如两个byte型的128相加得到256就超出了byte型的取值范围。

看一些自动向上转型的其他例子：

```java
int i = 10;
char b = 'b';
// 1000000.0 再次注意有时可能丢失精度
double doubleI = i * 1E5;
// 245.0
double dobuleB = b * 2.5;
```

我们强制（手动）实现大范围向小范围的转换，某些时候确有此种需求，就产生了强制类型转换。当然强制类型转换除向下（范围从大到小）转型外还有其他的情况，非自动转型的情况都属于强制类型转换。

```java
double d = 12.3;
// 12 截断即下取整
int intD = (int) d;
// 同空间类型强转
byte n = 110;
char nCh = (char) n;
// 向下且跨域
double o = 111;
char oCh = (char) o;
// 晓得强转写法
byte factor = 2;
byte product = (byte) (factor * 1);
// 编译失败：不加F尾缀，那是让系统帮着实现double->float？当然不行了，向下转型是手动的 修正：要么冠以(float)要么加尾缀F
float wrongF = 120.01;
// 编译失败 int->short
short minus = 6;
minus = 6 - 5;
```

应当了解向上转型（int->float long->float long->double）和向下转型都可能导致精度损失，前者产生于小数点之前，后者产生于小数点之后。

```java
// 离谱的精度损失-连范围都超出了
int val = 128;
// -128
byte bVal = (byte) val;
```

整型字面量默认类型为int，浮点型字面量默认类型为double。

```java
char w = 'w';
int wI = w + 8;
double wD = w + 10.;
```

##### 进制

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

#### 运算符

Java里的运算符不外乎：算术、赋值、比较（关系）、逻辑、位、三元。

##### 算术

给一些有趣的例子：

```java
int num1 = 10;
int num2 = 4;
// 2 先得浮点结果2.5，再截断
int division1 = num1 / num2;
// 从左往右算，还是先int型的2，再乘上4 而不是以浮点型乘4
int product = num1 / num2 * num2;
// 2.0 先得到int型的2，再自动向上转型为浮点的2.
double division2 = num1 / num2;
// 2.5 没有自动提升的条件，可以手动强转
System.out.println((double) num1 / num2);
// 也可以创造自动提升的条件
System.out.println(num1 / (num2 + 0.0));
int m1 = -7;
int m2 = -2;
// -1 余数的符号与被模数符号一致 我们几乎不会离谱到用负的取模
System.out.println(m1 % m2);
```

##### 自增

这个没啥好说的，注意前置自增与后值自增的区别就行了。
