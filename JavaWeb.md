# JavaWeb

参考视频：

- [JavaWeb教程](https://www.bilibili.com/video/BV18s411u7EH)。
- [Java Web部分课程](https://www.bilibili.com/video/BV1q4411u7mM?spm_id_from=333.999.0.0)。

## 概述

前端部分这里就不记了。

附带讲一下单元测试与异常。若抛出异常但处理了，则单元测试的结果是成功；若抛出异常且没有处理，则单元测试的结果是失败。

## XML

### 概述

即extensible markup language-可扩展标记语言，由W3C组织发布，作用是以统一的格式组织有关系的数据，多级标签能很好地反映数据的层次结构。

由于这种统一的编写规范，实际方面它常用于传输数据、作配置文件。

注：HTML和XML共一个爹叫SGML（标准通用标记语言）。两者分工不同-HTML主要做页面展示，故语法比较随意；XML主要做数据的存储、描述、传输，故语法很严格。

### 读写

解析目前解析方式有两派（可参考javax.xml.parser包）：

- DOM：W3C官方推荐的解析方式，与HTML的解析类似，一次性完加载XML文件，然后据此生成DOM树，接着解析。
  - JDOM：对DOM方式的封装，使更好用。
  - DOM4J：在JDOM基础上进一步封装，综合DOM方式和SAX方式的优点，用前者修改，用后者解析。
- SAX（simple API for XML）：非官方标准，却是应用最广的方式，仅支持查询，不过效率更高，基于事件回调边加载边解析。
  - PULL：对SAX的封装，使更好用。

解析是由XML解析器完成的。

这里用DOM4J，JDK用的是原生的DOM或SAX，因此我们要导入外部的jar包。

本节不给出代码，请参考xml项目。

### xPath

xPath很像jQuery，是一个针对XML文档的元素选择器，简化了上一节相关的查询写法，顾名思义，是通过路径语法来简化的。

它依赖jar包jaxen。

这里有[xPath教程](https://www.w3school.com.cn/xpath/index.asp)，注意看里面的路径示例。列举少许例子：

```java
SAXReader saxReader = new SAXReader();
Document document = saxReader.read(new File("src\\student.xml"));
Element root = document.getRootElement();
// 从根结点开始选择
Node node = root.selectSingleNode("//student[@id='1']");
Element element = (Element) node;
System.out.println(element.attributeValue("id"));
List<Element> ages = root.selectNodes("//age");
for (Element age : ages) {
    System.out.println(age.getText());
}
```

##   Tomcat

### 概述

服务器概念分硬件、软件两个层面来认知，首先是个性能很好的计算机，其次上面装有提供服务的软件。

web服务器主要负责接收客户端发来的请求并响应资源。具体对javaweb程序来说，必须具备servlet，它就干接收、处理请求及响应资源的事，还须具备servlet容器即web服务软件，二者缺一不可。

常见的javaweb服务软件：

- tomcat：Apache旗下，目前应用最广。
- JBoss：Redhat旗下，应用较广。
- GlassFish：Oracle旗下，应用不广。
- Resin：Caucho旗下，应用越来越广。
- Weblogic：Oracle旗下，要钱，适合大型项目。
- Websphere：IBM旗下，要钱，适合大型项目。

免费开源的Tomcat用java语言开发，是一个符合J2EE标准（Servlet规范）的web服务软件。

web应用是静态的还是动态的取决于是否包含请求处理程序以及是否涉及数据库。

### 安装

安装路径中不能有空格、中文等。

### 目录结构

```
bin：包括启动、关闭在内的可执行文件、批处理文件等
conf：配置文件
lib：运行服务器依赖的jar包
logs：运行期间的日志
temp：临时文件
webapps：部署目录，含所有web项目，一个项目对应一个文件夹，默认站点是ROOT
work：服务器运行时编译好的文件，如java、class文件
```

### eclipse

默认拷贝出一个tomcat镜像，地址在工作空间内，部署目录为wtpwebapps，更改其配置不影响原tomcat。

开发完到生产条件下，就不再用eclipse了，而是把项目打成war包置于webapp目录下，运行tomcat，自动解压。

一般而言，修改了jsp、css等文件，不需要重启服务器。

### 站点目录结构

自建的动态web项目具备以下目录结构：

```
src：源文件
WebContent：资源
	META-INF：版本信息等，不重要
	WEB-INF：不可见资源，不能直接访问，只能间接访问
  		classes：编译源程序生成的字节码文件（classpath）
  		lib：导入的jar包
  		web.xml：配置文件
```

WEB-INF目录里的资源不能直接通过浏览器访问，只能通过内部转发（重定向也不行）访问。

tomcat规定web项目两个位置放字节码（这个位置也叫类路径classpath），即WEB-INF下的classes与lib，前者对应自己源文件的字节码，后者对应jar包字节码。然后应将lib下的jar包add to build path，针对web项目，eclipse能帮我们完成。

部署后生成的同名目录仅含WebContent文件夹里面的东西（上码第3行至第7行），也就是说tomcat把其他的文件都略过了。

### 虚拟主机

已经有一个name为localhost的虚拟主机，可在server.xml中增加虚拟主机。

```xml
<Host appBase="myapps" autoDeploy="true" name="www.zcf.com" unpackWARs="true">
	<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs" pattern="%h %l %u %t &quot;%r&quot; %s %b" prefix="localhost_access_log" suffix=".txt"/>
    <!-- 相对路径+内嵌式，这里等价于D:\server\apache-tomcat-8.5.70\myapps\ssm（绝对路径+内嵌式） -->
    <Context docBase="ssm" path="/ssm"/>
    <!-- 绝对路径+外链式 -->
    <Context docBase="D:\Van\virtualHost\ssm\WebContent" path="/virtual"/>
</Host>
```

appBase：虚拟主机根目录。针对上例tomcat目录下会生成myapps文件夹。

name：自定义的主机名，协议名+主机名+端口号就映射到appBase值对应的路径。针对上例，`http://www.zcf.com`就映射到`D:\server\apache-tomcat-8.5.70\myapps`。

Context的两个重要参数：

- docBase：web项目的站点路径，实现外链式（启动服务器时工作目录中不会产生同名目录）或内嵌式部署。

- path：项目名，协议名+主机名+端口号拼上此值就映射到docBase值对应的路径。针对上例，`http://www.zcf.com/virtual`就映射到`D:\Van\virtualHost\ssm\WebContent`，`http://www.zcf.com/ssm`就映射到`D:\server\apache-tomcat-8.5.70\myapps\ssm`。

### 注

端口号占用问题：打开命令行，输入`netstat -ano | findstr 8080`，意即找出占用8080端口的进程的ID，然后去任务管理器中找到命中进程，将其终止。

## HTTP

### 概述

HTTP协议规定了浏览器和万维网服务器之间的通信规则，规定了所传输的请求、响应报文的格式。

报文基本结构是报文首部+空行+报文主体。

```
GET /pseudo HTTP/1.1 请求首行
Host: localhost:8080 主机名+端口号，哪个计算机的哪个进程
Connection: keep-alive 长时TCP连接，体现了对HTTP 1.0的改进
Cache-Control: max-age=0 缓存控制
sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="100", "Google Chrome";v="100"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36 用户代理，客户端的详细信息
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9 客户端允许的接收内容的类型
Sec-Fetch-Site: none
Sec-Fetch-Mode: navigate
Sec-Fetch-User: ?1
Sec-Fetch-Dest: document
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9
Cookie: _ga=GA1.1.1182678932.1647678234
```

请求报文格式：

- 请求首行：`请求方法 路径名（后可跟查询字符串） 协议及其版本`。如上例第1行。
- 请求头信息：本次请求的一系列设置信息（键值对形式）。如上例第2行至末尾。
- 空行：空格加回车。get方法无以下两项，如上例所示。
- 请求体：即请求参数。get方法的参数列表跟在路径名后面，其他方法的参数列表就是请求体。

```
HTTP/1.1 200 
Accept-Ranges: bytes 断点续传
ETag: W/"126-1650165036952"
Last-Modified: Sun, 17 Apr 2022 03:10:36 GMT
Content-Type: text/html 内容类型（重点）
Content-Length: 126
Date: Sun, 17 Apr 2022 03:13:25 GMT
Keep-Alive: timeout=20
Connection: keep-alive

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>hello</title>
</head>
<body>
 Hello Wrold
</body>
</html>
```

响应报文格式：

- 响应首行：`协议版本 响应状态码`。
- 响应头信息：尤其注意内容类型。
- 空行：如上例第10行。
- 响应体：即响应数据。如上例第11行至末尾。

上面两段示例都不是最完整的，且不是每行都很重要，下面就捡重要的、开发中我们会经常考察的来讲。

### 状态码

反映请求、响应的成功情况，常见的有：

- 2开头：成功。
- 3开头：成功且要求重定向。
- 4开头：失败，如404-找不到目标资源、405、400-跟客户端发的请求有关。
- 5开头：失败，服务器内部错误，有时跟客户端发的请求有关。

### 内容类型

服务器（浏览器）根据请求头（响应头）里的内容类型来解析请求参数（响应体）。

参考[官方文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Type)了解响应内容类型。尤注意其media-type分量，谈到了MIME（multipurpose internet mail extensions-多功能因特网邮件扩展）类型，其写法为`大类型/小类型`，并与某个文件扩展名相对应。tomcat的web.xml文件用mime-mapping标签记录了极为完整的MIME类型。

参考[Ajax笔记](Ajax.md)以了解请求内容类型。

### Referer

此请求头可用于阻止恶意访问或跳转回原页面。

只有因触发页面中的某个链接（href、src、AJAX的URL等）而产生的请求才包含此请求头。此请求头具有传递性。

referer（referrer）值是触发当前请求的链接引用的URL即所处页面的URL（带查询字符串）。

可参考此[文章](https://www.sojson.com/blog/58.html)，其中强调了我们不能完全依赖它，因为axios、potman等都可以伪造请求报文。

## JSP

### 概述

JSP（Java Server Page）是实现动态网页的核心技术，本质就是servlet。

由于前后端分离的大趋势，JSP已然式微。

交叉阅读本章与[Servlet](#Servlet)一章。

### 运行原理

以index.jsp为例。

tomcat的全局web.xml中定义了jsp请求与处理类JspServlet的映射。

当请求index.jsp时，调用处理类对象的service方法，这个方法干什么呢？

若index.jsp被首次请求，则index.jsp被翻译成index_jsp.java，即一个类，其超类之一就是HttpServlet，故此类就是一个servlet，具体原文档里的后端部分译为Java代码，前端部分译为字符串传入JspWriter对象out的write方法，随后这个类被编译成index_jsp.class，两个文件均生成在work目录下，最后加载index_jsp.class，通过反射创建此类实例并调用其_jspService方法，即执行后端部分并执行write方法将前端部分写出到HttpServletResponse对象response（\_jspService方法的一个参数）的缓冲区，再由后者传输给浏览器去加载解析渲染，若非首次请求且jsp文档没改动，则无需重新编译。

收到响应后前端部分被浏览器按HTML格式接收，故jsp文档的正常展示必须依靠服务器，本地打开的话浏览器不认得这个扩展名，就展示成普通文本。 

### 页面元素

#### 模板元素

即HTML代码，翻译时它们被嵌入字符串，最终被浏览器解析渲染。

#### 脚本片段

英文为scriptlet，里面专门写Java代码，具体分以下三种：

- 本片段一经翻译，会原封不动嵌入servlet的_jspService方法体内，有的还会自动被补上异常处理。

  ```jsp
  <%
  	String hobby = "computer science";
  	init();
  	out.print(hobby + "and more...<br/>");
  %>
  ```

- 本片段一经翻译会变成servlet的域和方法。

  ```jsp
  <%!
      // 域
  	public String name;
  	// 方法
  	public void setName() {
  		name = "Van";
  	}
  %>
  ```
  
- 本片段仅用于页面输出，会被传入JspWriter对象out的print方法。

  ```jsp
  <%= "<font color='red'>Hello</font>" + name %>
  ```

来看个完整的例子，就将上面三段拼成一个jsp文件。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>hello my scriptlet</title>
</head>
	<body>
		<%
			String hobby = "computer science";
			init();
        	// 后端输出
        	System.out.println("print on server");
        	// 前端输出
			out.print(hobby + "and more...<br/>");
		%>
		<%!
			public String name; 
			public void init() {
				name = "Van";
				// 貌似方法体内不能出现打印语句
			}
		%>
		<%= "<font color='red'>Hello</font>" + name %>
		<h2>Hello World</h2>
	</body>
</html>
```

运行后在浏览器中查看网页源代码，就会发现没有后端代码的影子。

```html
<html>
<head>
<title>Hello Van</title>
</head>
<body>
computer scienceand more...<br/>
<font color='red'>Hello</font>Van
<h2>Hello World</h2>
</body>
</html>
```

#### 注释

|                     | jsp文件 | java文件 | html页面 |
| ------------------- | ------- | -------- | -------- |
| `<%-- JSP注释 --%>` | 可见    | 不可见   | 不可见   |
| `<!-- HTML注释 -->` | 可见    | 可见     | 可见     |
| `// Java注释`       | 可见    | 可见     | 不可见   |

由上可得：

- JSP注释在翻译的时候被忽略。
- HTML注释在浏览器渲染DOM的时候被忽略。
- Java注释在编译的时候被忽略。

#### 指令

指令一般写在开头，会被翻译成java代码。

page指令：向浏览器指明文档的前端部分如何被解析。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
```

几个属性的作用参见[JSP 指令](https://www.runoob.com/jsp/jsp-directives.html)。

注：彻底地统一所有文件的编码方式，可通过eclipse.ini：

```ini
-Dfile.encoding=utf-8
```

include指令：静态包含其他页面。

```jsp
<!-- 绝对路径起始于项目根目录，相对路径起始于当前文档所在目录 -->
<%@ include file="/user/common.jsp"%>
```

注：参考此[文章](https://www.cnblogs.com/wxgblogs/p/5602689.html)了解静态包含于动态包含的异同。

taglib指令：引入标签库。在[JSTL](#JSTL)一章再了解。

### 标签

列举一些常用的。

```jsp
<!-- 动态包含 路径用法同静态包含 -->
<jsp:include page="common.jsp"></jsp:include>
<!-- 不带参转发 路径用法同servlet一章中的转发操作 -->
<jsp:forward page="login_success.jsp"></jsp:forward>
<!-- 带参转发 -->
<jsp:forward page="/TempServlet">
	<jsp:param name="username" value="root"/>
</jsp:forward>
```

### 内置对象

#### 概述

我们可在jsp页面内使用九大内置对象（或叫隐含对象），它们由服务器实例化。

- pageContext：属PageContext类，封装本servlet实例的上下文信息。

- out：属JspWriter类，在页面上输出内容。
- request：属HttpServletRequest接口，封装本次请求信息。
- response：属HttpServletResponse接口，封装本次响应信息。
- sesssion：属HttpSession接口，记录当前会话信息，后面专门谈session和cookie。
- application：属ServletContext接口，封装当前web项目信息。
- config：属ServletConfig接口，封装本servlet实例的配置信息。
- page：属Object类，引用本servlet实例。
- exception：属Throwable类，封装本servlet实例的异常信息。

在翻译jsp文档所得类的_jspService方法体内能发现这九个内置对象作局部变量或参数。

#### config

```jsp
<%
	// jsp 因为全局web.xml中为*.jsp请求配的名字就是jsp
	System.out.println(config.getServletName());
%>
```

#### page

虽然引用本servlet实例，但类型是Object，也就是说没啥方法可调的，还不如用this，它也引用本类实例。

#### response

所属类有几个重要方法需要掌握，但一般通过JSP使用，参见后面的[HttpServletResponse](#HttpServletResponse)。

附带理解一下两个输出：

```jsp
<%
	out.print("<h3>我在后</h3>");
	response.getWriter().write("<h2>我在前</h2>");
%>
```

print方法是将数据输出到out对象的缓冲区，write方法是将数据输出到response对象的缓冲区，最后响应时前者会并入后者、尾随后者，故浏览器渲染时第3行在上面。怎么改变顺序呢？在第2行后加一个`out.flush();`即倾空out对象的缓冲区，里面的数据先一步进入response对象的缓冲区。【我把前者一次性写满，是不是也能先一步呢？】

#### 域对象

##### 概述

九大隐含对象中有4个域对象（或叫范围对象），按数据可见范围从小到大排依次是：pageContext、request、session、application。

他们共有共享数据的方法：

- setAttribute：新增或修改属性。
- getAttribute：获取属性值。
- removeAttribute：移除属性。

诸对象的数据可见范围：

- pageContext：当前页面可见。
- request：本次请求可见。
- session：某浏览器与某项目的一次会话内的请求可见，关于一次会话有以下命题：
  - 同次会话内的请求均携带一个Name值为JSESSIONID的cookie，且此cookie的Value值都一样。
  - 服务器生成一对新的session与Name值为JSESSIONID的cookie，标志着某浏览器与某项目新会话的开启。

- application：某项目本次运行期间针对本项目的请求可见。

尽量使用最小范围对象以减少服务器的资源、性能损耗，因为维护的时间短。

注：同一浏览器开出来的多个窗口，处同一会话。

##### pageContext

调用此对象的get方法簇能获取其他任意隐含对象。

我们请求one.jsp，它再转发到two.jsp：

```jsp
<!-- one.jsp -->
<%
	pageContext.setAttribute("one", 1);
%>
<!-- 显示1 本页内可见 后续例子均如此 -->
<%= pageContext.getAttribute("one") %>
<jsp:forward page="/two.jsp"></jsp:forward>
```

```jsp
<!-- two.jsp 显示null -->
<%= pageContext.getAttribute("one") %>
```

跨页面了，前者的数据对后者就不可见了。

##### request

所属类有几个重要方法需要掌握，但一般不通过JSP使用，参见后面的[HttpServletRequest](#HttpServletRequest)。

还是上一节的例子，不过把pageContext改成request：

```jsp
<!-- one.jsp -->
<%
	request.setAttribute("one", 1);
%>
<%= request.getAttribute("one") %>
<jsp:forward page="/two.jsp"></jsp:forward>
```

```jsp
<!-- two.jsp 显示1 -->
<%= request.getAttribute("one") %>
```

说明同一次请求内多页面共享数据。

若去掉转发，先请求one.jsp后请求two.jsp或请求one.jsp而重定向到two.jsp，则显示null，因为是先后共两次请求。

##### session

还是上一节的例子，不过把request改成session且去掉转发：

```jsp
<!-- one.jsp -->
<%
	session.setAttribute("one", 1);
%>
<%= session.getAttribute("one") %>
```

```jsp
<!-- two.jsp 显示1 -->
<%= session.getAttribute("one") %>
```

说明只要浏览器不关且项目未下线，期间即使发不同请求，也能共享数据。

若先访问one.jsp，然后关闭浏览器再打开或切换浏览器，访问two.jsp，则显示null。

##### application

所属类含几个重要方法，请参见[ServletContext](#ServletContext)。

沿用上一节的例子与节尾操作，只不过把session改为application：

```jsp
<!-- one.jsp -->
<%
	application.setAttribute("one", 1);
%>
<%= application.getAttribute("one") %>
```

```jsp
<!-- two.jsp 显示1 -->
<%= application.getAttribute("one") %>
```

说明只要项目不下线或关闭服务器，不同会话能共享数据。

## 访问数据库

在jsp文档里写连接、操作数据库的代码。

```jsp
<!-- checkLogin.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>访问数据库-检查登录</title>
</head>
<body>
<form action="result.jsp">
	姓名：<input type="text" name="username"><br>
	密码：<input type="password" name="password"><br>
	<button type="submit">提交</button>
</form>
</body>
</html>
```

```jsp
<!-- result.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 导包 -->
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>登录是否成功</title>
</head>
<body>
<%
    // 联系JSP执行原理，这里相关的try-catch语句都在翻译得到的java文件中
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	final String DRIVER = "com.mysql.cj.jdbc.Driver";
	final String URL = "jdbc:mysql://localhost:3306/java_web";
	final String USER = "root";
	final String PASSWORD = "root";
	Class.forName(DRIVER);
	Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
	String sql = "select count(*) from user where name = ? and password = ?";
	PreparedStatement pre=connection.prepareStatement(sql);
	pre.setString(1, username);
	pre.setString(2, password);
	pre.execute();
	ResultSet result = pre.getResultSet();
	result.next();
	int count = result.getInt(1);
	if(count > 0){
		out.println("登录成功");
	} else {
		out.println("登录失败");
	}
%>
</body>
</html>
```

出于前后端分离、各司其职的思想，我们不提倡在jsp文档中写后端代码，于是引入JavaBean的知识。

## JavaBean

JavaBean是基于Java语言的一种可重用组件。参考[JavaBean百科](https://baike.baidu.com/item/javaBean)。

作用：

- 减轻jsp页面的复杂度。
- 实现代码复用，一个bean供多个jsp文件调用。

它就是一个类，不过得满足一些条件：

- 所有方法的权限修饰符为public。
- 有公有的无参构造器。
- 所有实例域私有，并且提供set、get方法（boolean实例域的get应为is）。

它通常作为MVC模式里的实体类，用于封装数据。一般地，实体类与数据表一一对应，属性与字段一一对应，还与表单控件的name一一对应，实体类对象与记录一一对应。

```jsp
<!-- 其他省略 -->
<form action="resultBetter.jsp">
```

```java
/**
 * 封装数据的实体模型或数据模型
 * 
 * @author Van
 *
 */
public class User {
	private String name;
	private String password;

	public User(String name, String password) {
		super();
		this.name = name;
		this.password = password;
	}

	public User() {
		super();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
```

```java
/**
 * 封装业务逻辑的业务模型
 * 
 * @author Van
 *
 */
public class LoginLogic {
	public int checkLogin(User user) {
		final String DRIVER = "com.mysql.cj.jdbc.Driver";
		final String URL = "jdbc:mysql://localhost:3306/java_web";
		final String USER = "root";
		final String PASSWORD = "root";
		PreparedStatement ps = null;
		Connection connection = null;
		ResultSet rs = null;
		try {
			Class.forName(DRIVER);
			String sql = "select count(*) from user where name = ? and password = ?";
			connection = DriverManager.getConnection(URL, USER, PASSWORD);
			ps = connection.prepareStatement(sql);
			ps.setString(1, user.getName());
			ps.setString(2, user.getPassword());
			ps.execute();
			rs = ps.getResultSet();
			rs.next();
			return rs.getInt(1);
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
```

```jsp
<!-- resultBetter.jsp 对应MVC中的视图层 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 导包 -->
<%@ page import="logic.LoginLogic" import="entity.User"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>登录是否成功</title>
</head>
<body>
<%
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	User user = new User(username, password);
	LoginLogic logic = new LoginLogic();
	int count = logic.checkLogin(user);
	out.println(count > 0 ? "登录成功" : "登录失败");
%>
</body>
</html>
```

这样改进还不够好，jsp文件中仍有后端代码，此外，我们的Web项目会越做越大，如何优雅地管理各类资源呢？引出MVC的知识。

## MVC

![MVC](JavaWeb.assets/MVC.png)

上图中的控制层一般由servlet担纲，由此引出servlet的知识。

上一章中resultBetter.jsp里的后端代码就应当移到servlet中去。

注：model与view的关系体现了观察者模式；view与controller的关系体现了策略模式。

## Servlet

### 概述

广义上servlet指sun公司指定的一套技术标准，即一系列web应用相关的接口，包括监听器等。狭义上servlet指javax.servlet.Servlet接口及其子接口、实现类。引用J2EE文档对此接口的定义：

> A servlet is a small Java program that runs within a Web server. Servlets receive and respond to requests from Web clients, usually across HTTP, the HyperText Transfer Protocol.

servlet实例由servlet容器（即web服务器如tomcat）创建，其下方法在特定情况下被回调。

一个servlet类按一定的路径规则捕捉请求。对2.5及以下版本，需配置web.xml；对3.0及以上版本，用WebServlet注解比较方便，两者不能共存。

```xml
<servlet>
    <!-- 第3、7行值相同，作为某请求与处理该请求的servlet类之间的桥梁 -->
	<servlet-name>xxx</servlet-name>
    <servlet-class>servlet.MyServlet</servlet-class>
</servlet>  
<servlet-mapping>
  	<servlet-name>xxx</servlet-name>
    <!-- 拦截请求，起头斜杠代表项目根路径，对应的虚拟路径即协议+主机名+端口号+项目名 -->
  	<url-pattern>/MyServlet</url-pattern>
</servlet-mapping>
```

```java
// @WebServlet("MyServlet")
public class MyServlet implements Servlet {
	public MyServlet() {
		System.out.println("创建servlet实例...");
	}

	/**
	 * 初始化servlet实例
	 */
	@Override
	public void init(ServletConfig config) throws ServletException {
		System.out.println("初始化servlet实例...");
	}

	/**
	 * 获取servlet实例的配置信息
	 */
	@Override
	public ServletConfig getServletConfig() {
		System.out.println("获取servlet实例的配置...");
		return null;
	}

	/**
	 * 服务-处理任意请求
	 */
	@Override
	public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
		System.out.println("my first servlet");
		res.getWriter().write("hello!");
	}

	/**
	 * 获取对servlet实例的描述信息 没意思
	 */
	@Override
	public String getServletInfo() {
		System.out.println("获取servlet实例的描述信息...");
		return "MyServlet";
	}

	/**
	 * 销毁servlet实例
	 */
	@Override
	public void destroy() {
		System.out.println("销毁servlet实例...");
	}
}
```

URL定位到的资源分为：

- 静态资源：实际的文件，地址带文件扩展名。
- 动态资源：处理请求的程序，地址不带扩展名。

浏览器发送一个请求，先根据URL中的协议+主机名+端口号+项目名定位到某计算机上tomcat软件上部署的某项目，然后将路径名剩余部分同url-pattern或WebServlet注解的值相匹配，匹配上了就加载classes目录下对应servlet类的字节码、通过反射创建其实例、调用service方法处理并返回，匹配不上则去项目根目录下找，还找不到就返回404了。

JSP是特殊的动态资源，JSP一章中分析了对此请求的[处理流程](#运行原理)。

### 生命周期

围绕servlet类的诸方法，梳理一个servlet实例从创建到销毁的过程。

针对上例，启动tomcat时控制台空空如也，首次访问之后有了打印：

```shell
servlet实例的构造器...
初始化servlet实例...
my first servlet
```

再次访问时仅打印第3行，多次访问均如此。关闭tomcat时打印了：

```shell
销毁servlet实例...
```

综上可得首次收到对应请求时servlet容器调用构造器创建servlet实例，初始化时调用init方法，接着调用service方法处理请求，之后的每次访问都只调用此实例的service方法，项目从服务器上卸载或关闭服务器时servlet实例被销毁，此间调用destroy方法。

构造器和init方法仅执行一次表明此实例是个单例。诸方法支持多线程，那么为避免线程安全问题，最好不要在此类中添加域。

![servlet生命周期](JavaWeb.assets/servlet生命周期.png)



默认servlet类等到需要处理请求的时候才被创建，可使其随着tomcat服务器的启动而创建。两种改法：

```xml
<servlet>
    <!-- 值越小越先创建 -->
	<load-on-startup>1</load-on-startup>
</servlet>
```

```java
@WebServlet(value="/MyServlet" loadOnStartup=1)
```

### ServletConfig

先在web.xml里准备点东西：

```xml
<!-- web项目的初始化参数，为诸实例共用 -->
<context-param>
    <param-name>user</param-name>
    <param-value>root</param-value>
</context-param>
<servlet>
    <servlet-name>my</servlet-name>
    <servlet-class>servlet.MyServlet</servlet-class>
    <!-- 随便自拟初始化参数 -->
    <init-param>
        <param-name>slogan</param-name>
        <param-value>fight for motherland</param-value>
    </init-param>
</servlet>
```

再看init方法：

```java
/**
 * 初始化servlet实例前调用 config对象只存放本servlet类的配置信息
 */
@Override
public void init(ServletConfig config) throws ServletException {
    // 获取servlet-name标签值即类别名
    System.out.println(config.getServletName());
    // 获取init-param标签值即初始化参数
    System.out.println(config.getInitParameter("slogan"));
    // 获取ServletContext对象，它封装了所属web应用相关的信息和方法
    System.out.println(config.getServletContext());
    System.out.println("初始化servlet实例...");
}
// 打印结果
my
fight for motherland
org.apache.catalina.core.ApplicationContextFacade@3afec336
初始化servlet实例...
```

能推出为什么是初始化前调用，因为配置的初始化参数可能影响着初始化，初始化涉及对实例内的属性赋值。

### ServletContext

当前servlet实例的上下文，指的就是所属web应用即部署的项目，对应的域对象是application。

编辑web.xml：

```xml
<!-- web项目的初始化参数，与后面的servlet实例的初始化参数相区分 -->
<context-param>
    <param-name>user</param-name>
    <param-value>root</param-value>
</context-param>
```

再看servlet类：

```java
public class UseContext implements Servlet {
	// 虽然提倡不写域，但此对象是只用来读的，不会造成线程安全问题
	private ServletConfig config;

	@Override
	public void init(ServletConfig config) throws ServletException {
		this.config = config;
	}

	@Override
	public ServletConfig getServletConfig() {
		return config;
	}

	@Override
	public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
		ServletConfig config = this.getServletConfig();
		ServletContext context = config.getServletContext();
		// root
		System.out.println(context.getInitParameter("user"));
		// /java-web 返回项目名，起头斜杠指服务器根路径（虚拟上指协议+主机名+端口号）
		System.out.println(context.getContextPath());
		// D:\apache-tomcat-8.5.70\wtpwebapps\java-web\hello.jsp 起头斜杠指项目根路径 常用于文件上传下载
		System.out.println(context.getRealPath("/hello.jsp"));
		// context对象可作为最大的范围对象application共享数据
		context.setAttribute("common", 521);
        // 空响应体
	}
	// ...
}
```

此类有大量方法，上例service方法体中我们列举了几个重要的。

### HttpServlet

通过eclipse创建的servlet类并不是实现Servlet接口，而是继承HttpServlet类。

```xml
<servlet>
    <servlet-name>MyHttpServlet</servlet-name>
    <servlet-class>servlet.MyHttpServlet</servlet-class>
    <init-param>
        <param-name>school</param-name>
        <param-value>whpu</param-value>
    </init-param>
</servlet>
<servlet-mapping>
    <servlet-name>MyHttpServlet</servlet-name>
    <!-- 多写几项也是可以的 -->
    <url-pattern>/extra/MyHttpServlet</url-pattern>
</servlet-mapping>
```

```java
//@WebServlet(urlPatterns = { "/extra/MyHttpServlet" }, initParams = { @WebInitParam(name = "schoole", value = "whpu") })
public class MyHttpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public MyHttpServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("为get请求调用此方法");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("为post请求调用此方法");
	}
}
```

结合上图中的那段文字，分析源码。自定义servlet类继承HttpServlet类，后者继承GenericServlet类，又后者实现Servlet接口。按理说，感知到请求，就会调用servlet实例的service方法，假定自定义类已覆盖doGet和doPost，按是否覆盖service分情况讨论：

- 当我们没覆盖service，调用父类HttpServlet的service方法，此方法体内又去调用重载的service方法，此方法体内判断请求方法是get、post还是其他，然后调用对应的do方法，又因为自定义类覆盖了doGet与doPost，故调用自定义类的对应do方法。
- 当我们覆盖了service。不管何种请求，直接调用自定义类的service方法。

### HttpServletResponse

HttpServletResponse接口对象封装了一次响应的信息。透过几种doPost方法体看它的功能：

```java
// 响应普通文本即字符串
PrintWriter writer = response.getWriter();
// 控制台显示Content-Length为10
writer.write("plain text");
```

```java
// 重定向 由于本servlet类的奇葩url-pattern，应跳到上一级
response.sendRedirect("../hello.jsp");
// 方法体执行结束，意味着对重定向里的第一个请求处理完毕
```

控制台显示重定向里第一次响应的响应体是空的，响应头里有一项Location引人瞩目，告诉浏览器第二次请求的URL。

```java
// 也可重定向到动态资源 我另创建了一个TempServlet，模板是extra/TempServlet ./可省略
response.sendRedirect("./TempServlet");
```

### HttpServletRequest

HttpServletRequest接口对象封装了一次请求的信息。透过doPost方法看它的功能：

```java
/* 获取请求参数 */
String username = request.getParameter("username");
System.out.println(username);
String[] hobbies = request.getParameterValues("hobby");
for (String hobby : hobbies) {
    System.out.println(hobby);
}
/* 获取请求头信息 */
System.out.println(request.getHeader("Content-type"));
System.out.println(request.getHeader("Content-length"));
/* 转发到另一个资源 */
// 用最小范围对象request带数据
request.setAttribute("age", 18);
// 获取转发器
RequestDispatcher dispatcher = request.getRequestDispatcher("TempServlet");
// 转发 从参数request看出带数据转发的特性
dispatcher.forward(request, response);
```

一次请求只能对应一次响应，故方法体内不要响应多次-写多个转发、多个重定向或转发加重定向。

由于多线程的存在，响应语句与其他语句没有先后要求，可以先响应后在响应期间执行后续语句，但有时存在隐患，比如带数据转发时下一个servlet实例拿不到数据：

```java
// 第一个servlet类实例
request.getRequestDispatcher("TempServlet").forward(request, response);
request.setAttribute("age", 18);

// 下一个servlet类实例 眼见得有两次转发
System.out.println(request.getAttribute("age")); // null
request.getRequestDispatcher("../hello.jsp").forward(request, response);
```

故一般把唯一的响应语句写在方法体末尾。

附带熟悉一下get方法和post方法的区别：

- get的参数是显式的，跟在路径名后面；post的参数是隐式（请求体）显式均可存在。
- get请求参数容量有限（4-5KB），如上传大文件会失败；而post的请求体可含大量数据。
- 乱码问题的解决方案不同，参见[编码方式-请求](#请求)。

### 转发与重定向

|                 | 转发            | 重定向           |
| --------------- | --------------- | ---------------- |
| 浏览器地址栏    | 不变            | 改变             |
| request范围数据 | 共享            | 不共享           |
| 请求-响应次数   | 1               | 2                |
| 对象支持        | HttpRequest对象 | HttpResponse对象 |
| 目标资源        | 必须是项目内的  | 不限于项目内的   |

服务端内部的转发可看作特殊的请求，故也带有方法等属性，值接续自当前请求。

在浏览器点前进后退是不发请求的，因为利用的是缓存的资源，这也印证了前端路由的可行性。而且在后退得到的地址中，重定向中的第一个地址、转发的目标地址都不会出现，这不难理解：缓存存的是有内容的页面，重定向里的第一个地址就是作重定向用的，不对应页面；转发是服务器内部进行的，浏览器不可知，当然记录不了转发后的目标地址。

### 注

改善上一章的登录案例。

```jsp
<!-- checkLogin.jsp 其他省略 -->
<form action="user/LoginServlet">
```

```java
// LoginServlet类的doPost方法体 本类对应MVC中的控制层
String username = request.getParameter("username");
String password = request.getParameter("password");
User user = new User(username, password);
LoginLogic logic = new LoginLogic();
int count = logic.checkLogin(user);
if (count > 0) {
    response.sendRedirect("/java-web/resultBest.jsp");
} else {
    request.getRequestDispatcher("../resultFail.jsp").forward(request, response);
}
```

成功和失败的页面就不展示了，干干净净，没有后端代码。

### 编码方式

#### 响应

响应给浏览器的时候要明确告知资源的编码方式，浏览器知道它怎么编码的才能解码回原内容。浏览器默认的字符集ISO-8859-1是个大杂烩，无法智能适配具体编码方式，故需我们指定。

```java
// 只告诉浏览器按HTML格式解析文本，但并未指定字符集，会显示乱码
response.setContentType("text/html"); // 改正：response.setContentType("text/html;charset=UTF-8")
// 设定必须在获取输出流之前，不然就白设了，因为这个流有了默认编码方式
PrintWriter writer = response.getWriter();
writer.write("<h1>假文本，真HTML<h1>");
```

可通过下面这个方法设定响应体编码方式，但它须辅以上面那个方法：

```java
// 先指定响应体内容类型，其编码方式才能被感知
response.setContentType("text/html");
response.setCharacterEncoding("UTF-8");
// 所以还不如像上例中的改正那样，把两个东西写一起，或这么写：response.addHeader("Content-type", "text/html;charset-8");
```

像html、jsp等文档中有指定编码方式的语句，则无需额外指定。

殊途同归，最终的效果都体现在控制台响应头的这一项：

```
Content-Type: text/html;charset=UTF-8
```

#### 请求

读请求参数的时候也可能出现乱码（特指中文，英文不会），我们须告知服务器根据何种编码方式来解析。解决：

```java
// 同理本行应在拿参数语句之前
request.setCharacterEncoding("UTF-8");
```

此方案只适用于post请求，不适合get请求。因为post请求的参数是以请求体形式存在的，意味着调用doPost方法的时候才将二进制流转为字符串，get请求的参数是跟在URL后面的，而这完整路径在doGet执行前早就被服务器按默认编码方式解析了。

对get请求正确做法是在tomcat的server.xml文件中配置：

```xml
<!-- 添加URIEncoding属性 -->
<Connector connectionTimeout="20000" port="80" protocol="HTTP/1.1" redirectPort="8443" URIEncoding="UTF-8"/>
```

### 路径

归纳一下虚拟路径（就是URL）的含义。

- url-pattern处，绝对路径起始于web项目的根路径。
- 页面中，绝对路径起始于服务器的根路径，相对路径起始于当前资源所属路径（易知对重定向，属第二个路径）。
- 转发处，绝对路径起始于项目的根路径（这也印证了转发只针对项目内资源），相对路径起始于当前资源所属路径。
- 重定向处，绝对路径起始于服务器的根路径，相对路径起始于当前资源所属路径。
- 其他情况。

若不指定项目名，项目的根路径与服务器的根路径就一样了，但最好不要这样做，容易误导。

使用相对路径的话一不小心会产生错误，实际开发中一般统一用绝对路径，较为稳妥。既然用绝对路径，重定向时就得补上项目名，最好通过HttpServletRequest对象的getContextPath方法动态获取。

base标签属HTML标签库，用于给本页面中的所以相对路径（包括JS里的）补上指定前缀，使其化为绝对路径。

```jsp
<!-- 置于head标签内且在所有含路径标签之前 最好写成动态的，协议名://主机名:端口号/项目名/ -->
<base href="<%=request.getScheme() %>://<%=request.getServerName() %>:<%=request.getServerPort() %><%=request.getContextPath() %>/"/>
<base href="<%=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/" %>" /> 
<!-- 注意request.getContextPath()返回值是带起始斜杠的 -->
```

## 三层架构

### 概述

本章第一节分析三层架构，后面几节搜集一些项目相关的问题。

从上到下是：

- 表示层：USL-User Show Layer，也叫视图层。

- 业务逻辑层：SLL-Service Logic Layer，也叫Service层。

- 数据访问层（持久化层）：DAL-Data Access Layer，也叫Dao层。

它与MVC设计模式的目的相同，即解耦合、提高代码复用度，但它对Web项目结构的理解不同，比MVC更加精细。

三层架构与MVC的对应关系：

![MVC与三层架构的关系](JavaWeb.assets/MVC与三层架构的关系.png)

往细里说的话其实有5层。

三层间的关系：上层调用下层，下层处理并返回结果给上层。

### classpath

有必要提一下长见识的classpath的问题，假如要读入一个配置文件，若使用单元测试类加文件输入流，则这个文件不管放部署前项目的什么地方都能读进来，只要路径写对了，看几个例子：

```java
Properties props = new Properties();
// 从原生项目根目录中找
props.load(new FileInputStream("webcontent\\db.properties"));

Properties props = new Properties();
// 同上
props.load(new FileInputStream("src\\db.properties"));
```

若项目已然部署，在方法中使用文件输入流，则无论文件放哪都是找不到的。我们只能借助类加载器，用类加载器就涉及到classpath的问题，它找文件的起始路径是classpath即诸字节码的根路径，已有一个源码包src，我们再建一个源码包名如config，把配置文件置于其下，对比部署前后的情况：

| ![原生源码包](javaweb.assets/原生源码包.png) | ![部署后的classes目录](javaweb.assets/部署后的classes目录.png) |
| -------------------------------------------- | ------------------------------------------------------------ |

发现所有源码包下的东西集束于classes文件夹中，只不过左边内层是java文件，右边是class文件。

用类加载器读配置文件的代码：

```java
Properties props = new Properties();
// getSystemClassLoader方法有坑，暂无法解释，别用
props.load(TempServlet.class.getClassLoader().getResourceAsStream("db.properties"));
System.out.println(props.getProperty("username"));
```

### servlet优化

对自定义的servlet类进行优化，为将来理解springmvc框架的控制器作铺垫。

目前是一个servlet类与一个请求一一对应，请求一多的话servlet类也会跟着变多，我们想对它们进行分类整合，比如将登录、注册的处理逻辑并入一个UserServlet类，让它们作此类的方法，设一个请求参数用于指定调用哪个方法，再利用反射动态调用。

拿到请求参数然后动态调用方法的逻辑也是通用的，故可抽取到一个BaseServlet类中。这个类又由UserServlet等类继承，那么在子类中就只用写像登录、注册这样的具体方法。

```java
@WebServlet("/BaseServlet")
public class BaseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        // 要在解析任一请求参数前指定编码方式
		request.setCharacterEncoding("UTF-8");
		// 发请求时指定的方法名
		String methodName = request.getParameter("method");
		// 调用叫此名字的方法
		try {
			Method method = this.getClass().getDeclaredMethod(methodName);
			method.setAccessible(true);
			method.invoke(this, request, response);
		} catch (Exception e) {
			e.printStackTrace();
            // 这里相当于servlet的全局异常处理了
			response.sendRedirect(request.getContextPath() + "/exception.jsp");
		}
	}

}
```

```java
@WebServlet("/user")
public class UserServlet extends BaseServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	public void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//...
	}

	public void register(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//...
	}
    //还有别的针对用户的处理逻辑就再加方法
}
```

### 分页

一种思路是在后端算出指定页的起始记录号，再去数据库基于limit关键字查询。

分页模型要素分析（注意顺序）：

- 总记录数：从数据库查出来。
- 每页记录数：有默认值，可由外部指定，须大于0。
- 首页号：若总记录数为0，则为0，否则为1。
- 总页数（尾页号）：若总记录数为0，则取0，否则若总记录数/每页记录数有余数，则取商加1，否则取商。
- 当前页号：由外部指定，须大于等于首页号且小于等于尾页号。
- 本页起始索引：若当前页号为0则取0，否则取(当前页号-1)*每页记录数。
- 本页所有记录：根据本页起始索引和每页记录数，从数据库查出来。
- 本页是否有上一页：当前页号是否大于首页号。
- 本页是否有下一页：当前页号是否小于尾页号。
- 上一页号：若有上一页，当前页号-1。
- 下一页号：若有上一页，当前页号+1。

### 重复提交

重复（不包括查询字符串的URL重复）写数据的提交会带来问题。举一些例子：

- 重复插入数据库。
- 重复修改数据库。
- 服务器性能无谓损耗。

前两个问题是关系到用户体验的，因为系统不报错但用户不知情，从以下活动体会他们的不知情：

- 网卡了，用户后退到缓存的提交页面做提交，以为后退能撤销刚才的提交，以为提交一次其实是两次。
- 网卡了，用户在提交后转发到的页面做刷新，以为刷新一次上次提交就失效但并不会，以为提交一次其实是两次。
- 网卡了，用户再次触发某提交链接，以为再次触发上一次的就失效但并不会，以为提交一次其实是两次。

那么解决原理就是阻止上述活动，只有用户在响应得到的提交页面上提交且仅提交一次时，才真正执行处理提交的逻辑。

常用解决方案诸如：

- 针对刷新重复提交问题，将转发改成重定向。
- 通过前端JS阻止重复触发提交链接。（可是JS是可禁用的）

特别介绍令牌（token）机制，它能替代上述两种方案，还能解决浏览器后退到缓存页面重复提交的问题。

具体是在请求页面时向session里添加一个令牌数据（可用UUID充当），另添加一个作令牌的请求参数，然后在提交的处理逻辑中比对令牌参数和session里的令牌，一致则移除令牌数据并执行后续逻辑。

```java
// TokenServlet内
String token = UUID.randomUUID().toString();
request.getSession().setAttribute("token", token);
request.setAttribute("tokenParam", token);
request.getRequestDispatcher("token.jsp").forward(request, response);
```

```jsp
<!-- token.jsp内 -->
<form action="TokenSubmit" method="post">
    <!-- 在浏览器查看网页源代码，这一行是看得到的 -->
	<input type="hidden" name="tokenParam" value="${tokenParam }"/>
	用户名：<input type="text" name="username"/>
	<button type="submit">提交</button>
</form>
```

```java
// TokenSubmit内
HttpSession session = request.getSession();
String token = (String) session.getAttribute("token");
String tokenParam = request.getParameter("tokenParam");
System.out.println("令牌参数：" + tokenParam);
System.out.println("令牌数据：" + token);
// 有人可能不经页面，直接通过地址栏提交，不带令牌参数
if (tokenParam == null) {
    response.sendRedirect(request.getContextPath() + "/TokenServlet");
} else if (tokenParam.equals(token)) {
    // 令牌一致，允许注册 注册逻辑就省略了
    session.removeAttribute("token");
    // 转发后用户刷新页面，因为令牌数据没了且重复提交的令牌参数还是旧的，故令牌不匹配，只能刷新提交页面
    // 网卡时用户多次点提交，点一次令牌数据就没了，后面几次请求的令牌参数也都是旧的，故令牌不匹配，只能刷新提交页面
    request.getRequestDispatcher("one.jsp").forward(request, response);
    // response.sendRedirect(request.getContextPath() + "/one.jsp");
} else {
    // 令牌不一致
    response.sendRedirect(request.getContextPath() + "/two.jsp");
}
```

令牌不一致，那么如何优雅地让用户明白重复提交了呢？

注：点浏览器左上角三个按钮，得到的静态资源可能取自缓存，AJAX等则不会，按shift+F5（谷歌推荐）清空缓存地刷新。

不知情的重复提交发生在页面的跳转（包括前端控制的跳转）时，故其他情况下的提交（增删改操作）一般无需令牌机制。前后端分离时，客户端的令牌可由页面刷新时发AJAX获取。

### 验证码

用于防止恶意注册、暴力登录等，但作用有限，如今机器越来越厉害了。

验证码机制与token机制一样。请求页面时嵌入验证码图片，并将对应内容存入session，然后在提交的处理逻辑中对比验证码参数和session里的内容数据，匹配才移除内容数据并执行后续逻辑。

有个验证码生成工具叫kaptcha，是谷歌旗下的。图片的相关配置可参考[kaptcha配置文件](https://blog.csdn.net/ZhangVeni/article/details/50990895)。大多数第三方包下含Constants.class文件，里面定义了一些重要的常量，像kaptcha的这个文件就有图片样式、验证码内容相关的常量。

注：可设置浏览器是否缓存图片，若不缓存，则即使后退也会重新请求图片资源。

### 计算问题

项目运行时有可能会遇到计算问题，诸如整数溢出为负数或0、浮点数精度损失。

我们最好在有计算问题的地方使用Big系列类，用完转回原类型。注意实例化BigDecimal时传入字符串最稳妥。

## EL表达式

这两章又回到JSP，内容会略述。

Expression Language-表达式语言，用于简化JSP代码。

对于实体类，EL表达式仅依赖getter不依赖setter，无其他影响的话属性都不用写。

用法详见[JSP 表达式语言](https://www.runoob.com/jsp/jsp-expression-language.html)。

## JSTL

JSP standard tag libray-JSP标准标签库，是一套由Sun公司制定的API，立足于EL表达式扩展出了更多功能。

由Apache实现的这套API含5个标签库，每个标签依赖一个类。想使用就得导包。

用法详见[JSP 标准标签库](https://www.runoob.com/jsp/jsp-jstl.html)。提一些注意点：

- `<c:url>`与`<c:redirect>`里的绝对路径起始于项目根路径，前者可用于重写URL，解决浏览器禁用cookie问题。

  ```java
  // encode系列方法重写URL，智能地判断浏览器是否禁用cookie，是则拼上;JSESSIONID键值对
  response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/cookie.jsp"));
  ```

  ```xml
  <a href="<c:url value="/cookie.jsp"></c:url>">去往cookie.jsp，动态拼上;JSESSIONID键值对</a>
  ```

- `c:choose`标签内的注释只能是JSP注释。

欲自定义标签必遵守Sun制定的规范，即实现JspTag接口。自定义标签分以下几步：

1. 在WEB-INF/tags目录中编写标签库的描述文件：new xml file->取名，改后缀为tld->create xml file from an xml schema file->select xml catalog entry->选中含web-jsptaglibrary的xsd->移除j2ee前缀。
1. 编写此文件，描述标签结构。
1. 定义对应的实现类，须实现JspTag的子接口SimpleTag。

## cookie与session

这两个东西配合起来用于提升访问效率，直接从服务端取数据、往服务端存数据。

可参考文章[session和cookie的区别](https://blog.csdn.net/qq_35257397/article/details/52967241)。

类型说明：

- session是HttpSession接口实现类的对象，注意所含的id域。
- cookie是Cookie类的对象，注意所含的Name域和Value域。

内容太杂，这里拣关键的说一下。

每次浏览器访问服务器某项目时，服务器先看请求带没带Name值为JSESSIONID的cookie（记作凭证cookie）：没带的话就为此项目并此浏览器生成一对session和凭证cookie，前者准备保存项目相关数据，后者交给浏览器保存，前者的id值与后者的Value值一模一样，这就开启了新一次会话，浏览器下次访问此项目时就会带着这个cookie；带了的话浏览器将它的Value值同现存的所有session的id值一一比对，有匹配的就允许其操作此session所保存的数据，全都不匹配的话就重新生成一对session与凭证cookie并将后者交给浏览器，覆盖掉原有的凭证cookie，这又开启了一次新的会话。

一个session的id值或一个凭证cookie的Value值唯一标识一个浏览器与一个项目的一次会话。

相关方法的使用参考项目。

## 过滤器

### 概述

servlet、过滤器、监听器是Javaweb的三大组件。

可参考[Servlet 编写过滤器](https://www.runoob.com/servlet/servlet-writing-filters.html)。另参考J2EE文档的javax.servlet.Filter接口，其中对filter的定义如下：

> A filter is an object that performs filtering tasks on either the request to a resource (a servlet or static content), or on the response from a resource, or both.

过滤器不光过滤请求，还过滤响应，好比地铁的进口闸机和出口闸机，有以下基本工作：

- 拦截请求，读写请求报文。
- 拦截响应，读写响应报文。
- 放行请求或不放行而响应其他资源。

由上生成的应用诸如登录验证、事务控制、乱码解决等。

用法上同servlet很像。看个例子：

```java
//@WebFilter("/MyFilter")
public class MyFilter implements Filter {

	public MyFilter() {
		System.out.println("创建我的过滤器");
	}

	public void destroy() {
		System.out.println("销毁我的过滤器");
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// 检查
		if (request.getParameter("money") != null) {
            // 满足要求才放行
			chain.doFilter(request, response);
		} else {
			// 不满足要求则不会响应目标资源，而是替代资源
			response.getWriter().write("no money, no girl");
		}
	}

	public void init(FilterConfig fConfig) throws ServletException {
		System.out.println("初始化我的过滤器");
	}

}
```

```xml
<filter>
    <filter-name>MyFilter</filter-name>
    <filter-class>filter.MyFilter</filter-class>
    <!-- 随便写点初始化参数 -->
    <init-param>
        <param-name>slogan</param-name>
        <param-value>fight for hometown</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>MyFilter</filter-name>
    <!-- 只要访问girl.jsp就会被拦截检查 -->
    <url-pattern>/girl.jsp</url-pattern>
</filter-mapping>
```

### 执行原理

为某项目添加过滤器之后，访问此项目某资源的请求会先被过滤器拦截并检查，满足条件则放行，获取目标资源，否则响应过滤器中定义的替代资源，无替代资源的话就返回一个空响应体的响应。并且，在响应目标资源时，也会先被过滤器拦截，可以篡改响应体。

```java
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
    // 此时request对象和response对象已经生成且都作实参了
	if (request.getParameter("money") != null) {
        // 响应报文未完全形成，但已经生成响应头，且先往response对象的缓冲区中写数据准备作响应体的开头，由于没指定设编码方式，响应头里的编码方式就是默认的会导致乱码的
        response.getWriter().write("头插");
        // 执行jsp文档翻译出的java代码，将前端部分追加写出到response对象的缓冲区 注意设定内容类型的代码会失效，因为响应头已经生成了，想改里面的编码方式已经晚了
		chain.doFilter(request, response);
        // 往response对象的缓冲区里追加数据
        response.getWriter().write("尾插");
        // 而后响应报文最终形成，被发送给浏览器
        System.out.println("拦截响应")
	} else {
		// 响应体为空
	}
}
```

若满足条件却不显式调用doFilter方法，请求不被放行，于是返回头插尾插数据作响应体的响应。

前后扩充响应体仅适用于jsp资源，对普通静态资源，只能做头插，因为doFilter一执行完响应体成形了。

### 生命周期

过滤器从创建到销毁均由服务器控制，不过生命周期跟servlet稍有不同。

过滤器对象的创建和初始化是随着项目的加载而进行的，通过调用构造器创建对象，初始化时调用init方法，它们都仅执行一次，故过滤器也是单例。对象随着项目的卸载而销毁，销毁时执行destroy方法。每当服务器接收到对应请求，就调用doFilter方法来拦截。各方法也均支持多线程。

### url-pattern

配置此标签值进行灵活匹配，拦截某个请求或某一类请求。

- 精确匹配：拦截标签值与地址尾部完全一样的请求。

  ```xml
  /girl.jsp
  /pages/order/order.jsp
  /client/LoginServlet
  ```

- 路径匹配：标签值由路径名与通配符组成，拦截对此路径下任意资源的请求。

  ```xml
  /* 本项目下所有资源
  /pages/*
  /client/*
  ```

- 后缀匹配：拦截目标资源带指定后缀名的请求。

  ```xml
  *.jsp
  *.jpg
  *.* 谁都不拦截（不是谁都拦截），没人这么配
  ```

上述配置也适用于servlet，但servlet一般只采用精确匹配。

三者不能混用，看错误的例子：

```xml
/pages/user/*.jsp
```

附带看一下URL和URI的区别，在doFilter方法体内加几行：

```java
// 发的是http://localhost/java-web/girl.jsp?money=100
HttpServletRequest req = (HttpServletRequest) request;
// /java-web/girl.jsp URI是去掉Host部分的地址，不带查询字符串
String uri = req.getRequestURI();
// http://localhost/java-web/girl.jsp URL是完整的地址，但也不带查询字符串
StringBuffer url = req.getRequestURL();
// 请求头里的路径名是/java-web/girl.jsp?money=100
```

### FilterConfig

```java
public void init(FilterConfig fConfig) throws ServletException {
    String filterName = fConfig.getFilterName();
    String slogan = fConfig.getInitParameter("slogan");
    // 由servlet上下文对象（表示项目）获取项目初始化参数
    ServletContext context = fConfig.getServletContext();
    String user = context.getInitParameter("user");
    System.out.println("初始化我的过滤器");
}
```

### 过滤器链

当多个过滤器拦截同一个请求，web.xml中先出现的过滤器先拦截请求，后拦截响应，因为web.xml自上而下被服务器扫描，先扫描到的离浏览器越近、离资源越远。

对于离资源最近的过滤器，执行doFilter方法体，针对动态资源底层就会调用service方法、_jspService方法。

### dispatcher

假如我们通过一个servlet转发得到gir.jsp，则过滤器不会拦截，因为其url-pattern只针对浏览器发来的请求，不针对服务器内部的转发。不过可通过dispatcher标签增强其管控范围：

```xml
<filter-mapping>
    <filter-name>MyFilter</filter-name>
    <url-pattern>/girl.jsp</url-pattern>
    <!-- 如此转发到girl.jsp之前也会被拦截 -->
    <dispatcher>FORWARD</dispatcher>
</filter-mapping>
```

此标签取值有4种，相对多种场景进行拦截，那得配多个标签。

- REQUEST：默认，只拦截请求。
- FORWARD：只拦截转发。
- INCLUDE：只拦截动态包含。
- ERROR：只拦截JSP异常时向全局报错页面的转发。注意page指令里的errorPage属性指的是局部报错页面，靠FORWARD拦截。

借此机会看一下全局（此项目）报错页面的配置：

```xml
<error-page>
    <error-code>404</error-code>
    <location>/error/404.html</location>
</error-page>
```

### 控制事务

服务器接收请求到发送相应，是由一个线程控制的，对接数据库的事务机制，这一个线程必须对应一个连接，从而保证出错时能撤销当前请求涉及到的所有DML操作。项目里我们设定业务逻辑层诸方法内部获取、释放连接，若servlet处理请求调多个业务逻辑层方法或业务逻辑层方法调用本层方法，则产生多事务，做不到整体回滚。

参考bookstore-upper项目，整个项目里的大部分异常都抛给事务过滤器处理。我们提倡底层做约束（抛异常），高层统一回滚（处理），消除try-catch语句高度冗余。罗列关键的改进点：

- 造了个事务过滤器，实现全局事务控制兼全局异常处理，可联想express的错误处理中间件。

  ```java
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
          throws IOException, ServletException {
      Connection conn = null;
      try {
          conn = JDBCUtils.getConnection();
          // 放行请求前开启事务
          conn.setAutoCommit(false);
          chain.doFilter(request, response);
          // 拿到资源后提交
          conn.commit();
      } catch (Exception e) {
          // 针对期间所有异常，统一回滚
          try {
              conn.rollback();
          } catch (SQLException | NullPointerException e1) {
              e1.printStackTrace();
          }
          // 针对期间所有异常，统一发往错误页面
          HttpServletRequest req = (HttpServletRequest) request;
          HttpServletResponse resp = (HttpServletResponse) response;
          resp.sendRedirect(req.getContextPath() + "/exception.jsp");
      } finally {
          try {
              // 恢复自动提交
              if (conn != null) {
                  conn.setAutoCommit(true);
              }
          } catch (SQLException e) {
              e.printStackTrace();
          }
          // 释放连接、移除键值对
          JDBCUtils.closeResource(conn, null, null);
      }
  }
  ```

  ```xml
  <!-- 全局事务控制及全局异常处理 -->
  <filter>
      <filter-name>TxFilter</filter-name>
      <filter-class>com.van.filter.TxFilter</filter-class>
  </filter>
  <filter-mapping>
      <filter-name>TxFilter</filter-name>
      <url-pattern>/*</url-pattern>
  </filter-mapping>
  ```

- 在工具类中设一个映射属性，当前线程的id作键，一个连接对象作值，组成键值对放入映射，这样同时处理不同请求，虽然共用映射，但根据各自的线程id获取各自的连接，互不干扰。

  ```java
  public class JDBCUtils {
      private static DataSource dataSource = new ComboPooledDataSource("C3P0Source");
      // 各线程对应一次请求到响应，各自复用各自的连接
      private static Map<Long, Connection> conns = new HashMap<>();
  
      /**
       * 从c3p0连接池中获取连接，并存入映射，唯一对应当前线程（请求->响应），或从映射中获取连接
       * 
       * @return
       * @throws SQLException
       */
      public static Connection getConnection() throws SQLException {
          // 当前线程id唯一（id号并不是自增唯一的，是可以复用的，仅在已被分配期间唯一）
          long id = Thread.currentThread().getId();
          // 各用各的，不会搞乱
          Connection connection = conns.get(id);
          if (connection == null) {
              connection = dataSource.getConnection();
              conns.put(id, connection);
          }
          return connection;
      }
  
      /**
       * 关闭资源，并移除映射中的对应键值对
       * 
       * @param conn
       * @param stmt
       * @param rs
       */
      public static void closeResource(Connection conn, Statement stmt, ResultSet rs) {
          DbUtils.closeQuietly(conn, stmt, rs);
          // 不移除，线程id号一旦复用，拿已经释放的连接调用方法，会抛异常，另外映射越来越大浪费内存
          conns.remove(Thread.currentThread().getId());
      }
  }
  ```

- 当前线程重复执行BaseDao的通用方法，就会重复获取对应的唯一连接。

  ```java
  // 其他通用查询方法省略
  public T getEntity(String sql, Object... params) throws SQLException {
      // 当前线程重复利用一开始拦截请求时拿到的连接，使得诸DML操作在同一事务内
      Connection conn = JDBCUtils.getConnection();
      // 捕捉因数据库约束产生的异常，层层往上抛给事务过滤器
      return runner.query(conn, sql, new BeanHandler<T>(type), params);
  }
  ```

- BaseServlet也得改，得把异常上传给事务过滤器。

  ```java
  protected void service(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      String methodName = request.getParameter("method");
      try {
          Method method = this.getClass().getDeclaredMethod(methodName, HttpServletRequest.class,
                  HttpServletResponse.class);
          method.setAccessible(true);
          method.invoke(this, request, response);
      } catch (Exception e) {
          // 在catch里抛出非受检异常，由事务过滤器捕获
          throw new RuntimeException(e);
      }
  }
  ```

- dao层方法少了大量Connection参数的定义、service层方法少了大量try-catch语句，但两层均多出大量throws语句。

## 监听器

监听器主要监听三个当前对象：

- 对应请求的ServletRequest接口对象。
- 对应会话的HttpSession接口对象。
- 对应web应用的ServletContext接口对象。

这三个对象各由各的监听器监听，合起来有8个，如下所示：

<img src="D:\chaofan\typora\专业\JavaWeb.assets\image-20220504161651355.png" alt="image-20220504161651355" style="zoom:80%;" />

由上图左列可只这些监听器接口分三大类：

- 3个：监听生命周期，仅创建与销毁。
- 3个：监听属性的增改（setAttribute）删（removeAttribute）。
- 2个：监听session对象的钝化活化（activation）和对象绑定（binding）。

下面这个例子包办了，三个对象都能监听：

```java
// 监听三个域对象的监听器
public class LifeCycleListener implements ServletRequestListener, HttpSessionListener, ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("正在销毁application对象");
	}

	@SuppressWarnings("unused")
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("正在创建application对象");
		// 对应当前web应用
		ServletContext context = sce.getServletContext();
	}

	@SuppressWarnings("unused")
	@Override
	public void sessionCreated(HttpSessionEvent se) {
		System.out.println("正在创建session对象");
		// 对应当前会话
		HttpSession session = se.getSession();
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		// session销毁（失效）只有到期、手动失效两种方式
		System.out.println("正在销毁session对象");
		// 关闭服务器、卸载项目等都不会调用此方法，session只是被钝化，并不是被销毁
	}

	@Override
	public void requestDestroyed(ServletRequestEvent sre) {
		System.out.println("正在销毁request对象");
	}

	@SuppressWarnings("unused")
	@Override
	public void requestInitialized(ServletRequestEvent sre) {
		System.out.println("正在创建request对象");
		// 对应当前请求
		ServletRequest request = sre.getServletRequest();
		ServletContext context = sre.getServletContext();
	}
}
```

下面这个例子也是包办的：

```java
// 监听三个域对象的属性的监听器 后面几个方法体里的代码类似，就不写了
public class AttributeListener implements ServletRequestAttributeListener, HttpSessionAttributeListener, ServletContextAttributeListener {

