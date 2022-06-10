# dubbo

## 分布式系统

分布式系统是若干独立计算机的集合，此集合对用户来说就像单个相关系统。比如我们浏览京东的时候，感觉只有一个完整系统为我们服务，但其背后存在着成千上万台独立的计算机，它们合起来构成完整的京东商城系统。

分布式系统（distributed system）是建立在网络之上的软件系统，没有网络的话分布式系统也就不存在。

如今诸常规应用架构已无力负载得起巨量请求，且网站的规模越来越大，故分布式服务架构以及流动计算架构势在必行。

不难想出将各个功能模块放到不同的计算机上，让它们共同工作，来抵御大规模流量。这些小的功能模块之间会有联系，即互相调用，那么这些联系也需要系统来维护。

## 架构演变

可参考[dubbo-入门-背景](https://dubbo.apache.org/zh/docs/v2.7/user/preface/background/)，文档详细介绍了从单一应用架构（ORM）到垂直应用架构（MNV）再到分布式服务架构（RPC）最后到流动计算架构（SOA）的发展。

架构的变化与技术的兴起同时进行。

## RPC

RPC是一种跨服务器进程间的通信方式，是一种技术思想。具体来说，它使得程序调用另一个地址空间（通常这个地址空间在共享网络的另一台机器上）中的过程或函数，且不由程序员来实现这个远程调用的细节，即程序员无论调用本地还是远程的函数，对应的代码在形式上是基本相同的。

下面是一个跨服务器调用的时序图：

![时序图](https://img-blog.csdnimg.cn/20190923151223905.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMzNDIzNDE4,size_16,color_FFFFFF,t_70)

建立连接、序列化反序列化的速度十分影响RPC的效率。

常见RPC框架包括dubbo、gRPC、Thrift、HSF。

这是[dubbo官网](https://dubbo.apache.org/zh/)。

## 注册中心

### 概念

为了动态感知诸服务器的状态，引入一种注册中心的机制。

我们可以注册所有的界面和业务逻辑，注册中心相当于维护了一个清单，明细各界面和业务逻辑都在哪些服务器上，并监控各服务器的状态和里面服务的状态。当程序发起一个RPC时，会先由注册中心告知目标服务在哪些服务器上，然后根据负载均衡机制选定其中一个服务器建立通信、传递数据、远程调用。

注册中心还提供了可视化界面，展现各服务的健康状况、调用统计等等。

### dubbo架构

官方文档[dubbo架构](https://dubbo.apache.org/zh/docs/v2.7/user/preface/architecture/)给了详细说明。着重理解下面这张图：

<img src="https://dubbo.apache.org/imgs/user/dubbo-architecture.jpg" alt="dubbo-architucture" style="zoom:150%;" />

### zookeeper

dubbo支持好几种注册中心，推荐使用zookeeper。
