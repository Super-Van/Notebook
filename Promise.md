# Promise

参考视频：[Promise教程](https://www.bilibili.com/video/BV1GA411x7z1)。

## 概述

优势：

- 支持链式调用，避免回调地狱。
- 可为一个异步任务指定多个结果处理函数。

回调地狱简而言之就是上一个异步任务的回调函数里是下一个异步任务，且往往存在多层嵌套。

回调地狱的具体缺陷：

- 代码可读性差。
- 不便于异常的处理。

我们可以将promise对象简称为容器，这个容器中可以存放异步任务也可以存放同步任务，但多存放异步任务。

我们在promise里说的回调函数一般指then方法的参数。

## 入门案例

点按钮，1秒后弹出中奖结果：

```js
// 生成闭区间[m, n]内的一个随机整数
function rand(m, n) {
    return Math.ceil(Math.random() * (n - m + 1)) + m
}
let btn = document.querySelector("button")
btn.addEventListener("click", () => {
    setTimeout(() => {
        let n = rand(1, 100)
        if (n < 30) {
            alert("恭喜中奖")
        } else {
            alert("再接再厉")
        }
    }, 1000);
})
```

用promise改进：

```js
btn.addEventListener("click", () => {
    const p = new Promise((resolve, reject) => {
        setTimeout(() => {
            let n = rand(1, 100)
            if (n < 30) {
                resolve()
            } else {
                reject()
            }
        }, 1000);
    })
    p.then(() => {
        alert("恭喜中奖")
    }, () => {
        alert("再接再厉")
    })
})
```

回调函数携带参数：

```js
const p = new Promise((resolve, reject) => {
    setTimeout(() => {
        let n = rand(1, 100)
        if (n < 30) {
            resolve(n)
        } else {
            reject(n)
        }
    }, 1000);
})
// 叫value和reason是潜规则
p.then((value) => { // 形参value的值与resolve的实参n的值保持一致
    alert(`恭喜中奖，中奖号码为 ${value}`)
}, (reason) => {
    alert(`再接再厉，您的号码为 ${reason}`)
})
```

下面是一个读文件的例子：

```js
const fs = require("fs")

p = new Promise((resolve, reject) => {
    fs.readFile("poem.txt", "utf-8", (err, data) => {
        if (err) reject(err)
        else resolve(data)
    })
})
p.then(value => {
    console.log(data);
}, r => {
    console.log(err);
})
```

下面是一个异步请求的例子：

```js
const btn = document.querySelector("button")
btn.addEventListener("click", () => {
    const p = new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest()
        xhr.open("get", "http://localhost:8080/ghibli/songs")
        xhr.send()
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4) {
                if (xhr.status >= 200 && xhr.status < 300) {
                    resolve(xhr.response)
                } else {
                    reject(xhr.response)
                }
            }
        }
    })
    p.then(value => {
        console.log(value);
    }, reason => {
        console.error(reason);
    })
})
```

既然promise很有用，那么每次用到异步任务时，就要将其装进promise容器。可以手动装，也可以借助node的util模块提供的promisify方法。

```js
const fs = require("fs")
const util = require("util")

// 传入异步任务函数或方法
const readFilePromise = util.promisify(fs.readFile)
// 定义异步任务的结果处理函数
readFilePromise("poem.txt", "utf-8").then(value => {
    console.log(value);
}, reason => {
    console.log(reason);
})
```

## 状态属性

通过打印我们能看出promise对象有一个属性叫PromiseState，意即其状态，这个状态跟容器中的任务相关，分为下列三种：

- pending：悬而未决的。
- resolved或fulfilled：已成功的。
- rejected：已失败的。

状态的变化又分为下面两种，且仅居其一。

- 要么是从pending变为resolved。
- 要么是从pending变为rejected。

那么无论任务成功还是失败，最终都会产生一个结果数据，对应成功的一般叫作value，对应失败的一般叫作reason，只有resolve或reject函数才能以它为参数。这个结果数据还保存于promise对象的PromiseResult属性。

## API解读

### 概述

详尽解读参见于[MDN Promise](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise)，这里更注重实践。

### 构造函数

```js
let p = new Promise(
    // 实参executor函数 立即执行函数体
    (resovle, reject) => {
        resovle("ok")
        // 永远先打印1
        console.log(1);
    }
)
console.log(2);
```

使用构造函数时传入一个实参-executor（执行器）函数，此函数有两个形参-resolve和reject，用于根据任务完成情况改变容器状态并拿到任务的结果数据，尤其是异步任务的回调函数结果。

执行器函数会在promise对象内部被立即调用，异步操作又会随之进行。

### 实例方法then

方法定义处有两个形参-onResolved和onRejected，它们用于处理任务的结果数据。

onResolved的一般形式为`value => {}`；onRejected的一般形式为`reason => {}`。value或reason是结果数据，这两个形参接收的实参函数体就是对任务成功或失败的结果数据的处理。

then方法返回一个新的promise对象。

### 实例方法catch

只有一个形参onRejected，接收的实参是处理任务失败结果数据的函数体，一般写作`reason => {}`。

```js
let p = new Promise((resolve, reject) => {
    // 修改容器状态为失败，使得catch方法执行
    reject("some error...")
})
p.catch(reason => { // 此函数是catch的实参，形参reason的值和reject的实参一致
    // 打印some error...
    console.log(reason);
})
```

### 静态方法resolve

形参接收任意类型的实参。

返回值由形参决定：若形参为普通值，则返回一个状态为成功、结果数据就是自己的promise对象；若形参为promise对象，则返回容器的状态和结果与此promise对象的相同。

```js
let p1 = Promise.resolve(250)
// ... [[PromiseState]]: "fulfilled" [[PromiseResult]]: 250
console.log(p1);

let p2 = Promise.resolve(new Promise((resolve, reject) => {
    resolve("嘿嘿嘿")
}))
// ... [[PromiseState]]: "fulfilled" [[PromiseResult]]: "嘿嘿嘿"
console.log(p2);

let p3 = Promise.resolve(new Promise((resolve, reject) => {
    reject("shit")
}))
// ... [[PromiseState]]: "rejected" [[PromiseResult]]: "shit"
console.log(p3);
// p3状态失败，不对失败作处理的话控制台会报错
```

### 静态方法reject

形参接收任意类型实参，但不论接收何种实参，永远返回一个状态为失败、结果为自己的promise对象。

```js
let p1 = Promise.reject(200)
// ... [[PromiseState]]: "rejected" [[PromiseResult]]: 200
console.log(p1);

let p2 = Promise.reject(new Promise((resolve, reject) => {
    resolve("success")
}))
// ... [[PromiseState]]: "rejected" [[PromiseResult]]: Promise 状态为失败，而结果为状态成功的容器
console.log(p2);
```

### 静态方法all

接收promise对象组成的数组。只有当所有容器的状态为成功，才返回一个状态为成功的新容器，其结果为诸容器结果组成的数组，否则返回一个状态失败、结果为第一个失败容器的结果的新容器。

```js
let p1 = new Promise((resolve, reject) => {
    resolve("success")
})
let p2 = new Promise((resolve, reject) => {
    resolve(200)
})
let p3 = new Promise((resolve, reject) => {
    resolve("amazing")
})
// [[PromiseState]]: "fulfilled" [[PromiseResult]]: Array(3)
let p = Promise.all([p1, p2, p3])
```

```js
let p1 = new Promise((resolve, reject) => {
    resolve("success")
})
let p2 = new Promise((resolve, reject) => {
    reject("error 2")
})
let p3 = new Promise((resolve, reject) => {
    reject("error 3")
})
// [[PromiseState]]: "rejected" [[PromiseResult]]: "error 2"
let p = Promise.all([p1, p2, p3])
```

### 静态方法race

接收容器组成的数组。返回一个新容器，其状态、结果是数组中第一个完成异步任务（状态发生改变）的容器的状态、结果。

```js
let p1 = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve("timeout 1 finished")
    }, 3000);
})
let p2 = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve("timeout 2 finished")
    }, 2000);
})
let p3 = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve("timeout 3 finished")
    }, 1000);
})
let p = Promise.race([p1, p2, p3])
// [[PromiseState]]: "fulfilled" [[PromiseResult]]: "timeout 3 finished"
console.log(p);
```

## 一些要点

### 容器状态改变

有三种方法：

- 调用resolve方法，将状态由pending改为resolved。
- 调用reject方法，将状态由pending改为rejected。
- 使用抛异常语句`throw "xxx"`，将状态由pending改为rejected。

### 指定多个回调函数

只需针对同一个容器调用多次then方法，就可为此容器内的任务指定多个结果处理函数。

```js
let p = new Promise((resolve, reject) => {
    resolve("嘿嘿嘿")
})
// 按照同步机制，先调第一个，后调第二个
p.then(value => {
    console.log("调用第一个回调", value);
})
p.then(value => {
    console.log("调用第二个回调", value);
})
```

### 状态改变与定义回调的顺序

正常情况下是先定义回调函数再等待状态的改变，但也可以想办法让它反过来。

- 如果先定义回调函数体，那么当状态发生改变，回调函数就立即被调用，得到结果数据。
- 如果先改变状态，那么等到定义完回调函数才调用回调函数，得到结果数据。

我们用最简单的例子看第二种情况：

```js
let p = new Promise((resolve, reject) => {
    // 当前执行器函数体内没有异步任务，故同步任务完毕，先进行状态的改变
    resolve("ok")
})
// 后进行回调函数定义，定义好了才执行回调
p.then(value => {
    console.log(value);
})
```

我们稍微一改，比如加个定时器，就能将后者变为前者，即正常情况：

```js
let p = new Promise((resolve, reject) => {
    // 当前执行器函数体内有了异步任务
    setTimeout(() => {
        // 后进行状态改变，状态一变就执行回调
        resolve("ok")
    }, 3000);
})
// 故先进行回调函数定义
p.then(value => {
    console.log(value);
})
```

注意老生常谈的问题，函数体的定义不等于函数体的执行。

### then方法的返回值

具体讨论返回的新的promise对象的状态和结果，它们由指定的回调函数的返回情况决定：

- 若抛出异常，则状态为rejected，reason为所抛异常的信息。
- 若返回非promise对象的任意值，则状态为resolved，value为该值。
- 若返回一个promise对象，则状态和结果就是此promise对象的状态和结果。

以上三条对成功的回调和失败的回调都适用。示例如下：

```js
/* 反常的例子 */
let p = new Promise((resolve, reject) => {
    reject("error")
})
let result = p.then(value => {
    // 在成功的回调中抛异常
    throw "error"
}, reason => {
    // 在失败的回调中返回非promise对象的值，包括undefined
    return 521
    // return new Promise((resolve,reject)=>{
    //     resolve("success")
    // })
})
// [[PromiseState]]: "fulfilled" [[PromiseResult]]: 521
console.log(result);
```

### 多任务串联

我们以定时器为例来看看多异步任务的嵌套，上一个定时器到点才启动下一个定时器：

```js
let p = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve("第一个定时器到点")
    }, 2000);
})
p.then(value => {
    console.log(value);
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve("第二个定时器到点")
            console.log("嘿嘿嘿");
        }, 2000);
    })
}).then(value => {
    console.log(value);
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve("第三个定时器到点")
        }, 2000);
    })
}).then(value => {
    console.log(value);
})
```

### 异常穿透

多任务串联情况下，任何一个任务都可能发生异常，有了promise，我们只需在最后调用catch方法就能实现一旦发生异常就捕获并处理，而无需针对每个异步任务都写一个异常处理。throw语句及失败状态都属于异常。

```js
let p = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve("第一个定时器到点")
    }, 2000);
})
p.then(value => {
    console.log(value);
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // throw "error" 注意在异步任务的回调函数里抛异常跟异常穿透无缘了，因为直接由window调用
            reject("error 2")
            // resolve("第二个定时器到点")
        }, 2000);
    })
}).then(value => {
    console.log(value);
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve("第三个定时器到点")
        }, 2000);
    })
}).then(value => {
    console.log(value);
    // throw "error 3" 应在结果处理函数里抛异常
}).catch(reason => {
    console.warn(reason);
})
```

在容器中的同步任务里抛异常catch才有反应。

### 中断promise链

在多任务串联的链式调用代码写好的情况下，我们想在某异步任务完成（成功或失败都算）后不再进行后续任务，有且仅有一种方法，那就是让容器状态保持pending。

```js
let p = new Promise((resolve, reject) => {
    setTimeout(() => {
        resolve(2)
    }, 2000);
})
p.then(value => {
    console.log(value);
}).then(value => {
    console.log(3);
    // 返回的容器的状态为pending
    return new Promise((resolve, reject) => {
        console.log(4);
        // resolve和reject都不写
    })
}).then(value => {
    console.log(value);
}).catch(reason => {
    console.log(reason);
})
console.log(1);

// 打印顺序：1 2 3 4
```

## 手写Promise

自己复现Promise，更好地理解底层原理。

初始类骨架：

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {}
```

为了让执行器函数一经定义就执行，在构造函数体内调用执行器函数。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 同步调用执行器函数
    executor()
}
```

定义执行器函数时传了两个形参函数，那么我们在调用时也传两个实参函数，并将它们定义在构造器内部，定义成箭头函数，以通过指向当前容器的this拿到容器的状态然后修改。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    /**
     * 执行器函数的第一个实参，传给初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
    }
    /**
     * 执行器函数的第二个实参，传给初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        this.PromiseState = "rejected"
        this.PromiseResult = reason
    }
    // 同步执行执行器函数
    executor(resolve, reject)
}
```

容器内同步任务抛异常，调用执行器函数过程中捕获并处理这个异常，具体处理是让容器状态变为失败，结果数据就是异常信息。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    /**
     * 执行器函数的第一个实参，对应初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
    }
    /**
     * 执行器函数的第二个实参，对应初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        this.PromiseState = "rejected"
        this.PromiseResult = reason
    }
    // 同步执行执行器函数 捕获并处理同步任务异常
    try {
        executor(resolve, reject)
    } catch (error) {
        reject(error)
    }
}
```

限定容器状态变化的话只能由pending变为fulfilled或rejected，且只能改变一次。具体地，改状态前判断状态是否已变，是则不改。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    /**
     * 执行器函数的第一个实参，对应初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 判断容器状态是否已更改
        if (this.PromiseState !== "pending") return
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
    }
    /**
     * 执行器函数的第二个实参，对应初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        if (this.PromiseState !== "pending") return
        this.PromiseState = "rejected"
        this.PromiseResult = reason
    }
    // 同步执行执行器函数 捕获并处理同步任务异常
    try {
        executor(resolve, reject)
    } catch (error) {
        reject(error)
    }
}
```

定义实例方法then。同步任务执行完毕就得调用then方法，具体还要调用它的参数函数，这个参数函数是带形参的，那么这个形参在内部接收的实参就应该是容器的结果数据。

```js
/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    if (this.PromiseState === "fulfilled") {
        onResolved(this.PromiseResult)
    }
    if (this.PromiseState === "rejected") {
        onRejected(this.PromiseResult)
    }
}
```

而针对异步任务，我们就不能在调用then的时候立即调用onResolved或onRejected，而应当在容器状态改变之后再调用，即在resolve或reject函数体内调用，那么应提前在then函数体内将onResolved或onRejected挂载到本实例上。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    // 结果处理函数（回调函数）
    this.callback = {}
    /**
     * 执行器函数的第一个实参，对应初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 判断容器状态是否已更改
        if (this.PromiseState !== "pending") return
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
        // 调用结果处理函数
        this.callback.onResolved(this.PromiseResult)
    }
    /**
     * 执行器函数的第二个实参，对应初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        if (this.PromiseState !== "pending") return
        this.PromiseState = "rejected"
        this.PromiseResult = reason
        this.callback.onRejected(this.PromiseResult)
    }
    // 同步执行执行器函数 捕获并处理同步任务异常
    try {
        executor(resolve, reject)
    } catch (error) {
        reject(error)
    }
}

/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 针对同步任务，状态已改变
    if (this.PromiseState === "fulfilled") {
        onResolved(this.PromiseResult)
    }
    if (this.PromiseState === "rejected") {
        onRejected(this.PromiseResult)
    }
    // 针对异步任务，状态尚未改变
    if (this.PromiseState === "pending") {
        this.callback = {
            onResolved,
            onRejected
        }
    }
}
```

为了能指定多个回调函数并在之后依序调用，上述callback属性就不能是个可覆盖的对象了，应当改为可扩充的数组，相应地在then函数体内将这两个回调函数追加挂载到callback上，在resolve与reject函数体内遍历地调用结果处理函数。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    // 结果处理函数（回调函数）
    this.callback = []
    /**
     * 执行器函数的第一个实参，对应初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 判断容器状态是否已更改
        if (this.PromiseState !== "pending") return
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
        // 遍历调用结果处理函数
        this.callback.forEach(item => {
            item.onResolved(this.PromiseResult)
        })
    }
    /**
     * 执行器函数的第二个实参，对应初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        if (this.PromiseState !== "pending") return
        this.PromiseState = "rejected"
        this.PromiseResult = reason
        this.callback.forEach(item => {
            item.onRejected(this.PromiseResult)
        })
    }
    // 同步执行执行器函数 捕获并处理同步任务异常
    try {
        executor(resolve, reject)
    } catch (error) {
        reject(error)
    }
}

/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 针对同步任务，状态已改变
    if (this.PromiseState === "fulfilled") {
        onResolved(this.PromiseResult)
    }
    if (this.PromiseState === "rejected") {
        onRejected(this.PromiseResult)
    }
    // 针对异步任务，状态尚未改变
    if (this.PromiseState === "pending") {
        this.callback.push({
            onResolved,
            onRejected
        })
    }
}
```

根据总结的规律，针对同步任务实现then方法的返回。

```js
/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 返回一个MyPromise对象
    return new MyPromise((resolve, reject) => {
        // 捕捉并处理执行回调函数期间的异常
        try {
            // 针对同步任务，状态已改变
            if (this.PromiseState === "fulfilled") {
                // 回调函数的返回值
                let result = onResolved(this.PromiseResult)
                // 若返回值为一个MyPromise对象
                if (result instanceof MyPromise) {
                    // 设返回对象的状态和结果为此对象的状态和结果
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                }
                // 若返回一个普通值
                else {
                    // 状态为成功，结果数据为本值
                    resolve(result)
                }
            }
            if (this.PromiseState === "rejected") {
                let result = onRejected(this.PromiseResult)
                if (result instanceof MyPromise) {
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                } else {
                    resolve(result)
                }
            }
        } catch (error) {
            reject(error)
        }
        // 针对异步任务，状态尚未改变
        if (this.PromiseState === "pending") {
            this.callback.push({
                onResolved,
                onRejected
            })
        }
    })
}
```

而针对异步任务实现then方法的返回，具体我们要对callback数组中的函数进行扩展，使得容器状态改变后调用结果处理函数时，要像上面那样根据结果处理函数的返回值设定返回容器的状态和结果。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    // 结果处理函数（回调函数）
    this.callback = []
    /**
     * 执行器函数的第一个实参，对应初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 判断容器状态是否已更改
        if (this.PromiseState !== "pending") return
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
        // 遍历调用结果处理函数
        this.callback.forEach(item => {
            item.onResolved()
        })
    }
    /**
     * 执行器函数的第二个实参，对应初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        if (this.PromiseState !== "pending") return
        this.PromiseState = "rejected"
        this.PromiseResult = reason
        this.callback.forEach(item => {
            item.onRejected()
        })
    }
    // 同步执行执行器函数 捕获并处理同步任务异常
    try {
        executor(resolve, reject)
    } catch (error) {
        reject(error)
    }
}

/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 返回一个MyPromise对象
    return new MyPromise((resolve, reject) => {
        // 捕捉并处理执行回调函数期间的异常
        try {
            // 针对同步任务，状态已改变
            if (this.PromiseState === "fulfilled") {
                // 回调函数的返回值
                let result = onResolved(this.PromiseResult)
                // 若返回值为一个MyPromise对象
                if (result instanceof MyPromise) {
                    // 设返回对象的状态和结果为此对象的状态和结果
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                }
                // 若返回一个普通值
                else {
                    // 状态为成功，结果数据为本值
                    resolve(result)
                }
            }
            if (this.PromiseState === "rejected") {
                let result = onRejected(this.PromiseResult)
                if (result instanceof MyPromise) {
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                } else {
                    resolve(result)
                }
            }
        } catch (error) {
            reject(error)
        }
        // 针对异步任务，状态尚未改变
        if (this.PromiseState === "pending") {
            this.callback.push({
                onResolved: () => {
                    // 捕捉并处理执行回调函数期间的异常
                    try {
                        // 执行结果处理函数并取得返回值
                        let result = onResolved(this.PromiseResult)
                        // 根据返回值设定返回容器的状态与结果
                        if (result instanceof MyPromise) {
                            result.then(value => {
                                resolve(value)
                            }, reason => {
                                reject(reason)
                            })
                        } else {
                            resolve(result)
                        }
                    } catch (error) {
                        reject(error)
                    }
                },
                onRejected: () => {
                    try {
                        let result = onRejected(this.PromiseResult)
                        if (result instanceof MyPromise) {
                            result.then(value => {
                                resolve(value)
                            }, reason => {
                                reject(reason)
                            })
                        } else {
                            resolve(result)
                        }
                    } catch (error) {
                        reject(error)
                    }
                }
            })
        }
    })
}
```

我们发现存在高度重复的代码，可以将其抽离为函数。

```js
/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 返回一个MyPromise对象
    return new MyPromise((resolve, reject) => {
        /**
         * 执行回调并根据回调的返回设定返回容器的状态与结果
         * @param {function} onResult 回调函数（结果处理函数）onResolved或onRejected
         */
        let setPromise = onResult => {
            // 捕捉并处理执行回调函数期间的异常
            try {
                // 回调函数的返回值
                let result = onResult(this.PromiseResult)
                // 若返回值为一个MyPromise对象
                if (result instanceof MyPromise) {
                    // 设返回对象的状态和结果为此对象的状态和结果
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                }
                // 若返回一个普通值
                else {
                    // 状态为成功，结果数据为本值
                    resolve(result)
                }
            } catch (error) {
                reject(error)
            }
        }
        // 针对同步任务，状态已改变
        if (this.PromiseState === "fulfilled") {
            setPromise(onResolved)
        }
        if (this.PromiseState === "rejected") {
            setPromise(onRejected)
        }
        // 针对异步任务，状态尚未改变
        if (this.PromiseState === "pending") {
            this.callback.push({
                onResolved: () => {
                    setPromise(onResolved)
                },
                onRejected: () => {
                    setPromise(onRejected)
                }
            })
        }
    })
}
```

定义实例方法catch并实现异常穿透，具体要解决回调函数未指定的问题。

```js
/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 可能未定义回调函数
    if (typeof onResolved !== "function") {
        // 即 value => {return value}
        onResolved = value => value
    }
    if (typeof onRejected !== "function") {
        onRejected = reason => {
            // 让返回容器的状态变为rejected，结果变为reason 层层抛
            throw reason
        }
    }
    // 返回一个MyPromise对象
    return new MyPromise((resolve, reject) => {
        /**
         * 执行回调并根据回调的返回设定返回容器的状态与结果
         * @param {function} onResult 回调函数（结果处理函数）onResolved或onRejected
         */
        let setPromise = onResult => {
            // 捕捉并处理执行回调函数期间的异常
            try {
                // 回调函数的返回值
                let result = onResult(this.PromiseResult)
                // 若返回值为一个MyPromise对象
                if (result instanceof MyPromise) {
                    // 设返回对象的状态和结果为此对象的状态和结果
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                }
                // 若返回一个普通值
                else {
                    // 状态为成功，结果数据为本值
                    resolve(result)
                }
            } catch (error) {
                reject(error)
            }
        }
        // 针对同步任务，状态已改变
        if (this.PromiseState === "fulfilled") {
            setPromise(onResolved)
        }
        if (this.PromiseState === "rejected") {
            setPromise(onRejected)
        }
        // 针对异步任务，状态尚未改变
        if (this.PromiseState === "pending") {
            this.callback.push({
                onResolved: () => {
                    setPromise(onResolved)
                },
                onRejected: () => {
                    setPromise(onRejected)
                }
            })
        }
    })
}