	@Override
	public void attributeAdded(ServletContextAttributeEvent event) {
		// 获取属性名
		String attrName = event.getName();
		// 获取属性值
		Object attribute = event.getServletContext().getAttribute(attrName);
		System.out.println("正在往application中添加attribute，属性名：" + attrName + "，属性值：" + attribute);
	}

	@Override
	public void attributeRemoved(ServletContextAttributeEvent event) {
		String attrName = event.getName();
		System.out.println("正在从application中移除attribute，属性名：" + attrName);

	}

	@Override
	public void attributeReplaced(ServletContextAttributeEvent event) {
		String attrName = event.getName();
        // 旧值
		Object oldVal = event.getValue();
        // 新值
		Object newVal = event.getServletContext().getAttribute(attrName);
		System.out.println("正在application中更新attribute，属性名：" + attrName + "，旧属性值：" + oldVal + "，新属性值：" + newVal);

	}

	@Override
	public void attributeAdded(HttpSessionBindingEvent event) {
	}

	@Override
	public void attributeRemoved(HttpSessionBindingEvent event) {
        // session失效也触发此方法，只不过不能通过event拿刚移除的属性了，因为session已失效，证明此方法是失效后调用的
	}

	@Override
	public void attributeReplaced(HttpSessionBindingEvent event) {
	}

