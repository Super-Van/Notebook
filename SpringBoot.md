# SpringBoot

参考视频：[SpringBoot教程](https://www.bilibili.com/video/BV1Et411Y7tQ?p=112&vd_source=768bca3ca74de2a4a4a3a209b7b1ec86)。

## 概述

spring生态圈内有Data、Cloud、Security等如此多的成员，组装得越多就越靠近配置地狱，那么spring技术栈一站式框架springboot（boot：开机）专攻这一问题，快捷方便地整合生态圈里的任何成员，简化繁杂的配置与构建，让我们更专注于业务逻辑的开发。

随着spring 5的问世，spring技术栈分为两拨-原有的servlet技术栈与响应式技术栈，后者号称占用少量资源就能处理大量并发。为配合Java 8的新特性，源码层面spring 5也有一些改革。

援引[官网](https://spring.io/projects/spring-boot)对它的定义：

> Spring Boot makes it easy to create stand-alone, production-grade Spring based Applications that you can "just run".

缺点是作为高层框架，封装太深，内部原理难掌握。

spring生态依托于重要的时代背景，主要包括[微服务](https://martinfowler.com/microservices/)、分布式、云原生（cloud native）等。

## 实例

以依托原生maven项目的web项目为例，参考[Developing Your First Spring Boot Application](https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started.first-application)，后面还有更快捷的创建方式。

在POM中添加依赖：

```xml
<!--必备依赖-->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.3.4.RELEASE</version>
</parent>
<!--web场景启动器-->
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

当前做web开发就用web场景启动器。

创建主程序类：

```java
@SpringBootApplication
public class MainApplication {
    public static void main(String[] args) {
        SpringApplication.run(MainApplication.class,args);
    }
}
```

最后随便弄个控制器就可以直接测试了，其他什么都不用配，连tomcat都内置了。

当有特定配置需求，springboot做了极大简化，统一收束到一个配置文件，比如下面这个properties文件：

```properties
# 刚起头，就写这一个吧
server.port=80
```

详细配置参见[Application Properties](https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#appendix.application-properties)。

```java
//@Controller
//@ResponseBody
@RestController // 上面两个的合体
public class MyController {
    @RequestMapping("/hello")
    public String hello() {
        return "hello springboot";
    }
}
```

至于部署，以前的web工程需要打成war包再放在tomcat的webapp目录下，现在不用了，就打成一个增容版的jar包，直接执行便可提供web服务，jar包用`java -jar`命令执行。前提是有这个依赖：

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

idea中，在Maven选项卡Lifecycle下拉列表中选中package命令点击Run Maven build按钮打包，最好一并选中clean命令先重新编译一下。

## 依赖管理

### 版本仲裁

上例POM里的parent标签表示本项目级联继承父项目的POM配置，既然级联，那么点开spring-boot-starter-parent，它也有个parent标签，父项目叫spring-boot-dependencies，再点开，其中的properties标签声明了许多常用jar包的版本。

父项目已经帮我们做好了开发中常用依赖的管理，见于spring-boot-dependencies的dependencyManagement标签，它做的是版本号的管理，即并不导入依赖，而是等自己添加依赖时，就自动指定预设的版本号。我们想改版本号的话，或是在version标签体里指定，或是定义properties标签去覆盖父项目对应依赖的版本号，例如：

```xml
<!--就近优先原则-->
<properties>
    <mysql.version>5.1.43</mysql.version>
</properties>
```

### 场景启动器

场景启动器是一系列以`spring-boot-starter-`开头的依赖，针对任何场景开发，都无需费尽心力考虑导哪些包，因为相关依赖都在场景启动器里声明了，比如点开spring-boot-starter-web，就发现所需的dependency标签，还有级联的，详情可在POM.xml中右键点开Diagram。

[Starters](https://docs.spring.io/spring-boot/docs/current/reference/html/using.html#using.build-systems.starters)罗列了所有spring支持的场景启动器，都不满意甚至可以自定义场景启动器，这是后话了，还有一些第三方的。

所有场景启动器都有一个依赖叫spring-boot-starter，它的依赖spring-boot-autoconfigure是springboot自动配置的核心依赖。

## 自动配置

### 概述

springboot自动配置了场景常见功能，那么运行起来后IOC容器中就有相关的组件对象，可通过run方法的返回值查看：

```java
ConfigurableApplicationContext context = SpringApplication.run(MainApplication.class, args);
for (String name:context.getBeanDefinitionNames()){
    System.out.println(name);
}
```

包扫描也不用配，[默认](https://docs.spring.io/spring-boot/docs/current/reference/html/using.html#using.structuring-your-code)主程序类所在包及其子包被扫描。不想用默认的话，或是这样：

```java
@SpringBootApplication(scanBasePackages="com.van")
```

或是这样：

```java
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan("com.van")
```

大多数默认配置是容器中的组件，它们由容器中的其他一类组件-配置类自动注册，基于Configuration、Bean等注解，我们点开spring-boot-autoconfigure包发现admin、amqp、aop等一个个场景目录，其下大多数类即配置类。

默认配置都能在统一的配置文件中更改，其他配置也能在此文件中编写，每一个配置项均与容器中某组件的属性相映射。

### 底层注解

#### Configuration

用Configuration注解标注的类取代XML配置文件，用Bean注解+方法取代bean标签。

```java
/**
 * IOC容器配置类 本身也是容器内组件，底层映射中的键为首字母小写的类名
 */
@Configuration(proxyBeanMethods = true)
public class ContextConfig {
    /**
     * 注册 对照bean标签，以方法名为id值，返回值类型为class值，返回值为容器中生成的组件实例
     *
     * @return
     */
    @Bean
    public Student student() {
        return new Student(1, "欧阳询");
    }

    @Bean("teacher") // 注解值作底层映射中的键
    public Teacher getTeacher() {
        return new Teacher(1, "王羲之");
    }
}

/*主程序类中测试*/ 
ConfigurableApplicationContext context = SpringApplication.run(MainApplication.class, args);
for (String name : context.getBeanDefinitionNames()) {
    System.out.println(name);
}
//主程序类也算配置类 com.van.MainApplication$$EnhancerBySpringCGLIB$$e19f7647@3f736a16
System.out.println(context.getBean("mainApplication"));
System.out.println(context.getBean("student"));
System.out.println(context.getBean("teacher", Teacher.class));
//单实例
System.out.println(context.getBean("teacher") == context.getBean("teacher"));
//cglib代理，com.van.config.ContainerConfig$$EnhancerBySpringCGLIB$$950dfb57@2da66a44
ContextConfig contextConfig = context.getBean(ContextConfig.class);
System.out.println(contextConfig);
//显式调用注册方法，返回值是单实例与否取决于proxyBeanMethods属性，与其同真假
System.out.println(contextConfig.student() == contextConfig.student());
```

proxyBeanMethods属性的原理是：用代理对象则扩充注册方法原本的逻辑，即判断容器是否已有该类对象，有则不返回新对象，返回已有对象，否则返回新对象，不用代理对象则每次调用均返回新对象。

这个属性值为true与false分别对应springboot的两种模式-full与lite（轻量级）。所谓轻量，就是跳过了容器中是否含某组件对象的检查，效率会更高。lite模式适合没有组件关联的情况，牺牲空间换时间；full模式适合有组件关联的情况，牺牲时间换空间。

#### Import

可以将Import注解打给已纳入容器的任何组件，习惯上打给配置类，后同。

```java
@Import({Student.class})
```

有趣的是，这里通过Import注解又注册了Student类，对照bean标签，id值是全限定类名，与前面注册的id值为student的同类组件区分开，如此随着容器启动当中就恒有两个Student对象。

#### Conditional

条件注解有一大堆派生注解，怎么看出来派生呢？比如下面这个例子：

```java
@Conditional({OnBeanCondition.class})
public @interface ConditionalOnBean {}
```

两行写法是等价的。我们可以搜索Conditional开头的派生注解，挑选出适合当前需求的。

#### ImportResource

一旦使用springboot，原先的容器配置文件就不起作用了，一点点地对里面的配置进行重构太麻烦，于是以此注解包含旧有配置。

```java
@ImportResource("classpath:beans.xml") // 打给配置类
```

#### ConfigurationProperties

配置文件的配置项映射到某组件的属性，前提就是此组件被纳入容器且标有ConfigurationProperties注解。

那么对自定义组件，标注@Component或其他几种外加ConfigurationProperties即可。

```java
@Component
// 既可标在类定义处，也可标在注册方法处
@ConfigurationProperties(prefix = "cat") // 配置项的前缀
public class Cat {}
```

```properties
cat.name=小白
cat.age=2
```

那么对非自定义组件，像场景目录下的一些组件，源码动不了，就只能去配置类用EnableConfigurationProperties注解一箭双雕-注册传入的组件同时将让它绑定配置文件，且组件还是得有@ConfigurationProperties，因为必须指明配置项前缀。

```java
@EnableConfigurationProperties({Cat.class}) // 打给配置类
```

@ConfigurationProperties大量出现在源码中，标志着组件（属性）与配置文件（配置项）相绑定。

### 源码解读

@SpringBootApplication相当于这三个注解的合体，因此我们拆开来看。

```java
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(
    excludeFilters = {@Filter(
    type = FilterType.CUSTOM,
    classes = {TypeExcludeFilter.class}
), @Filter(
    type = FilterType.CUSTOM,
    classes = {AutoConfigurationExcludeFilter.class}
)}
)
```

我们看@SpringBootConfiguration标有@Configuration，说明这也是个配置类。@ComponentScan没什么好说的，这里有内置的排除规则。最重要的就是@EnableAutoConfiguration。

它相当于这两个注解的合体：

```java
@AutoConfigurationPackage
@Import({AutoConfigurationImportSelector.class})
```

在@AutoConfigurationPackage中有个@Import，注册的是内部类Registrar，它又实现了ImportBeanDefinitionRegistrar，在实现方法registerBeanDefinitions体内开启包扫描：

```java
AutoConfigurationPackages.register(registry, (String[])(new AutoConfigurationPackages.PackageImports(metadata)).getPackageNames().toArray(new String[0]));
```

仔细观察可知这些组件就是主程序类所属包及其子包下的组件：metadata是被@Import标注的@AutoConfigurationPackage的相关信息，就包括它标注的类MainApplication，接着getPackageNames方法返回的就是MainApplication所处包名。

看另一个注解Import传入了ImportSelector接口的实现类AutoConfigurationImportSelector的Class实例，在实现方法selectImports体内批量注册组件，它调用getAutoConfigurationEntry方法。后者体内又调用getCandidateConfigurations方法，这个方法返回了所有可能注册的配置类。体内用SpringFactoriesLoader类调用loadFactoryNames方法。体内调用loadSpringFactories方法。这个方法体内，发现会扫描当前项目内匹配`META-INF/spring.factories`路径的文件，恰好spring-boot-autoconfigure包下面就有这个文件，点开发现所有内置场景相关的所有配置类的全类名，尤以名字以AutoConfiguration结尾的最多。那么对第三方场景启动器，其自动配置类的加载也体现于jar包META-INF目录下的spring.factories文件中。

这些配置类都会被加载（不一定进容器），但是依靠条件注解按需注册管理的其他组件，如ConditionalOnClass-缺少依赖的类就不注册、ConditionalOnMissingBean-用户注册了就不重复注册。点开它们，有的标有@Configuration，类体内存在@Bean、条件注解等标注的方法，存在条件注解等标注的内部类等等。典例如配置类DispatcherServletAutoConfiguration的dispatcherServlet方法。

联系配置文件，配置类常标有@EnableConfigurationProperties，运行时获取它指定的组件对象传入注册方法或构造器，指定组件的名字通常以Properties结尾，而我们已知此组件与配置文件相绑定，所以我们理解了配置项影响着配置类，进而影响配置类注册的组件即默认配置。例如配置类HttpEncodingAutoConfiguration在调用characterEncodingFilter方法注册CharacterEncodingFilter时，基于properties属性给CharacterEncodingFilter对象的encoding属性赋值，而properties属性是靠@EnableConfigurationProperties的值`ServerProperties.class`初始化的，这个ServerProperties又与前缀为server的配置项相绑定。

所以除了文档给的Application Properties，自己也可去源码中找所需的prefix属性。

### 最佳实践

引入场景依赖。

查看自动配置。一个直观的办法是添加`debug=true`配置项，打印出的Negative matches（Did not match）就指没注册的配置类，Positive matches就指注册了的配置类。

可能需要修改默认配置或新增配置：

- 添加配置项。
- 自定义配置类并注册对应某配置的组件。
- 自定义实现一批类名以Customizer结尾的接口。

## 便捷开发

### Lombok

它提供的注解使得JavaBean在编译时自动生成getter、setter、构造器，源代码只留属性。还提供注解使得类体自动添加类型源自slf4j、log4j等日志的Logger属性。

添加依赖；idea安装插件。

```java
@Data //getter、setter
@AllArgsConstructor //全参构造器
@NoArgsConstructor //无参构造器
@ToString //toString方法
@EqualsAndHashCode // equals与hashCode方法
public class Student {
    private Integer no;
    private String name;
}
```

```java
@Slf4j
@RestController
public class MyController {
    //方法体内写 log.info("");
}
```

### Spring Initializer

即项目初始化向导，标题是idea里的叫法，eclipse里叫spring starter project。

它提供了界面供我们选择场景，随后自动导入相关依赖、自动创建主程序类、自动在resources目录下创建：

```
static：存放css、js、图像等静态资源
template：jsp、html等页面
application.properties
```

## YAML

即yet another markup language，非常适合作配置文件，故常用application.yaml等价替换application.properties，两者都有的话后者优先级更高。

语法可参考[菜鸟教程](https://www.runoob.com/w3cnote/yaml-intro.html)等文档。

idea中yml文件对自定配置项即自己打的@ConfigurationProperties指定的前缀没有代码提示，发现被标注的类开头有Annotation Processor未找到的提醒，它就起着提示的作用，参考[Configuring the Annotaion Processor](https://docs.spring.io/spring-boot/docs/current/reference/html/configuration-metadata.html#appendix.configuration-metadata.annotation-processor.configuring)，我们把依赖导进来并在打包时排除。

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <excludes>
                    <exclude>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-configuration-processor</artifactId>
                    </exclude>
                </excludes>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## Web场景

### 静态资源

#### 概述

参考[Static Content](https://docs.spring.io/spring-boot/docs/2.3.12.RELEASE/reference/html/spring-boot-features.html#boot-features-spring-mvc-static-content)，规定类路径下的static或resources或public或META-INF/resources作静态资源根目录，默认映射的路径模板是`/**`，可以修改如：

```properties
spring.mvc.static-path-pattern: /static/**
```

一般是要改的，便于让拦截器放行静态资源请求或转发。

可修改默认的静态资源根目录：

```properties
# 映射到ResourceProperties类，查看里面是怎么写路径的
spring.resources.static-locations[0]: classpath:/rain/
spring.resources.static-locations[1]: classpath:/sun/
```

对于纯项目根路径如`localhost:8080`的请求，会找index.html：先去静态资源目录下找，没有则去找控制器的处理方法。

应用图标要放在静态资源目录下，名字必须是favicon.ico。

#### 源码解读

web场景有哪些默认配置，那就是WebMvcAutoConfiguration类注册了哪些组件。注意到内部类WebMvcAutoConfigurationAdapter也是个配置类，标有@EnableConfigurationProperties，值包含映射`spring.mvc`前缀的WebMvcProperties及映射`spring.resources`前缀的ResourceProperties，这两个类的对象作构造方法的参数，还有一些其他参数，它们均由容器自动注入。

接着看addResourceHandlers方法，开头是几个配置项：

- `spring.resources.add-mappings`：静态资源请求无效与否，设false这个方法就直接返回了，不往后处理静态资源了。
- `spring.resources.cache.period`：缓存时长。

然后是对匹配`/webjars/**`的路径的处理，映射到`classpath:/META-INF/resources/webjars/`下的资源，再是静态资源路径模板匹配的请求的处理，映射到静态资源目录下的资源。

再看welcomePageHandlerMapping方法，体内创建WelcomePageHandlerMapping对象，传入静态资源路径模板。构造器体内判断index.html在静态资源目录下且这个模板是`/**`，满足则将`/`匹配的请求地址映射到ParameterizableViewController对象，见于其调用的setRootView方法（前提是我们没定义`/`路径模板，不然我们的[先拦下来](#请求映射)），此处理器对象再调用handleRequestInternal方法设视图名为`forward:/index.html`，即从静态资源目录下获取index页面，不满足再判断templates目录中有无index.html，有则同理设视图名为`index`，即让匹配的控制器方法来处理。至于favicon图标，只要访问本站点，浏览器就会发`/favicon.ico`，显然匹配到静态资源路径模板，故去静态资源目录中找favicon.ico。

### REST

关于对REST风格请求的支持，我们看WebMvcAutoConfiguration类已经有了hiddenHttpMethodFilter方法，注册的是继承HiddenHttpMethodFilter的OrderedHiddenHttpMethodFilter类的实例，但默认还是不生效，还差点东西，注意到方法头上的：

```java
@ConditionalOnProperty(prefix = "spring.mvc.hiddenmethod.filter", name = "enabled", matchIfMissing = false)
```

matchIfMissing为false，意思是没有这个配置项就不注册，所以还得去配置文件加上这个配置项：

```properties
spring.mvc.hiddenmethod.filter.enabled=true
```

点开HiddenHttpMethodFilter，ALLOWED_METHODS属性表示过滤器能将POST请求过滤为PUT、DELETE、PATCH请求。

跟浏览器不同，Postman等工具能直接发PUT或DELETE请求，即直接将请求头里的方法设为PUT或DELETE，那么过滤器成了摆设。

迎合前后端分离、后端作仅返回JSON数据的接口、springboot常用于分布式微服务的趋势，此配置项就没有默认开启。

冗长的`@RequestMapping(value = "/user", method = RequestMethod.XXX)`可等价简化为：

```java
@GetMapping("/user")
@PostMapping("/user")
@PutMapping("/user")
@DeleteMapping("/user")
```

我们改过滤器默认规定的请求参数值`_method`，顺带练习一下注册内置组件、覆盖默认配置（利用@ConditionalOnMissingBean）：

```java
@Bean
public HiddenHttpMethodFilter getHiddenMethodFilter(){
    HiddenHttpMethodFilter hiddenHttpMethodFilter = new HiddenHttpMethodFilter();
    hiddenHttpMethodFilter.setMethodParam("_mom");
    return hiddenHttpMethodFilter;
}
```

### 请求映射

源码在springmvc笔记里分析过了，这里谈一些不同之处。

在getHandler方法体内，handlerMappings属性有5个元素，依次是：

```
requestMappingHandlerMapping
welcomePageHandlerMapping
BeanNameUrlHandlerMapping
RouterFunctionMapping
SimpleUrlHandlerMapping
```

在springmvc笔记里看到的是3个，多了两个-WelcomePageHandlerMapping与RouterFunctionMapping类型的元素。

去WebMvcAutoConfiguration下看默认注册了HandlerMapping接口的哪些实现类，有requestMappingHandlerMapping、welcomePageHandlerMapping方法。

必要时注册自定义的HandlerMapping实现类，定制请求路径映射的处理器。

### 参数处理

#### 概述

本章补充一些springmvc笔记没见过的。

@CookieValue所标参数类型不仅可以是字符串， 还可以是Cookie类：

```java
/**
 * @param cookie 自动传入Name值为JSESSIONID的Cookie对象
 * @return
 */
@RequestMapping("/cookie")
@ResponseBody
public String getCookie(@CookieValue("_ga") Cookie cookie){
    System.out.println(cookie.getName());
    System.out.println(cookie.getValue());
    return "cookie";
}
```

#### RequestAttribute

这个注解与ModelAttribute注解相像，都能在处理方法之间共享数据，但后者所标参数的实参取自隐含模型，前者所参数的实参取自request域对象，故对后者来说前驱方法可以用Model、ModelMap、Map对象作参数来添加数据，对前者而言则只能用原生request域对象作参数添加数据。

```java
@GetMapping("/former")
public String former(HttpServletRequest request) {
    request.setAttribute("msg", "success");
    request.setAttribute("code", 200);
    return "forward:/latter";
}

@GetMapping("/latter")
@ResponseBody
public Map<String, Object> latter(@RequestAttribute("msg") String msg, @RequestAttribute("code") Integer code) {
    Map<String, Object> map = new HashMap<>();
    map.put("msg", msg);
    map.put("code", code);
    return map;
}
```

域对象不含指定数据的话会报错，可通过注解的required属性取消强制性。

#### MatrixVariable

URI规范-RFC 3986定义了一种别致的URL形式，即一组以分号分隔的键值对，功能上充当参数。我们记得严格意义上的URL是不包括查询字符串的，但并不意味着不能包含参数，这种形式就是证明。spring为响应规范，制定了这个注解-矩阵变量。

比如我们发送一个请求，路径是`/matrix/2;id=2;hobby=volleyball,run,badminton`，对应处理方法如下：

```java
@RequestMapping("/matrix/{student}") // 须绑定在路径变量上，这里可看出路径变量并不依赖@PathVariable，假如用@PathVariable获取路径变量值，发现不包括矩阵变量（第一个分号连同后面的内容），即仅2
@ResponseBody
public String matrixVariable(@MatrixVariable("id") Integer id, @MatrixVariable("hobby") List<String> hobby) {
    System.out.println(id);
    hobby.forEach(System.out::println);
    return "student";
}
```

默认矩阵变量是不生效的。找到WebMvcAutoConfigurationAdapter的configurePathMatch方法，它依赖UrlPathHelper类，关注此类的removeSemicolonContent属性，默认值是true，看其setter的注释-URL里分号连同后面的内容会被删掉。

想让它生效，可惜没有相关配置项，于是只能自己另注册WebMvcConfigurer接口组件，实现configurePathMatch方法，覆盖WebMvcAutoConfigurationAdapter的实现逻辑：

```java
/**
 * 配置类或实现此接口作此它的bean，或用注册方法注册匿名实现类
 * @return
 */
@Bean
public WebMvcConfigurer getWebMvcConfigurer(){
    return new WebMvcConfigurer() {
        @Override
        public void configurePathMatch(PathMatchConfigurer configurer) {
            UrlPathHelper urlPathHelper = new UrlPathHelper();
            urlPathHelper.setRemoveSemicolonContent(false);
            configurer.setUrlPathHelper(urlPathHelper);
        }
    };
}
```

另行注册WebMvcConfigurer组件后，容器中就有两个WebMvcConfigurer的bean，另一个是默认注册的WebMvcAutoConfigurationAdapter的bean。

来看复杂的写法，一个矩阵变量绑定一个路径变量，那么多个矩阵变量对应各自路径变量，应分别获取：

```java
@RequestMapping("/matrix/{student}/{teacher}")
@ResponseBody
public String multiMatrixVariable(@MatrixVariable(value = "id", pathVar = "student") Integer studentId, @MatrixVariable(value = "name", pathVar = "student") String studentName, @MatrixVariable(value = "id", pathVar = "teacher") Integer teacherId, @MatrixVariable(value = "name", pathVar = "teacher") String teacherName) {
    System.out.println(studentId + studentName);
    System.out.println(teacherId + teacherName);
    return "student";
}
```

### 源码解读

springmvc笔记中提到RequestMappingHandlerAdapter元素取代AnnotationMethodHandlerAdapter元素，底层一大改进是处理方法参数的解析是由参数解析器完成的（前者的参数解析逻辑很松散，完整地见于HandlerMethodInvoker类的resolveHandlerArguments方法），详见于RequestMappingHandlerAdapter的invokeHandlerMethod方法，此方法体内，用到HandlerMethodArgumentResolverComposite类型的argumentResolvers属性，它又有个argumentResolvers列表属性，含二十多个元素，包括针对@RequestParam的RequestParamMethodArgumentResolver、针对@PathVariable的PathVariableMethodArgumentResolver等等。

处理方法参数解析器的顶层接口是HandlerMethodArgumentResolver，含两个方法：

- supportsArgument：当前参数解析器（实现类）对象支不支持对当前参数的解析。
- resolveArgument：上一方法返回true，才调用此方法解析参数。

目标方法对象handlerMethod被包装为ServletInvocableHandlerMethod类型的invocableMethod对象，它调用setter收纳了argumentResolvers属性，后来它调用invokeAndHandle方法，传入ServletWebRequest对象与ModelAndViewContainer对象。体内调用invokeForRequest方法，继续传入两个对象。方法体内，调用getMethodArgumentValues方法，继续传入两个对象，解析得到实参数组，然后将其传入doInvoke方法即执行目标方法，得到目标方法返回值并作返回值。那就得看getMethodArgumentValues方法如何解析参数，先调用getMethodParameters方法得到目标方法形参详情，赋给名为parameters的MethodParameter数组，准备空的实参数组args，遍历parameters数组，循环体内resolvers属性调用resolveArgument方法，传入当前元素、ModelAndViewContainer对象、请求对象、WebDataBinderFactory类型的属性。此方法体内，先调用<span id="argumentResolvers">getArgumentResolver方法</span>得到能解析当前参数的解析器对象，传入MethodParameter对象。体内遍历argumentResolvers属性即全体解析器对象，逐对象调用前面提到的supportsArgument，传入MethodParameter对象，而且某参数首次解析之后将MethodParameter对象与对应的解析器对象组成键值对缓存入映射，提升后续执行效率，最后返回匹配的解析器对象。回到resolveArgument方法体，后用拿到的解析器对象调用resolveArgument方法，传入MethodParameter对象、ModelAndViewContainer对象、NativeWebRequest对象、WebDataBinderFactory对象，返回的实参对象作返回值。回到getMethodArgumentValues方法体，将resolveArgument方法返回的实参对象填入args数组，最后返回arg数组。

譬如模型数据。Map类型的参数由MapMethodProcessor对象解析，其resolveArgument方法调用ModelAndViewContainer对象的getModel方法得到隐含模型，最终赋给参数。Model类型的参数由ModelMethodProcessor对象解析，后续同理。

譬如自定义类型的参数。它由ServletModelAttributeMethodProcessor对象解析，关注其父类ModelAttributeMethodProcessor覆盖的resolveArgument方法，逻辑在springmvc笔记里的数据绑定一章梳理过，需要补充的是WebMvcAutoConfiguration的getConfigurableWebBindingInitializer方法，注册了ConfigurableWebBindingInitializer，它实现了WebBindingInitializer接口，覆盖initBinder方法，传入WebDataBinder对象，体内调用此对象的相应setter将conversionService属性注入，这个conversionService属性已经保存了所有转换器对象。

关注一个新东西叫返回值解析器，参见invokeHandlerMethod方法体内出现的HandlerMethodReturnValueHandlerComposite类型的returnValueHandlers属性，它又有个returnValueHandlers列表属性，存放着10多个返回值解析器对象，它们的顶层接口是HandlerMethodReturnValueHandler，含两个方法：

- supportsReturnValue：当前返回值处理器对象支不支持处理当前返回值。许多实现类覆盖此方法的逻辑就是判断返回值类型跟自己指定的匹不匹配。又如RequestResponseBodyMethodProcessor覆盖此方法的逻辑是检查有无@ReponseBody。
- handleReturnValue：上一方法返回true，才调此方法处理返回值。

进入ServletInvocableHandlerMethod的invokeAndHandle方法体，returnValueHandlers属性调用handleReturnValue方法，传入invokeForRequest方法的返回值即目标方法的返回值、此返回值的类型、ModelAndViewContainer对象、ServletWebRequest对象。方法体内，调用selectHandler方法找出合适的HandlerMethodReturnValueHandler对象，传入返回值及其类型，随后用此对象调用handleReturnValue方法，继续传入四个对象。在selectHandler方法体内，遍历returnValueHandlers属性，逐解析器对象调用supportsReturnType方法，传入返回值类型，一旦结果为true就返回当前解析器对象。

关于handleReturnValue方法，以RequestResponseBodyMethodProcessor覆盖的逻辑为例，顺便理解HttpMessageConverter\<T>的相关知识。方法体内，关注writeWithMessageConverters方法，传入返回值、返回值类型、请求对象、响应对象。此方法体内，先看isResourceType方法，判断返回值是否为流数据，是则将其写入响应体，再看到MediaType类型（封装内容类型及其权重）的content对象，这涉及到内容协商的知识，HTTP规定浏览器用请求头的Accept一项告诉服务器自己可接受的内容类型即响应体类型，接着调用getAcceptableMediaTypes方法，传入请求对象得到MediaType列表，就是浏览器制定的Accept项，接着调用getProducibleMediaTypes方法，传入请求对象、返回值、返回值类型，得到MediaType列表，即可生成的内容类型-容器内所有HttpMessageConverter实现类支持的内容类型的累加，下面就是服务器做的内容协商的过程，双层循环遍历两个MediaType列表，相当于对两端各自的内容类型作笛卡尔积再比对，见于isCompatibleWith方法，匹配则加入一个MediaType列表，然后经过一顿筛选得到最精确的内容类型-selectedMediaType对象，后面遍历HttpMessageConverter列表类型的messageConverters属性，看谁能处理这个内容类型外加返回值类型，依据是GenericHttpMessageConverter接口中定义的canWrite方法，它判断当前实现类是否能将传入的Class实例（返回值类型）转为传入的Media对象（内容类型），像本例中是AbstractJackson2HttpMessageConverter元素符合条件，后面用这个实现类对象调用write方法，将返回值对象转为JSON字符串，再写出到响应体中，只要有一个符合就返回。

具体看getAcceptableMediaTypes方法如何拿到浏览器可接受的内容类型。体内出现一个ContentNegotiationManager类型的属性，叫内容协商管理器，它调用resolveMediaTypes方法，传入请求对象，遍历ContentNegotiationStrategy列表类型的strategies属性，调用元素的resolveMediaTypes方法，传入请求对象，得到MedieType列表，只要列表不是`[*/*]`（无法解析也得到`[*/*]`列表），就直接返回，否则继续考察下一个元素，那么所有元素解析出的都是`[*/*]`，才返回它，默认只有一个HeaderContentNegotiationStrategy类型的元素即基于请求头的内容协商策略。其resolveMediaTypes方法体内就调用请求对象的getHeaderValues方法，传入HttpHeaders的ACCEPT枚举。

关于getProducibleMediaTypes方法的具体逻辑自行梳理，也会依靠canWrite方法。

### 类型转换

自定义类型转换器也是靠实现WebMvcConfigurer接口，具体实现其addFormaters方法：

```java
@Bean
public WebMvcConfigurer getWebMvcConfigurer() {
    return new WebMvcConfigurer() {
        //其他省略
        @Override
        public void addFormatters(FormatterRegistry registry) {
            registry.addConverter(new Converter<String, Student>() {
                @Override
                public Student convert(String source) {
                    if (!StringUtils.isEmpty(source)) {
                        String[] splits = source.split(",");
                        Student student = new Student();
                        student.setName(splits[0]);
                        student.setAge(Integer.parseInt(splits[1]));
                    }
                    return null;
                }
            });
        }
    };
}
```

### HttpMessageConverter

针对客户端要求接收自创内容类型的场景，尝试自定义HTTP消息转换器并加入各处messageConverters属性。

springboot自动检索HttpMessageConverter实现类并创建对象，见于WebMvcAutoConfigurationAdapter覆盖的configureMessageConverters方法底层逻辑，详见HttpMessageConverters类的构造器、WebMvcConfigurationSupport类的getMessageConverters方法及静态代码块。

准备好自定义的实现类：

```java
/**
 * 自定义HTTP消息转换器，只做输出转换，将Student对象转为分号分隔的键值对组字符串，内容类型命名为application/x-semicolon
 */
public class SemicolonMessageConverter implements HttpMessageConverter<Student> {
    @Override
    public boolean canRead(Class<?> clazz, MediaType mediaType) {
        return false;
    }

    /**
     * 是否能将clazz（返回值类型）转为mediaType（内容类型）
     *
     * @param clazz
     * @param mediaType
     * @return
     */
    @Override
    public boolean canWrite(Class<?> clazz, MediaType mediaType) {
        //构造true的条件为返回值类型是Student且内容类型是application/x-semicolon
        return mediaType == null || clazz.isAssignableFrom(Student.class) && mediaType.equals(MediaType.parseMediaType("application/x-semicolon"));
    }

    @Override
    public List<MediaType> getSupportedMediaTypes() {
        return MediaType.parseMediaTypes("application/x-semicolon");
    }

    @Override
    public Student read(Class<? extends Student> clazz, HttpInputMessage inputMessage) throws IOException, HttpMessageNotReadableException {
        return null;
    }

    @Override
    public void write(Student student, MediaType contentType, HttpOutputMessage outputMessage) throws IOException, HttpMessageNotWritableException {
        //这就是java对象转响应体的底层操作，就弄个简单的，仅面向Student
        String data = student.getName() + ";" + student.getAge();
        outputMessage.getHeaders().setContentType(MediaType.parseMediaType(contentType.getType() + "/" + contentType.getSubtype() + ";charset=utf-8"));
        OutputStream body = outputMessage.getBody();
        body.write(data.getBytes());
    }
}
```

然后在注册的WebMvcConfigurer实现类组件中覆盖extendMessageConverters方法：

```java
@Override
public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
    //指定在messageConverters列表里的位置
    converters.add(0, new SemicolonMessageConverter());
}
```

用postman测试。

### 内容协商

尝试内容协商的应用实例：针对不同客户端不同的Accept请求信息，使用不同的HttpMessageConverter实现类，将Java对象转换为不同类型响应体。

自己不用写任何额外代码，底层已经实现了，只需用postman更改Accept信息来测试。

基于请求头且使用浏览器的话，请求头Accept项只能通过异步请求修改。同步请求改不了，但可以在请求参数上做文章，带上一个format参数，例如：

```
localhost:8080/student?format=xml
localhost:8080/student?format=json
```

前提是要有这个配置：

```properties
spring.mvc.contentnegotiation.favor-parameter=true
```

有了此配置，源码里提到的strategies属性就多了一个ParameterContentNegotiationStrategy类型的元素，我们发现它有一个parameterName属性，默认值就是format，此元素排在默认元素之前，调用的resolveMediaTypes方法定义于父类AbstractMappingContentNegotiationStrategy中，方法体内又调用本类的getMediaTypeKey。后者返回的就是format参数值。

这个ParameterContentNegotiationStrategy仅支持format取xml与json，想支持别的，只好去注册的WebMvcConfigurer实现类组件中覆盖configureContentNegotiation方法，定制ParameterContentNegotiationStrategy对象：

```java
@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
    Map<String, MediaType> mediaTypes = new HashMap<>();
    mediaTypes.put("json", MediaType.APPLICATION_JSON);
    mediaTypes.put("xml", MediaType.APPLICATION_XML);
    mediaTypes.put("x-semicolon", MediaType.parseMediaType("application/x-semicolon"));
    ParameterContentNegotiationStrategy parameterContentNegotiationStrategy = new ParameterContentNegotiationStrategy(mediaTypes);
    //别忘了把HeaderContentNegotiationStrategy对象也加进来，因为这个strategies方法会是覆盖各处strategies属性，不加的话假定发不带form参数而改Accept的请求，那么ParameterContentNegotiationStrategy对象就无法解析，得到*/*
    HeaderContentNegotiationStrategy headerContentNegotiationStrategy = new HeaderContentNegotiationStrategy();
    configurer.strategies(Arrays.asList(parameterContentNegotiationStrategy, headerContentNegotiationStrategy));
}

```

### Thymeleaf

这个模板引擎性能不佳，适合小型应用，不适合高并发项目，高并发得靠其他模板引擎或前后端分离。

有了这玩意儿前后端不分离，主要是后端学的。springboot默认无法支持JSP，虽然默认注册了InternalResourceViewResolver，但底层依赖的JspServlet相关包并没导入。

语法类似JSP，自行查找文档。

不过需要导入相关依赖-thymeleaf场景启动器：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

自动配置集中于这几个类：

- 自动配置类ThymeleafAutoConfiguration。

- ThymeleafProperties类，这个类一看名字知道绑定了配置文件，对应前缀是`spring.thymeleaf`，关注prefix与suffix属性，默认值分别是`classpath:/templates/`与`.html`。
- 另见于SpringTemplateEngine类。

- 视图解析器ThymeleafViewResolver，由ThymeleafAutoConfiguration的一个内部类的方法defaultTemplateResolver注册。

### 视图解析

主要知识在springmvc笔记里已经讨论过，这里补充一些基于引入了返回值解析器的新源码的试图解析原理。

已知处理方法返回的是字符串且不带@ResponseBody。进入HandlerMethodReturnValueHandlerComposite类的handleReturnValue方法，看selectHandler方法返回HandlerMethodReturnValueHandler的哪个实现类的对象（像RequestResponseBodyMethodProcessor就专门处理带@ResponseBody的目标方法的返回值），发现结果是ViewNameMethodReturnValueHandler，从其覆盖的supportsReturnValue方法可看出它支持的返回值类型是void及字符序列，再关注其覆盖的handleReturnValue方法。体内调用ModelAndViewContainer对象的setViewName方法将返回值设为视图名。

看RequestMappingHandlerAdapter的invokeHandlerMethod方法体末尾，调用getModelAndView方法，传入ModelAndViewContainer对象、ModelFactory对象、ServletWebRequest对象，得到ModelAndView对象，里面就封装了视图名与隐含模型里的数据，然后往上层层返回，最终作handle的返回值。

doDispatch方法体内调用到applyDefaultViewName方法，传入请求对象与ModelAndView对象。体内判断后者view属性是否为null，意即处理方法的返回值是否为void，是则设置默认视图名-当前请求的地址即回到原处理方法，成死循环了。

我们发现spring 4九大组件之一的viewResolvers属性默认仅含一个InternalResourceViewResolver类型的元素，

而spring 5目前而言有5个，依次是：

```
ContentNegotiatingViewResolver
BeanNameViewResolver 以视图名作键，去容器中找bean
ThymeleafViewResolver
ViewResolverComposite
InternalResourceViewResolver
```

于是我们略微看看第一个类覆盖的resolveViewName方法，这个类也有个viewResolvers属性，由其他四个元素组成，这个方法底层就是遍历其他四个元素，根据内容协商策略找出最合适的，怎么找跟前面找最合适的HttpMessageConventer实现类思路一样，重点关注View接口中定义的getContentType方法。

### 拦截器

摒弃了XML方式，来看注册WebMvcConfigurer、实现其addInterceptors方法使得自定义的拦截器生效：

```java
@Configuration
public class WebMvcConfig {
    @Bean
    public WebMvcConfigurer getWebMvcConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addInterceptors(InterceptorRegistry registry) {
                registry.addInterceptor(new LoginInterceptor()).addPathPatterns("/**").excludePathPatterns("/login", "/css/**", "/fonts/**", "/js/**", "/images/**");
            }
        };
    }
}
```

```java
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") != null) {
            return true;
        } else {
            request.setAttribute("msg", "请先登录");
            request.getRequestDispatcher("/login").forward(request, response);
            return false;
        }
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
    }
}
```

### 文件上传

直接上例子，跟springmvc笔记的差不多，新接触RequestPart注解。

```java
@PostMapping("/upload")
public String fileupload(@RequestParam("email") String email, @RequestParam("username") String username, @RequestPart("avatar") MultipartFile avatar, MultipartFile[] photos) throws IOException {
    // 单文件容量，多文件个数
    log.debug("email={}, username={}, avatar={}, photos={}", email, username, avatar.getSize(), photos.length);
    String uploadPath = "D:\\fileupload\\";
    File uploadDir = new File("D:\\fileupload");
    if (!uploadDir.exists()) {
        boolean made = uploadDir.mkdir();
    }
    if (!avatar.isEmpty()) {
        avatar.transferTo(new File(uploadPath + UUID.randomUUID().toString() + "_" + avatar.getOriginalFilename()));
    }
    if (photos.length > 0) {
        for (MultipartFile photo : photos) {
            if (!photo.isEmpty()) {
                photo.transferTo(new File(uploadPath + UUID.randomUUID().toString() + "_" + avatar.getOriginalFilename()));
            }
        }
    }
    return "redirect:/";
}
```

然后看相关的自动配置，有MultipartAutoConfiguration，附带地有MultipartProperties，点开后者发现所有配置项均以`spring.servlet.multipart`开头，另见maxFileSize、maxRequestSize等属性比如针对它们进行配置：

```properties
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=100MB
```

再就是了解处理方法的MultipartFile类型实参是怎么由底层得到的。关注MultipartAutoConfiguration的注册方法multipartConfigElement及multipartResolver，两个都标有@ConditionalOnMissingBean。接着还是看doDispatch方法体，调用到checkMultipart方法，传入请求对象，将其包装成一个新的请求对象。此方法体内，用九大组件之一的multipartResolver属性调用isMultipart方法，传入请求对象，判断请求头内容类型是否以`multipart/`开头，随后multipartResolver属性调用resolveMultipart方法，传入请求对象。体内将请求对象传入StandardMultipartHttpServletRequest构造器，返回包装得到的新的请求对象。往后进入[前面](#argumentResolvers)接触过的getArgumentResolver方法，看用到哪种参数解析器，即argumentResolvers列表属性中哪种类型的元素，结果是RequestPartMethodArgumentResolver类型，找到其覆盖的resolveArgument方法，主要逻辑是形成以文件表单域的name值作键、以流数据（MultipartFile接口是InputStreamSource的子接口）作值的映射，随后依据@RequestPart值或参数名从映射取值并赋给参数，这个流数据是从HttpInputMessage对象中得来的，转换自然是由HttpMessageConverter对象完成，见于readWithMessageConverters方法。

### 异常处理

参考[Error Handling](https://docs.spring.io/spring-boot/docs/2.3.12.RELEASE/reference/html/spring-boot-features.html#boot-features-error-handling)。探究原理。

首先看自动配置。关注ErrorMvcAutoConfiguration配置类，它依赖了绑定配置文件的ServerProperties、ResourceProperties、WebMvcProperties这几个类。

注册了BasicErrorController组件，依赖ErrorProperties类，其模板路径值是`server.error.path`配置项的值，默认是`/error`，往下看到errorHtml与error方法，分别浏览器与非浏览器客户端返回ModelAndView对象与ResponseEntity对象。在errorHtml方法体内，调用resolveErrorView方法，传入请求对象、响应对象、错误状态码、其他错误信息映射。体内遍历ErrorViewResolver列表属性，运行时仅有[后面](#unique)的DefaultErrorViewResolverConfiguration类型（其实也是唯一的实现类）元素，它调用resolveErrorView方法，传入响应对象以外的三个对象并往上层层返回。

同为配置类的内部类WhitelabelErrorViewConfiguration注册了View组件，@Bean的name值为`error`，又注册了BeanNameViewResolver组件，点开其实现的resolveViewName方法可知会按照视图名从容器中检索View对象，这就跟前面相呼应了-根据视图名`error`检索底层映射中键为`error`的View对象，这个视图对象隶属StaticView类，其实现的render方法体内就有默认错误页面内容的拼接。

同为配置类的内部类<span id="unique">DefaultErrorViewResolverConfiguration</span>注册了DefaultErrorViewResolver组件，关注SERIES_VIEWS属性-与错误状态码相关的映射，接着看实现的resolveErrorView方法，它又调用resolve方法，传入状态码字符串及错误信息映射，得到封装视图名为`error/错误状态码`的ModelAndView对象，还封装了错误信息。

关注到注册的DefaultErrorAttributes组件，关注getErrorAttributes方法，返回封装提示信息的映射。

其次看异常处理的流程。比如处理方法抛异常，那么在doDispatch方法体内由catch语句捕获，将异常对象赋给dispatchException变量，随后调用processDispatchResult方法。体内调用processHandlerException方法，传入请求对象、响应对象、目标处理器对象、异常对象。此方法体内，for循环遍历九大组件之一的handlerExceptionResolvers属性，其下默认有如下类型元素：

```
DefaultErrorAttributes
HandlerExceptionResolverComposite 它下面又包含一个resolvers属性，也是存放HandlerExceptionResolver实现类元素
	resolvers 这三个就和springmvc笔记里的概述对上了
		ExceptionHandlerExceptionResolver
		ResponseStatusExceptionResolver
		DefaultHandlerExceptionResolver