/**
 * 实例方法catch
 * @param {function} onRejected 最终处理异常的回调函数
 */
MyPromise.prototype.catch = function (onRejected) {
    this.then(undefined, onRejected)
}
```

根据总结的规律，实现静态方法resolve和reject。

```js
/**
 * 静态方法resolve
 * @param {*} data 任意类型数据
 */
MyPromise.resolve = function (data) {
    return new MyPromise((resolve, reject) => {
        // 若传入值为MyPromise对象，则返回容器的状态与结果与其一致
        if (data instanceof MyPromise) {
            data.then(value => {
                resolve(value)
            }, reason => {
                reject(reason)
            })
        }
        // 否则返回容器的状态为成功，结果为本值
        else {
            resolve(data)
        }
    })
}

/**
 * 静态方法reject
 * @param {*} data 任意类型数据
 */
MyPromise.reject = function (data) {
    return new MyPromise((resolve, reject) => {
        // 返回容器状态恒为失败，结果为传入值
        reject(data)
    })
}
```

根据总结的规律，实现静态方法all。

```js
/**
 * 静态方法all
 * @param {MyPromise[]} myPromises 若干MyPromise对象
 */
MyPromise.all = function (myPromises) {
    return new MyPromise((resolve, reject) => {
        // 成功容器个数
        let count = 0
        // 成功容器结果集
        let resultArray = []
        myPromises.forEach((item, index) => {
            item.then(value => {
                count++
                resultArray[index] = value
                // 所有容器状态都变为成功
                if (count === myPromises.length) {
                    // 返回容器状态才为成功
                    resolve(resultArray)
                }
            }, reason => {
                // 只要有容器状态变为失败，返回容器状态就为失败
                reject(reason)
            })
        })
    })
}
```

根据总结的规律，实现静态方法race。

```js
/**
 * 静态方法race
 * @param {MyPromise[]} myPromises 若干MyPromise对象
 */