	@Override
	public void attributeAdded(ServletRequestAttributeEvent srae) {
	}

	@Override
	public void attributeRemoved(ServletRequestAttributeEvent srae) {
	}

	@Override
	public void attributeReplaced(ServletRequestAttributeEvent srae) {
	}
}
```

想让以上两个监听器生效，需在web.xml中添加配置：

```xml
<listener>
    <listener-class>listener.LifeCycleListener</listener-class>
</listener>
<listener>
    <listener-class>listener.AttributeListener</listener-class>
</listener>
```

第三类的两个监听器不需要在web.xml中配置，它们监听session域对象相关的四项工作：

- 绑定：执行setAttribute方法，存入数据。
- 解绑：removeAttribute方法，移除数据。
- 钝化：为了给内存腾出空间、防止数据丢失，服务器将session对象从内存序列化进硬盘，又叫持久化。
- 活化：钝化的逆过程。

我们引用官方文档对钝化活化监听器的定义：

> Objects that are bound to a session may listen to container events notifying them that sessions will be passivated and that session will be activated. A container that migrates session between VMs or persists sessions is required to notify all attributes bound to sessions implementing HttpSessionActivationListener.

监听的目标是绑定给session的对象，故应让某个JavaBean实现此接口以及Serializable接口：

```java
// 只监听Student对象
public class Student implements HttpSessionActivationListener, Serializable {
	private static final long serialVersionUID = -4801427360080538621L;