```

逐元素调用resolveException方法，继续传入四个对象，返回ModelAndView对象，只要不为null就退出循环，DefaultErrorAttributes元素的实现逻辑是将异常信息保存到请求域对象中，返回null，HandlerExceptionResolverComposite元素实现的逻辑是遍历其resolvers属性，同样逐元素调用resolveException方法，联系springmvc笔记，这三种类型的实现逻辑均概括于概述一节。这些元素调用此方法都返回null的话，就继续往上抛，由doDispatch方法体内更外层的catch语句捕获，结果看不出特别的处理，那么遵循servlet的规范，会由tomcat内部转发到`/error`，携带错误状态码等数据，后续过程就落到本章开头了。

```java
@ControllerAdvice
public class CommonExceptionHandler {
    @ExceptionHandler({ArithmeticException.class})
    public ModelAndView handlerArithmetic() {
        ModelAndView mv = new ModelAndView();
        mv.addObject("message", "服务器出了点小问题");
        mv.setViewName("error/500");
        return mv;
    }
}
```

```java
@ResponseStatus(reason = "您已登录，不可重复登录", value = HttpStatus.FORBIDDEN) //403
public class RepeatLoginException extends Exception {
    private static final long serialVersionUID = 4290318133037466013L;
}
```

略述这些元素调用resolveException方法的底层：ExceptionHandlerExceptionResolver寻找打了@ExceptionHandler的处理方法；ResponseStatusExceptionResolver看似处理，其实仍是令tomcat内部转发到`/error`，携带@ResponseStatus的value、reason值等数据；DefaultHandlerExceptionResolver也是令tomcat内部转发到`/error`，携带各种内置异常类型对应的错误状态码等数据，体现于底层响应对象调用的sendError方法。

### 原生组件

参考[Embedded Servlet Container Support](https://docs.spring.io/spring-boot/docs/2.3.12.RELEASE/reference/html/spring-boot-features.html#boot-features-embedded-container)，原生组件即web三大接口组件-servlet、监听器、过滤器，有时在使用springmvc（springboot）同时仍想用这些组件，得先在主程序类添加ServletComponentScan注解：

```java
@ServletComponentScan(basePackages = "com.van")
```

然后指定包下的这些组件应标有相应注解，等价于以前web.xml里的配置，有@WebServlet、@WebListener、@WebFilter。

也可以在配置类中注册RegistrationBean，替代这三个注解：

```java
@Configuration
public class NativeComponentConfig {
    @Bean
    public ServletRegistrationBean<MyServlet> myServlet() {
        //这一个方法只能注册一个servlet，后续同理
        return new ServletRegistrationBean<>(new MyServlet(), "/my");
    }