MyPromise.race = function (myPromises) {
    return new MyPromise((resolve, reject) => {
        myPromises.forEach(item => {
            // 谁状态先改变，就取谁的状态和结果作返回容器的状态和结果
            item.then(value => {
                resolve(value)
            }, reason => {
                reject(reason)
            })
        })
    })
}
```

完善一个细节，即异步调用结果处理函数。

```js
/**
 * 我的Promise
 * @param {function} executor 形参函数 执行器函数
 */
function MyPromise(executor) {
    // 状态
    this.PromiseState = "pending"
    // 结果
    this.PromiseResult = null
    // 结果处理函数（回调函数）
    this.callback = []
    /**
     * 执行器函数的第一个实参，对应初始化容器时执行器函数的第一个形参
     * @param {*} value 结果数据 
     */
    let resolve = value => { // 用箭头函数控制this指向当前实例
        // 判断容器状态是否已更改
        if (this.PromiseState !== "pending") return
        // 修改容器状态
        this.PromiseState = "fulfilled"
        // 设置容器结果值
        this.PromiseResult = value
        // 遍历调用结果处理函数 异步调用
        setTimeout(() => {
            this.callback.forEach(item => {
                item.onResolved()
            })
        })
    }
    /**
     * 执行器函数的第二个实参，对应初始化容器时执行器函数的第二个形参
     * @param {*} reason 结果数据
     */
    let reject = reason => {
        if (this.PromiseState !== "pending") return
        this.PromiseState = "rejected"
        this.PromiseResult = reason
        setTimeout(() => {
            this.callback.forEach(item => {
                item.onRejected()
            })
        });
    }
    // 同步执行执行器函数 捕获并处理同步任务异常
    try {
        executor(resolve, reject)
    } catch (error) {
        reject(error)
    }
}