	/**
	 * 监听钝化（内存->外存），Will：在钝化之前执行
	 */
	@Override
	public void sessionWillPassivate(HttpSessionEvent se) {
		// 前提是对象已经绑进去了
		System.out.println("我和session一起钝化");
	}

	/**
	 * 监听活化（外存->内存），Did：在活化之后执行
	 */
	@Override
	public void sessionDidActivate(HttpSessionEvent se) {
		System.out.println("我和session一起活化");
		Student student = (Student) se.getSession().getAttribute("student");
		System.out.println(student);
	}

}
```

我们引用官方文档对绑定解绑监听器的定义：

> Causes an object to be notified when it is bound to or unbound from a session. The object is notified by an [`HttpSessionBindingEvent`](https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionBindingEvent.html) object. This may be as a result of a servlet programmer explicitly unbinding an attribute from a session, due to a session being invalidated, or due to a session timing out.

监听的目标也是绑定给session的对象，故同样是让某个JavaBean实现此接口：

```java
// 只监听User对象
public class User implements HttpSessionBindingListener {
	@Override
	public void valueBound(HttpSessionBindingEvent event) {
		String name = event.getName();
		Object value = event.getValue();
		System.out.println("name: " + name + ", value: " + value);
	}

	/**
	 * session失效也引起解绑
	 */
	@Override
	public void valueUnbound(HttpSessionBindingEvent event) {
        // 不过这里能拿到属性，证明此方法是session失效前调用的
		String name = event.getName();
		Object value = event.getValue();
		System.out.println("name: " + name + ", value: " + value);
	}
}
```

## 国际化

### 概述

外国人叫它i18n（internationalization），目的是让web应用适配多国语言、多国时间、多国地域。

一般国际化是小范围的，整个项目做国际化还不如另写一套针对其他语言的项目。

### 实现

我们一般创建一个配置文件名为`基础名_语言_国家.properties`，例如：

```
i18n_zh_CN.properties
i18n_en_US.properties
```

然后将同含义不同文字形式的提示信息置于相应的文件中，文件又放在classpath（源码包）下。

```properties
username=\u9EC4\u98DE\u9E3F
```

```properties
username=Thomas
```

ResourceBundle类管理所有国际化资源文件，能够动态获取国际化资源，演示一下原理：

```java
// 根据本机环境动态获取地域信息
Locale us = Locale.getDefault()
// 根据基础名与地域信息从所有i18n文件中找到特定的那一个，并加载资源
ResourceBundle rb = ResourceBundle.getBundle("i18n", us);
String username = rb.getString("username");
System.out.println(username);
```

JSP文档里的使用：

```jsp
<body>
<%
	// 从请求头里获取浏览器设置的地域信息
	Locale locale = request.getLocale();
	// 针对最下面两个超链接
	String lang = request.getParameter("lang");
	String country = request.getParameter("country");
	if (lang != null && country != null) {
		locale = new Locale(lang, country);
	}
	ResourceBundle rb = ResourceBundle.getBundle("i18n", locale);