    @Bean
    public FilterRegistrationBean<MyFilter> myFilter() {
        FilterRegistrationBean<MyFilter> filterRegistrationBean = new FilterRegistrationBean<>();
        filterRegistrationBean.setFilter(new MyFilter());
        filterRegistrationBean.setUrlPatterns(Arrays.asList("/my", "/css/*"));
        return filterRegistrationBean;
    }

    @Bean
    public ServletListenerRegistrationBean<MyServletContextListener> myServletContextListener() {
        return new ServletListenerRegistrationBean<>(new MyServletContextListener());
    }
}
```

比如发送`/my`请求，发现只有这原生的servlet和filter拦截了，springmvc的DispatcherServle无动于衷，来探究一下原理。

先看DispatcherServlet是怎么注册的，对照以前的XML配置。来到DispatcherServletAutoConfiguration类，注意到注册方法dispatcherServlet，依赖WebMvcProperties类，下面是同为配置类的DispatcherServletRegistrationConfiguration类，其下有注册DispatcherServletRegistration的方法，这个类继承了ServletRegistrationBean，故刚才那个注册方法是将DispatcherServlet纳入IOC容器，这个方法是将其纳入服务器环境，并且在后者体内发现创建DispatcherServletRegistrationBean对象时构造器传入的路径模板是`webMvcProperties.getServlet().getPath()`，点开发现默认值是`/`，所以遵循精确优先原则，发送`/my`请求时，MyServlet对象优先处理，过滤器也有用，而DispatcherServle的doDispatch方法引发的拦截器等功能当然全都失效。

### 嵌入式容器

#### 概述

参考[The ServletWebServerApplicationContext](https://docs.spring.io/spring-boot/docs/2.3.12.RELEASE/reference/html/spring-boot-features.html#boot-features-embedded-container-application-context)，springboot项目可内置tomcat、jetty等服务器，涉及的源码在于ServletWebServerApplicationContext类，关注其下createWebServer方法。体内调用getWebServerFactory方法，即从容器中按ServletWebServerFactory类型找bean并返回，即使有多个也仅返回一个，后面用得到的bean调用getWebServer方法，返回值赋给WebServer接口类型的属性，譬如引用实现类TomcatWebServer的对象，看它的构造器调用了initialize方法，后者又调用Tomcat属性的start方法，即启动服务器。

那么ServletWebServerFactory的注册要去看ServletWebServerFactoryAutoConfiguration类，其头上的@Import注册了ServletWebServerFactoryConfiguration类的若干内部类，与具体服务软件相关，如EmbeddedTomcat，其下便有TomcatServletWebServerFactory的注册方法，另发现它标有@ConditionalOnClass，依赖Tomcat类等，说明这些服务器是动态嵌入的，导谁的包就嵌入谁，如果导了多个最终也只用一个，它实现的getWebServer方法体展示了tomcat服务器启动的准备工作。

#### 切换

默认内置的是tomcat服务器，点开spring-boot-starter-web的POM，发现了spring-boot-starter-tomcat。比如想切换到undertow服务器，操作如下：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <!--依赖排除-->
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<!--undertow-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-undertow</artifactId>
</dependency>
```

