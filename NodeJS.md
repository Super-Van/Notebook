# Node.js

参考视频：[Node.JS教程](https://www.bilibili.com/video/BV1Ns411N7HU)。

关于node的调试，参考视频[代码快速演示devtools调试node](https://www.bilibili.com/video/BV1vf4y1m7sj?from=search&seid=6021563095627602754)。

## 概述

### 概念

不是一门语言，不是库，不是框架，是一个JS运行时环境，可以解析和执行JS代码，即现在的js可以完全脱离浏览器来运行。

- 浏览器中的JavaScript：EcmaScript、DOM、BOM。

- node.js中的JavaScript：没有DOM、BOM（这些依赖浏览器），只有EcmaScript。

node.js构建于Chrome V8引擎之上。代码只是具有特定格式的字符串而已，只有引擎才能认识、解析和执行。Google Chrome的v8引擎是目前公认的解析执行js代码最快的引擎，于是node.js的作者对它进行分离移植，开发出了一个独立的js运行时环境。

node.js用事件驱动和非阻塞I/O模型（异步）使得js变得轻量、高效。

npm是世界上最大的开源库生态系统，绝大多数js相关的包都放在npm中，这使得开发人员能更方便地下载相关包，如下载jQuery：`npm install jquery`。

### 功能

node.js（可简称node）能帮助我们深入了解web后台，只有了解服务端才能更好地配合服务端开发人员进行协同开发。在学习上node不仅帮我们打开服务端黑盒子，还能帮我们进一步学习高级的前端框架（Vue、React、Angular）。

所谓服务端黑盒子，或者这么理解。node.js除了可以解析代码外，还可以客服浏览器安全级别的限制（网络沙箱限制），提供系统（服务器）级别的API，如：

- 文件读写。
- 进程管理。
- 网络通信。

这些都封装于node的模块系统中，后续我们也会学习到[模块系统](#模块系统初探)。

node能用来开发后端web服务器（主要）、命令行工具等。

实际项目中我们主要使用第三方开发的工具，如webpack、gulp、npm。

从node中我们还能学到B/S编程模型、模块化编程、node常用的API、异步编程、Express开发框架、ES6等等。

一言以蔽之，node能让JS从前端语言变成后端语言。

### 预备知识

HTML、CSS、JavaScript、简单的命令行指令（如cd、dir、ls、mkdir、rm）、服务端开发经验。

### 安装配置

想玩最新的语法选择最新发布版（current），想搞开发选择长期支持版（LTS）。

从官网下载、安装zip版，然后自行配置，尤其是让以后安装的模块都落在D盘，具体可参考[NodeJS安装配置](https://www.jianshu.com/p/e3e000c67c81)。有时候要注意自己建的node_global和node_cache目录的权限。

检验安装是否成功，在DOS中输入：

```shell
node -v
npm -v

node --version
npm --version
```

## 实例

### 概述

稍微提一下如何使用node运行js文件：

1. 创建js脚本文件。

2. 打开终端，定位到脚本文件所属目录。

3. 输入`node xxx.js`以执行脚本文件。

### 读写文件

```js
var fs = require('fs');
fs.writeFile('hello.txt', 'My name is Van', function (error) {
    if (error) {
        console.log("写入文件失败！");
    } else {
        console.log("写入文件成功！");
    }
})
fs.readFile('hello.txt', function (error, data) {
    if (error) {
        console.log('读取文件失败！');
    } else {
        // data本身是二进制数据，不用toString方法的话输出二进制数字
        console.log(data.toString());
    }
})
```

注意所有的文件操作API都是异步的，所有存在延后执行的现象。

### 简单的http服务

服务器能干啥？提供数据相关的服务。

B/S交互过程：发送请求->接收请求->处理请求->发送响应。

```js
/**
 * node专门提供了一个用于创建服务器的核心模块：http
 */

// 加载http模块
var http = require('http');
// 创建web服务器并返回一个server实例
var server = http.createServer();
// 绑定端口号，启动服务器
server.listen(3000, function () {
    console.log('服务器启动成功，可通过 http://127.0.0.1:3000/ 进行访问');
});
/**
 * request事件处理函数：function(request, response){}
 * request：请求对象，获取客户端的一些请求信息，如请求路径
 * reponse：响应对象，向客户端发送响应消息。
 */
// 客户端发送请求过来，就会触发服务器的request事件，然后执行第二个参数-回调函数
server.on('request', function (request, response) {
    console.log('收到客户端的请求了，请求路径是：' + request.url);
    // response对象可多次调用write方法向客户端发送响应数据，最后须用end方法结束响应，否则客户端会一直等待
    if (request.url == '/hello') {
        response.write('Hello Van!');
        response.write('How are you?');
    } else if (request.url == '/node') {
        response.write('This is nodejs.');
    } else if (request.url == '/product') {
        var products = [
            {
                name: 'iphone',
                price: 2100
            },
            {
                name: 'Huawei',
                price: 3000
            },
            {
                name: 'Mi',
                price: 2800
            }
        ];
        // 响应数据的类型只能是二进制位或字符串。stringify方法：将js对象转为json字符串
        response.end(JSON.stringify(products));
    }
    // 告知客户端，响应信息发送完毕
    response.end();
});
```

上述代码可理解为：js在node.js环境中运行，使得主机能够提供服务，摇身一变成服务器。那么此时我们就可将js不再视作往常的前端语言而是一个服务端语言了，因为它不再由浏览器上解析执行了，而是在一个新的环境node中运行，且具备服务（接收请求、返回数据）职能。然后我们的主机既有客户端（浏览器）又有服务端（上述js代码生成），实现了http通信。

所以我们应清晰地理解node是个什么样的存在。它扩大了js的业务范围，把后端的活儿也抢了。

## 模块系统初探

node为js提供了一些服务器级别的API，大多数被包装到具体的模块中。例如：文件操作模块fs、http服务构建模块http、路径操作模块path、操作系统信息模块os等。

引入核心模块的写法实例：

```js
var fs = require('fs');
var http = require('http');
var path = require('path');
var os = require('os');
```

require方法就是用来加载模块的。node的模块分为三种：

- 内置的模块。

- 用户自己编写的模块。引入时须注意相对路径写法，js后缀可省略（推荐）。

- 第三方模块。

在node中只有模块作用域，各模块之间相互独立，模块不能相互污染（修改）各自内部的变量、方法。虽然只有模块作用域，但有时候使用自定义模块的目的不是简单地执行其中代码，而是将其中的某个方法供外部调用，那么就得靠require了。

require方法不仅能加载模块，还能拿到从模块中导出的对象。每个文件模块都提供了一个exports对象，它默认是一个空对象，等待用户往它里面添加属性即所要导出的变量或方法。

```js
/**
 * 导出文件模块
 */

// 挂载到exports中的方法
exports.add = function (a, b) {
    return a + b;
}
// 内部函数没有被挂载到exports中
add = function (a, b) {
    console.log(a + b)
}
// 内部变量没有被挂载到exports中
var age = 20;
// 挂载到exports中的变量
exports.age = 22;
```

```js
/**
 * 导入文件模块
 */

// 加载模块
var module = require('./export');
// 调用模块提供的方法
var res = module.add(1, 2);
console.log(res);
// 使用模块提供的变量
console.log(module.age)
```

下面来看一个HTTP模块的使用案例。

开两个服务器，占用不同的端口号。

```js
/**
 * @Description: 使用nodejs开两个占用不同端口的服务器，这是第一个
 */
//  导入HTTP模块，拿到http对象
var http = require('http');
// 创建一个服务器
var server = http.createServer();
// 开启监听，指定端口号
server.listen(3000, function () {
    console.log('服务器启动成功。');
});
// 接收客户请求并指定处理函数
server.on('request', function (request, response) {
    console.log('收到请求路径是：' + request.url);
    console.log('请求地址是：', request.socket.remoteAddress, request.socket.remotePort);
    /**
     * 服务器发送数据默认用utf8编码
     * 而浏览器解析数据默认用当前系统的编码方式，中文系统默认是gbk
     * 故最好统一两端的编码方式
     */
    // 服务器设置响应的首部信息，知会浏览器内容类型为普通文本，字符集为utf-8
    response.setHeader('Content-Type', 'text/plain; charset=utf-8');
    response.end('Hello 超凡');
});
```

```js
/*
 * @Description: 使用nodejs开两个占用不同端口的服务器，这是第二个
 */
//  导入HTTP模块，拿到http对象
var http = require('http');
// 创建一个服务器
var server = http.createServer();
// 开启监听，指定端口号
server.listen(5000, function () {
    console.log('服务器启动成功。');
});
// 接收客户请求并指定处理函数
server.on('request', function (request, response) {
    console.log('收到请求路径是：' + request.url);
    console.log('请求地址是：', request.socket.remoteAddress, request.socket.remotePort);
    var url = request.url;
    if (url === '/plain') {
        // 服务器设置响应的首部信息，知会浏览器内容类型为HTML文本，字符集为utf-8
        response.setHeader('Content-Type', 'text/plain; charset=utf-8');
        response.end('<p>Hello NodeJS p标签不被解析</p>');
    }
    else if (url === '/html') {
        // 服务器设置响应的首部信息，知会浏览器内容类型为HTML文本，字符集为utf-8
        response.setHeader('Content-Type', 'text/html; charset=utf-8');
        response.end('<p>Hello NodeJS p标签被解析</p>');
    }
});
```

我们可在浏览器中查看响应首部信息。

![首部](nodejs.assets\首部.png)



可配合文件模块fs，响应文件资源。

```js
/*
 * @Description: 服务器返回文档资源
 */
//  导入HTTP模块，拿到http对象
var http = require('http');
// 导入fs模块
var fs = require('fs');
// 创建一个服务器
var server = http.createServer();
// 开启监听，指定端口号
server.listen(3000, function () {
    console.log('服务器启动成功。');
});
// 接收客户请求并指定处理函数
server.on('request', function (request, response) {
    var url = request.url;
    // 默认地址，访问主页
    if (url === "/") {
        response.setHeader('Content-Type', 'text/html; charset=utf-8');
        fs.readFile('./resource/index.html', function (error, data) {
            if (error) {
                response.setHeader('Content-Type', 'text/plain; charset=utf-8');
                response.end('文件读取失败，请稍后重试');
            }
            else if (data) {
                response.setHeader('Content-Type', 'text/html; charset=utf-8');
                // data本身是二进制数据，而end函数支持二进制数据和字符串数据，故无需使用toString函数
                response.end(data);
            }
        });
    }
    if (url === '/image') {
        fs.readFile('./resource/ridiculous.jpg', function (error, data) {
            if (error) {
                response.setHeader('Content-Type', 'text/plain; charset=utf-8');
                response.end('文件读取失败，请稍后重试');
            } else if (data) {
                // 无需设定字符集，因为各格式的图片的编码方式是统一的，字符集的设定往往只针对字符
                response.setHeader('Content-Type', 'image/jpeg');
                response.end(data);
            }
        });
    }
});
```

后面会使用到第三方的express web框架，它把上述代码全都封装起来了，让我们更轻松地调用。

附[Content-Type对照表](https://tool.oschina.net/commons)。

## 代码风格

插入章。谈谈js的代码风格。

代码风格主要集中在缩进、空格和分号等几个方面。不同代码风格都不会报错，因为它不是代码硬性规定。

首先自己要形成一定的风格，自己写的一份代码不能毫无章法。其次就是在项目中，要服从团队约定的风格。

于是js社区指定了几套风格规范，不强制大家遵守，只是一个约定（当然不遵守在公司就可能死得很惨）。目前，有两套比较流行的规范：

- [JavaScript Standard Style](https://standardjs.com/readme-zhcn.html)（它就喜欢叫这个名字-标准，其实标准不能是自封的）。
- [Airbnb JavaScript Style](https://github.com/lin-123/javascript)（Airbnb是个租房公司）。

前者较为松散，用得人更多；后者较为严谨，约束更多。

关于加不加分号的问题。通常js代码是无需分号分隔的，但仍存在一些特殊情况必须靠分号来避免语法解析错误，尤见于ES6语法。

## 模板引擎

我们模拟Apache简单的目录列表，动态获取、渲染各目录（文件）名：

```javascript
let http = require('http');
let fs = require('fs');
let baseDir = "d:/chaofan/vscode/node/www"
let server = http.createServer();
server.listen(3000, function () {
    console.log('服务器启动成功');
});
server.on('request', function (request, response) {
    let url = request.url;
    response.setHeader('Content-Type', 'text/html; charset=utf-8');
    fs.readFile('./www/template.html', function (error, data) {
        if (error) {
            response.setHeader('Content-Type', 'text/plain; charset=utf-8');
            response.end('404 Not Found');
        }
        let trs = ``
        data = data.toString()
        // 读取文件目录
        fs.readdir(baseDir, function (error, files) {
            if (error) {
                response.end("Directory Not Found");
            }
            files.forEach(file => {
                trs += `
                    <tr>
                        <td data-value="index.html"><a class="icon file" draggable="true" href="/D:/chaofan/vscode/node/www/index.html">${file}</a></td>
                        <td class="detailsColumn" data-value="0">520 B</td>
                        <td class="detailsColumn" data-value="0">0</td>
                    </tr>
                `
            });
            // 动态内容替换占位符
            data = data.replace(/^_^/, trs)
            response.end(data);
        })
    });
});
```

我们看到上面是我们手动拿数据替换占位符，而现有的许多模板引擎可更优雅地进行替换，这里我们以基于JavaScript的art-template为例。

这是它的[中文文档](http://aui.github.io/art-template/zh-cn/docs/index.html)。它很强大，除了能干服务端渲染，还能生成页面模板（整体或局部）以实现html代码的复用，详见[模板继承](http://aui.github.io/art-template/zh-cn/docs/syntax.html#%E6%A8%A1%E6%9D%BF%E7%BB%A7%E6%89%BF)。

想让其安装到某目录下很简单，进入该目录，然后输命令：

```shell
# --save可省略
npm install art-template --save
```

先看一个简单的用例：

```html
<!-- 引入 -->
<script src="./node_modules/art-template/lib/template-web.js"></script>

<body>

</body>
<template id="tpl">
    {{name}}
    {{age}}
    <!-- 遍历 -->
    {{each hobbies}} {{$value}} {{/each}}
</template>
<script>
    // tpl就是渲染之后的html字符串
    let tpl = template("tpl", {
        name: "于谦",
        age: 50,
        hobbies: ["抽烟", "喝酒", "烫头"]
    })
    // 只是在这里打印了，并没有渲染到页面上
    console.log(tpl);
</script>
```

接着就是在node中使用，对本章开头的代码进行改进：

```js
let http = require('http')
let fs = require('fs')
// 当前文件应与node_modules目录同级，即处art-template的安装目录
let template = require("art-template")
let baseDir = "d:/chaofan/vscode/node/www"
let server = http.createServer();
server.listen(3000, function () {
    console.log('服务器启动成功');
});
server.on('request', function (request, response) {
    fs.readFile('../www/template.html', function (error, data) {
        if (error) {
            response.end('404 Not Found');
        }
        fs.readdir(baseDir, function (error, files) {
            if (error) {
                response.end("Directory Not Found");
            }
            // 返回渲染后的字符串
            data = template.render(data.toString(), {
                // 待渲染数据：文件名数组
                files: files
            })
            response.end(data);
        })
    });
});
```

在相应的html页面中作如下处理：

```html
<tbody id="tbody">
    <!-- 依数组数据迭代 -->
    {{each files}}
    <tr>
        <td data-value="index.html"><a class="icon file" draggable="true"
                href="/D:/chaofan/vscode/node/www/index.html">{{$value}}</a></td>
        <td class="detailsColumn" data-value="0">520 B</td>
        <td class="detailsColumn" data-value="0">0</td>
    </tr>
    {{/each}}
</tbody>
```

## 服务端渲染与客户端渲染

我们在服务端使用模板引擎将数据渲染到页面中就实现服务端渲染，比如之前接触过的JSP、thymeleaf，再就是上面记述的node+art-template。而且也可从这个角度说明JS可以转型为服务端语言。

在客户端使用模板引擎渲染数据到页面中则叫作客户端渲染，比如vue等前端框架。

对两者作个对比：

- 请求方面。服务端渲染一般与同步请求挂钩，服务端等数据全部渲染完毕才会响应给客户端，每次渲染意味着请求地址的改变，也意味着页面（包括静态资源）的再次发送；客户端渲染一般与异步请求挂钩，客户端先发送同步请求得到页面，然后发送异步请求得到数据，页面整体不刷新而局部刷新，当前的请求地址未改变，然后在本地进行数据渲染。
- 时间方面。一般而言，服务端渲染比客户端渲染慢。
- 直观表现方面。我们对比京东的商品列表和用户评论。两者的内容在浏览器调试区Element一栏都可见，因为Element一栏展示的是最终的渲染结果，囊括了先由同步请求返回的服务端渲染的数据与后由异步请求返回的客户端渲染出来的数据。但是，点开网页源代码的话，会发现商品列表内容可见，而用户评论的内容不可见，这就是因为源代码列出的是同步请求返回的html页面。那么此页面业已包含服务端渲染进来的数据，商品列表就存在于这些数据之中，而用户评论不属于服务端渲染的数据，也就不会在页面中出现。
- [SEO](./html5+css3.md#SEO)方面。出于安全考虑，异步请求默认是不支持SEO、不允许被爬取的。商家要赚钱，要提高销量，就得极大化推广自己的商品，所以商品数据要置于同步请求中，暴露给搜索、爬虫。

## 处理静态资源

开发中，我们约定把html文件放在views目录下（本视频如此，下同）。

图片、CSS文件、JS文件、音视频等都叫静态资源。

浏览器解析html文件碰到这些地方时，就发送针对它们的新请求。

我们约定把静态资源放在public目录下，其中还可细化生成几个目录如img、JS、CSS、lib（存放第三方模块）等。

## 模块系统详解

### node控制台

插播节。node控制台与浏览器控制台类似，只不过环境解析不出window等浏览器中才有的js对象。它常用于node API的辅助测试。

在命令行输`node`加回车就进入node控制台，连按两下ctrl+C就退出。

它也被称作REPL：read、eval、print、loop。

### 模块化概念

模块化（编程）具体指两个条件：

- 文件作用域。
- 通信规则。即引入和导出。

原本的JS是不支持上述条件的，即不支持模块化。于是民间出现了五花八门的模块化解决方案如CommonJS、AMD、CMD、UMD等等。最后为了统一化，EcmaScript在2015年发布了ES 2016官方标准，其中就包含了对模块化的支持。

目前前端的很多新技术的目的当然是提高效率，但为了适用于低版本浏览器又不得不靠一些编译工具等价转换。

下面学习一下CommonJS模块规范。

### CommonJS模块规范

#### 概述

有如下规范：

- 模块作用域：模块内部可访问，外部则不行。
- 使用require方法加载模块。
- 使用exports接口对象导出本模块成员。

#### require

语法举例：`let fs = require("./util")`

作用：

- 执行被加载模块的代码。
- 得到被加载模块由exports导出的成员。

#### exports

node奉行模块作用域，文件中的所有成员只在本文件有效。那么对于希望被其他模块访问的成员，我们就要把这些成员挂载到exports接口对象中。

导出多个成员例如：

```js
exports.age = 22
exports.name = "Van"
exports.sayHello = function () {
    console.log("hello world")
}
exports.body = {
    height: 172,
    weight: 55
}
```

导出单个成员例如：

```js
module.exports = "bye"
// 后续还有对module.exports的赋值的话，覆盖前面的

// 在另一个文件中加载
let bye = require("./xxx")
console.log(bye) // bye
```

#### 原理

下面详细说说模块间交互的原理。

node中，每个模块内部都有一个隐式对象叫module，此对象中又有一个属性叫exports。而且模块尾部还有一个隐式返回语句`return module.exports`。所以本质上，模块的所有成员都是挂载到module对象的exports属性上。

node为了简化写法，就将module的exports属性赋给exports变量，实现代码也是隐式的：`var exports = module.exports`。我们可以验证：

```js
// true
console.log(exports === module.exports)
```

所以我们可以说`exports`和`module.exports`就是等价的。

那么我们就继续分析：

- 若想返回多个成员，则对exports添加这些属性，而又因为exports与module的exports引用同一块地址，故module的exports也有了这些属性，最后由返回语句返回给加载模块使用。
- 若想返回单个成员，情况就不一样了。我们把某个成员直接赋给exports，exports就不再指向module的exports所指向的地址，故此成员就不会挂载到module的exports中，也就不能被返回出去。因此对于单个成员的导出，我们只能写`module.exports = xxx`。

实在觉得绕的话，就放弃使用exports，只用`module.exports`。

#### 优先从缓存加载

在一次完整的执行过程中，当第二次加载某个模块时，不会再次执行其代码，而是直接拿到导出的成员。

#### 加载规则

前面我们说加载的模块由自定义模块、核心模块和第三方模块。

关于自定义模块。讨论如下：

```js
// ./ 当前目录
let train = require("./train")
// ../ 上一级目录
let val = require("../val")
// / 绝对路径 即当前文件的磁盘根目录 很少用
let test = require("/test")
```

标识不带路径标识符`/`的模块就一定是非自定义模块即核心模块或第三方模块。

关于核心模块。它们本来是在node源码的lib目录下，但本机安装node之后它们都被编译进node.exe二进制文件中。所以核心模块本质上也是文件，只不过我们可以直接通过名字调用它们。

关于第三方模块。它们必须通过npm下载到局部或全局的node_modules目录中，然后我们也是直接通过包名来调用。那么node如何找到它们？我们首先要约定好不存在与核心模块同名的第三方包。

- 第一种情况：node会先在当前文件目录中找node_modules目录，有则继续找node_modules/包名目录/package.json，然后找目标文件中的main属性。这个main属性就记录了此包的入口模块（就是一个js文件），最后node就执行其中代码，完成加载。
- 第二种情况：package.json文件不存在或存在但其中的main属性不存在，node就径直去加载index.js文件。
- 第三种情况：当前目录中连node_modules目录都没有，node会逐级向上查找此目录，找到了则进行同上后续步骤，否则报错。

以上描述只是粗略的，更详细严谨的可参考文章[node.js的模块机制](https://www.infoq.cn/article/nodejs-module-mechanism)。

看个现成的art-template的例子：

```json
"license": "MIT",
"main": "index.js",
"name": "art-template",
"repository": {
"type": "git",
"url": "git://github.com/aui/art-template.git"
```

```js
/* index.js */
const template = require('./lib/index');
const extension = require('./lib/extension');

template.extension = extension;
require.extensions[template.defaults.extname] = extension;

module.exports = template;
```

照猫画虎，我们甚至可以创造个自己的第三方模块。

综上所述，三种模块最终被加载的都是文件。

#### 包说明文件

理解完node的查找机制我们容易联想到maven，它们的职能是相通的，都是帮我们节省庞杂的依赖导入操作，这种操作体现在包说明文件package.json中，此文件还包括其他的项目相关描述。

我们建议每个项目都要有包说明文件。可以手动创建此文件，也可以通过`npm init`命令初始化出来。后者详情如下：

```shell
PS D:\Van\Desktop\node-demo> npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help init` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (demo) node-demo
version: (1.0.0) 0.0.1
description: 一个简单的node测试项目
entry point: (index.js) main.js
# 其他没填的暂时不管 目前最关心的是dependencies
test command:
git repository:
keywords:
author: zhangchaofan
license: (ISC)
About to write to D:\Van\Desktop\node-demo\package.json:

{
  "name": "node-demo",
  "version": "0.0.1",
  "description": "一个简单的node测试项目",
  "main": "main.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "zhangchaofan",
  "license": "ISC"
}


Is this OK? (yes) yes
```

完毕就在项目目录中得到一个package.json文件：

```json
{
  "name": "node-demo",
  "version": "0.0.1",
  "description": "一个简单的node测试项目",
  "main": "main.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "zhangchaofan",
  "license": "ISC"
}
```

此时尚未引入第三方包，故无依赖项。随后我们引入第三方模块，最好带上`--save`选项以记录依赖信息（npm 5之后不用带，依赖项会自动生成）：

```powershell
PS D:\Van\Desktop\node-demo> npm install --save jquery
npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN node-demo@0.0.1 No repository field.

+ jquery@3.6.0
added 1 package from 1 contributor in 2.485s
PS D:\Van\Desktop\node-demo> npm install --save art-template
npm WARN node-demo@0.0.1 No repository field.

+ art-template@4.13.2
added 33 packages from 141 contributors in 1.678s
```

随后发现包说明文件中多了依赖项（第11行）：

```json
{
  "name": "node-demo",
  "version": "0.0.1",
  "description": "一个简单的node测试项目",
  "main": "main.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "zhangchaofan",
  "license": "ISC",
  "dependencies": {
    "art-template": "^4.13.2",
    "jquery": "^3.6.0"
  }
}
```

此文件的强大之处还在于如果不小心把node_modules文件夹删了，那么只需`npm install `命令就把其中的依赖项全部下载下来。

#### package-lock.json

npm初始化命令会产生package.json文件，而首次安装第三方包会产生另一个文件package-lock.json，后续安装则会更新此文件。

npm 5之前没有这个东西。

我们注意到，每个第三方包的目录下都有一个package.json文件，其中就重点记录了本包所依赖的其他包。那么这许多个package.json文件太零散了，针对整个项目的package-lock.json文件就应运而生，检索展开所有包的信息，包括依赖。节选项目中的代码为例：

```json
"dependencies": {
    "accepts": {
      "version": "1.3.7",
      "resolved": "https://registry.npm.taobao.org/accepts/download/accepts-1.3.7.tgz",
      "integrity": "sha1-UxvHJlF6OytB+FACHGzBXqq1B80=",
      "requires": {
        "mime-types": "~2.1.24",
        "negotiator": "0.6.2"
      }
    },
    "acorn": {
      "version": "5.7.4",
      "resolved": "https://registry.nlark.com/acorn/download/acorn-5.7.4.tgz",
      "integrity": "sha1-Po2KmUfQWZoXltECJddDL0pKz14="
    },
    "array-flatten": {
      "version": "1.1.1",
      "resolved": "https://registry.nlark.com/array-flatten/download/array-flatten-1.1.1.tgz",
      "integrity": "sha1-ml9pkFGx5wczKPKgCJaLZOopVdI="
    },
    "art-template": {
      "version": "4.13.2",
      "resolved": "https://registry.npm.taobao.org/art-template/download/art-template-4.13.2.tgz",
      "integrity": "sha1-TEy9RN4IqtAxZgJAhx9Fx9c3z8E=",
      "requires": {
        "acorn": "^5.0.3",
        "escodegen": "^1.8.1",
        "estraverse": "^4.2.0",
        "html-minifier": "^3.4.3",
        "is-keyword-js": "^1.0.3",
        "js-tokens": "^3.0.1",
        "merge-source-map": "^1.0.3",
        "source-map": "^0.5.6"
      }
    },
    "body-parser": {
      "version": "1.19.0",
      "resolved": "https://registry.npm.taobao.org/body-parser/download/body-parser-1.19.0.tgz",
      "integrity": "sha1-lrJwnlfJxOCab9Zqj9l5hE9p8Io=",
      "requires": {
        "bytes": "3.1.0",
        "content-type": "~1.0.4",
        "debug": "2.6.9",
        "depd": "~1.1.2",
        "http-errors": "1.7.2",
        "iconv-lite": "0.4.24",
        "on-finished": "~2.3.0",
        "qs": "6.7.0",
        "raw-body": "2.4.0",
        "type-is": "~1.6.17"
      }
    },
    "bootstrap": {
      "version": "3.4.1",
      "resolved": "https://registry.nlark.com/bootstrap/download/bootstrap-3.4.1.tgz?cache=0&sync_timestamp=1631029379048&other_urls=https%3A%2F%2Fregistry.nlark.com%2Fbootstrap%2Fdownload%2Fbootstrap-3.4.1.tgz",
      "integrity": "sha1-w6NH1Bniia0R9AM+PEEyuHwIHXI="
    },
    ...
}
```

它这样展开记录的作用是缩短`npm install`完成的时间。分析一下可知，package.json和package-lock.json对依赖的管理是等价的，但后者的信息更快捷明了，因为上面我们已经见识过了，它已经帮我们跳过查找的步骤，罗列了所有包信息，相比之下前者仅记录项目中我们手动显式安装的包，并没有帮我们作进一步的依赖检索。

另一个作用要看它的名字里有个lock（锁），意即锁定包的版本（版本问题有时候是很令人头疼的）。我们可以验证一下，把项目的lock文件和node_modules文件夹删掉，并手动改低package文件中某包的版本，再`npm install`，结果会发现下载得到的包的版本并非改之后的低版本，而是最新版，即自动升级。

### 文件路径与模块路径

一般地，相对路径的`./`开头是可以省略的。请看下面的例子：

```js
let fs = require("fs")
// 默认从当前文件所在目录中找data目录
fs.readFile("data/val.json", (err, data) => {
    if (err) {
        console.log("读取失败");
    }
    else {
        console.log(data.toString());
    }
})
```

前面说过带路径标识符的一定是自定义模块，那么自定义模块路径就不能像上面的文件路径那样省略开头的`./`，省了就会被node认定为非自定义模块，就必定找不到。例如：

```js
// 不用带.js后缀
require("./data/util")
```

另外千万不要把`./`和`/`混淆了。

### 相对路径与绝对路径

无论相对路径出现在哪个文件，起点都只能是命令行的当前目录。有时候当前目录、入口文件及该文件所在目录均不一样，比如：

```shell
# 在入口文件的上一级目录运行入口文件且该文件在入口文件所在目录的下一级目录，绵延三级
PS D:\chaofan\vscode\nodejs> node .\demo\main.js
```

由于此机制，有时稍不注意，某文件中写的相对路径就可能找不到。于是我们马上想到将相对路径改为显式绝对路径，但这又有问题，即文件或项目一旦移动就会使原显式绝对路径失效。最后，node提供非模块成员`__filename`及`__dirname`，为我们动态获取当前文件的绝对路径（隐式绝对路径）及其所在目录的绝对路径。

注：引入模块时，node不光执行主函数体，也连带执行其他文件的可执行代码。

JS中require语句里的相对路径对上述问题免疫，因为其导包起点永远是当前文件所在目录。

我们有必要掌握node的[path模块](http://nodejs.cn/api/path.html)，里面有许多实用API。

## NPM常用命令

npm有两层含义：一是[npm网站](https://www.npmjs.com/)，二是npm命令行工具。

升级npm-自己升级自己：

```shell
npm install --global npm
```

跳过向导，快速构建项目：

```shell
npm init -y
```

install系列：

```shell
# 仅下载某个包
npm install xxx
npm i xxx
npm i xxx

# 下载某个包并将依赖信息保存至package.json中
npm install --save xxx
npm install xxx --save
npm i -S xxx
npm i xxx -S

# 根据package.json中的dependencies属性安装所有包
npm install
npm i
```

uninstall系列：

```shell
# 仅删除包目录，不删除依赖信息
npm uninstall xxx
npm un xxx

# 把包目录和依赖信息都删除
npm uninstall --save xxx
npm un -S xxx
```

help系列：

```shell
# 查看使用帮助
npm help

# 查看指定命令的使用帮助
npm uninstall --help 
```

为提高速度，可使用淘宝镜像作为下载源：

```sh
npm config set registry https://registry.npm.taobao.org
# 有时候官网快
npm config set registry http://www.npmjs.org
```

查看npm的配置信息：

```shell
npm config list
```

查看已安装情况：

```sh
# depth指依赖显示深度
npm list --depth=0
npm list --depth --global
npm list element-ui
```

## Express

### 概述

基于node的web框架能提高我们的开发效率，让不同开发人员写的代码统一化。在node中有许多web开发框架，这里我们以express为主展开学习。

这是express的[官网](https://expressjs.com.cn)。

express帮我们做了底层的工作，让代码变得更优雅。比如避免路径判断、感知并设置响应头（如content-type）、简化静态资源的开放操作等。

### 案例

下面是一个简单案例：

```js
let express = require("express")
let app = express()
app.listen(8000, () => {
    console.log("server is running...");
})
// 指定公开目录
app.use("/public/", express.static("./public/"))
app.use("/views", express.static("./views/"))
app.get("/", (req, res) => {
    res.send("hello express")
})
```

稍微提一下，原有的API依然可以用。例如：

```js
app.get("/", (req, res) => {
    res.write("hello ")
    res.write("world")
    res.end()
    // 等价写法 res.end("hello world")
})
```

但是express不推荐再使用原来的API了，因为这样它就无法做设置content-type、字符集等补充操作。比如仍就上例，express就优化为`res.send("hello world")`。

注：模块实现热部署：

1. 安装nodemon：

   ```shell
   npm install --global nodemon
   ```

2. 用nodemon运行：

   ```shell
   nodemon xxx.js
   # powershell上有nodemon脚本禁止运行的情况
   npx nodemon xxx.js
   ```

如此一来，每当保存xxx.js文件之后，项目就自动重启。

### 整合art-template

插入节。

这是art-template和express搭配使用的[官方文档](http://aui.github.io/art-template/express/)。内容很少，能快速上手。安装语句为：

```shell
# 前提是art-template已安装
npm install --save express-art-template
# 若未安装，可一并安装下来 用空格分隔诸模块即可
npm install --save art-template express-art-template
```

关于请求参数的获取。express通过`req.query`获取查询字符串，此外它已经内置获取请求体的模块body-parser，不用另外安装。

下面贴了项目的服务端代码：

```js
let comments = [
    { name: "Bob", comment: "今天天气真好", dateTime: new Date("2020/9/30") },
    { name: "Tom", comment: "今天天气真好", dateTime: new Date("2021/8/2") },
]

const express = require("express")
const app = express()

// 使用render函数的前提是整合art-template 推荐用art作文件名后缀以提高辨识度
app.engine("html", require("express-art-template"))
// 解析application/x-www-form-urlencoded形式的请求体
app.use(express.urlencoded({ extended: false }))
// 解析application/json或multipart/form-data
app.use(express.json())

app.listen(80, () => {
    console.log("server is running...");
})
// 指定公开目录
app.use("/public/", express.static("./public/"))

// 访问主页 
app.get("/", (req, res) => {
    // render第一个入参只给名字即可，按照约定默认就从views目录里找
    res.render("index.html", {
        comments
    })
})
// 访问发表页
app.get("/post", (req, res) => {
    res.render("post.html")
})
// 发表
app.post("/comment", (req, res) => {
    // let comment = req.query  req.query只能获取显式请求参数
    let comment = req.body
    comment.dateTime = new Date()
    comments.unshift(comment)
    // 重定向
    res.redirect("/")
})
```

### 路由

#### 基本路由

下面就get和post两种请求方法列举一些象征性的例子。

get：

```js
app.get("/getStudents", (req, res) => {
    // ...
})
app.get("/getScores", (req, res) => {
    // ...
})
```

post：

```js
app.post("/addStudent", (req, res) => {
    // ...
})
app.post("/deleteStudent", (req, res) => {
    // ...
})
app.post("/updateStudent", (req, res) => {
    // ...
})
```

#### 静态资源

直接上例子：

```js
app.use("/views", express.static("./views"))
// 对上例的扩展 随便戴多少个帽子，反正整个都会被后面的替换掉
app.use("/user/views", express.static("./views"))

// 默认的开放目录 请求路径直接写成static目录里面的东西 这里就没有替换了
app.use(express.static("./static"))
```

#### 代码抽离

我们可以把专门处理路由的代码分到独立的模块中去。例如（省略了许多非关键性代码）：

```js
/* router.js */
module.exports = (app) => {
    // 函数体
}
```

```js
/* app.js */
// 导入路由文件
const router = require("./router")
// 调用路由处理
router(app)
```

express提供了更优雅的实现。对上述代码进行改写（省略同上）：

```js
/* router.js */
// 路由容器
const router = express.Router()
// 处理路由
router.get("/", (req, res) => {
    // 函数体
})
// 导出路由容器
module.exports = router
```

```js
/* app.js */
const router = require("./router")
// 挂载路由
app.use(router)
```

从理念上讲，划分模块的目的就是使模块的职责更单一，增强项目的可维护性。

## 回调函数

插入章。理解异步任务有回调函数，同步任务也有回调函数，这里重点谈同步任务的回调函数。

回调函数是JS异步机制的精髓。某事件发生才调用并执行回调函数，这么做的一大初衷就是避免长时任务造成的无谓等待。

那么学习到node，就又出现了正相反的场景：文件读写很费时，但我们恰恰是要等文件读写完成再作后续操作。文件读写是异步的：主线程一遇到`fs.readFile`方法就开始读文件，尴尬的事情发生了，文件还没读完，主线程就已经响应回去了。

解决：将原来的同步响应代码写到文件读写函数的回调函数体内，于是主线程开始读写文件后就会发现，同步任务一个都没有，就只能先等异步任务执行完。那么等到文件一读写完，它们的回调函数就成了同步任务（进入执行栈），于是执行到其中的响应代码处，就能顺利带着数据响应回去。

所以我们看有时候是想发挥异步机制的优势，但有时候又想还原异步任务为同步任务，应实事求是。

以我们的项目为例：

```js
router.get("/deleteStudent", (req, res) => {
    // 调用函数B 带函数体的匿名函数A作函数B的回调函数 注意到A在这里是B的实参，而err又是A的形参
    studentDao.deleteStudent(req.query.id, (err) => { // 作实参的A被定义
        if (err) {
            res.status(500).send("server error...")
        }
        else {
            // 将最终的返回过程写到回调函数A里面
            res.redirect("/")
        }
    })
})
```

```js
// 自定义同步任务即函数B，函数A即callback为其回调函数 与上对比，此处A是B的形参，体现了高阶函数的思想
exports.deleteStudent = function (id, callback) { // 作形参的A被调用
    fs.readFile(dbPath, "utf-8", (err, data) => { // 两重任务-外层同步，内层异步，兼有两重回调函数-本函数是内层异步任务readFile的回调函数，callback是外层同步任务的回调函数，用于获取内层异步任务回调函数的结果
        /* 读文件的完成（只不过存在分支） */ 
        if (err) {
            // 这里err又是A的实参
            callback(err)
        }
        else {
            let students = JSON.parse(data)
            let targetIndex = students.findIndex((item) => {
                return item.id === parseInt(id)
            })
            students.splice(targetIndex, 1)
            fs.writeFile(dbPath, JSON.stringify(students), (err) => {
                /* 写文件的完成 也存在分支 */ 
                if (err) {
                    callback(err)
                }
                else {
                    callback(null)
                }
            })
        }
    })
}
```

剖析上例：将原来的同步响应代码封装成函数A，然后将函数A作为文件读写函数的父函数B的参数，亦即自定义同步任务的回调，再在文件读写的回调函数体中即读写完成后调用函数A。

函数A是同步任务-函数B的回调，这就印证了同步任务也可以有回调函数。

最后我们就抛开回调函数这一思想，看看更简洁的写法：

```js
/* 最简洁 不做函数B 不做函数A  */
router.get("/deleteStudent", (req, res) => {
    fs.readFile(dbPath, "utf-8", (err, data) => {
        if (err) {
            res.status(500).send("server error...")
        }
        else {
            let students = JSON.parse(data)
            let targetIndex = students.findIndex((item) => {
                return item.id === parseInt(id)
            })
            students.splice(targetIndex, 1)
            fs.writeFile(dbPath, JSON.stringify(students), (err) => {
                if (err) {
                    // 直接写，不封装
                    res.status(500).send("server error...")
                }
                else {
                    res.redirect("/")
                }
            })
        }
    })
})
```

```js
/* 次简洁 保留函数A，不做函数B，这样一来A就无法作回调 */ 
router.get("/deleteStudent", (req, res) => {
    // 只能写里面 实在想写在外面，就只能将res设为fun的参数
    function fun (err) => {
        if (err) {
            // 此处产生闭包
            res.status(500).send("server error...")
        }
        else {
            res.redirect("/")
        }
    }
    fs.readFile(dbPath, "utf-8", (err, data) => {
        if (err) {
            fun(err)
        }
        else {
            let students = JSON.parse(data)
            let targetIndex = students.findIndex((item) => {
                return item.id === parseInt(id)
            })
            students.splice(targetIndex, 1)
            fs.writeFile(dbPath, JSON.stringify(students), (err) => {
                if (err) {
                    fun(err)
                }
                else {
                    fun(null)
                }
            })
        }
    })
})
```

## MongoDB

### 概述

[MongoDB](https://www.mongodb.com/zh-cn)是一个非关系型数据库（NoSQL）。那么学习NoSQL就不需要掌握SQL语法。

非关系型数据库细分为多种，比如有的所采用的数据结构是键值对。

我们要学的MongoDB是长得最像关系型数据库的非关系型数据库，因为它有如下概念：

- 数据库。
- 集合（collection）。对应关系型数据库里的数据表。
- 文档（document）。对应关系型数据库里的记录（元组）。

但同时，它又不需要设计表结构。

### 安装

这是[下载地址](https://www.mongodb.com/try/download/community)，亲测用迅雷下载zip版最快。

要配置环境变量，具体到安装目录下的bin目录一级。

检查成功与否：

```shell
C:\Users\Van>mongo --version
MongoDB shell version v5.0.3
Build Info: {
    "version": "5.0.3",
    "gitVersion": "657fea5a61a74d7a79df7aff8e4bcf0bc742b748",
    "modules": [],
    "allocator": "tcmalloc",
    "environment": {
        "distmod": "windows",
        "distarch": "x86_64",
        "target_arch": "x86_64"
    }
}
```

### 服务的启动与关闭

服务程序mongod依赖于数据库根目录，即命令行路径的磁盘根目录的`data/db`目录，如果没有的话需要我们手动创建。创建好之后无论在本盘下的哪儿执行mongod程序都会在此数据库根目录生成一些初始材料。

也可以修改默认数据库根目录，不过每次执行mongod程序时就得跟上这串路径：

```shell
mongod --dbpath=自定义路径
```

关闭很简单：或按Ctrl+C或直接关闭控制台。

### 连接与退出数据库

连接：

```shell
# 重开一个控制台 默认使用本机数据库服务 要知道还有云服务（以后了解）
C:\Users\Van>mongo
```

退出：

```shell
# 在当前已连接状态的控制台
> exit
```

### 基本使用

这里就省略了，不太重要，自行找文档，比如菜鸟的[MongoDB 教程](https://www.runoob.com/mongodb/mongodb-tutorial.html)，里面也教了如何将mongod注册为windows服务。

### mongoose

#### 概述

有了数据库，下面就该配合node来使用。我们一般不用官方的mongodb包来开发，因为过于麻烦。

有操作更为简单的第三方包[mongoose](https://mongoosejs.com/)，它是基于mongodb包作了二次封装。

#### 入门案例

下面我们就官网给的首个例子作一些分析：

```js
const mongoose = require('mongoose');
// 连接数据库
mongoose.connect('mongodb://localhost:27017/test');
// 创建集合 最终的集合名会是小写复数cats 初始设计一个字段name，类型为字符串
const Cat = mongoose.model('Cat', { name: String });
// 集合实例
const kitty = new Cat({ name: 'Zildjian' });
// 持久化保存这个集合
kitty.save().then(() => console.log('meow'));
```

从第5行可以看出，尽管mongo的集合的（文档）结构很灵活，但这里最好约定一种结构，保证数据完整统一。

用命令行验证：

```shell
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
test    0.000GB
> use test
switched to db test
> show collections
cats
> db.cats.find()
{ "_id" : ObjectId("6162d622f20fe29b845bc7a4"), "name" : "Zildjian", "__v" : 0 }
```

我们可以看出不像java与数据库的交互那么复杂，mongoose仅凭简单的代码就将建库、建集合、连接、增删改查等实现出来。

#### 基本使用

我们仍旧沿着官方文档的指南复现并分析。

首先是设计schema（集合的结构）、发布model（集合模型）：

```js
const mongoose = require('mongoose');
// 连接数据库 被连接的数据库不需要事先存在 插入第一条文档之后它才自动被创建
mongoose.connect("mongodb://localhost/guide")
// 结构构造器
let Schema = mongoose.Schema
// 设计集合结构 以对象的形式
const userSchema = new Schema({
    // 属性名是字段名 属性值可以是对象，其中容纳多个约束如非空、默认值等
    username: {
        type: String,
        // 非空
        required: true
    },
    password: {
        type: String,
        required: true
    },
    // 属性值可以是字段类型
    email: String
});
// 根据结构生成集合模型，既能创建集合（首次保存后）又能构造文档对应的对象 第一个参数为首字母大写的单数字符串，mongoose会据此生成小写复数名称的集合如User->users
let User = mongoose.model("User", userSchema)
```

注意上述代码中出现的类型是MongoDB所规定的类型，写法上与JS里的数据类型是不完全一样的。

其次就是核心的增删改查了。详尽的API可参照[官方文档的Model部分](https://mongoosejs.com/docs/api/model.html)，下面的示例只是一小部分。

向集合里增加一条文档：

```js
// 新构造一个对象
let admin = new User({
    username: "admin",
    password: "123456",
    email: "admin@google.com"
})
// 将此对象保存为一条文档 这里是保存首条文档，所以顺带创建了User集合
admin.save((err, res) => {
    if (err) {
        console.log("插入（保存）失败");
    }
    else {
        console.log("插入成功：");
        console.log(res);
    }
})
```

每添加一条文档，mongdb会自动附加上一个ObjectId类型的主键`_id`如`ObjectId("6163f8a50f801e1840489b59")`，而mongoose能在查询到某条文档、形成model对象之后自动根据此`_id`添加一个字符串类型的属性`id`。

下面看查询：

```js
// 查询所有文档
User.find((err, res) => {
    if (err) {
        console.log("查询失败");
    }
    else {
        // res类型为数组
        console.log(res);
    }
})
// 按条件查询所有
User.find(
    // 对象作条件
    {
        username: "小张",
        password: "888888"
    },
    // 回调函数 获得异步操作（查询）的结果-错误或成功得到的模型对象
    (err, res) => {
        if (err) {
            console.log("查询失败");
        }
        else {
            console.log(res);
        }
    }
)
// 按条件查询第一条
User.findOne(
    {
        username: "小张"
    },
    (err, res) => {
        if (err) {
            console.log("查询失败");
        }
        else {
            // res类型为对象
            console.log(res);
        }
    }
)
```

再来看删除：

```js
// 按条件删除所有
User.deleteMany(
    // 过滤条件
    {
        username: "小张"
    },
    (err, res) => {
        if (err) {
            console.log("删除失败");
        }
        else {
            console.log("删除成功");
            // 其实res没啥意义，不报错就是成功了
            console.log(res);
        }
    }
)
```

最后看更新：

```js
// 根据条件更新所有
User.updateMany(
    // 过滤条件
    {
        username: "admin"
    },
    // 所作修改
    {
        username: "sys",
        password: "333333",
        email: "sys@itcast.com"
    },
    // 第二个参数res没啥意义，直接略掉
    (err) => {
        if (err) {
            console.log("修改失败");
        }
        else {
            console.log("修改成功");
        }
    }    
)
// 根据条件更新第一条 这是项目里的例子
Student.updateOne(
    // 注意虽然前面说了_id不是字符串但这里存在自动类型转换，将字符串转为ObjectId
    { _id: req.body.id },
    req.body,
    (err) => {
        if (err) {
            res.status(500).send("server error...")
        }
        else {
            res.redirect("/")
        }
    }
)
```

最后再次强调API瞬息万变，正在使用的东西可能转眼间就被弃用了，要多看文档。

最后给一个完整的用例，即将项目的student.js和router.js文件摘录下来：

```js
/* student.js */
const mongoose = require("mongoose")
// 默认端口是27017 保持默认的话可省略
mongoose.connect("mongodb://localhost/itcast")
const studentSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    gender: {
        type: Number,
        // 枚举
        enum: [0, 1],
        // 默认值
        default: 0
    },
    age: {
        type: Number
    }
})
const Student = mongoose.model("Student", studentSchema)
module.exports = Student
```

```js
/* router.js */
const express = require("express")
// 路由容器
const router = express.Router()
const Student = require("./student")

// 访问首页 渲染学生列表
router.get("/", (req, res) => {
    Student.find((err, students) => {
        if (err) {
            res.status(500).send("server error...")
        }
        else {
            res.render("index.html", {
                students
            })
        }
    })
})
// 访问添加学生页
router.get("/createPage", (req, res) => {
    res.render("createPage.html")
})
// 添加学生
router.post("/createStudent", (req, res) => {
    // save的回调函数的第二个参数没啥意义，略掉了
    new Student(req.body).save((err) => {
        if (err) {
            res.status(500).send("server error...")
        }
        else {
            res.redirect("/")
        }
    })
})
// 访问修改学生页
router.get("/updatePage", (req, res) => {
    Student.findById(req.query.id, (err, student) => {
        if (err) {
            res.status(500).send("server error...")
        }
        else {
            res.render("updatePage.html", {
                student
            })
        }
    })
})
// 修改学生
router.post("/updateStudent", (req, res) => {
    Student.updateOne(
        // 自动类型转换
        { _id: req.body.id },
        req.body,
        (err) => {
            if (err) {
                res.status(500).send("server error...")
            }
            else {
                res.redirect("/")
            }
        }
    )
})
// 删除学生
router.get("/deleteStudent", (req, res) => {
    Student.deleteOne(
        { _id: req.query.id },
        (err) => {
            if (err) {
                // 像这里也产生了闭包，体现于res，有两层匿名回调函数
                res.status(500).send("server error...")
            }
            else {
                res.redirect("/")
            }
        }
    )
})

module.exports = router
```

## Promise

### 概述

本章只记述老师选讲的promise知识，更全面的去参考[Promise笔记](Promise.md)。

窃以为promise秉持同步任务的回调函数的理念。

### 回调地狱

承接前面讲到的回调函数的深究，来看看回调地狱问题。

扯理论还不好懂，直接上个经典的例子-读多个文件：

```js
// 读取A B C三个文件
const fs = require("fs")
fs.readFile("./a.txt", "utf-8", (err, data) => {
    if (err) {
        throw err
    }
    else {
        console.log("a 读取完毕");
    }
})
fs.readFile("./b.txt", "utf-8", (err, data) => {
    if (err) {
        throw err
    }
    else {
        console.log("b 读取完毕");
    }
})
fs.readFile("./c.txt", "utf-8", (err, data) => {
    if (err) {
        throw err
    }
    else {
        console.log("c 读取完毕");
    }
})
```

多次运行的结果摘录如下：

```powershell
c 读取完毕
b 读取完毕
a 读取完毕

a 读取完毕
b 读取完毕
c 读取完毕

b 读取完毕
c 读取完毕
a 读取完毕
```

显而易见，乱七八糟。说明一下a文件是最大的。

由上可知，读取开始的顺序一定是a、b、c，但结束的顺序是捉摸不定的，即便a是最大的，也有可能最先读完。如果我们想永远输出第二坨结果，不难想到可以这样改：

```js
const fs = require("fs")
fs.readFile("./a.txt", "utf-8", (err, data) => {
    if (err) {
        throw err
    }
    else {
        console.log("a 读取完毕");
        // a读完了才读b
        fs.readFile("./b.txt", "utf-8", (err, data) => {
            if (err) {
                throw err
            }
            else {
                console.log("b 读取完毕");
                // b读完了才读c
                fs.readFile("./c.txt", "utf-8", (err, data) => {
                    if (err) {
                        throw err
                    }
                    else {
                        console.log("c 读取完毕");
                    }
                })
            }
        })
    }
})
```

眼见一个明显的多层的回调函数套异步任务的结构。这种嵌套结构是很丑的，尤其回调函数的数量一旦庞大起来就很难阅读。

### 核心用法

针对回调嵌套地狱的缺陷，ES6开始引入promise。

我们可以把promise描述为一个容器，当中往往存放一个异步任务。此容器有三种状态，从时间上看：

1. pending：任务的进行。比如文件读取、计时、移动光标等等。
2. 进行完毕，容器会进入以下两种状态之中的一种：
   - resolved：结果为成功。比如已获得要读取的数据、定时器到期等等。
   - rejected：结果为失败。比如读文件过程中由于某种原因出错、未获得数据等等。

先看下面这个例子：

```js
fs = require("fs")
console.log(1);
// promise本质上是个构造函数 我们可以把promise称作承诺容器
new Promise(() => { // 这个实参函数叫执行器函数，一经定义就立即同步执行
    console.log(2);
    fs.readFile("a.txt", "utf-8", (err, data) => {
        // 承诺容器里的任务失败了
        if (err) {
            console.log(err);
        }
        // 承诺容器里的任务成功了
        else {
            console.log(3);
            console.log(data);
        }
    })
})
console.log(4);

// 打印结果：1 2 4 3 文件内容
```

上述代码按打印结果等价地缩略成这样：

```js
fs = require("fs")
console.log(1);
console.log(2);
fs.readFile("a.txt", "utf-8", (err, data) => {
    // 承诺容器里的任务失败了
    if (err) {
        console.log(err);
    }
    // 承诺容器里的任务成功了
    else {
        console.log(3);
        console.log(data);
    }
})
console.log(4);

// 打印结果：1 2 4 3
```

所以我们不难看出向promise的构造函数中传入的函数是同步任务，但它其函数体内的任务往往是异步的。

再往下看：

```js
fs = require("fs")

let p = new Promise((resolve, reject) => {
    console.log(2);
    fs.readFile("a.txt", "utf-8", (err, data) => {
        // 承诺容器里的任务失败了
        if (err) {
            // 于是调用reject，将容器状态变为rejected
            reject(err)
        }
        // 承诺容器里的任务成功了
        else {
            // 于是调用resolve，将容器状态变为resolved
            resolve(data)
        }
    })
})
// then函数被同步调用
p.then( 
    function (data) { // 形参data的值与resolve的实参data的值保持一致
        console.log(data);
    },
    function (err) { 
        console.log("读取文件失败");
    }
)
```

resolve和reject的职责在于改变容器状态及拿到异步任务结果；then方法的两个参数函数的职责在于在容器状态改变之后根据异步任务结果做后续操作。

我们继续来看promise怎么对回调嵌套进行优化的：

```js
fs = require("fs")

let p1 = new Promise((resolve, reject) => {
    fs.readFile("a.txt", "utf-8", (err, data) => {
        if (err) {
            reject(err)
        }
        else {
            resolve(data)
        }
    })
})

let p2 = new Promise((resolve, reject) => {
    fs.readFile("b.txt", "utf-8", (err, data) => {
        if (err) {
            reject(err)
        }
        else {
            resolve(data)
        }
    })
})

let p3 = new Promise((resolve, reject) => {
    fs.readFile("c.txt", "utf-8", (err, data) => {
        if (err) {
            reject(err)
        }
        else {
            resolve(data)
        }
    })
})

/* 省略了失败结果的回调 */
p1.then(
    function (data) {
        console.log("读取文件 a")
        // 于是p2中的异步任务读文件b就一定在读文件a成功之后开始
        return p2
    },
).then( // 此处then函数的调用者就成了p2
    function (data) {
        console.log("读取文件 b");
        // 于是p3中的异步任务读文件c就一定在读文件b成功之后开始
        return p3
    }
).then( // 此处then函数的调用者就成了p3
    function (data) {
        console.log("读取文件 c");
    }
)
```

我们宏观地看最后一坨，一种诸任务依次进行的并列结构映入眼帘，这就比之前的嵌套结构直观优雅多了。

我们还可以进一步对重复代码进行封装：

```js
fs = require("fs")

/**
 * @description: 生成一个promise容器，其中存放读文件异步任务
 * @param {string} filePath 文件路径
 * @return {Promise}
 */
function getReadFilePromise(filePath) {
    return new Promise((resolve, reject) => {
        fs.readFile(filePath, "utf-8", (err, data) => {
            if (err) {
                reject(err)
            }
            else {
                resolve(data)
            }
        })
    })
}

getReadFilePromise("a.txt")
    .then(
        function (data) {
            console.log("读取文件 a")
            return getReadFilePromise("b.txt")
        }
    )
    .then(
        function (data) {
            console.log("读取文件 b");
            return getReadFilePromise("c.txt")
        }
    )
    .then(
        function (data) {
            console.log("读取文件 c");
        }
    )
```

promise只改进了代码的美观性，而在功能上等价于朴素写法，并没有提升效率。想象一下大型web应用存在着几十上百个回调函数的嵌套，那是相当恐怖的，用promise来美个容是极好的。

再练一个例子-给原生ajax套上promise：

```js
/**
 * @description: 自行将ajax get请求封装进promise
 * @param {string} url 请求路径
 * @return {Promise} promise容器
*/
function getAjaxPromise(url) {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest()
        xhr.responseType = "json"
        xhr.open("get", url)
        xhr.send()
        xhr.onload = () => {
            resolve(xhr.response)
        }
        xhr.onerror = (err) => {
            reject(err)
        }
    })
}
btn.addEventListener("click", function () {
    getAjaxPromise("http://localhost/first-server")
        .then((res) => {
            console.log(res);
            return getAjaxPromise("http://localhost/second-server")
        })
        .then((res) => {
            console.log(res);
        })
})
```

最后我们回到项目上，mongoose已经支持promise，这里就只看一下渲染返回主页的改进写法：

```js
router.get("/", (req, res) => {
    Student.find()
        .then(
            (students) => {
                res.render("index.html", {
                    students
                })
            },
            (err) => {
                res.status(500).send("server error...")
            }
        )
})
```

### 注

性能不是我们码农该考虑的问题。

promise这些干封装的框架在性能上当然没有原生的高，且封装得越复杂性能越低。但是，既然它们这么火，就不要浅薄地考虑性能问题，内心默认忽略不计就行了。不然它们真拖性能的话，早就被人们唾弃了。

## 同步请求与异步请求

历史上先有同步请求后有异步请求。

最开始的做法是：以表单校验为例，发送同步请求后，浏览器等客户端会锁死等待，直到得到服务端响应的结果，然后在本页面渲染结果，不管结果是完整的html文档还是细碎的json等数据甚至是异常信息，本页原来的内容会被清空。

上述细碎数据就包括`用户名已存在`这样的提示信息，那么人们觉得这种不成页面的东西呈现在眼前很丑，所以后来想到新的做法：还是同步请求，不过服务端不是单纯返回数据，而是再次整体渲染好数据（可包括原表单请求体），仍旧转发到原html文档。于是对用户来说，看起来页面没啥变化，就多了一坨提示信息。

目前这种基于同步请求，完全由服务端控制的交互方式仍有许多网站（如github）在使用，因为它较为统一。那么再后来，就有用户体验师为用户着想，提出了更丰富优雅的交互方式，便形成了异步请求：页面里其他东西都不动，只靠前端通过操作dom渲染出收到的提示数据，来实现交互。

一个安全的网站既有前端校验又有后端校验，故上述交互工作服务端和客户端都参与了。

当服务端处理异步请求，转发和重定向是无效的，转发和重定向只在对同步请求的处理中才有用。注意这种无效是从页面展示这个角度说的，即页面（包括地址栏）不发生任何变化。但是在控制台中能发现，实质上浏览器确实访问了转发或重定向的地址，还能解析响应体如html文本，但解析出来的东西只能在控制台展示。

## Express的中间件

中间件的原始理论知识就不扯了。

express里，中间件本质上是方法，职能是匹配并处理请求。我们把从开始处理请求到响应的整个过程分解，然后分发给诸中间件。

它的基本结构如下：

```js
app.use("/xxx", function (request, response, next) {
    //...
    // next() 调用下一个匹配到的中间件
})
```

说说上述参数：

- 开头的字符串是匹配条件。
- request：请求对象。
- response：响应对象。
- next：下一个中间件。

像下面这些都是中间件：

```js
app.use()
app.get()
app.post()
//...
```

我们看项目里许多调用use的地方首参都没有，即默认地匹配到任意请求，不关心路径名与请求类型。

从作用上讲，它和JavaWeb里的过滤器异曲同工。

express官网给了一个关于中间件的[指南](http://expressjs.com/en/guide/using-middleware.html#using-middleware)，它按职能对中间件作了分类，如应用级别、路由级别、错误处理。这里通过改写项目，来重点实践一下错误处理中间件：

```js
/* app.js 其他省略 */
// 挂载路由 要在后两个中间件的前面
app.use(router)
// 404中间件 没被匹配到的请求就会被此处理
app.use((req, res) => {
    res.render("404.html")
})
// 统一处理异常
app.use(function (err, req, res, next) {
    res.status(500).json({
        message: err.message
    })
})
```

```js
/* router.js */
// 登录
router.post("/login", (req, res, next) => {
    User.findOne({
        email: req.body.email,
        password: md5(md5(req.body.password))
    }, (err, user) => {
        if (err) {
            // res.status(500).json({
            //     message: err.message
            // })
            // 交给错误处理中间件处理
            next(err)
        } else {
            if (!user) {
                res.status(200).json({
                    code: 250,
                    message: "邮箱或密码错误"
                })
            } else {
                if (user.status === 2) {
                    res.status(200).json({
                        code: 250,
                        message: "此账户已被封禁"
                    })
                } else {
                    // 将用户数据加入session
                    req.session.user = user
                    res.status(200).json({
                        code: 520,
                        message: "登录成功"
                    })
                }
            }
        }
    })
})
```



ge