%>
<h2><%= rb.getString("welcome") %></h2>
<%= rb.getString("username") %><input type="text" name="username"><br>
<%= rb.getString("password") %><input type="password" name="password">
<button type="submit"><%= rb.getString("submit") %></button>
<a href="i18n.jsp?lang=zh&country=CN">中文</a>&ensp;|&ensp;<a href="i18n.jsp?lang=en&country=US">English</a>
</body>
```

经典白学，上例只是演示原理，下面这个基于JSTL的才是常用的：

```properties
# 还能带插槽
welcome={0}, welcom you to WHPU, today is {1}, wish {0} a good dream
username=login
password=register
submit=submit
```

```jsp
<!-- 根据请求参数指定地域 语言_国家 -->
<fmt:setLocale value="${param.locale }"/>
<!-- 指定基础名 地域信息在请求头里已经有了 -->
<fmt:setBundle basename="i18n"/>
<!-- 还能传参数 -->
<h2>
<fmt:message key="welcome">
	<fmt:param>君</fmt:param>
	<fmt:param><fmt:formatDate value="<%= new Date() %>" type="both" dateStyle="long" timeStyle="short"/></fmt:param>
</fmt:message>
</h2>
<fmt:message key="username"/><input type="text" name="username"><br>
<fmt:message key="password"/><input type="password" name="password">
<button type="submit"><fmt:message key="submit"/></button>
<a href="i18n-upper.jsp?locale=zh_CN">中文</a>&ensp;|&ensp;<a href="i18n-upper.jsp?locale=en_US">English</a>
</body>
```

## 文件相关

### 概述

这东西太常见了，如上传头像、上传商品海报、下载表格等。思考文件存储在哪里好呢，数据库还是服务器？数据库一般保存占空间很小的字段，二进制流的话一来占空间，二来传到应用再传到客户端很费时间，故对优化的项目而言文件（图片、音视频等）一般存到静态文件服务器；对普通项目而言文件就存到某个目录下。

### 上传

上传依赖表单，具体是type值为file的input控件，form的method值应为post。回顾[Ajax笔记](Ajax.md)中关于请求内容类型的讨论，这里延续实验一下，我们保持form默认的enctype（encode type）值即A类型，servlet能拿到普通请求参数但拿不到二进制流。

```java
request.setCharacterEncoding("utf-8");
String username = request.getParameter("username");
// 一般是带后缀的文件名（除了IE奇葩）
String avatar = request.getParameter("avatar");
// 借助commons-io
String stream = IOUtils.toString(request.getInputStream());
// stream是空串的，证明流并没有传进来
System.out.println("流：" + stream);
response.sendRedirect("/java-web/file-upload.jsp");
```

参考[form标签的enctype属性](https://www.w3school.com.cn/tags/att_form_enctype.asp)。然后把enctype值改成B类型，就发现除了流，其他参数拿不到了，都封进流了。

```java
request.setCharacterEncoding("utf-8");
// null
String username = request.getParameter("username");
// null
String avatar = request.getParameter("avatar");
String stream = IOUtils.toString(request.getInputStream());
// stream有东西了，还包含前两个参数，即封装所有表单数据
System.out.println("流：" + stream);
response.sendRedirect("/java-web/file-upload.jsp");
```

```
流：------WebKitFormBoundaryYAxPM8sHcjoKlOLS
Content-Disposition: form-data; name="username"

