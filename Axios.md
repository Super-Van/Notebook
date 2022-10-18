# Axios

参考视频：[axios入门与源码解析](https://www.bilibili.com/video/BV1wr4y1K7tq?spm_id_from=333.999.0.0)。

前置知识：Promise、AJAX。

我们用一个简易服务端JSON-Server作为练习用，可去[Json Server](https://www.npmjs.com/package/json-server)查看一些使用技巧。

## 概述

这是一个基于Promise的HTTP客户端，同时适用于浏览器（客户端）与nodeJS环境（服务端）。

那么在浏览器，可以借助axios像服务端发送AJAX请求获取数据，在nodeJS也可借助axios向另一个服务端发送HTTP请求。

有两种使用方式：

- 在练习阶段在html文档里由script标签导入。
- 在开发阶段将其作为模块安装、导入及使用。

## 入门案例

常用方式。借助一个发送增删改查请求的小例子：

```js
// GET
btns[0].addEventListener("click", () => {
    axios({
        method: "GET",
        url: "http://localhost:3000/posts/2"
    }).then(response => {
        console.log(response);
    })
})
// POST
btns[1].onclick = () => {
    axios({
        method: "POST",
        url: "http://localhost:3000/posts",
        data: {
            title: "郑宰韩",
            author: "尹熙谦"
        }
    })
}
// PUT 联系push记忆 push：推送（改变）
btns[2].addEventListener("click", () => {
    axios({
        method: "put",
        url: "http://localhost:3000/posts/2",
        data: {
            title: "侧耳倾听",
            author: "近藤喜文"
        }
    })
})
// DELETE
btns[3].addEventListener("click", () => {
    axios({
        method: "delete",
        url: "http://localhost:3000/posts/3"
    }).then(response => {
        console.log(response);
    })
})
```

注：在网络正常条件下，任何请求都是能收到响应的，即使是报错响应。

其他方式，即[请求方法别名](https://www.axios-http.cn/docs/api_intro)，用法与上面的类似，只不过具体方法省略了一些配置属性。

## 响应对象

我们看看上例get请求response对象的打印结果：

```js
// source
{data: {…}, status: 200, statusText: 'OK', headers: {…}, config: {…}, …}
// parsed
config: {url: 'http://localhost:3000/posts/2', method: 'get', headers: {…}, transformRequest: Array(1), transformResponse: Array(1), …}
data: {title: '侧耳倾听', author: '近藤喜文', id: 2}
headers: {cache-control: 'no-cache', content-length: '68', content-type: 'application/json; charset=utf-8', expires: '-1', pragma: 'no-cache'}
request: XMLHttpRequest {readyState: 4, timeout: 0, withCredentials: false, upload: XMLHttpRequestUpload, onreadystatechange: ƒ, …}
status: 200
statusText: "OK"
[[Prototype]]: Object
```

解释一下上述属性：

- config：axios自身配置。里面的headers是请求头信息。
- data：响应体，axios自动将响应的原json字符串转为js对象。
- headers：响应头信息。
- request：当前底层的XMLHttpRequest对象。
- status：响应状态码。
- statusText：响应状态字符串。

这个对象不是响应体，是axios对请求对象和响应对象整合而成的产物。

## 配置对象

axios的诸请求方法提到的config参数都指的是配置对象，梳理一下前端常用属性：

- url：字符串；请求的目的服务端地址。若设定baseURL属性则本值可为路径名。
- method：字符串；请求方法。
- baseURL：字符串；服务端地址的协议到端口号部分。
- headers：对象；对请求头的设置。
- params：诸请求方法均支持的请求字符串。axios会自动将对象转为参数串。
- data：参数串或对象；请求体。不指定内容类型条件下，axios会根据形式自动设定内容类型。
- timeout：请求中断时限。

关于其他属性可参见[请求配置](https://www.axios-http.cn/docs/req_config)。有不少属性是仅在后端的node环境中才生效的。

## 默认配置

对一些属性值重复的属性可作默认配置。比如：

```js
axios.defaults.method = "get"
axios.defaults.baseURL = "http://localhost:3000"
axios.defaults.timeout = 3000
```

## 创建实例

先上例子：

```js
const joke = axios.create({
    baseURL: "https://api.apiopen.top",
    timeout: 2000
})
// 打印一个函数
console.log(joke);
joke({
    url: "/getJoke"
}).then(response => {
    // 打印响应对象
    console.log(response);
})
const book = axios.create({
    timeout: 3000
})
book.get("http://localhost:3000/posts/1").then(response => {
    // 打印响应体
    console.log(response.data);
})
```

这里的joke和book实例是哪个类的实例老师没有展开讲，不过我们能看出它能实现的功能和axios对象是等价的，并且它的优势在于能针对多个不同的服务端地址。

## 拦截器

请求拦截器检验请求数据，满足要求放行，不满足中断；响应拦截器检验响应数据，满足要求放行，否则另作处理。

这里我们就对官网提供的一个例子作分析，先看一个一路成功的情况：

```js
// 添加请求拦截器
axios.interceptors.request.use(function (config) {
    console.log("请求拦截器 放行");
    // 在发送请求之前做些什么
    return config;
}, function (error) {
    console.log("请求拦截器 扣押");
    // 对请求错误做些什么
    return Promise.reject(error);
});
// 添加响应拦截器
axios.interceptors.response.use(function (response) {
    console.log("响应拦截器 放行");
    // 2xx 范围内的状态码都会触发该函数。
    // 对响应数据做点什么
    return response;
}, function (error) {
    console.log("响应拦截器 扣押");
    // 超出 2xx 范围的状态码都会触发该函数。
    // 对响应错误做点什么
    return Promise.reject(error);
});
// 发请求
axios({
    method: "get",
    url: "http://localhost:3000/posts"
}).then(response => {
    console.log("最终的成功回调");
})

// 打印结果
请求拦截器 放行
响应拦截器 放行
最终的成功回调
```

再看一个手动让请求出错的情况：

```js
axios.interceptors.request.use(function (config) {
    console.log("请求拦截器 放行");
    throw "error in config"
    // return config;
}, function (error) {
    console.log("请求拦截器 扣押");
    return Promise.reject(error);
});
axios.interceptors.response.use(function (response) {
    console.log("响应拦截器 放行");
    return response;
}, function (error) {
    console.log("响应拦截器 扣押");
    return Promise.reject(error);
});
axios({
    method: "get",
    url: "http://localhost:3000/posts"
}).then(response => {
    console.log("最终的成功回调");
}).catch(reason => {
    console.log("最终的失败回调");
})

// 打印结果
请求拦截器 放行
响应拦截器 扣押
最终的失败回调
```

我们定义多个请求和响应拦截器，看看一路成功的拦截情况：

```js
axios.interceptors.request.use(function (config) {
    console.log("请求拦截器1 放行");
    return config;
}, function (error) {
    console.log("请求拦截器1 扣押");
    return Promise.reject(error);
});
axios.interceptors.request.use(function (config) {
    console.log("请求拦截器2 放行");
    throw "error in config"
    // return config;
}, function (error) {
    console.log("请求拦截器2 扣押");
    return Promise.reject(error);
});
axios.interceptors.response.use(function (response) {
    console.log("响应拦截器1 放行");
    return response;
}, function (error) {
    console.log("响应拦截器1 扣押");
    return Promise.reject(error);
});
axios.interceptors.response.use(function (response) {
    console.log("响应拦截器2 放行");
    return response;
}, function (error) {
    console.log("响应拦截器2 扣押");
    return Promise.reject(error);
});
axios({
    method: "get",
    url: "http://localhost:3000/posts"
}).then(response => {
    console.log("最终的成功回调");
}).catch(reason => {
    console.log("最终的失败回调");
})

// 打印结果
请求拦截器2 放行
请求拦截器1 扣押
响应拦截器1 扣押
响应拦截器2 扣押
最终的失败回调
```

请求拦截器进的是栈，响应拦截器进的是队列，后续会分析相关源码。

请求拦截器中出现的config参数就是配置对象，这意味着我们能在拦截时对配置进行加工，如`config. timeout = 2000`。

同样地，响应拦截器也能对响应对象即response参数作加工，比如我们只想返回响应体：`return response.data`。

## 取消请求

我们弄两个按钮，点击第一个发送请求，在收到结果前点击第二个取消请求：

```js
// 全局变量
let cancel = null
btns[0].addEventListener("click", () => {
    axios({
        method: "get",
        url: "http://localhost:3000/posts/2",
        cancelToken: new axios.CancelToken(c => {
            cancel = c
        })
    })
})
btns[1].addEventListener("click", () => {
    // 调用cancel
    cancel()
})
```

此外我们还需将浏览器切换到Slow 3G模式拖延交互时长。

据此我们可实现防抖（节流）的功能：

```js
// 全局变量
let cancel = null
btns[0].addEventListener("click", () => {
    // 检查上次请求是否收到响应
    if (cancel !== null) {
        // 尚未收到响应，就取消掉
        cancel()
    }
    axios({
        method: "get",
        url: "http://localhost:3000/posts/2",
        cancelToken: new axios.CancelToken(c => {
            cancel = c
        })
    }).then(response => {
        console.log(response);
        // 使cancel回归初始状态
        cancel = null
    })
})
btns[1].addEventListener("click", () => {
    // 调用cancel，终止请求
    cancel()
})
```

## 源码分析

### 文件结构