/**
 * 实例方法then
 * @param {function} onResolved 任务成功后的结果处理函数
 * @param {function} onRejected 任务失败后的结果处理函数
 */
MyPromise.prototype.then = function (onResolved, onRejected) {
    // 可能未定义回调函数
    if (typeof onResolved !== "function") {
        // 即 value => { return value }
        onResolved = value => value
    }
    if (typeof onRejected !== "function") {
        onRejected = reason => {
            // 让返回容器的状态变为rejected，结果变为reason 层层抛
            throw reason
        }
    }
    // 返回一个MyPromise对象
    return new MyPromise((resolve, reject) => {
        /**
         * 执行回调并根据回调的返回设定返回容器的状态与结果
         * @param {function} onResult 回调函数（结果处理函数）onResolved或onRejected
         */
        let setPromise = onResult => {
            // 捕捉并处理执行回调函数期间的异常
            try {
                // 回调函数的返回值
                let result = onResult(this.PromiseResult)
                // 若返回值为一个MyPromise对象
                if (result instanceof MyPromise) {
                    // 设返回对象的状态和结果为此对象的状态和结果
                    result.then(value => {
                        resolve(value)
                    }, reason => {
                        reject(reason)
                    })
                }
                // 若返回一个普通值
                else {
                    // 状态为成功，结果数据为本值
                    resolve(result)
                }
            } catch (error) {
                reject(error)
            }
        }
        // 针对同步任务，状态已改变
        if (this.PromiseState === "fulfilled") {
            // 异步执行回调
            setTimeout(() => {
                setPromise(onResolved)
            })
        }
        if (this.PromiseState === "rejected") {
            setTimeout(() => {
                setPromise(onRejected)
            });
        }
        // 针对异步任务，状态尚未改变
        if (this.PromiseState === "pending") {
            this.callback.push({
                onResolved: () => {
                    setPromise(onResolved)
                },
                onRejected: () => {
                    setPromise(onRejected)
                }
            })
        }
    })
}
```

最后按照ES6类语法对完整实现进行重构。

```js
class MyPromise {
    constructor(executor) {
        this.PromiseState = "pending"
        this.PromiseResult = null
        this.callback = []
        let resolve = value => {
            if (this.PromiseState !== "pending") return
            this.PromiseState = "fulfilled"
            this.PromiseResult = value
            setTimeout(() => {
                this.callback.forEach(item => {
                    item.onResolved()
                })
            })
        }
        let reject = reason => {
            if (this.PromiseState !== "pending") return
            this.PromiseState = "rejected"
            this.PromiseResult = reason
            setTimeout(() => {
                this.callback.forEach(item => {
                    item.onRejected()
                })
            });
        }
        try {
            executor(resolve, reject)
        } catch (error) {
            reject(error)
        }
    }