root
------WebKitFormBoundaryYAxPM8sHcjoKlOLS
Content-Disposition: form-data; name="avatar"; filename="凡.jpg"
Content-Type: image/jpeg

一串乱码...
```

接着就想如何由流拆分得到各个参数。

```java
request.setCharacterEncoding("utf-8");
// 借助commons-fileupload，它依赖commons-io
DiskFileItemFactory factory = new DiskFileItemFactory();
ServletFileUpload fileUpload = new ServletFileUpload(factory);
try {
    // 流中的一个部分就是一个FileItem对象
    List<FileItem> list = fileUpload.parseRequest(request);
    for (FileItem fileItem : list) {
        // true表示普通表单域，false表示文件
        if (fileItem.isFormField()) {
            // 普通表单域的name值
            String fieldName = fileItem.getFieldName();
            System.out.println(fieldName);
        } else {
            // 文件名
            String fileName = fileItem.getName();
            System.out.println(fileName);
            // 获取文件流
            InputStream stream = fileItem.getInputStream();
            // 防止重名覆盖
            String prefix = UUID.randomUUID().toString();
            // 上传存放到部署后的项目中
            FileOutputStream outputStream = new FileOutputStream(
                    getServletContext().getRealPath("/upload/") + prefix + "_" + fileName);
            IOUtils.copy(stream, outputStream);
            // 请求报文一收完，输入流自动关闭，只用手动关输出流
            outputStream.close();
        }
    }
} catch (FileUploadException e) {
    e.printStackTrace();
}
response.sendRedirect("/java-web/file.jsp");
```

### 下载

我们用指向静态资源的普通超链接实践下载，发现浏览器能渲染的资源就不给下载而是直接渲染出来，不能渲染的就下载下来。于是我们通过响应头告知浏览器不要去渲染得到的流而是写出到磁盘。

```java
String fileName = "凡.jpg";
String realPath = getServletContext().getRealPath("/upload/" + fileName);
// 根据资源动态设置响应内容类型
response.setContentType(getServletContext().getMimeType("/upload/" + fileName));
// 解决此请求头里中文文件名编码问题的万能方案
String encoded = new String(fileName.getBytes("gbk"), "ISO-8859-1");
// 告知浏览器如何处置，是渲染还是保存 attachment-附件
response.setHeader("Content-Disposition", "attachment;filename=" + encoded);
// 读入内存
FileInputStream fis = new FileInputStream(realPath);
// 写出到响应对象的缓冲区
ServletOutputStream os = response.getOutputStream();
IOUtils.copy(fis, os);
// 这里输入流得手动关，而一发完响应报文输出流就自动关闭
fis.close();
```

## 项目发布

一般是将原生项目打成war包，放在远程服务器tomcat安装路径下的webapps文件夹内，让tomcat自动部署。

我们还总将tomcat启动程序做成服务，随开机启动：

```shell
# 进入tomcat安装路径，可能需要管理员权限 服务名任意
service.bat install Tomcat8.5
```

```shell
# sc是系统删服务命令
sc delete Tomcat8.5
```

用eclipse，我们在项目名上点右键->export->搜索war->在弹窗里选定war包的存放目录。

## IDEA

本章说明一下如何使用IDEA创建Web项目并设定热部署。

下面是建项目和配置Tomcat的步骤图：

![image-20200710111849638](JavaWeb.assets/image-20200710111849638.png)



![image-20200710112550303](JavaWeb.assets/image-20200710112550303.png)

注意上图第一步Add Configuration。

![image-20200710112850345](JavaWeb.assets/image-20200710112850345.png)

设定热部署：

![image-20200710113738803](JavaWeb.assets/image-20200710113738803.png)

引入Tomcat环境依赖（加号加的是第二个列表项-Library）：

![image-20200710114625522](JavaWeb.assets/image-20200710114625522.png)

tomcat依赖（或环境）就是一组jar包，它们可见于tomcat根目录的lib文件夹内。

关于字节码文件存放路径的修改及lib目录的设定可参考此[博客](https://www.cnblogs.com/printN/p/6537903.html)。

附带谈一下jar包的问题，这里记录一下自己在两个IDE上的实验结果：

- eclipse：

  - web项目：只要把jar包拷贝到lib目录下，eclipse就自动对它们Add to build path，效果是编译不报错。

  - 普通项目：eclipse不会帮我们把jar包Add to build path，结果是编译报错，此时就得手动Add to Build Path。

- idea：

  - web项目：只把jar包拷贝到lib目录下，编译会报错。要手动对它们逐一进行Add as Library或Project Structure->Modules->Denpendencies->+Jars or directories->选中lib目录（推荐）。但直接运行能成功。
  - 普通项目：同eclipse。

## JNDI

### 概述

即Java Name Directory Interface-Java名称目录接口。

JNDI实现在项目间共享数据，域对象等，具体通过tomcat配置文件context.xml对这些东西进行读写。

### 使用

往context.xml中写入：

```xml
<Environment name="jndiName" value="jndiValue" type="java.lang.String"/>
```

在jsp文档中写：

```java
Context jndi = new InitialContext();
// java:comp/env/ 这个前缀一定要加
String value = (String)jndi.lookup("java:comp/env/jndiName");
out.print(value);
```