#### 定制

关于服务器的相关配置，我们看ServletWebServerFactoryAutoConfiguration依赖了ServerProperties类，映射配置项起始于`server`，纵览其属性。

其他方式请参考[Customizing Embedded Servlet Containers](https://docs.spring.io/spring-boot/docs/2.3.7.RELEASE/reference/html/spring-boot-features.html#boot-features-customizing-embedded-containers)。

由此归纳修改或扩充springboot默认行为的若干种方式：

- 修改配置文件。

- 自定义配置类：@Configuration+@Bean。
- 只针对web场景，实现WebConfigurer接口并注册。

- 实现xxxCustomizer接口。

## 数据访问

### 概述

数据访问层相关的场景依赖以`spring-boot-starter-data-`开头，最基本的就是spring-boot-starter-data-jdbc了。导入后发现级联导入了spring关于jdbc、事务等的相关依赖以及Hikari（一种数据源）依赖。另外自己别忘了导数据库驱动。

导了依赖之后就多了数据源、事务相关的自动配置。有DataSourceAutoConfiguration类、DataSourceTransactionManagerAutoConfiguration类、JdbcTemplateAutoConfiguration类、XADataSourceAutoConfiguration类等。DataSourceAutoConfiguration依赖DataSourceProperties类，映射的配置项以`spring.datasource`开头。

既然有数据库连接池，免不了那连接相关的配置：

```properties
spring.datasource.url=jdbc.mysql://localhost:3306/boot_admin
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=root
#spring.datasource.type=com.zaxxer.hikari.HikariDataSource
```

默认只导了Hikari，留心Hikari类的dataSource方法，且注意类头上有@ConditionalOnMissingBean。

### Druid

引入第三方技术，无非两种方式：

- 编写配置类+注册配置相关的组件。
- 找现成的场景启动器，再修改配置项。

这是github上的[官方文档](https://github.com/alibaba/druid/wiki/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)。

第一种方式：

```java
@Configuration
public class DataSourceConfig {
    @Bean
    @ConfigurationProperties("spring.datasource")
    public DataSource druid() throws SQLException {
        DruidDataSource druidDataSource = new DruidDataSource();
        //现学现用@ConfigurationProperties
        //druid.setUrl("com.mysql.cj.jdbc.Driver"); druid.setMaxActive(10);...
        //统计监控信息，开启防火墙 同样可等价去配置文件里配
        druidDataSource.setFilters("stat,wall");
        return druidDataSource;
    }

    /**
     * 监控页
     *
     * @return
     */
    @Bean
    public ServletRegistrationBean<StatViewServlet> statViewServlet() {
        ServletRegistrationBean<StatViewServlet> registrationBean = new ServletRegistrationBean<>(new StatViewServlet(), "/druid/*");
        //登录后才能访问监控页，且产生的用户对象会存到session中
        registrationBean.addInitParameter("loginUsername", "admin");
        registrationBean.addInitParameter("loginPassword", "admin");
        return registrationBean;
    }

    /**
     * web关联监控-应用于连接池的交互情况
     *
     * @return
     */
    @Bean
    public FilterRegistrationBean<WebStatFilter> webStatFilter() {
        FilterRegistrationBean<WebStatFilter> filterFilterRegistrationBean = new FilterRegistrationBean<>(new WebStatFilter());
        filterFilterRegistrationBean.setUrlPatterns(Collections.singletonList("/*"));
        filterFilterRegistrationBean.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
        return filterFilterRegistrationBean;
    }
}

```

可以访问`/druid`，查看druid监控到的的数据库连接池使用情况。这第一种虽不常用，但毕竟活学活用了前导知识，领会原生配置向springboot配置演化的套路。

第二种方式：打开官方文档，就看到有[druid-spring-boot-starter](https://github.com/alibaba/druid/tree/master/druid-spring-boot-starter)，文档详细介绍了如何配置。

然后看看自动配置。druid-spring-boot-starter已经依赖了druid。DruidDataSourceAutoConfigure类标有	`@AutoConfigureBefore({DataSourceAutoConfiguration.class})`，意即在DataSourceAutoConfiguration之前配置，如此触发后者头上的@ConditionalOnMissingBean，使后者不被注册，再就是依赖了DruidStatProperties类，对应配置项以`spring.datasource.druid`开头，然后是头上的@Import注册了DruidSpringAopConfiguration类、DruidStatViewServletConfiguration类、DruidWebStatFilterConfiguration类、DruidFilterConfiguration类，它们的逻辑跟上一种方式我们自己写的基本一致，只是更详尽。

参考这些类的信息或[文档](https://github.com/alibaba/druid/tree/master/druid-spring-boot-starter)，修改配置文件。

### Mybatis

整合mybatis，参考github上mybatis提供的[spring-boot-starter](https://github.com/mybatis/spring-boot-starter)。

首先自然导入场景启动器mybatis-spring-boot-starter，有了它就看SqlSessionFactory、SqlSession、Mapper对象如何自动生成的。来到MybatisAutoConfiguration类，依赖了MybatisProperties类，它映射的是以`mybatis`开头的配置项，另见涉及SqlSessionFactory、SqlSessionFactoryBean、DataSource等组件的几个条件注解，往下翻就能看到SqlSessionFactory的注册方法，再往下有SqlSessionTemplate类的注册方法，内含SqlSession属性，在后面用@Import注册了内部类AutoConfiguredMapperScannerRegistrar，其下registerBeanDefinitions方法负责@Mapper的扫描，此注解依赖BeanFactory属性负责dao层接口的自动注入，等价于SSM配置里的mybatis-spring标签。

就相关配置给个例子：

```properties
# 全局配置文件与映射文件的位置
mybatis.config-location=classpath:mybatis/mybatis-config.xml
mybatis.mapper-locations=classpath:mybatis/mappers/*.xml
# 全局配置文件的所有东西都能在这里配，那么最好上2行都注掉
mybatis.configuration.map-underscore-to-camel-case: true
```

标给主程序类的MpperScan注解可替代多个@Mapper：

```java
@MapperScan("com.van.dao")
```

### Mybatis Plus

[Mybatis Plus](https://baomidou.com/)是mybatis的增强工具，目的是简化开发、提高效率。IDEA建议安装MybatisX插件。

提前导入mybatis-plus-boot-starter，那么之前的mybatis场景启动器不需要了。

点开相关的自动配置MybatisPlusAutoConfiguration类，它依赖MybatisPlusProperties类，后者绑定`mybatis-plus`开头的配置项，其mapperLocations属性是有默认值的，同理往下看到SqlSessionFactory的注册方法，参数是从容器获取中的DataSource对象，再往下看到SqlSessionTemplate的注册方法，以及注册AutoConfiguredMapperScannerRegistrar的@Import。

来领略Mybatis Plus的简化特性。例如让dao层接口继承提供的BaseMapper接口，以取代映射文件，除非有极复杂的SQL语句：

```java
public interface UserMapper extends BaseMapper<User> {}
```

又如，SQL语句是底层帮我们生成的，实体类名与表名相映射，属性名与字段名相映射，那么可能有映射不了的情况，可靠如下注解排除：

```java
//其他省略
//解决表驼峰名，默认映射首字母小写类名
@TableName("user")
public class User {
    @TableField(exist = false) //不映射了
    private String username;
    @TableField(exist = false)
    private String password;
    private Integer id;
    private String name;
    private Integer age;
    private String email;
}
```

再如，既然dao层接口方法都能简化，那么service层接口及其实现类的方法也可简化：

```java
//点开ServiceImpl及IService查看提供的增删改查方法
public interface UserService extends IService<User> {}
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {}
```

其他功能如分页插件请结合项目自行了解。

### Redis

redis是典型的NoSQL，[官网](https://redis.io/docs/)对它进行了详细介绍。

有redis场景启动器spring-boot-starter-data-redis与spring-boot-starter-data-redis-reactive（针对响应式编程）。

点开RedisAutoConfiguration类，发现其依赖映射起始于`spring.redis`配置项的RedisProperties类，@Import注册了LettuceConnectionConfiguration与JedisConnectionConfiguration组件，注意到它们体内的一些方法-lettuceClientResources、redisConnectionFactory等，Lettuce、Jedis均是客户端，再看RedisTemplate与StringRedisTemplate的注册方法。

## 单元测试

### 概述

2.2.0开始以JUnit 5为默认测试库，JUnit 5 = JUnit Platform（JVM上的测试框架基础，对接多种测试引擎） + JUnit Jupiter（核心测试引擎） + JUnit Vintage（兼容旧版）。

2.4以上版本默认移除对Vintage的依赖，若使用旧版则需手动导入[依赖](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.4-Release-Notes)，其他说明参见[Migrating from JUnit 4](https://junit.org/junit5/docs/current/user-guide/#migrating-from-junit4)。

### 注解

常用注解参见[Annotations](https://junit.org/junit5/docs/current/user-guide/#writing-tests-annotations)，也可用spring提供的注解，如@Autowired、@Transactional-测试方法执行完自动回滚。看一些例子：

```java
@SpringBootTest //无此注解便无（属性、参数的）自动注入等功能，依赖等价于@RunWith的@ExtendWith
public class JUnit5Test {
    @BeforeEach
    void testBeforeEach() {
        System.out.println("每一个测试方法开始执行前执行");
    }

    @AfterEach
    void testAfterEach() {
        System.out.println("每一个测试方法执行完后执行");
    }

    @BeforeAll
    static void testBeforeAll() {
        //所有测试方法执行在点击类名时触发
        System.out.println("所有测试方法开始执行前执行");
    }

    @AfterAll
    static void testAfterAll() {
        System.out.println("所有测试方法执行完后执行");
    }

    @Test //位于org.junit.jupiter.api包，jupiter词眼JUnit 5独一份
    @DisplayName("测试displayName注解") //当前测试的易读性描述
    void testDisplayName() {
        System.out.println("test @DisplayName");
    }

    @Test
    @Disabled
    void testDisabled() {
        System.out.println("触发所有方法执行时，此方法不执行");
    }

    @Test
    @Timeout(value = 500, unit = TimeUnit.MILLISECONDS)
    void testTimeout() {
        System.out.println("一旦超过限定时长，方法执行立即终止并抛异常");
    }

    @Test
    @RepeatedTest(3)
    void testRepeatedTest() {
        System.out.println("测试方法重复执行若干次");
    }
}
```

### 断言

参考Assertions类下的一些静态方法。断言的强大之处在于执行所有测试方法后生成一个翔实的报告。

```java
@Test
@DisplayName("测试简单断言")
void testSimpleAssertion() {
    Assertions.assertEquals(2, 1 + 1, "两值不相等");
    //前面的断言结果为失败则后续断言不执行
    Assertions.assertSame(new Object(), new Object(), "两对象不是同一个对象");
}

@Test
@DisplayName("测试数组断言")
void testArrayAssertion() {
    Assertions.assertArrayEquals(new int[]{1, 2}, new int[]{1, 2}, "两数组内容不一致");
}

@Test
@DisplayName("测试组合断言")
void testAllAssertion() {
    //所有相关断言结果为成功，此断言结果才是成功
    Assertions.assertAll("assertAll", () -> Assertions.assertTrue(true && true), () -> Assertions.assertEquals(2, 2));
}

@Test
@DisplayName("测试异常断言")
void testTrowsAssertion() {
    Assertions.assertThrows(ArithmeticException.class, () -> System.out.println(10 / 0), "逻辑并无异常");
}

@Test
@DisplayName("快速失败")
void testFail() {
    Assertions.fail("快速失败");
}
```

项目上线之前，来到Maven选项卡中Lifecycle一栏下的test选项，点击Run Maven Build按钮，即运行所有测试类，控制台就会产生结果报告。

### 前置条件

例如：

```java
@Test
@DisplayName("测试前置条件")
void testAssumptions() {
    //只有前置条件通过了才向后执行，但测试结果并不是失败
    Assumptions.assumeTrue(2 == 1, "结果非true");
    System.out.println("顺利继续");
}
```

带前置条件或@Disabled的测试方法的结果不可能是失败，要么成功要么跳过。

### 嵌套

嵌套测试落实为类的嵌套，即存在内部类，进而存在@BeforeEach等所标方法的内外层关系。[Nested Tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-nested)给了说明与例子。

规律有：外层测试方法的执行不触发内层@BeforeEach等生效，但内层测试方法的执行触发外层@BeforeEach等生效。

### 参数化

请参考[Parameterized Tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests)。

## 指标监控

### 概述

针对生产环境中部署的诸多微服务，有必要进行监控、审计等，由此springboot抽取了Actuator场景即spring-boot-starter-actuator。

参考[Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/2.3.12.RELEASE/reference/html/production-ready-features.html#production-ready)。启动项目后，通过访问下列地址查看当前项目（微服务）的监控情况：

```shell
# 不完整
localhost:8080/actuator/health
localhost:8080/actuator/info
localhost:8080/actuator/loggers
localhost:8080/actuator/beans
```

### Endpints

最后一项称作endpoint，参考前述文档的Endpoints一节，注意到其中的两种暴露模式-JMS（可视化监控工具Jconsole展示）与Web（浏览器展示），默认前者暴露所有端点，而后者仅暴露health与info，提倡以Web模式暴露所有端点。

```yaml
management:
  #所有端点的统一配置
  endpoints:
    web:
      exposure:
        include: "*"
  #具体端点的配置
  endpoint:
    health:
      #各组件详细的健康信息
      show-details: always
```

最常用的端点有：

- health：健康状况。
- metrics：运行时指标，如内存的占用情况。
- loggers：日志。

metrics提供分层的指标信息，这些信息可对接专业的监控平台如Prometheus，然后做拉取或推送。

查看指标信息一般有二次请求，第一次即形如`localhost:8080/boot-admin/actuator/metrics`，第二次针对罗列出的子项，形如`localhost:8080/boot-admin/actuator/metrics/jvm.gc.pause`。

有选择地开关端点：

```yaml
management:
  endpoints:
    #关闭所有端点
    enabled-by-default: false
    web:
      exposure:
        include: "*"
  #开启某些端点
  endpoint:
    health:
      show-details: always
      enabled: true
    info:
      enabled: true
    beans:
      enabled: true
    metrics:
      enabled: true
```

可定制health端点，前提是实现HealthIndicator接口。例如：

```java
@Component
public class MyHealthIndicator extends AbstractHealthIndicator {
    /**
     * 健康检查的逻辑
     *
     * @param builder
     * @throws Exception
     */
    @Override
    protected void doHealthCheck(Health.Builder builder) throws Exception {
        //监控信息，比如mongodb
        Map<String, Object> map = new HashMap<>();
        //随意判断
        if (1 == 1) {
            builder.status(Status.UP);
            map.put("count", 1);
            map.put("ms", 500);
        } else {
            builder.status(Status.DOWN);
            map.put("err", "连接超时");
            map.put("ms", 3000);
        }
        builder.withDetail("code", 100).withDetails(map);
    }
}
```

于是访问health端点，页面展示出的components对象就多出个my属性。

可定制info端点，直接通过配置文件（可能需要额外照此[文档](https://blog.csdn.net/pyhkobe/article/details/98862353?spm=1001.2101.3001.6650.3&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-3-98862353-blog-80762056.pc_relevant_aa&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7Edefault-3-98862353-blog-80762056.pc_relevant_aa&utm_relevant_index=4)操作）：

```yaml
info:
  appName: boot-admin
  appVersion: 1.0.0
  mavenProjectName: @project.artifactId@
  mavenProjectVersion: @project.version@
```

或通过实现InfoContributor接口：

```java
@Component
public class MyInfoContributor implements InfoContributor {
    @Override
    public void contribute(Info.Builder builder) {
        //随便写点
        builder.withDetail("msg", "boot-admin for Van").withDetails(Collections.singletonMap("my", "customized info"));
    }
}
```

两方式共存时info展示结果将是合并的。

定制metrics，一般是扩充指标，现有的不外乎关于JVM、CPU、第三方库等。

```java
@Service
public class UserServiceImpl implements UserService {
    @Autowired
	private UserMapper userMapper;
    private Counter counter;
    
    /**
     * @Param meterRegistry 指标注册器
     */
    public UserServiceImpl(MeterRegistry meterRegistry) {
        //用Counter对象统计saveUser方法调用次数 userService.saveUser.count就会出现在metrics展示列表中
        counter = meterRegistry.counter("userService.saveUser.count");
    }
    
    public void saveUser(User user) {
        //累加
        counter.increment();
        userMapper.insert(user);
    }
}
```

最后是定制端点：

```java
@Component
//访问地址形如localhost:8080/boot-admin/actuator/van
@Endpoint(id = "van")
public class MyEndpoint {
    @ReadOperation
    public Map getDockerInfo() {
        return Collections.singletonMap("my docker info", "docker started");
    }

    @WriteOperation
    public void stopDocker() {
        System.out.println("docker stopped");
    }
}
```

### 可视化

这里我们介绍[spring-boot-admin](https://github.com/codecentric/spring-boot-admin)，用于同多个微服务进行监控信息的交互，然后可视化到浏览器。

它相当于另一个服务器，故首先另立一个项目，文档里给了相关要求，然后依照文档对被监控项目即监控可视化的客户端进行配置。

详细代码参考项目。

## 环境切换

即开发、生产、测试等环境的切换，参考[Profiles](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.profiles)。

一种做法是借助配置文件的切换。首先它们的名字有讲究，如application-prod、application-test、application，然后在application文件里指定环境：

```properties
#值就得跟application-后的某个后缀
spring.profiles.active=prod
```

原理是默认配置文件永远加载，再根据其中的环境配置连带加载另一个配置文件，即两文件里的配置项都生效，同名的话后者优先。

若项目已经打包，则可通过命令行更改环境：

```shell
#其他配置项也都可在此更改
java -jar boot-admin-0.0.1-SNAPSHOT.jar --spring.profiles.active=test --person.name=testing
```

控制台会显示当前环境。

另一种做法是@Profile配合@Bean、@Component等注册注解，其所含标识与激活标识相匹配，由此决定哪些组件被注册。环境标识的激活同上。

可以融合多个环境下的配置：

```properties
spring.profiles.group.prodgroup[0]=prod1
spring.profiles.group.prodgroup[1]=prod2
spring.profiles.group.testgroup[0]=test
```

## 外部化配置

参考[Externalized Configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config)。

yaml文件、properties文件、环境变量、命令行参数等可作外部配置源，像`$`符就从它们中检索目标属性。文档里按优先级顺序罗列了十几条，后面的同名配置系项会覆盖前面的。

文档第三节按优先级顺序罗列了配置文件的查找路径，同样后面的同名配置项会覆盖前面的。由此不难想到一个提升效率的技巧，在项目依然打包后，在jar包同级目录等目录中创建配置文件，覆盖前置配置，而无需重新打包部署。

## 自定义starter

大体思路是创建不含源代码而仅含依赖信息的项目作starter，POM里必有spring-boot-starter依赖，后者又依赖spring-boot-autoconfigure。实现过程参考[视频](https://www.bilibili.com/video/BV1Et411Y7tQ?p=194&vd_source=768bca3ca74de2a4a4a3a209b7b1ec86)，此处列出一些关键代码：

```java
//向一般starter看齐，与配置文件相绑定的类不在类体内做注册
@ConfigurationProperties("van")
public class VanProperties {
    private String prefix;
    private String suffix;

    public String getPrefix() {
        return prefix;
    }

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }
}

public class VanService {
    @Autowired
    private VanProperties vanProperties;

    public void greet(String name) {
        System.out.println(vanProperties.getPrefix() + name + vanProperties.getSuffix());
    }
}

@Configuration
@EnableConfigurationProperties(VanProperties.class)
@ConditionalOnMissingBean(VanService.class)
public class VanServiceAutoConfigure {
    @Bean
    public VanService vanService(){
        return new VanService();
    }
}
```

```factories
# 后者的src/main/resources/META-INF/spring.factories
# Auto configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.van.config.VanServiceAutoConfigure
```

## 启动原理

### 概述

结合源码探究springboot项目的启动原理，尤关注回调机制，即ApplicationContextInitializer、ApplicationListener、SpringApplicationRunListener对象出现的地方。

入口是主程序类，点进静态方法run，体内调用重载的run方法。体内创建SpringApplication对象并返回其run方法的结果。

在SpringApplication的构造方法体内，主要看一些属性的赋值，底层涉及所有依赖下面spring.factories文件的加载，如要给initializers属性赋值就去此文件中找ApplicationContextInitializer的全限定类名、要给listeners属性赋值就去此文件中找ApplicationListener的全类名。

在run方法体内，传入的是命令行多参数args，底层遍历bootstrappers属性逐元素调用initialize方法、遍历listeners属性逐元素调用starting方法，联系观察者模式，这个starting方法相当于通知所有观察者项目正在启动，让它们各自进行相应操作，体现了回调机制，DefaultApplicationArguments方法保存命令行参数，prepareEnvironment方法读取所有配置源的属性值、绑定到对应类属性上，注意到底层遍历listeners属性逐元素调用enviornmentPrepared方法，通知观察者们环境准备完成，往下就是重要的IOC容器的创建过程。

点进createApplicationContext方法，根据项目类型（SERVLET还是REACTIVE）创建具体ApplicationContext对象。回到run方法体，prepareContext方法设定环境信息、注册一些组件、准备一些类型转换器等。此方法体内，applyInitializers方法遍历前面提到的initializer属性逐元素调用initialize方法扩展容器的功能，接着遍历前面提到的listeners属性逐元素调用contextPrepared方法，通知观察者们容器环境准备完毕，然后又遍历前面提到的listeners属性逐元素调用contextLoaded方法，通知观察者们容器相关配置加载完毕。

run方法体内往下就有了经典的refreshContext方法，传入容器对象，底层就调用了亲切的refresh方法，详细逻辑见于spring笔记，再往下遍历listeners属性逐元素调用started方法，通知观察者们容器创建完毕，接着看callRunners方法。体内获取ApplicationRunner与CommandLineRunner类型的对象添加进runners列表，然后对runners逐元素调用run方法。接着，若抛出异常则遍历listeners属性逐元素调用fail方法，否则调用running方法，最后返回容器对象。

官方文档的[Application Events and Listeners](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.spring-application.application-events-and-listeners)一节做了相关说明。

### 自定义监听器

上一节开头的三个接口及ApplicationRunner、CommandLineRunner接口均属于广义上的监听器或回调机制范畴，从上一节源码解读可看出它们定义的方法贯穿项目的启动过程，因此可自定义它们的实现类。

实现类的代码参见项目，别忘了头三个接口对象的产生基于spring.factories文件的加载，后两个的对象则由作组件而产生。

```factories
org.springframework.context.ApplicationContextInitializer=\
com.van.listener.MyApplicationContextInitializer
org.springframework.context.ApplicationListener=\
com.van.listener.MyApplicationListener
org.springframework.boot.SpringApplicationRunListener=\
com.van.listener.MySpringApplicationRunListener
```

