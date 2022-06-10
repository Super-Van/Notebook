# HTML5+CSS3

参考视频：[前端入门视频教程](https://www.bilibili.com/video/BV14J4114768)。

精通网页的结构、样式是前端开发人员的必备技能，也是学习JavaScript的基础。

就重要性和难度上说，CSS高于HTML。

## HTML

### 概述

#### 网页

网站是一个网页集合。

网页是构成网站的基本元素。一个网页就是一个文件，它要通过浏览器来阅读。它通常由图片、链接、文字、音视频等元素组成。一般的网页文件以.html或.htm结尾，因而俗称为html文件。

html指超文本标记语言（hyper text markup language），它是用来描述网页的语言。它不是一门编程语言，而是一门超级简单的标记语言。标记语言就是一套标记标签（markup tag）。

所谓超文本，有两层含义：

- 它由浏览器解析后所呈现的内容不止于文本，还能有图片、音视频等。
- 它可以从一个文件跳转到另一个文件，与世界各地服务器上的文件建立联系。

网页是由网页元素形成的，这些元素由html标签描述、由浏览器解析。

#### 浏览器

关于浏览器这里要谈两点：常用浏览器和浏览器内核。

浏览器是网页运行、显示的平台。常用的浏览器有IE（internet explorer）、火狐（Firefox）、谷歌（Chrome）、Safari和Opera等，它们并称为五大浏览器。

浏览器内核（渲染引擎）：负责读取网页内容、整理讯息、计算网页的显示方式并显示。

| 浏览器       | 内核    | 备注                    |
| ------------ | ------- | ----------------------- |
| IE           | Trident | IE、猎豹、百度          |
| Firefox      | Gecko   |                         |
| Safari       | Webkit  |                         |
| Chrome/Opera | Blink   | Blink其实是Webkit的分支 |

#### Web标准

web标准是由W3C（万维网联盟）组织和其他标准化组织制定的一系列标准的集合。

为什么需要web标准呢？因为不同浏览器在页面的展示上有或多或少的差异，这加重了开发者的负担，故需统一化。还有其他方面原因，这里不赘述。

web标准如何构成？主要包括结构（structure）、表现（presentation）、行为（behavior）三个方面。

| 标准 | 说明                                     |
| ---- | ---------------------------------------- |
| 结构 | 用于对网页元素进行整理和分类。主要指html |
| 表现 | 用于设置网页元素的外观样式。主要指css    |
| 行为 | 用于定义网页模型和设定交互。主要指js     |

web标准提倡结构、样式、行为相分离，即html代码写进html文件、css代码写进css文件、js代码写进js文件。

###  基本语法

课堂上学过一些基础知识，这里说几点：

- 标签必须由尖括号包围。

- 标签通常成对出现（叫双标签），极少标签是单标签。

- 双标签之间的关系只有两类：并列和包含。

### 基本结构标签

即不可或缺的标签，有html、head、title、body。看一个最简单的例子：

```html
<html>
    <head>
        <title>基本结构</title>
    </head>
    <body>
        键盘敲烂，月薪过万
    </body>
</html>
```

### 开发工具

我们选用VS Code。

新建html文件时，它会自动生成一些新的东西，一一解读一下：

- `<!DOCTYPE html>`是文档类型声明，负责告诉浏览器用哪个标记版本来解析html。此处指示的是最新版本即html5。它必须出现在文档的第一行。它本身不是html标签。

- `<html lang="en">`中的lang（language）属性负责定义网页的语言。en指英文（zh-CN指中国大陆）。这个属性不太重要，浏览器会根据它进行翻译之类的工作。

- `<meta charset="UTF-8">`中的charset（character set）属性指字符集，用于告知计算机基于何种编码方式解析。UTF-8基本涵盖全世界所有字符。

### 常用标签

#### 标题

从h1到h6。h是head的缩写。一个标题独占一行。

#### 段落

p是paragraph的缩写。文字会随着浏览器窗口大小的变化自动换行。每个段落之间有空隙。

#### 换行签

即`<br/>`。br是break的缩写。与p标签相比，它在文字换行后不会添加垂直间距。

#### 文本格式化

加粗：`<strong></strong>`或`<b></b>`。

倾斜：`<em></em>`或`<i></i>`。

删除线：`<del></del>`或`<s></s>`。

下划线：`<ins></ins>`或`<u></u>`。

#### div和span

这俩是没有语义的，它们就是一个”盒子“，用来装其他元素或文本。

div是division的缩写，表分割、分区；span表跨度、跨距。

div常用来布局，独占一行；span不独占一行，为行内元素。

#### 图像

img是image的缩写。

src（source）是它的必须属性，用于指定图像文件的路径。

title属性指提示文本。

alt（alternative）属性指替换文本。

width和height属性分别指定图像的显示宽度和显示高度。形如`width=“400” height=“300”`。

border属性指定图像的边框粗细。形如`border=“10”`。

一般不用属性修改图像的样式，而是通过css。

图片格式归纳入下：

|      | 存储                                     | 透明           | 动图   |
| ---- | ---------------------------------------- | -------------- | ------ |
| gif  | 仅256种颜色，体积小                      | 全透明或不透明 | 支持   |
| jpg  | 有损压缩，体积小                         | 不支持         | 不支持 |
| png  | 无损压缩，体积小                         | 支持           | 不支持 |
| svg  | 矢量式存储，适用于颜色和形状类别少的图像 | 不支持         | 不支持 |

注：在css中只修改图片的宽（高）度，则其高（宽）度会自适应（等比例）变化。

#### 超链接

a是anchor的缩写。

href（hypertext reference）属性用于指定目标地址。

target属性指定目标页面的打开方式：\_self表示在当前标签页打开（默认）；\_blank表示在新标签页打开。

链接分类：

- 空链接：`href="#"`。
- 下载链接：href的值指向一个.exe文件、.zip文件等类型的文件。
- 网页元素链接：用a标签包裹其他标签。

还有一个很常见的链接是锚（点）链接，通过它可以快速定位到本页中的某个位置。形如：

```html
<a href="#live">个人生活</a>
<h3 id="live">
    个人生活
</h3>
```

#### 注释和特殊字符

注释标签：`<!-- 注释 -->`。

特殊字符请参阅[HTML转义字符](https://tool.oschina.net/commons?type=2)。

#### 表格

表格用于整齐地展示数据，提升可读性，旧时代的程序员们还常用它来进行布局。

table标签定义表格；tr标签定义行；td标签定义非表头单元格；th（table head）标签定义表头（第一行）的单元格。注意它们的嵌套关系。

其属性在实际开发并不常用，还是通过css设置更好。这里列举一下主要属性（均写入table标签）：

- align：表格相对周围的对齐方式。
- border：单元格是否有边框。
- cellpadding：单元格的内容和边框的间距。
- cellspacing：单元格间的间距。
- width（height）：表格的宽度（高度）。如`width="500"`。

注：不提倡指明的属性在vscode中会显现白色。

为了更好地表达表格的语义，我们总在结构上将表格分为表格头部thead和表格主体tbody两大部分。

```html
<table>
    <thead>
    	<tr></tr>
    </thead>
    <tbody>
    	<tr></tr>
        <tr></tr>
        <tr></tr>
    </tbody>
</table>
```

合并单元格：

- 跨行合并：将`rowspan="个数"`写入起始td标签。多余的td元素删除。
- 跨列合并：将`colspan="个数"`写入起始td标签。多余的td元素删除

#### 列表

列表标签是用来布局的，即包裹（li标签包裹）其他标签。其特点是整齐、有序。列表分为无序列表、有序列表和自定义列表，下面我们一一讨论。

ul（unordered list）标签对应无序列表，其中只能包裹若干无先后关系的li标签，然后li标签再容纳普通文本或其他标签。它自带设好的样式属性，后面我们会用css进行修改。

ol（ordered list）标签对应有序列表，其中只能包裹若干有先后关系的li标签，显示时每项li元素前会标有数字。它也自带设好的样式属性。

dl（defined list）标签对应自定义列表，常用于对术语进行多项描述。其中仅能包裹dt标签（术语或标题）与dd标签（描述或分类），然后这俩又能包裹其他任何标签。dd元素前无任何项目符号。

#### 表单

表单的作用收集信息，信息可能来自用户也可能来自其他方面。

一个完整的表单通常由表单域、表单控件（表单元素）、提示信息组成。

##### form

form标签定义表单域：

```html
<form action="提交地址" method="提交方式" name="表单域名称">
    <!-- 各类表单控件 -->
</form>
```

下面来看看一些定义表单控件的标签。

##### input

input是一个单标签，其type属性可取很多值，它们有：

- button：按钮。
- checkbox：复选框。诸input标签的name值相同才支持多选多。
- file：文件上传。
- hidden：隐藏输入。
- image：图像形式的按钮。
- password：密码。
- radio：单选框。诸input标签的name值相同才支持多选一。
- reset：重置。
- submit：提交。
- text：单行文本。

除type外，value属性定义input元素的值；checked属性定义input元素首次加载时被选中，形如`checked="checked"`或`checked`；maxlength属性规定输入的最大字符数；placeholder属性定义输入框内的提示信息。

label标签本非表单标签，但常用来为表单元素作标注。label绑定input示例如下：

```html
<!-- for与id相映射 -->
<label for="sex">男</label>
<input type="radio" name="sex" id="sex" />
```

#####  select

select标签定义下拉列表。

```html
<select name="home">
    <option selected="selected" hidden>请选择城市</option>
    <option value="Beijing">北京</option>
    <option value="Tokyo">东京</option>
    <option value="London">伦敦</option>
    <option value="Paris">巴黎</option>
    <option value="Hongkong">香港</option>
</select>
```

##### textarea

textarea标签定义多行文本输入，如留言板、个人说明等。其cols属性指定每行最大字符数；rows属性指定文本域显示的最大行数（总行数无限）。这俩属性也是极不重要，实际开发中不会使用，还是用css改变文本域大小。

#### 注

标签都是有语义的，故在合理的地方应该用合理的标签。比如标题当用h，大段文字当用p。

## CSS

### 概述

如果说html负责内容，那么css负责形式。

css全称是cascading style sheet，即层叠样式表。它也是一种标记语言。

### 选择器

选择器的作用是根据需求把标签选出来，简而言之，就是选择标签用的。

完整的选择器表可参阅[CSS3选择器](https://www.w3school.com.cn/cssref/css_selectors.asp)。选择器越多，我们就能越灵活、方便地筛选出目标元素。

#### 基本选择器

无非四大类：

- 标签选择器：同名元素应用同一样式。
- 类选择器：同类元素应用同一样式。而且某元素可属多个类，形如`class="one two three"`，这样做的好处的各元素既能有公共的样式（方便统一修改），又有各不相同的样式。
- id选择器：唯一元素应用某种样式。
- 通配符选择器：所有元素应用同一样式。

注：每个盒子（块元素）都应该起一个类名，便于寻找、选中盒子以及后期维护。

#### 复合选择器

复合选择器是由多个基本选择器可通过各种方式组合而成的。它可以更准确、高效地选定元素。常用的复合选择器有：后代选择器、子选择器、并集选择器、伪类选择器等等。

后代选择器：也叫包含选择器。选中儿子、孙子、重孙子……。

```css
ol li {
    color: pink;
}
/* 逐代 */
.nav .nav-item li {
    font-size: 20px;
}
/* 跨代，但我们提倡尽量写全以提升查找速度 */
.nav li {
    color: green;
}
```

子元素选择器：选中儿子元素：

```css
div > a {
    color: blue;
}
```

并集选择器：选中多个元素。有个规范是这些元素分行写。

```css
ul,
div {
    text-aligh: center;
}
div, 
p, 
.pig > li {
    color: purple;
}
```

伪类选择器：带特殊功能的选择。如链接伪类、结构伪类、表单伪类。

先看看链接伪类：

```css
/* 为了确保生效，务必按照下述顺序编写 */
a:link /* 未被访问（浏览器没记录） */
a:visited /* 已被访问（访问一次就会被浏览器存记录） */
a:hover /* 指针悬停 */
a:active /* 鼠标按下未弹起 */
```

开发中我们常这样写：

```css
a {
    color: #333;
    text-decoration: none;
}
a:hover {
    color: #369;
    text-decoration: underline;
}
```

再看看foucus伪类。它用于选取获得焦点的表单元素。一般情况下仅input这一类表单元素才能获取焦点，因此该选择器主要面向它们。

```css
input:focus {
    background-color: pink;
    color: red;
}
```

本节内容不算很全，以后随时补充。

### 文字属性

文本属性定义文字的字体、字号（大小）、字重（粗细）、风格等。

字体示例如下。浏览器会依次检查各字体是否装在本系统上，取最前面的。短语型属性值须包上引号。尽量使用用户系统默认字体。

```css
font-family: "Microsoft YaHei", Arial, Helvetica, sans-serif;
```

字号示例如下。px（像素）是网页常用的单位。谷歌浏览器默认的字号为16。不同浏览器默认字号可能不同，于是我们应当尽量给一个明确值。可以通过body给整个页面指定字号，但对h元素不生效（对h的父元素的字号修改在它身上都不生效），通配符选择器对其生效。

```css
body {
    font-size: 20px;
}
h2 {  
   font-size: 18px; 
}
```

字重示例如下。在实际开发中，推荐用数值表示粗细。其他解读参考[CSS font-weight 属性](https://www.w3school.com.cn/cssref/pr_font_weight.asp)。

```css
/* 取消h2的加粗 */
h2 {
    /* 下面两个等价 */
    font-weight: 400;
    font-weight: normal;
} 
```

风格示例如下：

```css
p {
    font-style: italic | normal;
}
```

文字复合属性：

``` css
p {
    /* font: font-style font-weight font-size/line-height font-family; font-size和font-family不能省略 */
    font: italic 700 20px 'Microsoft YaHei';
}
```

### 文本属性

文字属性侧重单个字符的样式，文本属性侧重整体文字样式。

颜色示例如下：

```css
div {
    color: red;
    /* 最常用 */
    color: #ff0000; 
    color: rgb(255, 0, 0);
}
```

对齐示例如下。只能设置水平对齐方式，默认为左对齐。

```css
h1 {
    text-align: center | left | right;
}
```

注意这里的文本指广义的文本，包括行内元素（如a、span）和行内块元素（如img）等。

装饰示例如下。默认为none。

```css
div {
    text-decoration: none | underline | overline | line-through;
}
/* 取消超链接的下划线 */
a {
    text-decoration: none;
}
```

缩进示例如下：

```css
p {
    text-indent: 20px;
    /* 取选中文字大小的2倍，选中文字没设字号的话以父元素为准，以此类推 */
    text-indent: 2em;
}
```

行间距（行高）示例如下。对于单行文本，行间距=上边距+字高度（字号）+下边距；对于多行文本，行间距=下一行的文字的下边缘-上一行文字的下边缘。

```css
p {
    line-height: 25px;
}
```

在单行文本条件下，未设高度的行内块元素的高度只由行高决定，且若行高也没设的话，默认行高会比字号大。

### 引入方式

内部样式表：将css代码抽取进style标签，而style标签又是在html文件内部，故名。其控制范围是本html页面。它并没有实现内容与样式的完全分离。它的权重最高。

行内样式表（内联样式表）：使用标签内部的style属性设定样式。它仅控制当前标签。不推荐大量使用（避免内容和形式过于混淆）。

外部样式表：单独建立css文件，放css代码。使用时引入：

```html
<link rel="stylesheet" href="../css/shit.css">
```

它可以控制多个html页面。它完全实现结构（内容）与样式相分离。

### Emment语法

Emment语法的前身是Zen Coding，作用是通过缩写来提高HTML或CSS的编写效率。关于详细用法可参考网上教程。

### 元素显示模式

#### 块元素

常见的块元素有h、p、div、ul、ol、li等，其中div是最典型的块元素。

特点：

- 宽高、内外边距都能修改。
- 宽度默认为父容器的100%，高度默认由内容撑大，但前提是内容不脱标。
- 本身是一个容器，里面可以放行内或块元素。

注意：文字类块元素（如p、h）里面不能放块元素（p、h、div、ul等都不行）。

#### 行内元素

也叫内联元素，诸如a、span、strong、em等，其中span是最典型的行内元素。

特点：

- 相邻行内元素处同一行。
- 对宽高的修改是无效的，默认宽高就是内容的宽高。
- 内部只能放文本、行内元素或行内块元素。a元素例外，它里面可以放块元素（只是不符合W3C标准），但不能嵌套a元素。

附带看一个有意思的例子：

```css
<style>
    div {
        width: 200px;
        height: 200px;
        background-color: pink;
    }
    img {
        /* 我们发现图片宽度为100px，意味着无视了a元素，而以更外层的div为基准，因为a的宽高是由图片决定的 */
        width: 50%;
        /* margin: 0 auto; 如果又写了这个，那么不会相对于div居中，因为img有了宽之后a就有了宽，此时外边距参照的就不是div而是a 解决方法是再加个display: block; 块级元素的外边距不会参照行内元素*/
    }
</style>

<body>
    <div>
        <a href="#"><img src="../../shopping/images/error.png" alt=""></a>
    </div>
</body>
```

#### 行内块元素

有一些元素如img、input、td，它们兼具块元素和行内元素的特点，有些资料称其为行内块元素。

特点：

- 相邻行内元素或行内块元素在同一行（行内元素特点），但它们之间会有空隙（块元素特点）。
- 默认宽高就是内容宽高（行内元素特点），但前提是内容不脱标，浮动元素除外。
- 宽高、行高及内外边距都可修改（块元素特点）。

#### 显示模式的转换

```css
a {
    display: block;
    display: inline;
    display: inline-block;
}
```

注：如何实现单行文字垂直居中？令line-height值与参考系元素的height值相等。特别地，button元素的内容默认垂直居中。

### 背景属性

可以给页面元素设定背景颜色、背景图片及其展现方式等。

背景颜色：

```css
div {
    /* 默认为透明 */
    background-color: transparent;
    background-color: #ff0055;
    background-color: rgb(255,0,128);
}
```

背景图像常应用于背景图、logo、小型图标等，优点是便于控制。

```css
div {
    background-image: none;
    background-image: url(../images/dog.jpg);
}
```

背景平铺控制背景图像的平铺效果：

```css
div {
    /* 沿纵向与横向平铺（默认） */
    background-repeat: repeat;
    /* 无平铺 */
    background-repeat: no-repeat;
    /* 仅沿横向平铺 */
    background-repeat: repeat-x;
    /* 仅沿纵向平铺 */
    background-repeat: repeat-y;
}
```

背景图像和背景颜色会共同起作用，且背景图压着背景色。

改变背景图片的位置：

```css
div {
    /* 指明两方向上的位置，顺序随意 */
    background-position: top center;
    background-position: center bottom;
    background-position: left top;
    background-position: center center;
    /* 指明一个方向的位置，另一个方向上默认居中 */
    background-position: left;
    background-position: top;
    /* 指明位置的精确值，依次写横向（右是正方向）和纵向（下是正方向）的值 */
    background-position: 20px 50px;
    /* 指明x方向上的精确值，y方向上的默认居中 */
    background-position: 20px;
    /* 方位词和精确值混用 */
    background-position: 20px top;
    background-position: left 50px;
}
```

图片的大小并不影响当前元素的宽高，比如大图并不会撑大当前元素，而是会被裁剪，于是我们可通过设置位置选取大图里的合适部分来显示。例如：

```css
body {
    background-image: url(images/bg.jpg);
    background-repeat: no-repeat;
    background-position: center top;
}
```

背景固定用来控制背景图是固定的还是随着页面（滚动条）滚动而滚动。常用于制作视差滚动效果（如[QQ官网](https://im.qq.com/)）。

```css
body {
    background-attachment: scroll | fixed;
}
```

也可理解为图片只随着我们的视线移动，跟钓鱼网站的侧边广告似的。

背景属性的复合写法没有严格的顺序，不过一般约定为：

```css
background: background-color background-url background-repeat background-attachment background-position;
background: transparent url(../images/pig.png) no-repeat fixed top center
```

我们更提倡复合写法。

CSS3新增了背景色半透明的效果：

```css
background-color: rgba(0, 0, 255, 0.3);
/* 习惯性地把透明度值里的整数0省略 */
background-color: rgba(0, 0, 255, .3);
```

### 三大特性

#### 层叠性

即覆盖性。在同等权重（优先级）、同属性的条件下，后值覆盖前值；在同属性、不同优先级的条件下，优先级最高的值生效。

#### 继承性

子元素在某些样式未设定的条件下继承父元素的这些样式。我们看在浏览器的调试工具中，继承而来的样式属性会标有`inherited from`字样。恰当地使用继承可以简化代码，降低css代码的冗余度。

继承而来的样式典型地有文本相关的样式（如text-系列、font-系列、line-height），像盒子模型相关样式就不会继承。

```css
body{
    /* 行高可不带单位 */
    font: 12px/1.5 Microsoft YaHei;
}
/* 若子元素没有设定字号，则其行高为父元素字号的1.5倍；若子元素设定了行高，则其行高为其字号的1.5倍 */
```

但需注意超链接的一些样式（如字色、下划线）并不能通过继承性来修改，转而可用通配符选择器或直接选定超链接元素本身。

#### 优先级

选择器权重-继承或通配符选择器（0）<标签、伪元素选择器（1）<类、伪类、属性选择器（10）<id选择器（100）<行内样式（1000）<`!important`（$\infin$）。

最高的权重示例如下：

```css
div {
    color: pink!important;
}
```

复合选择器会产生权重叠加的问题，最正确的方法是计算叠加后的权重。那么我们在开发中应该逐层具体地写明选择器，才可避免考虑不期而遇的权重问题。

### 盒子模型

网页布局有三大核心：盒子模型、浮动和定位。

网页布局的本质就是利用css摆盒子。

盒子模型（Box Model）的组成：外边距（margin）、边框（border）、内边距（padding）、内容（content）。

#### 边框

先看最简单最容易理解的边框。

边框由三部分组成：宽度、样式、颜色。

```css
/* 复合写法，没有严格顺序，一般按照如下顺序 */
border: border-width border-style border-color;
border: 2px solid #555;
```

边框样式常用的值有实线（solid）、虚线（dashed）、点线（dotted），完整的值可参考[CSS border-style属性](https://www.w3school.com.cn/cssref/pr_border-style.asp)。大概因为难看，其他的样式很少用。

另外，四边的框可分开写，只不过也是很丑，不常用。举例如下：

```css
border-left: 1px dotted #333;
border-top-style: solid;
border-bottem-color: yellow;
```

特别地，将border-collapse应用于td（th）元素可达到合并相邻单元格边框的目的：

```css
th {
    border: 1px solid #330022;
    border-collapse: collapse;
}
td {
    border: 1px solid #330022;
    border-collapse: collapse;
}
```

最后强调一下边框宽度会影响盒子的实际宽高。

#### 内边距

即边框和内容的间距。

```css
/* 分开写法 */
padding-left: 10px;
padding-top: 20px;
padding-right: 10px;
padding-bottem: 20px;
/* 复合写法：上 右 下 左 */
padding: 20px 10px 20px 10px;
/* 复合写法：上 左右 下 */
padding: 20px 10px 20px;
/* 复合写法：上下 左右 */
padding: 20px 10px;
/* 复合写法：上下左右 */
padding: 5px;
```

内边距也会影响盒子的实际宽高（总宽高）。于是若我们想保持盒子总宽高不变，又想添加内边距，就不得不靠缩小宽高。

浏览器检查功能所展示的元素宽高指的是包括内边距的总宽高。

典例：利用padding且不设width来让导航栏各项等间距即均匀分布，尤针对每项字数不统一的情况。

```html
<!--
 * @Author: Van
 * @Date: 2021-01-08 19:58:28
 * @LastEditTime: 2021-01-12 18:54:57
 * @Description: file content
-->
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>sina</title>
    <style>
        .nav {
            height: 40px;
            border-top: 3px solid #ff8500;
            border-bottom: 1px solid #edeeff;
            text-align: center;
        }

        .nav a {
            /* 不设width */
            text-decoration: none;
            display: inline-block;
            height: 20px;
            padding: 10px 50px;
            color: #4c4c4c;
            font-size: 12px;
            line-height: 20px;
        }

        .nav a:hover {
            background-color: #fcfcfc;
            color: #ff8500;
        }
    </style>
</head>

<body>
    <div class="nav">
        <a href="#">新浪导航</a>
        <a href="#">手机新浪网</a>
        <a href="#">移动客户端</a>
        <a href="#">微博</a>
        <a href="#">猪八戒</a>
    </div>
</body>

</html>
```

#### 外边距

外边距的简写方式跟padding是完全一致的。

外边距的典型应用-块元素水平居中（前提是宽度已设）：

```css
margin: 0 auto;
```

那么行内元素和行内块元素的水平居中设置在前面已经提到过，就是将它们视作文本，对其父容器设定：`text-align: center`。

我们需注意一下嵌套块元素垂直外边距塌陷问题。例子如下：

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        * {
            padding: 0;
            margin: 0;
        }

        .father {
            width: 500px;
            height: 500px;
            background-color: #225566;
        }

        .son {
            width: 200px;
            height: 200px;
            background-color: #993448;
            margin: 10px 20px 10px 20px;
        }
    </style>
</head>

<body>
    <div class="father">
        <div class="son"></div>
    </div>
</body>

</html>
```

对于两个子元素紧挨着父元素边界的父子关系的块元素，父元素有上外边距（或没有）同时子元素也有上外边距，则父元素的实际上外边距会取较大的上外边距（或子元素的上外边距），那么最终结果是：父元素若有上外边距，则要么取自己的，要么取子元素的，看哪个更大；若无上外边距，则虽然无外边距（margin-top属，但实际还是存在子元素上外边距大小的上外边距。解决方案：

- 为父元素设定上边框。
- 为父元素设定上内边距。
- 为父元素设定：`overflow: hidden`。

很多元素默认带有内外边距，且随着浏览器不同值还不同。故我们在布局前应清除诸元素的内外边距：

```css
/* css的第一块代码 */
* {
    padding: 0;
    margin: 0;
}
```

另外需注意：

- 对行内元素务必只设定左右内外边距，上下的设了会不起作用，也是虽然属性值非0，但实际是0。
- 行内块元素不会产生外边距塌陷问题，浮动元素自带行内块元素特性，故浮动的块元素不会产生外边距塌陷问题。
- 浮动的行内元素的上下内外边距会起作用，也无塌陷问题。

#### 注

到底用padding还是margin？大部分情况下两者可以混用，但应根据实际情况选出最优解。

我们可以通过一些手段在不设宽度的条件下让父元素宽度挤出来（高度同理）并实现子元素居中。给一些例子：

```css
/* 利用子元素外边距 */
.son {
    height: 200px;
    margin: 0 50px;
}
/* 利用父元素内边距 */
.father {
    padding: 0 50px;
}
/* 利用子绝父相 */
.son {
    position: absolute;
    top: 0;
    left: 30px;
    right: 30px;
}
```

### 圆角边框

语法：

```css
/* 四个角统一 */
border-radius: 10px;
/* 复合写法：左上角 右上角 右下角 左下角 */
border-radius: 10px 20px 20px 10px;
/* 复合写法：左上+右下 右上+左下 */
border-radius: 0 20px;
/* 分别设定：顺序必须先垂直方向再水平方向 */
border-top-left-radius: 10px;
border-bottem-right-radius: 30px;
```

应用实例：

```css
/* 圆形 */
border-radius: 50%;
/* 圆角矩形 */
border-radius: 高度的一半;
```

### 阴影

盒子阴影语法：

```css
/* h-shadow：水平阴影位置 v-shadow：垂直阴影位置 blur：模糊度 spread：阴影尺寸 color：阴影颜色 inset：内阴影 */
box-shadow: 10px 10px 10px 10px 5px rgba(0, 0, 0, .3); /* 默认外阴影 */
box-shadow: 10px 10px 10px 10px 5px rgba(0, 0, 0, .3) inset;
```

盒子阴影不占用空间，不影响元素的布局。

附带提一下文字阴影语法，文字阴影用得不多。

```css
text-shadow: h-shadow v-shadow blur color;
```

### 浮动

网页布局的本质是用css摆放盒子。

css提供三种传统布局方式：

- 普通流（标准流，文档流）。
- 浮动。
- 定位。

标准流就是元素按照默认的方式排布。具体来说有：

- 块级元素独占一行，自上而下依次排列。
- 行内元素从左到右依次排列，碰到父元素边缘则自动换行。

标准流是最基本的布局方式。

实际开发中，一个页面基本包含全部三种布局方式（移动端又有别的新的布局方式）。

我们作布局的一般性经验是从外到内，先垂直后水平。

#### 作用

有很多特殊的布局效果标准流无法完成，此时就可借助浮动实现，因为浮动可改变元素的默认排列方式。

浮动的最典型应用是让若干块级元素在行内横向排列。

#### 使用

float属性解读：将浮动的块元素往某一边移动，直到其左边缘或右边缘（带外边距）碰到父容器（带内边距）或另一个浮动块元素的边缘（带外边距）。

语法：

```css
float: left | right;
```

#### 特性

施加浮动的元素会具备一些特性：

- 脱离标准文档流（脱标），不再保留原有的位置。对照PS图层的概念理解，上一层相对于下一层就是浮起来的。

- 若父元素未脱标，浮动子元素在行内显示并靠父元素顶部（带内边距）对齐，（带外边距）碰到父元素右边界（带内边距）另起一行。其他祖先元素也会影响它们的换行。

- 任何元素只要添加浮动属性就具有行内块元素的性质，例如：

  ```css
  span {
      float: left;
      /* 宽高可修改 */
      width: 200px;
      height: 100px;
      background-color: pink;
  }
  p {
      float: right;
      /* 宽度依内容变化而非父容器宽度的100% */
      height: 200px;
      background-color: purple;
  }
  ```

根据上面的特性，我们一般采取的策略是：先用标准流的父元素作好垂直排布，之后对内部子元素采用浮动排列作好水平排布，故而符合网页布局第一准则。

有个难点需要注意：浮动元素只能压住后面的标准流元素，而压不住前面的。例如：

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        * {
            padding: 0;
            margin: 0;
            list-style: none;
        }

        .box {
            width: 500px;
            height: 200px;
            background-color: pink;
        }

        .box div {
            width: 100px;
            height: 100px;
        }

        .first-child {
            float: left;
            background-color: yellow;
        }

        .second-child {
            background-color: purple;
        }

        .third-child {
            float: left;
            background-color: rgb(34, 150, 73);
        }
    </style>
</head>

<body>
    <div class="box">
        <div class="first-child">1</div>
        <div class="second-child">2</div>
        <div class="third-child">3</div>
    </div>
</body>

</html>
```

在很多情况下，标准流里的父盒子不方便给高度，因为子盒子数量在动态变化。而我们一旦不设父盒子的高度（即默认为0，浮动的子盒子撑不高父盒子），子盒子们已脱离标准流，那么后面的标准流元素就挤上来被遮住。我们希望子盒子撑大父盒子的高度。

解决方法就是给父盒子用上clear属性，清除浮动带来的定位影响。语法：

```css
/* 清除左浮动、右浮动、左浮动和所有浮动 */
clear: left | right | both;
```

这是实际开发中的常用做法，另外还有其他的做法：

- 额外标签法：在诸浮动元素后面紧接一个清除浮动的空元素。

  ```html
  <div class="box">
      <div class="float">1</div>
      <div class="float">2</div>
      <div class="float">3</div>
      <!-- 清除浮动造成的定位影响即不让前面三个压着自己 而后为父元素作高时就只盯着最后一个无浮动的标准流元素 -->
      <div style="clear: both"></div>
  </div>
  ```

- 给父元素添加overflow属性：

  ```css
  overflow: hidden | auto | scroll;
  ```

- 伪元素法：给父元素添加clearfix类。

  ```css
  .clearfix:after{
      content: "";
      /* 必须是块元素 */
      display: block;
      /* 又不能占位置 */
      height: 0px;
      /* 存在的意义就是清除浮动的影响 */
      clear: both;
      /* 还应该看不见 */
      visibility: hidden;
  }
  .clearfix{
      /*IE6、7专有*/
      *zoom: 1;
  }
  ```

- 双伪元素清除浮动：给父元素添加clearfix类。

  ```css
  .clearfix:before, .clearfix:after{
      content: "";
      display: table;
  }
  .clearfix:after{
      clear: both;
  }
  .clearfix{
      *zoom: 1;
  }
  ```

### 定位

#### 概述

意思是相对于原位置或父元素确定元素的位置，本质上也是摆放盒子。

组成：定位模式+位置偏移。

```css
/* 定位模式 */
position: static | relative | absolute | fixed;
```

边偏移的相关属性有四个：top、bottom、left、right。注意：

- 元素的边缘是带外边距的边缘。
- 当top和bottom都设值或left和right都设值，只执行top和left。

#### 静态定位

静态定位是元素的默认定位方式，意即无定位。该模式下边偏移属性失效。在布局中静态定位用得很少。

#### 相对定位

相对定位是指元素相对于默认位置作偏移。

可联系小学数学中的平移来理解，比如相对于原来位置右移100px、下移50px，可写作：

```css
position: relative;
/* 向右平移 */
left: 100px;
/* 向下平移 */
top: 50px
```

特点：

- 元素不会脱离标准流，即使实际位置改变了，后续元素的排布也依然参照其原来的位置。
- 相对定位的主要作用是配合绝对定位，给绝对定位元素当父元素。
- 元素默认层级会大于无定位的标准流元素和浮动元素的层级，即压着它们。

#### 绝对定位

绝对定位是指元素相对于最近一个有定位（绝对、相对、固定都可）的祖先元素作偏移，无视此祖先元素的内边距。

```css
position: absolute;
/* 本元素的右边缘距某祖先元素右边缘100px */
right: 100px;
/* 本元素的下边缘距某祖先元素下边缘100px */
bottom: 100px;
```

若元素所有的祖先元素都无定位，其相对于浏览器（body）作偏移。

元素脱离标准流，原来的位置不再占有。

”子绝父相“的理解：当浮动达不到复杂的定位要求时，我们就想给子元素添加绝对定位，而前提是父元素也需要添加定位，那么父元素加哪一种定位呢？相对、绝对还是固定？因为父元素后面往往有其他元素，它设成绝对或固定定位的话就会脱标，所以我们一般给父元素添加相对定位。

绝对定位元素的`margin: auto`设置不能实现水平居中效果。

绝对定位元素的默认宽度就不是父元素的100%了，而是内容宽度。我们要想设定宽度的话要么指明width要么通过left加right属性指定，比如下面这个子元素：

```css
.son {
    position: absolute;
    top: 0;
    bottom: 20px;
    left: 0;
    right: 30px;
    background-color: powderblue;
}
```

#### 固定定位

固定定位是指元素相对于浏览器的可视区域保持固定偏移。

典型的例子如客服侧边栏、钓鱼广告。

```css
position: fixed;
top: 100px;
right: 5px;
```

定位不依赖任意一个祖先元素。只以浏览器可视区域为基准。

元素脱离标准流。

特别地，我们可通过一定技巧让元素看起来以版心为基准，当然本质上还是以浏览器可视区域为基准。

```css
position: fixed;
top: 100px;
/* 元素左边缘距窗口左边缘有可视区域宽度的50% */
left: 50%;
/* 版心宽度的50% */
margin-left: 600px
```

#### 粘性定位

粘性定位是相对定位和固定定位的混合体。

典型例子如一些网站的搜索栏。

并不常用，兼容性较差，效果一般等价地由js实现。

```css
position: sticky;
/* 当元素的上边缘距浏览器可视区域上边缘0px时由相对定位变固定定位 */
top: 0;
```

以浏览器的可视区域为参考系（固定定位特点）；原先的位置保留（相对定位特点）。

必须添加top、bottom、left、right属性的其中一个。

#### 重叠次序

使用z-index控制重叠元素在z轴上的顺序。

```css
z-index: 1;
```

属性值可取正负整数或0，默认为auto。数值越大，元素越靠上层。

z-index值相同的情况下，后来者居上。

值后不能跟单位。

只有设了定位的元素的z-index属性才生效。

#### 定位特性

一旦添加了绝对定位或固定定位，除现有特性保留外，行内元素可设定宽度和高度，块元素的默认宽高是内容的宽高，前提是内容不脱标，浮动元素除外。

绝对定位元素覆盖下层元素时会覆盖一切，而浮动元素覆盖标准流元素时不会覆盖文字，浮动产生的初衷就是做文字环绕效果。

综合显示模式、浮动以及定位，辨析下面这些例子：

```css
/* 只分析父盒子的宽高 */

/* 100 100 */
ul {
    /* 父盒子脱标 */
    position: absolute;
}
ul li {
    /* 浮动子盒子虽然脱标，但仍能影响父盒子宽高 */
    float: left;
    width: 100px;
    height: 100px;
    background-color: aqua;
}

/* 100 100 */
ul {
    /* 父盒子不脱标，行内块模式 */
    display: inline-block;
}
ul li {
    /* 浮动子盒子虽然脱标，但仍能影响父盒子宽高 */
    float: left;
    width: 100px;
    height: 100px;
    background-color: aqua;
}

/* 一行 0 */
ul {
	/* 父盒子不脱标，块模式 */
}
ul li {
    /* 浮动子盒子脱标，不能影响父盒子宽高 前面说了给父盒子加上overflow就可影响高 */
    float: left;
    width: 100px;
    height: 100px;
    background-color: aqua;
}

/* 0 0 */
ul {
    /* 父盒子脱标 */
    position: absolute;
}
ul li {
    /* 子盒子脱标，不能影响父盒子宽高 模仿清除浮动的方法来撑开高是行不通的 */
    position: absolute;
    width: 100px;
    height: 100px;
    background-color: aqua;
}

/* 0 0 */
ul {
    /* 父盒子不脱标，行内块模式 */
    display: inline-block;
}
ul li {
    /* 子盒子脱标，不能影响父盒子宽高 */
    position: absolute;
    width: 100px;
    height: 100px;
    background-color: aqua;
}

/* 0 0 */
ul {
    /* 父盒子不脱标，块模式 */
}
ul li {
    /* 子盒子脱标，不能影响父盒子宽高 */
    position: absolute;
    width: 100px;
    height: 100px;
    background-color: aqua;
}
```

#### 注

当想为图片添加定位时，最好在外面套一层div，避免修改img元素本身。

### 元素显隐

注意当元素无论以何种方式隐藏时，悬浮、单击等行为对其而言都形同虚设了。

#### display属性

```css
/* 隐藏元素，且清空位置，但不删除元素（dom对象） */
display: none;
/* 将元素转换为块级元素，且还有显示元素的作用 */
display: block;
```

`display: none`用得很多，常搭配js做特效。

#### visibility属性

```css
/* 隐藏元素，但保留位置 */
visibility: hidden;
/* 显示元素 */
visibility: visible;
```

`visibility: hidden`没有`display: none`用得多。这两种样式都不会使dom中的元素被销毁。

#### overflow属性

控制包括子元素在内的内容溢出部分（水平、垂直方向都算，在边框之前溢出就算溢出）的显示方式。

```css
overflow: auto | hidden | visible | scroll;
```

取值说明：

- visible：默认值，显示溢出部分。

- hidden：隐藏但不删除溢出部分。

- scorll：以滚动条的方式保留并可查看全部内容。

- auto：在需要时添加滚动条，不需要时毫无变化。

注：给某父元素添加`overflow: hidden`，其内部一行上的最后一个浮动元素若已触及或超出父元素右边缘，则先换行，再隐藏垂直方向上的溢出部分。并非先直接隐藏水平方向上的溢出部分。

### 属性顺序

建议写诸属性时遵循此顺序：

```css
/* 布局属性 */
display（建议开头）| position | float | clear | visibility | overflow
/* 自身属性 */
width | height | margin | padding | border | background
/* 文本属性 */
color | font | text-decoration | text-align | vertical-align | white-space | break-word
/* 其他（主要是CSS3）*/
content | cursor | border-radius | box-shadow | background: linear-gradient
```

### 一些技巧

#### 精灵图

当网页里的图像过多时，服务器就频繁地接收请求和发送图片，导致服务器压力过大，页面的加载速度也会大大降低。

为了有效减少服务器接收请求和发送图片的次数，及提高页面的加载速度，CSS精灵技术（CSS Sprites，CSS雪碧）应运而生。

核心原理：将网页中的诸多小图像整合到一张大图中，然后服务器只需接收一次请求，发送一次大图。

精灵技术主要针对小背景图，不包括img元素里的图。

css抠图：精灵图使用的本质就是利用background-position属性调整背景大图像的位置，以选取目标小图像。

使用精灵图时需要精确测量每个小背景图的宽高和位置。一般background-position值是负的。

例如：

```css
background: url("images/sprites.png") no-repeat -182px 0;
```

#### 字体图标

主要用于网页中通用、常用的小图标。

精灵图的缺点：

- 图片文件较大。
- 图片经放大会失真。
- 更换图片会很麻烦，UI人员和前端人员都得改。

字体图标（iconfont）很好地解决了以上问题。

它看起来是图标，但本质是字符。优点有：

- 存储空间小于图像。
- 一加载就马上显现，从而减少了向服务器的请求。
- 放大不失真，且颜色、阴影、等样式易修改。
- 兼容性好，支持几乎所有的浏览器。

当然，字体图标不能完全取代精灵图，因为一些更精致的图像字体图标是达不到的。

推荐下载网站：

- [iconmoon字库](http://iconmoon.io)。
- [阿里iconfont字库](http://iconfont.cn)。

#### 三角形

朝右的三角：

```css
/* 宽高设为0 */
width: 0;
height: 0;
/* 先将四面边框颜色都设为透明 */
border: 10px solid transparent;
/* 再突出某一面边框的颜色 */
border-left-color: skyblue;
```

#### 用户细节

光标样式：

```css
cursor: default | pointer | move | text | not-allowed;
```

取消表单控件的边框：

```css
input {
    outline: none;
}
```

禁止缩放文本域：

```css
textarea {
    resize: none;
}
```

将textarea的开始、结束标签写到同一行，使得在文本域中输入时光标默认定位到首行。

#### vertical-align

此属性用于设置文字、图片、表单等内容的垂直对齐方式，但只针对行内元素或行内块元素有效。

```css
vertical-align: baseline | top | middle | bottom;
```

一行文本可以划分出四条界线-基线（baseline）、顶线（top）、middle（中线）、bottom（底线）。诸行内元素或行内块元素默认的垂直对齐方式是基线对齐。

因为图片和文字默认沿基线对齐，故默认情况下图片下边缘和下边框之间总会有一道缝隙。解决方法：要么设vertical-align的值为bottom，要么将其显示模式改成块级。

#### 省略号替换溢出文字

单行文本溢出情况：

```css
/* 强制一行内显示文本，即不换行 */
white-space: nowrap;
/* 隐藏溢出内容 */
overflow: hidden;
/* 用省略号代替溢出文字 */
text-overflow: ellipsis;
```

多行文本溢出情况有较大兼容性问题，仅适用于webkit内核的浏览器或移动端。

```css
overflow: hidden;
text-overflow: ellipsis;
/* 弹性盒子模型 */
display: -webkit-box;
/* 块元素内文本的限制行数 */
-webkit-line-clamp: 2;
/* 检索弹性盒子对象的子元素的排列方式 */
-webkit-box-orient: vertical;
```

行业中更推荐后台人员来实现这样的效果，让后台人员控制显示的字数，操作会更简单。

#### 布局相关

用margin负值实现相邻元素边框的重合。

但是有时候我们想在光标悬浮在当前元素上时，将其四面边框换颜色，可某一面边框就被margin取负值的相邻元素遮住了。解决方法：

- 若当前元素无定位，则对其设置相对定位即可：

  ```css
  position: relative;
  ```

- 若当前元素已有定位且相邻元素也有，则提升其层级：

  ```css
  position: relative;
  z-index: 1;
  ```

给元素添加浮动以实现文字单侧环绕效果。

#### 非等腰直角三角形

```css
width: 0;
height: 0;
/* 把某一面边框宽度拉大 */
border-top: 100px solid transparent;
border-right: 50px solid skyblue;
/* 把不要的两面边框宽度设为0 */
border-bottom: 0 solid transparent;
border-left: 0 solid transparent;

/* 边框简写 */
border-color: transparent skyblue transparent transparent;
border-style: solid;
border-width: 100px 50px 0 0;
```

此图形常用于实现梯形侧边效果。

#### 列表美化

一般来说我们去掉全部的列表前导符：

```css
li {
    list-style: none;
}
/* 或用通配符 */
* {
    list-style: none;
}
```

#### CSS初始化

某些标签的某些属性在不同浏览器上所取的默认值是不同的，为了消除这种差异，考虑浏览器的兼容性，我们需要对CSS作初始化。

对每个网页设定样式之前必须进行CSS初始化。

以京东的CSS初始化为例，我们作一番解读：

```css
/* 把所有内外边距清零 */

* {
    margin: 0;
    padding: 0
}

/* 取消斜体标签的倾斜效果 */

em, i {
    font-style: normal
}

/* 去掉li元素的小圆点 */

li {
    list-style: none
}

img {
    /* 对于低版本浏览器，被超链接元素包含的图片默认带边框 */
    border: 0;
    /* 避免图片底侧有空白缝隙的问题 */
    vertical-align: middle
}

/* 光标悬浮在按钮上时变成小手形状 */

button {
    cursor: pointer
}

/* 取消超链接内容默认的蓝色、下划线 */

a {
    color: #666;
    text-decoration: none
}

/* 光标经过超链接时文字变红 */

a:hover {
    color: #c81623
}

/* 按钮和其他表单控件的字体 */

button, input {
    font-family: Microsoft YaHei, Heiti SC, tahoma, arial, Hiragino Sans GB, "\5B8B\4F53", sans-serif；
    border: 0;
    outline: none;
}

body {
    /* 抗放大时的锯齿 */
    -webkit-font-smoothing: antialiased;
    background-color: #fff;
    font: 12px/1.5 Microsoft YaHei, Heiti SC, tahoma, arial, Hiragino Sans GB, "\5B8B\4F53", sans-serif;
    color: #666
}

/* 隐藏元素 */

.hide, .none {
    display: none
}

/* 清除浮动 */

.clearfix:after {
    visibility: hidden;
    clear: both;
    display: block;
    content: ".";
    height: 0
}

.clearfix {
    *zoom: 1
}
```

### 注

#### PS相关

网页美工人员主要用PS做好网页效果图再传给前端人员，于是我们用主要用PS做切图、测量等工作。

有很多切图方式：图层切图、切片切图、插件切图等。

图层切图：右击图层，选择快速导出为png。有时我们需要将多个图层合并导出，即先选中需要的图层，再选择图层菜单里的合并图层或用快捷键Ctrl+E，然后导出。

切片切图：用切片工具框选目标，再导出。

插件切图：推荐使用cutterman插件。

## H5新增内容

### 概述

HTML5针对以前的不足，增加了一些新标签、新表单控件和新的表单属性。

新内容有兼容性问题，视情况使用。

### 语义化标签

罗列如下：

- header：头部。

- nav：导航栏。

- article：正文。

- section：某个区域。

- aside：侧边栏。

- footer：底部。

这些语义化标签主要是为搜索引擎而生。

在IE9中需要把这些标签的显示模式转换为块级。

移动端更青睐这些标签。

HTML5还新增了其他的标签，我们后面再逐渐扩充。

### 多媒体标签

主要指这两个：

- 视频：video。

- 音频：audio。

有了它们我们可以很方便地在html页面中嵌入音视频，而无需借助flash和其他浏览器插件。

可以去菜鸟教程看看关于这两个标签的详细说明。

video元素仅支持三种视频格式：MP4、WebM、Ogg，尽量用MP4。

```html
<video src="文件地址" controls="controls"></video>
```

查看[video元素的属性](https://www.w3school.com.cn/tags/tag_video.asp)。

audio元素支持三种音频格式：MP3、Wav、Ogg，尽量用MP3。

```html
<audio src="文件地址" controls="controls"></audio>
```

谷歌考虑到用户体验，把音视频的自动播放强制关闭了，只能靠js解决。

查看[audio元素的属性](https://www.w3school.com.cn/tags/tag_audio.asp)。

### 表单属性

| type值        | 说明                           |
| ------------- | ------------------------------ |
| type="email"  | 限制用户的输入必须是邮件类型   |
| type="url"    | 限制用户的输入必须是url类型    |
| type="date"   | 日期选择控件                   |
| type="time"   | 时间选择控件                   |
| type="month"  | 月选择控件                     |
| type="week"   | 周选择控件                     |
| type="number" | 限制用户的输入必须是数字类型   |
| type="tel"    | 限制用户的输入必须是手机号类型 |
| type="search" | 搜索框                         |
| type="color"  | 颜色选择控件                   |

| 属性         | 值        | 说明                           |
| ------------ | --------- | ------------------------------ |
| required     | required  | 限定表单内容不能为空，即必填   |
| placeholder  | 提示文本  | 输入框内的提示信息             |
| autofoucs    | autofoucs | 页面加载完毕光标自动定到该控件 |
| autocomplete | on/off    | 历史记录和自动填充             |
| multiple     | multiple  | 多选文件                       |

比如用伪元素及新增的placeholder属性修改提示文本的颜色：

```css
input::placeholder {
    color: #ccc;
}
```

## C3新增内容

### 概述

CSS3的新特性有兼容性问题，IE9+才支持。

移动端对它的支持优于PC端。

它尚在不断改进中。

它的应用已经很广。

### 选择器

#### 属性选择器

举一些例子：

```css
/* 选择写明value属性的input元素。权重：11 */
input[value] {
    color: #ccc;
}
/* 选择name值为username的input元素。权重：11 */
input[name="username"] {
    color: #ccc;
}
input[name=username] {
    color: #ccc;
}
```

其他一些类似的例子可参考[CSS3选择器](https://www.w3school.com.cn/cssref/css_selectors.asp)。

#### 结构伪类选择器

主要用于根据文档结构来选择元素。

有下面这些例子：

```css
/* 权重：12 */
ul li:first-child {
    color: #333;
}
ul li:last-child {
    color: #333;
}
ul li:nth-child(2) {
    color: #333;
}
ul li:nth-child(even) {
    color: #333;
}
ul li:nth-child(odd) {
    color: #333;
}
/* 作选择时先看后面的nth-child(1)，再看前面的li，两者一定要相匹配 */
ul li:nth-child(1) {
    color: #333;
}
/* 参数除取n外，还可以取2n、2n+1、5n、n+3、-n+5，其中n的初值为0*/
ul li:nth-child(n) {
    color: #333;
}
/* 权重：20 */
.page:first-of-type {
    color: #333;
}
/* 权重：11 */
div:last-of-type {
    color: #333;
}
/* 作选择时先看前面的li，再看后面的nth-of-type(1) */
ul li:nth-of-type(1) {
    color: #333;
}
```

详细解释还是去参考[CSS3选择器](https://www.w3school.com.cn/cssref/css_selectors.asp)。

#### 伪元素选择器

它帮助我们利用CSS创建新元素，而不是通过html标签，从而减省html的结构。

拣两个重要的伪元素讲：

| 选择符   | 说明                   |
| -------- | ---------------------- |
| ::before | 在本元素的前部插入元素 |
| ::after  | 在本元素的后部插入元素 |

这两个伪元素选择器都能创建元素，但创建的元素都属于行内元素。

新创建的元素在文档树中是找不到的，故称伪元素。

属性列表里必须指明content属性。

示例如下：

```css
div::before {
    content: '我是前面的伪元素';
}
div::after {
    content: '我是后面的伪元素';
}
```

```css
div::before {
    content: "";
    display: none;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 0, 0, .2);
}

div:hover::before {
    display: block;
}
```

用伪元素清除浮动是额外标签法的优化，回顾一下这一做法，即给父盒子添加样式：

```css
.clearfix:after {
    content: "";
    display: block;
    height: 0;
    clear: both;
    visibility: hidden;
}
/* 或 */
.clearfix:before, .clearfix:after {
    content: "";
    /* 转换为块级元素且在一行显示 */
    display: table;
}
.clearfix:after{
    clear: both;
}
```

### 盒子模型

此模型用于解决padding和border撑大盒子的问题，详见[box-sizing](https://developer.mozilla.org/zh-CN/docs/Web/CSS/box-sizing)。这里我们用例子直观理解：

```css
/* 总宽高为300px，内容宽高为240px */
div {
    width: 300px;
    height: 300px;
    padding: 20px;
    border: 10px solid #ccc;
    box-sizing: border-box;
}
/* 默认：总宽高为360px，内容宽高为300px */
div {
    width: 300px;
    height: 300px;
    padding: 20px;
    border: 10px solid #ccc;
}
```

用图更清晰：

![image-20211213161434770](D:\chaofan\typora\专业\HTML5+CSS3.assets\image-20211213161434770.png)

![image-20211213161511274](D:\chaofan\typora\专业\HTML5+CSS3.assets\image-20211213161511274.png)

我们用表梳理一下，以宽度为例，高度同理：

|             | 内容宽度             | 总宽度               |
| ----------- | -------------------- | -------------------- |
| content-box | width                | width+padding+border |
| border-box  | width-padding-border | width                |

那么到底用哪一种，这得看具体情况。

在浏览器控制台指定某元素，显示的宽高是总宽高。子元素宽高设为100%，此比例参考的是父元素的内容宽高。

### 其他

模糊滤镜：

```css
img {
    /* 数值越大，越模糊，0表无模糊 */
    filter: blur(15px);
}
```

calc函数：

```css
div {
    /* 括号里可使用+ - * / */
    width: calc(100% - 30px); /* 子盒子宽度永远比父盒子宽度小30像素 */
}
```

### 过渡

过渡（transition）是CSS3中具有颠覆性的新内容之一。

我们可以在不使用flash动画或js的情况下，为元素从一种样式变换到另一种样式添加渐变效果。

低版本浏览器不支持这一内容但并不影响页面布局。

它经常和:hover等搭配使用。

语法：

```css
transition: 目标属性 过渡时间 运动曲线 开始时间;
```

取值解释如下：

- 目标属性：宽高、背景色、内外边距都可；如果想给所有属性添加过渡效果，则写个all即可。

- 过渡时间：数值，必须带单位s。

- 运动曲线：可省略，默认是ease。

- 开始时间：数值，必须带单位s；可省略，默认是0。

详情可参考[CSS3 transition属性](https://www.w3school.com.cn/cssref/pr_transition.asp)。

示例：

```css
div {
    width: 200px;
    height: 200px;
    background-color: skyblue;
    transition: width .5s ease 0s, height 1s 1s;
}
div:hover {
    width: 400px;
    height: 400px;
}
```

### 2D转换

#### 概述

转换（transform）是CSS3中具有颠覆性的特性之一，可实现元素的平移（translate）、旋转（rotate）、缩放（scale）等效果。

#### 平移

```css
div {
    width: 100px;
    height: 100px;
    /* 右移100px，下移100px */
    transform: translate(100px, 100px);
    /* 或者分开写*/
    /* 下面的会把上面的覆盖掉，上面的不生效 */
    transform: translateX(100px);
    transform: translateY(100px);
    /* 都生效 */
    transform: translateX(100px) translateY(100px);
}
```

特性：

- 仅限平面移动，即沿着x轴（正方向是右）和y轴（正方向是下）。
- 最大优点：平移后保留原有占位 （联想相对定位）。
- 值的百分比单位是相对于本元素宽高的占比。
- 对行内标签不生效。

由transform平移的特性得出相对父盒子居中对齐的新写法：

```css
.son {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 200px;
    height: 200px;
    transform: translate(-50%, -50%);
}
```

#### 旋转

rotate值的单位是deg。顺时针是正方向。

旋转的中心点默认是元素的中心点。

```css
img {
    width: 100px;
    height: 100px;
    transform: rotate(45deg);
}
```

可以设定旋转的中心点：

```css
img {
    /* 宽度的50%处，高度的50%处，即中心，等价于center center */
    transform-origin: 50% 50%;
    /* 左下顶点 */
    transform-origin: left bottom;
    /* 中上点 */
    transform-origin: center top;
    /* 右中点 */
    transform-origin: right center;
    /* 坐标 */
    transform-origin: 50px 50px;
}
```

#### 缩放

控制元素的放大和缩小。

```css
div {
    /* 保持不变 */
    transform: scale(1, 1);
    /* 等比例放大到原来的2倍 */
    transform: scale(2, 2);
    /* 等比例缩放简写，相当于上式 */
    transform: scale(2);
    /* 等比例缩小到原来的一半 */
    transform: scale(0.5 0.5);
    /* 宽度扩大到原来的2倍，高度不变 */
    transform: scale(2, 1);
```

特性：

- 默认基于中心缩放。

- 保留原有占位。

#### 综合

```css
div:hover {
    transform: translate(50px, 50px) rotate(180deg) scale(1.2);
}
```

属性顺序会影响最终效果。若想不调整坐标系位置，则平移应放在首位。若先旋转，则坐标系位置会随之变化。

### 动画

动画（animation）是CSS3中具有颠覆性的特性之一，可通过设置多个节点来精确控制一个或一组动画，从而实现复杂的动画效果。

相较于过渡而言，动画可以实现更多的变化、控制，连续、自动的播放等效果。过渡往往需要事件的触发如点击、悬浮等。

制作动画分两步：

1. 定义动画。
2. 调用动画。

定义：

```css
@keyframes 动画名称 {
    /* 可换成from */
    0% {
        transform: translateX(0);
    }
    /* 可换成to */
    100% {
        transform: translateX(500px);
    }
}
```

调用：

```css
div {
	/* 调用动画 */
    animation-name: divAn;
    /* 持续时间 */
    animation-duration: 1s;
}
```

多节点动画序列：

```css
/* 每个百分比指在持续时间上的占比 */
@keyframes move {
    /* 可省略，但一般不省 */
    0% {
        transform: translate(0, 0);
    }

    25% {
        transform: translate(500px, 0);
    }

    50% {
        transform: translate(500px, 300px);
    }

    75% {
        transform: translate(0, 300px);
    }

    100% {
        transform: translate(0, 0);
    }
}
```

关于动画的详细属性解读，可参考[CSS3 动画属性](https://www.w3school.com.cn/cssref/index.asp#animation)。

简写形式：

```css
animation: animation-name animation-duration animation-timing-function animation-delay animation-iteration-count animation-direction animation-fill-mode;
/* 调用多个动画，用逗号隔开 */
animation: bear 1s steps(8) infinite, move 1s forwards;
```

上述属性中不包括animation-play-state，该属性一般另外配合事件触发（如单击、悬浮）使用。

关于动画的速度曲线，可参考[CSS3 animation-timing-function 属性](https://www.w3school.com.cn/cssref/pr_animation-timing-function.asp)。尤其注意其中的值`step(n)`，常用于清除补间，而仅保留关键帧，比如下面这个北极熊奔跑的例子：

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>北极熊奔跑</title>
    <style>
        /* 外部div向右移动 */
        @keyframes run {
            0% {}

            100% {
                transform: translateX(500px);
            }
        }
		
        /* 内部长图像向左离散移动 */
        @keyframes slide {
            0% {}

            100% {
                transform: translate(-651px);
            }
        }

        .run {
            overflow: hidden;
            width: 82px;
            height: 40px;
            margin: 100px 0;
            animation-name: run;
            animation-duration: 2s;
            animation-timing-function: ease-out;
            animation-fill-mode: forwards;
        }

        .run img {
            animation-name: slide;
            animation-duration: .8s;
            /* 逐帧 */
            animation-timing-function: steps(8);
            animation-iteration-count: infinite;
        }
    </style>
</head>

<body>
    <div class="run">
        <img src="bear.png" alt="">
    </div>
</body>

</html>
```

### 3D转换

#### 平移

特指沿眼睛到屏幕方向的平移，即视觉上的放大缩小。

```css
/* z轴值越大则对象越近越大；z轴值越小则对象越远越小 */
transform: translateX(100px) translateY(100px) translateZ(100px);
/* 简写，三个值都不可省略 */
transform: translate3d(50px, 50px, 50px);
```

正值为向屏幕外、朝着眼睛；负值为向屏幕里。

需配合perspective属性（可理解为视距）使用才看出在z轴上的变化。透视属性应写在被观察元素的祖先元素中：

```css
/* z轴值为正且固定 */
/* 较近较大 */
perspective: 100px;
/* 较远较小 */
perspective: 500px;
```

#### 旋转

最好配合perspective属性使用 。

左手准则：左手大拇指指向x（y、z）轴正方向，其余四指弯曲的方向就是绕x（y、z）轴旋转的正方向。

```css
transform: rotateX(45deg);
transform: rotateY(45deg);
transform: rotateZ(45deg);
/* 自定义转轴，不常用。下面这个绕着向量(1, 1, 0)旋转60度 */
transform: rotate3d(1, 1, 0, 60deg);
```

#### transform-style

此属性作用：控制子元素是否开启三维环境。可想而知它是写在父元素中的。

当其值为flat时，子元素不会获得3d效果，即回到平面状态。

例如：

```css
body {
    perspective: 600px;
}

.father {
    width: 300px;
    height: 500px;
    margin: 100px auto;
    background-color: pink;
    transition: all 1s;
    transform-style: preserve-3d;
}

.father:hover {
    transform: rotateY(75deg);
}

.son {
    width: 300px;
    height: 300px;
    background-color: royalblue;
    transform: rotateX(45deg);
}
```

双面旋转：

```css
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>双面旋转</title>
    <style>
        body {
            perspective: 500px;
        }

        .box {
            position: relative;
            width: 300px;
            height: 300px;
            margin: 100px auto;
            transition: all 2s;
            transform-style: preserve-3d;
        }

        .box:hover {
            transform: rotateY(180deg);
        }

        .front,
        .back {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            text-align: center;
            line-height: 300px;
            font-size: 25px;
            color: #fff;
            border-radius: 50%;
        }

        .front {
            background-color: slateblue;
        }

        .back {
            background-color: turquoise;
            /* 背面 */
            transform: rotateY(180deg);
        }
    </style>
</head>

<body>
    <div class="box">
        <div class="back">张超凡</div>
        <div class="front">你是谁？</div>
    </div>
</body>

</html>
```

### 浏览器私有前缀

作用是兼容诸浏览器的老版本，对新版本自然无需指定。

有如下前缀：

- `-moz-`：代表Firefox的私有属性。
- `-ms-`：代表ie的私有属性。
- `-webkit-`：代表Safari、Chrome的私有属性。
- `-o-`：代表Opera的私有属性。

## 项目相关

### 网站制作

网站制作流程：

1. 与客户沟通，制定方案。
2. 签订合同。
3. 预付订金。
4. 初稿审核。
5. 前台页面设计，后台功能开发。
6. 测试验收。
7. 上线培训。
8. 后期维护。

UI人员会设计出一张原型图，即用一些几何图形描绘出页面的基本模样。此图经过客户认可之后，UI人员进一步据此设计PSD格式的效果图。

### SEO

#### 概述

SEO（search engine optimization）译作搜索引擎优化，意为遵守、根据某搜索引擎的规则提高网站在该搜索引擎内自然（非广告）排名。

它的目的就是帮助网站获得免费的流量（浏览量、点击量），在搜索引擎内提升网站的排名，提高网站的知名度。

#### TDK

网站TDK是指title、description、keyword三大标签，后两者其实是元标签meta。我们总是通过这三个标签实现SEO。

- title：网站标题。建议内容为网站名或产品名-网站的简介（尽量不超过30个汉字）。例如：

  ```html
  <title>京东（JD.COM）-综合网购首选-正品低价、品质保障、配送及时、轻松购物！</title>
  <title>小米商城-小米5s、红米Note4、小米MIX、小米笔记本官方网站</title>
  ```

- description：网站说明。概括网站的业务和主题。 内容一般由SEO人员给定。例如：

  ```html
  <meta name="description" content="京东JD.COM-专业的综合网上购物商城,销售家电、数码通讯、电脑、家居百货、服装服饰、母婴、图书、食品等数万个品牌优质商品.便捷、诚信的服务，为您提供愉悦的网上购物体验!"/>
  ```
  
- keyword：页面关键词。关键词最好限制到6到8个，之间用逗号隔开。例如：

  ```html
  <meta name="Keywords" content="网上购物,网上商城,手机,笔记本,电脑,MP3,CD,VCD,DV,相机,数码,配件,手表,存储卡,京东"/>
  ```

#### Logo

为了实现SEO，网站中的logo的写法也要遵循一定规则：

- 第二层盒子是h1标签（第一层一般是div），目的是提升权重，告诉浏览器此处很重要。
- h1标签里放一个超链接，将超链接的背景设为logo图。
- 在超链接中放文字，即网站名，但文字不显示。
- 给超链接添加title属性，即设定鼠标悬浮时的提示文字。

## 移动端

### 概述

移动端常见浏览器：UC、QQ、欧朋、百度手机、360、谷歌、搜狗手机、猎豹及其他杂牌的。

国内浏览器的内核都是由webkit修改过来的，尚无自主研发的内核。好比国产手机的操作系统都是基于Android开发的。

移动端屏幕尺寸类别五花八门，作为开发者无需关注乱七八糟的分辨率。

目前移动端主要指手机端。

### 视口

视口（viewport）就是浏览器所划定的屏幕区域，可分为布局视口、视觉视口和理想视口。

#### 布局视口

即layout viewport。一般的移动设备里的浏览器都设置了一个布局视口，用于解决早期PC端页面在手机上的显示问题。

IOS、Android基本将这个视口分辨率设为980px，故PC端的网页大多能在手机端呈现，只不过元素都很小，要通过缩放才能看清。

#### 视觉视口

即visual viewport，用户当前能看得到的网页区域。它或是原网页的某一块放大的区域，或是原网页缩得极小、两侧有白边的区域。

于是我们可以通过缩放控制视觉视口的变化，而不影响布局视口（布局视口仍保持原有宽高）。

#### 理想视口

ideal viewport。简单理解，就是布局视口和视觉视口相融合，原网页在当前视口无需缩放就能完整且清晰地被浏览。

我们要手动添加meta视口标签通知浏览器实现此功能。比如下面这个例子：

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

属性及其说明：

| 属性          | 说明                                             |
| ------------- | ------------------------------------------------ |
| width         | 布局宽度。理想情况下等于设备宽度（device-width） |
| initial-scale | 初始缩放比，一般是1.0                            |
| maximum-scale | 最大缩放比                                       |
| minimum-scale | 最小缩放比                                       |
| user-scalable | 是否允许用户缩放，1或yes表是，0或no表否          |

行业推荐的viewport设置：

```html
width=device-width,
initial-scale=1.0,
maximum-scale=1.0,
minimum-scale=1.0,
user-scalable=no
```

### 像素比

物理像素是真实存在的原始的设备像素。

而我们开发时碰到的px不一定指代物理像素，即1px不一定等于设备上一个像素点。

在PC端，1px=1个物理像素，但PC端的1px往往相当于移动端的多个像素点。

1px对应的物理像素点个数叫物理像素比或屏幕像素比。比如对于iPhone 6/7/8，PC端的一个375px的盒子占了它的满屏即750物理像素，故此处物理像素比为2，1个开发像素=2个物理像素。

我们看谷歌浏览器，当Toggle device toolbar按钮激活时，它显示的iPhone 6/7/8的屏宽是375，即开发像素，而不用物理像素750。附带讲微信小程序iPhone 6/7/8屏宽是750，只是单位是rpx。

早期手机屏幕的物理像素比是1，但随着Retina（视网膜屏幕）技术的发展，物理像素比就增大了。

开发中UI人员交付前端人员的设计稿往往是基于物理像素的，前端人员用google浏览器作视图的话就得先行减半尺寸。

### 多倍图

承接上面的理论，PC端的图在移动端就会放大，造成模糊问题。

那么在标准的viewport设置中，我们常用倍图来提高图片质量，以解决其在高清设备中的模糊问题。

有一种做法就是在CSS中手动地将图片缩小到原来的1/2，那么它再在手机上显示时就会跟原来一样清晰。例如：

```css
img {
    /* 原始宽高：100*100 */
    width: 50px;
    height: 50px;
}
```

针对背景图，我们可通过背景缩放属性background-size来进行二倍图的设定。例如：

```css
div {
    width: 500px;
    height: 200px;
    background: url("images/dog.png");
    /* 宽高都缩小到50px */
    background-size: 50px 50px;
}
/* 只写宽度，高度自适应 */
background-size: 50px;
/* 宽度设为本元素的50%， 高度自适应 */
background-size: 50%;
/* 完全覆盖本元素，可能会有裁切 */
background-size: cover;
/* 等比例缩放，且宽高中只要有一项吻合本元素的，就停止缩放 */
background-size: contain;
```

PS中的cutterman插件能够切出2倍图、3倍图。

### 开发方式

目前主流的移动端开发方式有两种：

- 单独页面（主流）：对PC端、手机端各自设计一套页面，结构、样式都大不相同。从网址就可看出，如`m.jd.com`与`jd.com`。
- 响应式、兼容PC端的移动端页面：随着屏幕宽度改变动态地调整样式，可适应不同终端。缺点是制作麻烦，需要花费很大精力去解决兼容性问题。

### 技术方案

移动端浏览器的内核基本上以webkit为主，因此我们不得不考虑webkit的兼容性问题。

可喜的是，我们大可放心使用H5和C3，碰到兼容性问题添加私有前缀即可。

关于移动端的CSS初始化，推荐使用[normalize.css](http://necolas.github.io/normalize.css/)。

CSS3的盒子模型在移动端是通用的。如果在PC端有兼容性问题，就照旧使用传统的盒子模型。

具体的若干套方案请直接阅读[布局](#布局)一节。

### 特殊样式

```css
/* 取消单击超链接后产生的高亮效果 */
-webkit-tap-highlight-color: transparent;
/* 取消IOS上按钮和输入框的默认效果 */
-webkit-apperance: none;
/* 禁用长按链接弹出悬浮菜单 */
-webkit-touch-callout: none;
```

还有其他一些特殊样式这里就不详举了。

### 布局

#### 概述

单独移动端页面的布局方式有：

- 流式布局（百分比布局），如京东。
- flex弹性布局（强烈推荐），如携程。
- less+rem+媒体查询布局，如苏宁。
- 混合布局。

适配移动端页面的响应式布局方式有：

- 媒体查询。
- boostrap。

那么到底用哪种方式就取决于项目经理了。

#### 流式布局

也称非固定像素布局。顾名思义，其优点在于适配不同尺寸屏幕的设备。

通过将盒子宽度设成百分比来随着屏幕宽度伸缩，而不受固定像素的约束。

流式布局是移动端web开发比较常见的布局方式。

为了防止过渡伸缩，我们常设布局视口的宽度阈值：

```css
max-width: 980px;
min-width: 320px;
```

注意那么当body的width设为100%时，意思是对于区间[320, 980]内的任一值，body都是占该值的100%。

比如`max-width: 640px; min-width: 320px`的情况，我们手动缩浏览器窗口最小只能缩到320px宽，但放大无上限。当窗口宽度缩到小于320px，网页就一直保持320px宽，肯定产生遮挡；当宽度拉到大于640px，网页就一直保持640px宽，肯定产生留白。

#### flex布局

网上有大量相关教程作阐释，此处省略，姑参考[菜鸟教程-flex布局](https://www.runoob.com/w3cnote/flex-grammar.html)。

##### 传统布局和flex布局

传统布局：

- 兼容性好。
- 操作繁琐。
- 局限性：在移动端不够简便。

flex布局：

- 操作极为简单，因而在移动端应用广泛。
- PC端浏览器支持情况较差。

建议：若是PC端页面，则用传统布局；若是移动端或不考虑兼容性的PC端，则使用flex布局。

##### 布局原理

flex是flex box的缩写，意即弹性盒子，用来为盒子模型提供最大的灵活性。flex布局又名弹性布局、伸缩布局、伸缩盒子布局、弹性盒布局等。

任何一个容器（元素）都可以指定使用flex布局。

父元素一旦使用flex布局，子元素的float、clear、vertical-align属性将失效。

采用flex布局的父元素叫flex容器（flex container），简称容器，其所有子元素叫容器成员，叫做flex项目（flex item），简称项目。

综上所述，通过给父元素添加flex属性，来控制子元素的分布方向和方式。

##### 常用父项属性

flex-direction：主轴及其方向。

justify-content：子元素在主轴上的分布方式。

flex-wrap：子元素是否换行。

align-content：子元素在交叉轴上的分布方式（多行）。

align-items：子元素在交叉轴上的分布方式（单行）。

flex-flow：flex-direction和flex-wrap的复合属性。

##### 常用子项属性

flex：分配剩余空间。

align-self：子元素在交叉轴上单独的对齐方式。

order：子元素的排列顺序。

#### rem布局

##### rem原理

rem（root em）是一个相对单位，类似于em。便于理解可看作一个变量。

em是父元素字号。譬如某父元素的字号为12px，将其子元素的font-size设为2em，则此子元素的字号为24px。

而rem定义为某屏幕尺寸（主要是宽度）条件下，html元素的字号。例如：

```css
html {
    font-size: 14px;
}
p {
    /* 140px */
    width: 10rem;
    height: 10rem;
}
```

##### 媒体查询

概念：媒体查询（media query）是CSS3的新语法。

特点：

- 可以针对不同的媒体类型定义不同的样式。
- 可以针对不同的屏幕尺寸定义不同的样式。
- 当修改了浏览器窗口的大小，页面会根据窗口宽高重新渲染。
- 苹果手机、Android手机、平板等很多设备都支持媒体查询。

语法：

```css
@media mediatype and | not | only (media feature) {
    /* css code */
}
```

mediatype-查询类型：

| 值     | 解释说明                             |
| ------ | ------------------------------------ |
| all    | 用于所有设备。                       |
| print  | 用于打印机和打印预览。               |
| screen | 用于电脑屏幕、平板电脑、智能手机等。 |

关键字整合多个媒体特性，形成媒体查询的条件。

- and：连接多个媒体特性。
- not：排除某个媒体特性。
- only：指定特定的媒体特性。

一个简单的例子：

```css
@media screen and (max-width: 800px) {
    body {
        background-color: pink;
    }
}
@media screen and (min-width: 500px) {
    body {
        background-color: purple;
    }
}
```

类似于分支语句的背景色变化例子：

```css
@media screen and (max-width: 539px) {
    body {
        background-color: blue;
    }
}
@media screen and (min-width: 540px) {
    body {
        background-color: green;
    }
}
/* 利用层叠性 */
@media screen and (min-width: 970px) {
    body {
        background-color: red;
    }
}
```

##### 引入资源

页面针对不同尺寸的屏幕使用两套大相径庭的样式，实质上就是针对不同尺寸调用不同的样式表。

底层实现方法是在link标签中判断设备尺寸，再据此引用不同的css文件。例如：

```html
<!-- 建议从小屏往大屏写 -->
<link rel="stylesheet" href="small.css" media="screen and (min-width: 320px)">
<link rel="stylesheet" href="big.css" media="screen and (min-width: 640px)">
```

##### Less

[less](http://lesscss.cn/)是一门非程序型语言，没有变量、函数等概念。有如下缺点：

- 冗余度较高。
- 不方便维护、扩展及复用。
- 计算能力不算太好。

less（learner style sheets）是一门css扩展语言，也成为css预处理器。

顾名思义，作为css的一种扩展，它并没有减少css的功能，而是在现有的css语法上，加入程序型语言的特性，比如它引入了变量、混入（mixin）、运算及函数等大量功能。于是它大大简化了css的编写，降低了css的维护成本。

其他一些常见的css预处理器有：sass、stylus等。

关于它的使用，我们新建一个less文件，然后在里面编写less语句。

注意less文件不能直接引用，最终还是只能引用css文件。于是最好安装一个插件Easy LESS，用于生成算好字面值的css文件以供引用。有时要设置导出路径`"out": "../css/"`。

使用举例：

```less
/* 变量 */

// 必须带@前缀
// 不能包含特殊字符
// 不能以数字开头
// 大小写敏感
@color: pink; // 作为通用色，用于多处，不必多处修改
@font14: 14px;

body {
    background-color: @color;
}
div {
    background-color: @color;
}
a {
    font-size: @font14;
}

/* 嵌套 */
header {
    width: 200px;
    height: 200px;
    a {
        color: #ccc;
        // &标注:hover是伪元素而非后代
        &:hover {
            color: green;
        }
    }
}

/* 运算 */

// 运算符两侧加空格
// 若两个数都有单位且不相同，则最终结果单位以第一个数的单位为准
@border: 5px;
div {
    width: 200px - 50;
    height: 200px * 2;
    background-color: #666 - #444;
}
img {
    // 除法要括号
    width: (82rem / 50);
    height: (82rem / 50);
}
```

##### 解决方案

目的：当设备尺寸发生变化时，让元素等比例缩放以适配。

市场上主流的适配方案有两种：

- rem+媒体查询+less。
- flexible.js+rem（推荐）。

先看第一种。我们先了解一下常见设备的宽度：

| 设备         | 宽度（px)                                                    |
| ------------ | ------------------------------------------------------------ |
| iPhone 4 5   | 640                                                          |
| iphone 6 7 8 | 750                                                          |
| Android      | 320 360 375 384 400 414 500 720 <br>4.7到5寸的安卓设备大部分为720 |

目前设计稿的尺寸基本以750px为准，以此去适配其他大部分屏幕。那么设$@basefont$为基准html字号，某元素宽度为88px，我们不难想到如下推导：
$$
\frac{88}{@basefont}=\frac{x}{rem}\Rightarrow x=\frac{88}{@basefont}rem
$$
其中$x$即目标屏幕上以rem为单位此元素的宽度，反映到less代码上：

```less
/* 最终得到的css形如xxxrem */
width: (88rem / @basefont);
```

这个rem即html字号又得先行确定。设将屏幕宽划分$@no$等份，目标屏幕宽度为$W$px，则目标html字号为$W/@no$，反映到代码上：

```less
// 360设备
@media screen and (min-width: 360px) {
    html {
        font-size: (360px / @no);
    }
}
```

方案一实践起来比较繁琐，方案二更简洁更高效。方案二由手机淘宝团队推出，是一个移动端适配库。有了它我们不用写媒体查询，它统一把所有屏幕宽度划分10等份，我们只需确定基准字号，如750px的设计稿，就设定html字号为75px。

我们看flexible.js里比较关键的几行代码：

```js
// set 1rem = viewWidth / 10
function setRemUnit () {
  var rem = docEl.clientWidth / 10
  docEl.style.fontSize = rem + 'px'
}
```

插件cssrem帮我们换算px和rem，它跟Easy LESS等价。此插件的默认html字号是16px，要手动改为所需的基准字号，具体设置Root Font Size。

#### 响应式布局

同一个页面在PC端、Pad端与手机端呈现大相径庭的布局，这就叫响应式布局。前面的布局都是单独面向PC端或移动端，对元素进行缩放，而响应式布局同时面向PC端和移动端，调整元素的排布，当然也涉及缩放。

从原理上讲，依旧通过媒体查询针对不同设备宽度进行样式的设置以调整布局。在响应式眼里，设备尺寸一般作如下划分：

| 设备               | 尺寸（区间）（px） |
| ------------------ | ------------------ |
| 超小屏幕（手机）   | (0, 768)           |
| 小屏（平板）       | [768, 992)         |
| 中等屏幕（显示器） | [992, 1200)        |
| 宽屏（大型显示器） | [1200, $+\infin$)  |

响应式布局提出布局容器的概念，其实就是一个盒子，通过媒体查询改变布局容器的大小，并且调整其子元素的排列方式和大小，达到整体上布局大变的效果。于是根据上述尺寸区间，我们有<span id="split">如下几种布局容器的尺寸：</span>

- 超小屏幕：设宽为100%，占满。
- 小屏幕：设宽为750px，两侧留白，后同。
- 中等屏幕：设宽为970px。
- 大屏幕：设宽为1170px。

基本代码实现：

```html
<style>
    @media screen and (max-width: 768px) {
        .container {
            width: 100%;
        }
    }

    @media screen and (min-width: 768px) {
        .container {
            width: 750px;
        }
    }

    @media screen and (min-width: 992px) {
        .container {
            width: 970px;
        }
    }

    @media screen and (min-width: 1200px) {
        .container {
            width: 1170px;
        }
    }

    .container {
        background-color: pink;
        height: 200px;
        margin: 0 auto;
    }
</style>

<body>
    <div class="container"></div>
</body>
```

我们常用bootstrap框架快速完成响应式布局，为此单独开一节讲。

### Bootstrap

#### 概述

它有一套完整的网页功能解决方案，包括样式库、组件、插件等。目前3.x.x版本用得最多最稳定，偏向于开发响应式、移动设备优先的web前端项目。

引入bootstrap，抛开js，我们一般搭建如下目录结构：

```
bootstrap
css
images
index.html
```

#### 布局容器

bootstrap预定义了一个面向响应式布局的容器类container，它的尺寸业已符合前面提到的[分档位设定](#split)，我们便不用为尺寸的变化写媒体查询了。另外还预定义了一个专门适用于移动端的流式布局容器类container-fluid，它占据视口的100%宽度。

#### 栅格系统

英文名为grid systems，亦译为网格系统。所谓栅格系统，是指将容器等分为12个列，然后通过定义所占列数设定元素的宽度。故栅格系统通过由外而内、由行到列的一系列行列搭配来实现页面布局。

留心在大屏的PC端可能存在通栏的盒子，用容器就不合适了。故栅格系统并非包办一切，有时仍需要自定义容器。

自行阅读官方提供的[栅格参数](https://v3.bootcss.com/css/#grid)。

响应式的精髓就在于可为元素同时指定多个互不干扰的类名，以根据不同设备分配不同列数，如`class="col-md-4 col-sm-6"`。

#### 列嵌套

提一下容器类最好只加在第一级盒子上。

列嵌套简单而言就是在已分配若干列的元素内部继续按列划分，具体做法是先在此元素内加一个row元素以消除其内边距对子元素位置的影响，并让嵌入子元素的高度同此元素的一致，再在row元素内部放若干跨列子元素。

```html
<div class="col-sm-4">
    <div class="row">
        <div class="col-sm-6">
            第一个跨列子元素
        </div>
        <div class="col-sm-6">
            第二个跨列子元素
        </div>
    </div>
</div>
```

#### 响应式显隐

除了响应式排布，bootstrap还提供了元素的响应式显隐效果。官方文档上叫[响应式工具](https://v3.bootcss.com/css/#responsive-utilities)。

### vw与vh

见识了rem，再来见识一对新单位vw、vh。它们代表着未来的趋势，B站、小米等已经大规模使用。

vw（vh）与rem、百分比类似，都是比例型单位。rem的参照物是html字号；百分比的参照物是父元素；vw-viewport width的参照物是屏幕宽度；vh-viewport height的参照物是屏幕高度。

来看一下算法。给定宽度为$W$px、高度为$H$px的视口，某元素宽度设为$x$vw，高度设为$y$vw，则将其换算为px：
$$
xvw=x\frac{W}{100}px=W\cdot x\%,yvh=y\frac{H}{100}px=H\cdot y\%
$$
如对于375px、667px宽的屏幕，10vw=37.5px，2vh=13.34px。

开发时第一版样式往往是根据设计稿写起来的，故从px换算到vw（vh）更为常见，那么根据上式不难得出：
$$
mpx=100\frac{m}{W}vw=\frac{m}{W/100}vw,npx=100\frac{n}{H}vh
$$
我们发现这比rem香很多哦，元素的宽高会随着屏幕尺寸变化而变化，但当我们用rem，还得手动提前分档位写好html字号。有了vw（vh），无需flexible.js，无需媒体查询。

由于涉及到大量除法运算，最好用上less，也可以用一个插件叫px2vw，可能要设置Width，一般为375。

开发中vh很少使用，因为它们都是用于缩放的比例，只不过参照物不同，一个是屏幕宽，一个是屏幕高，用一种参照物就可，又因为在移动端宽度是大头，故我们选屏幕宽。从实践来看，我们本就很少纵向伸缩浏览器窗口。

关于其兼容性有兴趣参考[caniuse](https://caniuse.com/)。