    then(onResolved, onRejected) {
        if (typeof onResolved !== "function") {
            onResolved = value => value
        }
        if (typeof onRejected !== "function") {
            onRejected = reason => {
                throw reason
            }
        }
        return new MyPromise((resolve, reject) => {
            let setPromise = onResult => {
                try {
                    let result = onResult(this.PromiseResult)
                    if (result instanceof MyPromise) {
                        result.then(value => {
                            resolve(value)
                        }, reason => {
                            reject(reason)
                        })
                    }
                    else {
                        resolve(result)
                    }
                } catch (error) {
                    reject(error)
                }
            }
            if (this.PromiseState === "fulfilled") {
                setTimeout(() => {
                    setPromise(onResolved)
                })
            }
            if (this.PromiseState === "rejected") {
                setTimeout(() => {
                    setPromise(onRejected)
                });
            }
            if (this.PromiseState === "pending") {
                this.callback.push({
                    onResolved: () => {
                        setPromise(onResolved)
                    },
                    onRejected: () => {
                        setPromise(onRejected)
                    }
                })
            }
        })
    }

    catch(onRejected) {
        this.then(undefined, onRejected)
    }

    static resolve(data) {
        return new MyPromise((resolve, reject) => {
            if (data instanceof MyPromise) {
                data.then(value => {
                    resolve(value)
                }, reason => {
                    reject(reason)
                })
            }
            else {
                resolve(data)
            }
        })
    }

