# Ajax

参考视频：[3小时Ajax入门到精通](https://www.bilibili.com/video/BV1WC4y1b78y)。

## 概述

理论部分省略，可参考[ajax-w3school](https://www.w3school.com.cn/js/js_ajax_intro.asp)与[ajax-mdn](https://developer.mozilla.org/zh-CN/docs/Web/Guide/AJAX)。这里主要围绕实践作记录。

[HTTP请求行、请求头、请求体详解](https://www.jianshu.com/p/eb3e5ec98a66)一文对request和response作了充分的解读。

我们一般把端口号到请求字符串之间的这段叫作路径名，如上面的`/server`。

## 实践

### get

我们基于node与express搭一个简单的服务端：

```js
const express = require("express")
const app = express()
app.get("/server", (req, res) => {
    // 此站点支持所有源站点的跨域共享
    res.setHeader("Access-Control-Allow-Origin", "*")
    res.send("Hello Ajax!")
})
app.listen(8000, () => {
    console.log("server launched");
})
```

然后通过点击按钮向其发送ajax请求，接收响应数据并写到页面中：

```html
<body>
    <button>发送请求</button>
    <div id="res"></div>
</body>
<script>
    const btn = document.querySelector("button")
    const div = document.querySelector("#res")
    btn.onclick = function () {
        // 创建ajax对象
        const xhr = new XMLHttpRequest()
        // 初始化请求，指定类型和地址
        xhr.open("get", "http://localhost:8000/server")
        // 发送请求
        xhr.send()
        // 监听请求状态的变化 异步的关键，有回调函数
        xhr.onreadystatechange = function () {
            // readystate是xhr对象的属性，可取以下各值
            // 0：open之前
            // 1：open之后
            // 2：send之后
            // 3：服务端开始返回数据
            // 4：服务端返回了数据
            if (xhr.readyState === 4) {
                // 2xx 成功
                if (xhr.status >= 200 && xhr.status < 300) {
                    /* 处理返回结果 行 头 空行 体 */
                    // 响应行：状态码和状态字符串
                    console.log(xhr.status, xhr.statusText);
                    // 响应头
                    console.log(xhr.getAllResponseHeaders());
                    // 响应体
                    console.log(xhr.response);
                    // 渲染到页面中
                    div.innerText = xhr.response
                } else {

                }
            }
        }
    }
</script>
```

依靠[onload](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequestEventTarget/onload)事件的前端实现更简单。

### 带参请求

修改open方法的参数，眼见得原路径跟了一个参数串`?name=Van&age=22&gender=man`。

```js
xhr.open("get", "http://localhost:8000/server?name=Van&age=22&gender=man")
```

访问时在浏览器调试台也有反映：

<img src="Ajax.assets\image-20210830115041918.png" alt="image-20210830115041918" style="zoom:80%;" />

这个参数串如上所见叫查询字符串，注意和下面接触到的隐式参数-请求体区分开，它是显式参数，可用于post、put等多种方法。

### post

在前端，只需将get方法改成post方法：

```js
xhr.open("post", "http://localhost:8000/server")
```

在后端，也是将get方法改为post方法：

```js
app.post("/server", (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", "*")
    res.send("here are post")
})
```

我们再附上参数。注意要想参数是隐式的，就得将其写成send方法的参数，而不像get方式那样直接嵌在open方法的url参数后部。

```js
xhr.send("name=Van&age=22&gender=man")
```

而且参数串的写法是不固定的，比如还可以这样写：

```js
xhr.send("name:Van&age:22&gender:man")
```

在实际场景中，前一种靠等号连接的居多，另外json字符串也居多。

虽然post请求既可携带请求字符串，也可携带请求体，但是post自身的优势在于安全的隐式参数，那么果真携带前者就无甚意义了。请求体独立于路径之外，便体现了安全性。

### 设置请求头

例如：

```js
// 指定内容类型
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
```

完成后访问服务端就会发现调试台的Request Headers一栏中`Content-Type`这一项的值就是`application/x-www-form-urlencoded`，其他属性是浏览器默认为我们设的。

上面这条Content-Type是预定义设置项，我们也可以自定义设置项：

```js
xhr.setRequestHeader("name", "command and alert")
```

设定后直接发请求的话会报错，因为浏览器存在安全检查，默认不支持自定义的请求头项，只支持预定义的。那么一般都是后端人员做出一些调整，使得自定义的被满足：

1. 调整响应头信息，以允许任何请求头信息，包括自定义的。
2. 上一步完毕，带自定义请求头信息的请求类型会自动转为options，那么我们还要在后端实现对此类请求的受理。

```js
// 接收任意类型请求（fetch、options等等）
app.all("/server", (req, res) => {
    res.setHeader("Access-Control-Allow-Headers", "*")
    res.send("here are post-options")
})
```

我们一般会把身份校验信息放在请求头里，传递给服务端，服务端再提取请求头里的信息来校验客户端身份。

后面我们还发现，把Content-Type改成非默认值如`xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8")`也通不过浏览器的安全检查，就也要通过上面两步来解决。

### 内容类型

即content-type，下面引用一段解释：

> Content-type是实体首部字段，用于说明请求或返回的消息是用什么格式进行编码的，在request header和response header里都有存在。 用来向服务器或者浏览器说明传输的文件格式，以便服务器和浏览器按照正确的格式进行解析。在最初的的http post请求只支持application/x-www-form-urlencoded,参数是通过浏览器的url进行传递，但此种方法不支持文件上传，所以后来Content-type 扩充了multipart/form-data类型以支持向服务器发送二进制数据，以及随着后面web应用的日益发展增加了application/json的类型

Content-Type取值主要有三种：

- application/x-www-form-urlencoded：规定参数形如`vip=10&level=6`，记为A。
- multipart/form-data：规定参数写法同上，记为B。
- application/json：规定参数形如`{ "vip" : "10", "level" : "6" }`，记为C。

任何get请求的请求头中都没有Content-Type，get请求的参数只能是查询字符串（query string parameters）。

内容类型只与请求体相关，故服务于post等请求，且有请求体才会有内容类型。比如浏览器展示的post类型、C的请求头长这样：

<img src="Ajax.assets\image-20211011202402934.png" alt="image-20211011202402934" style="zoom: 80%;" />

其中框出来的这两个东西就是比get请求头多出来的部分。其请求体如下：

![request payload](ajax.assets/image-20211011210912217.png)

图中Request Payload是更具体的两种类型之一，另一种叫Form Data。关于form data和request payload的深度辨析，可参考[Form Data与Request Payload，你真的了解吗？](https://juejin.cn/post/6844904149809627149)虽然B的写法与A一样，但格式却跟C一样而跟A不同。

A的请求体如下：

![image-20211011210625150](Ajax.assets\image-20211011210625150.png)

本节知识点的实践会在后面给出。

发异步请求，但地址是响应视图（html文档）的地址，最后我们发现页面不刷新，浏览器地址栏也不变，得到的响应体就是一个html文档，同时响应头里的内容类型为text/html。可见页面的刷新并地址栏变化与否只与客户端发的请求是同步还是异步有关，与服务端响应视图数据还是普通数据无关。参考[此文章](https://blog.csdn.net/weixin_42950079/article/details/106511064)了解响应内容类型，另有[官方介绍](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Type)，尤注意里面的media-type（MIME type链接）。

### 响应json

如今面对五花八门的客户端（浏览器、app等），服务端一般对异步请求响应json数据，且注意返回的json对象要以字符串为载体传输。

```js
// json对象转字符串（也叫序列化？）
// res.send(JSON.stringify(data))
res.send(data) // 貌似send方法会自动进行序列化？
// 有专门的方法将对象转为json字符串再发
res.json({name, "van", age: 18})
```

在客户端我们可以通过`JSON.parse()`手动反序列化，也可以通过设定responseType属性让JS帮我们反序列化：

```js
xhr.responseType = "json"
```

如此得到的`xhr.response`的类型就已经是json。后面我们接触到jQuery框架，它会智能识别出响应数据的类型。

参考[XMLHttpRequest.responseType](https://developer.mozilla.org/zh-CN/docs/Web/API/XMLHttpRequest/responseType)了解responseType的详情。

### IE缓存问题

IE浏览器会对同一种请求的上一次返回结果进行缓存，于是造成下一次请求结果被上一次结果覆盖，即没有刷新。

我们可通过给请求附加时间参数以让每次请求都具有唯一性，从而解决这个问题。

```js
xhr.open("post", "http://localhost:8000/server?t=" + Date.now())
```

在实际开发中我们不会自行处理此问题，因为使用的工具会帮我们完成，这里只是捎带脚提一句IE的毛病。

### 网络异常处理

先模拟服务端的超时响应：

```js
// 5秒钟之后才会响应数据
setTimeout(() => {
    res.send(data)
}, 5000);
```

再在客户端设定响应时间限制，若时限内未收到响应，则取消请求。

```js
xhr.timeout = 1000
```

进一步地，我们利用超时和网络异常的回调函数更友好地处理：

```js
xhr.timeout = 1000
// 超时回调
xhr.ontimeout = function () {
    alert("已超时，请稍后重试")
}
// 网络异常回调
xhr.onerror = function () {
    alert("网络异常，请稍后重试")
}
```

通过如下设定可模拟断网：

<img src="Ajax.assets\image-20210831173302604.png" alt="image-20210831173302604" style="zoom: 80%;" />

### 取消请求

下面来实现一下在数据尚未响应到客户端之前就主动取消当前请求。

比如点击一个按钮发送请求，在数据未收到之前点击另一个按钮取消这个请求：

```js
let xhr = null
btns[0].onclick = function () {
    xhr = new XMLHttpRequest()
    xhr.open("get", "http://localhost/server")
    xhr.send()
}
btns[1].onclick = function () {
    // 中断 注意对象也已销毁
    xhr.abort()
}
```

据此解决重复请求问题：用户疯狂地触发同一种请求会给服务端带来一定的无谓的压力。我们可以实现让客户端发送请求前检查上一个请求是否收到响应，是则开新请求，否则先取消上一个，再开。

```js
let isSending = false
div.onmouseover = function () {
    if (isSending) {
        xhr.abort()
    }
    xhr = new XMLHttpRequest()
    isSending = true
    xhr.open("post", "http://localhost/server")
    xhr.send()
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            // 不管状态码如何都视为已收到响应
            isSending = false
        }
    }
}
```

### 利用Axios

自行看文档[Axios 中文文档](https://www.axios-http.cn/)。这里给个例子：

```js
axios({
    method: 'post',
    url: 'http://localhost/server',
    // 请求字符串（显式的请求参数） axios会自动将对象转为参数串
    params: {
        name: "bob",
        age: 16
    },
    // 头信息
    headers: {
        // 令请求体类型为form data
        "content-type": "application/x-www-form-urlencoded"
    },
    // 请求体（隐式的请求参数）
    data: "vip=10&level=6"
}).then(
    function (response) {
        if (response.status === 200) {
            console.log(response.data);
        }
    });
```

上例验证了post请求既可以通过查询字符串带显式参数又可以通过请求体带隐式参数，但服务端对post请求一般只拿请求体。

借此回顾一下请求体的Content-Type。上例中我们设定了A，那么参数就必须按照A的规定写成参数串，就不能写成对象：

```js
data: {
    vip: 10,
    level: 6
}
```

同理如设定C，则参数就必须写作对象。当我们不设定格式，axios会灵活地根据data的写法设定内容类型。

B多用于文件上传，注意到`req.body`的结果是空对象`{}`，即文件之外的参数是取不到的。又一提，用表单上传文件，就必须将enctype属性改为B，A对文件是束手无策的。关于基于B取不到文件以外参数的问题，下列文章作了更详细的解读。

- [post请求中的参数形式和form-data提交数据时取不到的问题](https://www.cnblogs.com/h-c-g/p/11002380.html)。
- [multipart/form-data post 方法提交表单，后台获取不到数据](https://www.cnblogs.com/bdqczhl/p/5971404.html)。

### 利用jQuery

自行查看文档[jQuery.ajax()](https://www.jquery123.com/jQuery.ajax/)。

还是谈谈Content-Type的问题。jQuery将ContentType默认设为A，但data既能写成参数串也能写成对象，因为后者会自动被转为参数串。若我们把contentType值改成C，则相应地要显式将json对象转为json字符串：

```js
// 联系前面的知识，改了默认的内容类型，post请求就会变成options请求，后端也要跟着变
contentType: "application/json; charset=UTF-8",
data: JSON.stringify({
    vip: 10,
    level: 6
}),
```

附带讲，A也是post表单的默认格式，体现于form标签的enctype属性。

### 利用fetch函数

直接指路文档[使用 Fetch](https://developer.mozilla.org/zh-CN/docs/Web/API/Fetch_API/Using_Fetch)。

fetch函数用得少，这里例子就不给了。

## 跨域

### 同源策略

同源策略原名为same-origin policy，最早由Netscape公司提出，是浏览器的一种安全策略。关于其详细解读可参考[浏览器的同源策略](https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy)，简而言之它要求当前URL与AJAX请求的目标URL的协议、域名、端口号必须完全相同。

违背同源策略就是跨域，但跨域又在实际中很常见，因为要发挥服务器集群的优势。

AJAX默认是遵守同源策略的，也就是不支持跨域的，我们可以通过一些设定让它支持，一般在服务端设定。

### JSONP

jsonp（json with padding）是一个民间的跨域解决方案，纯粹靠程序员的聪明才智才开发出来的。

它只支持get请求。

HTML中的一些标签天生具有跨域能力，如img、link、iframe、script。JSONP即借助script标签实现跨域，而无需额外设定。

```html
<script>
    function handle(data) {
        console.log(data);
    }
</script>
<script src="http://localhost/jsonp-server"></script>
```

```js
app.get("/jsonp-server", (req, res) => {
    let data = { name: "van" }
    dataStr = JSON.stringify(data)
    res.send(`handle(${dataStr})`)
    // res.send(dataStr)
    // res.send("hello world")
})
```

但应注意，后端响应的字符串内容必须是浏览器可解析的JS代码。

给个用script标签仿AJAX且跨域的例子：

```js
btn.onclick = fucntion() {
    // 创建script标签
    const script = document.createElement("script")
    // 设定script标签的src属性
    script.src = "http://localhost/jsonp-server"
    // 将script标签插入文档
    document.body.appendChild(script)
}
```

### CORS

CORS即cross-origin resource sharing-跨域资源共享。CORS是官方的跨域解决方案，特点是不需要客户端作任何操作，完全交由服务端实现，支持get和post请求。具体地，此标准新增一组[HTTP响应头字段](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CORS#http_%E5%93%8D%E5%BA%94%E9%A6%96%E9%83%A8%E5%AD%97%E6%AE%B5)，允许服务器声明哪些源站点有权跨域访问资源，通过响应头告诉浏览器当前请求可以跨域，浏览器就会对响应放行。