    static reject(data) {
        return new MyPromise((resolve, reject) => {
            reject(data)
        })
    }

    static all(myPromises) {
        return new MyPromise((resolve, reject) => {
            let count = 0
            let resultArray = []
            myPromises.forEach((item, index) => {
                item.then(value => {
                    count++
                    resultArray[index] = value
                    if (count === myPromises.length) {
                        resolve(resultArray)
                    }
                }, reason => {
                    reject(reason)
                })
            })
        })
    }

    static race(myPromises) {
        return new MyPromise((resolve, reject) => {
            myPromises.forEach(item => {
                item.then(value => {
                    resolve(value)
                }, reason => {
                    reject(reason)
                })
            })
        })
    }
}
```

## async与await

这两个东西往往一起出场。async关键字接一个函数，隐式地创建Promise对象并返回，还作为await的依赖。await表达式是await关键字接一个Promise对象，得到其结果值，让多异步任务的串联更为简明。关于它们的详细描述可参看[async函数](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Statements/async_function)与[await表达式](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/await)。

我们还是以读多文件为例看看这两个东西的优势：

```js
const util = require("util")
const fs = require("fs")

async function readAndCon() {
    // 让异步任务的执行看起来就像同步任务的执行
    let data1 = await util.promisify(fs.readFile)("a.txt", "utf-8")
    let data2 = await util.promisify(fs.readFile)("b.txt", "utf-8")
    let data3 = await util.promisify(fs.readFile)("c.txt", "utf-8")
    let data = `${data1}\n${data2}\n${data3}`
    console.log(data);
}

// Promsie对象
console.log(readAndCon());
```

再将入门案例中发送AJAX请求的例子改写一下：

```js
function getJokes(url) {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest()
        xhr.open("get", url)
        xhr.send()
        xhr.onreadystatechange = () => {
            if (xhr.readyState === 4) {
                if (xhr.status >= 200 && xhr.status < 300) {
                    resolve(xhr.response)
                } else {
                    reject(xhr.response)
                }
            }
        }
    })
}
const btn = document.querySelector("button")
btn.addEventListener("click", async () => {
    // await只关心结果，onRejected函数就没定义，默认异常往上抛
    let jokes = await getJokes("http://localhost:8080/ghibli/songs")
    console.log(jokes);
})
```

