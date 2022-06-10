# Spring

参考视频：

- [Spring视频教程](https://www.bilibili.com/video/BV1ds411V7HZ)。
- [SSM联讲](https://www.bilibili.com/video/BV1d4411g7tv)。

## 概述

将所有web应用共有的东西如基础servlet、事务控制、日志记录、权限验证抽取成web框架，实现复用。框架就是多个可重用模块的集合，作为某领域的一站式解决方案，可理解为半成品软件。

Spring是分层（Spring SE/EE）的应用于全栈的轻量级开源框架。它以IOC和AOP为内核，提供了展示层的Spring MVC、业务层的事务管理、持久化层的Spring JDBC等众多企业级应用技术，还能够整合众多知名第三方开源框架和类库，逐渐成为使用最多的Java EE应用开源框架。

最早是2002年，一个大神叫Rod Johnson，发表了文章《Expert One-on-One J2EE Design and Development》，随后有人据此研发出Spring框架。最初Spring框架只有两大基石-面向切面编程与控制反转，后来越来越多的新东西被开发出来，诸如Spring data、Spring Boot、Spring Cloud、Spring Social。

框架=注解+反射+设计模式。

好处如下：

- 方便解耦、简化开发。

- 支持切面编程；支持声明式事务。

- 方便程序的测试。

- 方便集成各种优秀框架。

- 降低Java EE API的使用难度。

- 源码是经典学习范例。

这是它的模块分布图：

![spring运行时](https://docs.spring.io/spring-framework/docs/4.3.x/spring-framework-reference/html/images/spring-overview.png)

从下往上看：

- Test：单元测试。

  ```
  Test: spring-test
  ```

- Core Container：核心容器，即IOC，具体有四个jar包。

  ```
  Beans: spring-bean
  Core: spring-core
  Context: spring-context
  SpEL: spring-expressions
  ```

- 往往AOP+Ascpects：实现AOP；Instrumentation-设备整合与Messaging-消息服务都不用管。

  ```
  AOP: spring-aop
  Aspects: spring-aspects
  ```

- Data Access/集成：数据访问，具体有四个jar包，OXM-object xml mapping，JMS-消息服务不用管，这两个跟集成有关。

  ```
  JDBC: spring-jdbc
  ORM: spring-orm
  OXM: spring-oxm
  Transactions: spring-tx
  ```

- Web：开发Web应用，具体有四个jar包。

  ```
  WebSocket: spring-websocket
  Servlet: spring-web
  Web: spring-webmvc
  Portlet: spring-webmvc-portlet
  ```

## IOC

### 概述

IOC-inversion of control-控制反转：控制指的是资源获取的方式，正向方式就是传统的用new手动创建，对象一复杂，手动创建起来就蛮麻烦；反转之后一个容器帮我们创建资源包括初始化，这个容器统一管理所有组件-带某种功能的类。

DI-dependency injection-依赖注入：容器通过反射等为某组件对象的域赋值，尤指给自定义类型的域赋上依赖的组件对象，spring可检索出bean之间关联关系然后级联注入。

### 容器

通过一个实例了解IOC容器的相关特点。

因为使用Core Container模块，故应导入4个jar包，且还依赖一个日志包commons-logging。

容器配置文件应出现在编译后的classpath下，故对应地置于项目的源码包中。写法如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
	<!-- 注册一个组件对象，spring自动调用无参构造器创建此对象并根据下面的配置调用诸setter注入 -->
	<!-- bean：组件对象，id：对象的唯一标识，class：组件的全限定类名 -->
	<bean class="bean.Person" id="van">
		<!-- property：属性，name：属性名，value：属性值 -->
		<property name="name" value="van"></property>
		<property name="age" value="18"></property>
		<property name="gender" value="男"></property>
	</bean>
    <!-- 注入对应类型的默认值 -->
    <bean class="bean.Person" id="jenny"></bean>
</beans>
```

```java
// 其他省略
public class Person {
	private String name;
	private Integer age;
	private String gender;

	public void setName(String name) {
		this.name = name;
		// 注入时打印，打印两次
		System.out.println(name);
	}

	public Person() {
		super();
		// 容器启动时就打印
		System.out.println("我被IOC容器创建出来");
	}
}
```

通过id拿对象的测试：

```java
// 见名知义，由classpath下的某个xml文件生成IOC容器
ApplicationContext ioc = new ClassPathXmlApplicationContext("container.xml");
System.out.println("容器已创建");
// 传入对象的id值
Person van1 = (Person) ioc.getBean("van");
Person jenny = (Person) ioc.getBean("jenny");
// false
System.out.println(van1 == jenny);
Person van2 = (Person) ioc.getBean("van");
// true 两变量引用同一个对象
System.out.println(van1 == van2);
```

所有对象随着容器的创建而创建，而不是等到获取才创建。一个id值对应一个对象，不能重复。

容器通过拼接set和property标签的name值得到此域的setter名，从而调用匹配的setter，故本类须含此setter。

通过Class实例拿对象的测试：

```java
ApplicationContext ioc = new ClassPathXmlApplicationContext("container.xml");
// 抛异常，说明容器中存在多个此组件实例，不过减省了强转 存在唯一实例的话就不错
// Person person = ioc.getBean(Person.class);
// 这样就可以既有唯一性又避免强转
Person person = ioc.getBean("van", Person.class);
System.out.println(person);
```

### 注入

#### 概述

详细来看向容器中注册组件对象时的花式注入。

对于8大基本类型与String，基于value属性写实际值；对于对象类型，常基于ref属性写所依赖bean的id值。只有后者体现了DI中的依赖概念，即对象间的依赖关系。

有三种方式来实现属性的注入。

- 首先是上一节用过的setter方式。联系反射技术，它先要调用组件的无参构造器。

  ```java
  // 其他省略
  public class Teacher {
  	private String name;
  	private String gender;
  	private int age;
    
      // 自己写了有参的，Java就不提供无参的了
      public Teacher() {
      	super();
  	}
  }
  ```
  
  ```java
  // 其他省略
  public class Course {
  	private String name;
  	// 达到对象依赖（具体是关联）
  	private Teacher teacher;
  	private int credit;
  }
  ```
  
  ```xml
  <bean id="teacher" class="bean.Teacher">
      <property name="name" value="Mr.Zhang"></property>
      <property name="gender" value="male"></property>
      <property name="age" value="22"></property>
  </bean>
  <bean id="course" class="bean.Course">
      <property name="courseName" value="CS"></property>
      <!-- 针对引用类型的域，不用value，用ref（引用） -->
      <property name="teacher" ref="teacher"></property>
      <property name="credit" value="2"></property>
  </bean>
  ```
  
- 构造器方式。

  ```java
  // 底层调用这唯一的有参构造器进行注入
  public Teacher(String name, String gender, int age) {
      super();
      this.name = name;
      this.gender = gender;
      this.age = age;
  }
  ```
  
  ```xml
  <bean id="teacher" class="bean.Teacher">
      <!-- 默认从上至下按构造器参数顺序赋值，重载了就混乱了，于是可借助索引index、参数名name、参数类型type等属性精确匹配，建议用name，不会出错 -->
      <constructor-arg value="Mr.Zhang" index="0"></constructor-arg>
      <constructor-arg value="male" name="gender"></constructor-arg>
      <!-- value值的类型是字符串，根据type值自动转成Integer -->
      <constructor-arg value="22" type="int"></constructor-arg>
  </bean>
  ```
  
- p命名空间注入方式。要先引入命名空间，特定标签或属性依赖特定命名空间。

  ```xml
  <beans xmlns:p="http://www.springframework.org/schema/p"></beans>
  ```
  
  ```xml
  <bean id="course" class="bean.Course" p:name="CS" p:teacher-ref="teacher" p:credit="2"></bean>
  ```

```java
ApplicationContext ioc = new ClassPathXmlApplicationContext("set.xml");
Course course = (Course) ioc.getBean("course");
// 类的聚合关联，被依赖类声明周期可不与依赖类生命周期同步
Teacher teacher = ioc.getBean("teacher", Teacher.class);
// true
System.out.println(teacher == course.getTeacher());
```

使用ref属性反映了类的聚合，还可以用内部bean标签，反映了类的组合：

```xml
<bean id="course" class="bean.Course">
    <property name="name" value="OS"></property>
    <property name="teacher">
        <!-- 内部bean容器是感知不到的，这个id就是废的 这个bean和外部bean同生共死 -->
        <bean class="bean.Teacher" id="innerTeacher"></bean>
    </property>
    <property name="credit" value="3"></property>
</bean>
```

#### 集合

建一个类，5个实例域的类型分别是5大集合类。

```java
// 其他省略
public class CollectionInjection {
	private String[] numberArray;
	private List<String> nationList;
	private Set<String> fruitSet;
	private Map<String, String> sportMap;
	private Properties animalProps;
}
```

```xml
<bean id="collectionInjection" class="bean.CollectionInjection">
    <!-- Array的注入 -->
    <property name="numberArray">
        <array>
            <value>1</value>
            <value>2</value>
            <value>3</value>
        </array>
    </property>
    <!-- List的注入 -->
    <property name="nationList">
        <list>
            <value>China</value>
            <value>Russia</value>
            <value>France</value>
            <value>Britain</value>
            <value>America</value>
        </list>
    </property>
    <!-- Set的注入 -->
    <property name="fruitSet">
        <set>
            <value>apple</value>
            <value>banana</value>
            <value>pink</value>
        </set>
    </property>
    <!-- Map的注入 -->
    <property name="sportMap">
        <map>
            <!-- 键值对针对引用类型的值，要么在entry标签里用value-ref属性填id值，要么在标签体里写bean标签，要么在标签体里写ref标签，其bean属性填id值 -->
            <entry key="volleyball">
            	<value>排球</value>
            </entry>
            <!-- 可嵌套使用entry标签 -->
            <entry key="football" value="足球"></entry>
            <entry key="basketball" value="篮球"></entry>
        </map>
    </property>
    <!-- Properties的注入 -->
    <property name="animalProps">
        <props>
            <!-- 键与值类型均为String -->
            <prop key="cat">猫</prop>
            <prop key="dog">狗</prop>
            <prop key="bird">鸟</prop>
        </props>
    </property>
</bean>
```

我们想让list等标签独立出来，像外部bean那样被引用。

```xml
<!-- 依靠util命名空间 -->
<bean xmlns:util="http://www.springframework.org/schema/util"></bean>
```

```xml
<util:list id="outerList">
    <value>China</value>
    <value>Russia</value>
    <value>France</value>
    <value>Britain</value>
    <value>America</value>
</util:list>
<util:set id="outerSet">
    <value>apple</value>
    <value>banana</value>
    <value>pink</value>
</util:set>
<util:map id="outerMap">
    <entry key="volleyball" value="排球"></entry>
    <entry key="football" value="足球"></entry>
    <entry key="basketball" value="篮球"></entry>
</util:map>
<util:properties id="outerProps">
    <prop key="cat">猫</prop>
    <prop key="dog">狗</prop>
    <prop key="bird">鸟</prop>
</util:properties>
<!-- 引用 -->
<bean id="collectionInjection" class="bean.CollectionInjection">
    <property name="nationList" ref="outerList"></property>
    <property name="fruitSet" ref="outerSet"></property>
    <property name="sportMap" ref="outerMap"></property>
    <property name="animalProps" ref="outerProps"></property>
</bean>
```

#### 特殊值

特殊值包括特殊字符、空字符串、null等。

property标签里的赋值不仅可用value属性，还可用value标签。比如：

```xml
<bean class="bean.Teacher" id="teacher">
    <property name="name">
        <!-- 特殊字符 -->
        <value type="java.lang.String"><![CDATA[<>]]></value>
    </property>
    <!-- 空字符串的另一种处理方法 说了value属性值类型为String，即使赋null也是得到"null" -->
    <property name="gender">
        <value></value>
    </property>
</bean>
```

value属性和value标签的区别：

|              | value标签                                 | value属性                 |
| ------------ | ----------------------------------------- | ------------------------- |
| 值位置       | 双标签之间                                | 双引号包裹                |
| type属性     | 可选，指定数据类型                        | 无                        |
| 值含特殊字符 | 使用`<![CDATA[]]>`转义xml预定义的实体引用 | 直接写xml预定义的实体引用 |

xml预定义的实体引用同HTML的特殊字符，给一个[参考手册](https://www.w3school.com.cn/charsets/ref_html_8859.asp)。

再来看对空串和null的处理。

```xml
<bean id="course" class="bean.Course">
    <!-- 空字符串 -->
    <property name="name" value=""></property>
    <property name="credit">
        <value>2</value>
    </property>
    <!-- null -->
    <property name="teacher">
        <null />
    </property>
</bean>
```

#### 继承

此继承（parent标签）不是类继承的意思，而是共享现成的注入配置。

```xml
<bean class="bean.Person" id="van">
    <property name="name" value="van"></property>
    <property name="age" value="18"></property>
    <property name="gender" value="man"></property>
</bean>
<!-- 覆盖掉自注入的，其他的就同父bean的 -->
<bean class="bean.Person" id="bob" parent="van">
    <property name="age" value="30"></property>
</bean>
```

能通过abstract属性让某bean专用于共享配置，而不能被获取，id废了。

```xml
<bean class="bean.Person" id="no" abstract="true">
    <property name="name" value="anonymous"></property>
    <property name="age" value="0"></property>
    <property name="gender" value="BL"></property>
</bean>
```

#### 创建顺序

默认bean的创建顺序同配置顺序，从上到下扫描XML，但可用depends-on属性定制顺序。

```xml
<!-- teacher->course->person 可以填多个，用逗号分隔 -->
<bean class="bean.Person" id="person" depends-on="course"></bean>
<bean class="bean.Teacher" id="teacher"></bean>
<bean class="bean.Course" id="course" depends-on="teacher"></bean>
```

#### 外部属性文件

本节重点倒不是这个，而是通过引用外部属性文件让spring管理数据库连接池，让其保持单例。

本来数据库连接池的bean是在容器配置文件里配置的：

```xml
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    <property name="user" value="root"></property>
    <property name="password" value="root"></property>
    <property name="jdbcUrl" value="jdbc:mysql://localhost:3306/jdbc_learn"></property>
    <property name="driverClass" value="com.mysql.cj.jdbc.Driver"></property>
</bean>
```

虽然XML已经实现了软编码，解耦了源码和配置，改XML不用对项目重新打包部署，但从用户使用的便利性角度考虑，可进一步解耦XML里的配置代码与相关数据，所以常把属性抽成外部文件。

```properties
# there is prefix available such as jdbc.user
user=root
password=root
jdbcUrl=jdbc:mysql://localhost:3306/jdbc_learn
driverClass=com.mysql.cj.jdbc.Driver
```

```xml
<!-- 依赖context命名空间 -->
<bean xmlns:context="http://www.springframework.org/schema/context"></bean>
```

```xml
<!-- 引用外部属性文件 -->
<context:property-placeholder location="classpath:dbcpconfig.properties"/>
<!-- 数据源 -->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    <!-- 注：username是spring定义的关键字，指当前系统用户名 -->
    <property name="user" value="${user}"></property>
    <property name="password" value="${password}"></property>
    <property name="jdbcUrl" value="${jdbcUrl}"></property>
    <property name="driverClass" value="${driverClass}"></property>
    <!-- 留心填value时别多敲空格 -->
</bean>
```

#### 自动装配

自动装配是指在为某个bean的自定义类型域做注入（装配）时，无需显式指定，可基于名称等自动引用其他bean。可想而知我们无法为基本类型与内置类定义bean，更别说被引用了。

```xml
<bean id="teacher" class="bean.Teacher">
    <constructor-arg value="苏轼"></constructor-arg>
    <constructor-arg value="male"></constructor-arg>
    <constructor-arg value="985"></constructor-arg>
</bean>
<bean id="course" class="bean.Course" autowire="byName">
    <property name="name">
        <value>Spring入门到入坟</value>
    </property>
    <property name="credit">
        <value>2</value>
    </property>
    <!-- 不用写name值为teacher的property标签，容器会自动检索id值为teahcer的bean然后引入，找不到则注入null -->
</bean>
```

byName的这个name是由setter决定的。那么上例中所寻id值为teacher，这个teacher就不是从属性名得来的，而是从setTeacher方法名得来的，要是找不到跟名称相同的id值，就注入null。

autowire的值还可取以下这几个：

- byType：检索同类型的bean，调用setter注入，没找到就注入null，但若是此类型的bean不唯一，则报错。
- constructor：调用构造器注入，要求参数个数、类型跟待装配的bean相匹配，某类型的bean不唯一则继续按参数名检索。

针对集合域也有自动装配，且检索类型特别。例如：

```xml
<!-- 将容器中所有元素类型的bean添加进去，所以基于byType方式检索的类型是元素类型Teacher而非域类型List，constructor方式同理 -->
<bean id="school" class="bean.School" autowire="byType"></bean>
<bean id="teacher1" class="bean.Teacher">
    <constructor-arg value="张老师"></constructor-arg>
    <constructor-arg value="male"></constructor-arg>
    <constructor-arg value="20"></constructor-arg>
</bean>
<bean id="teacher2" class="bean.Teacher">
    <constructor-arg value="李老师"></constructor-arg>
    <constructor-arg value="male"></constructor-arg>
    <constructor-arg value="30"></constructor-arg>
</bean>
<bean id="teacher3" class="bean.Teacher">
    <constructor-arg value="汪老师"></constructor-arg>
    <constructor-arg value="male"></constructor-arg>
    <constructor-arg value="40"></constructor-arg>
</bean>
```

#### 注解

注解大大简化了注入的写法。

本节就不展开了，请参见[三层架构](#三层架构)一章，结合实际应用来学习更好。

### bean的作用域

这个名字不好，感觉作用域和单例不是一个意思啊。这里主要谈两种作用域：

- singleton（默认）：单例，每个bean或id值只对应一个对象，所有bean随容器创建而生成。
- prototype：原型或叫多实例，与上一种相反，所有bean跟容器不同生，即要获取某个bean时才创建一个且每获取一次就创建一次，故一个bean可对应多个对象。

第一种已经见识过了，验证一下第二种：

```xml
<!-- 我们通过scope属性修改默认作用域 -->
<bean class="bean.Person" id="person" scope="prototype"></bean>
```

```java
ApplicationContext ioc = new ClassPathXmlApplicationContext("scope.xml");
// id值一样，状态一样，却是两个对象
Person person1 = ioc.getBean("person", Person.class);
Person person2 = ioc.getBean("person", Person.class);
// false
System.out.println(person1 == person2);
// true
System.out.println(person1.equals(person2));
```

我们希望最大程度节省内存，即既要单例又要懒加载，那么保持默认作用域并使用lazy-init属性：

```xml
<bean class="bean.Teacher" id="teacher" lazy-init="true"></bean>
```

```java
ApplicationContext ioc = new ClassPathXmlApplicationContext("scope.xml");
// 此前容器不创建Teacher实例
Teacher teacher1 = ioc.getBean("teacher", Teacher.class);
Teacher teacher2 = ioc.getBean("teacher", Teacher.class);
// true
System.out.println(teacher1 == teacher2);
```

### 工厂方法

bean默认是由Spring利用反射创建出来的，不适合复杂的组件，这时可通过静态工厂、实力工厂的方法创建bean，联系工厂模式，专门封装实例化对象的细节，外部无需过多了解。

- 静态工厂：工厂类自身无需实例化，调用静态方法创建对象。
- 实例工厂：工厂类自身要实例化，调用实例方法创建对象。

```java
public class PersonStaticFactory {
	public static Person getPerson(String name) {
        // 随容器启动而执行
		System.out.println("static factory is creating a person");
		Person person = new Person();
		person.setName(name);
		person.setGender("male");
		person.setAge(0);
		return person;
	}
}
```

```xml
<!-- 注册静态工厂 虽然class值是工厂的全限定类名，但拿到的是Person对象-->
<bean id="staticPerson" class="factory.PersonStaticFactory" factory-method="getPerson">
    <!-- 静态方法的参数 -->
    <constructor-arg value="黄飞鸿"></constructor-arg>
</bean>
```

```java
public class PersonInstanceFactory {
	public Person getPerson(String name) {
		System.out.println("instance factory is creating a person");
		Person person = new Person();
		person.setName(name);
		person.setGender("male");
		person.setAge(0);
		return person;
	}
}
```

```xml
<!-- 注册实例工厂，创建实例工厂bean -->
<bean id="instanceFactoryBean" class="factory.PersonInstanceFactory"></bean>
<!-- 然后调用实例工厂bean的创建对象方法创建Person的bean -->
<bean id="instancePerson" class="bean.Person" factory-bean="instanceFactoryBean" factory-method="getPerson">
    <constructor-arg value="霍元甲"></constructor-arg>
</bean>
```

有了工厂，Spring就不再用反射创建对象了，转而用自定义工厂方法体里的new操作。

另外Spring提供了FactoryBean接口供我们实现，实现类会被认定为工厂。

```java
public class TeacherFactoryBean implements FactoryBean<Teacher> {
	/**
	 * 工厂方法，自动调用
	 */
	@Override
	public Teacher getObject() throws Exception {
        System.out.println("teacher factory is creating a teacher");
		Teacher teacher = new Teacher();
		teacher.setName("anonymous");
		teacher.setGender("unknown");
		teacher.setAge(0);
		return null;
	}

	/**
	 * 获取对象类型，自动调用
	 */
	@Override
	public Class<?> getObjectType() {
		return Teacher.class;
	}

	/**
	 * 是否将当前创建的对象设为单例
	 */
	@Override
	public boolean isSingleton() {
		return false;
	}
}
```

```xml
<!-- 注册Teacher工厂类 支持懒加载-检索此id值时，spring才调用getObject方法 -->
<bean id="teacherFactoryBean" class="factory.TeacherFactoryBean"></bean>
```

### bean的生命周期

有两个回调方法-初始化与销毁。

```xml
<!-- 围绕bean的生命周期定义一些回调方法，这些方法定义在Person类中-->
<bean id="singletonPerson" class="bean.Person" init-method="initPersonBean" destroy-method="destroyPersonBean"></bean>
```

```java
public void initPersonBean() {
    System.out.println("Person bean is being initialized");
}

public void destroyPersonBean() {
    System.out.println("Person bean is being destroyed");
}
```

```java
// 随容器启动创建bean，触发init回调
ConfigurableApplicationContext ioc = new ClassPathXmlApplicationContext("lifeCycle.xml");
// 随容器关闭销毁bean，触发destroy回调
ioc.close();
```

结合bean的作用域，讨论这两个回调的调用情况：

- singleton：如上所述，两个都仅调用一次。
- prototype：初始化回调在首次获取时才被触发，且每次获取都触发，且容器关闭不触发销毁回调。

### 后置处理器

spring提供PostProcessor接口，其中定义了bean初始化前后的回调方法。

```java
public class PersonBeanPostProcessor implements BeanPostProcessor {
	@Override
	public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
		System.out.println("before initializing a Person bean");
		System.out.println(bean);
		// id值
		System.out.println(beanName);
		return bean;
	}

	@Override
	public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
		System.out.println("after initializing a Person bean");
		System.out.println(bean);
		System.out.println(beanName);
		// 这里可以偷梁换柱，本来bean已经造好了，但可以返回别的东西
		return bean;
	}
}
```

```xml
<!-- 注册bean的后置处理器 -->
<bean id="personBeanProcessor" class="postProcessor.PersonBeanPostProcessor"></bean>
<bean id="person" class="bean.Person" init-method="initPersonBean" destroy-method="destroyPersonBean"></bean>
```

由测试结果可看出针对单实例bean一些方法的调用顺序：

```mermaid
graph LR;
	构造方法-->postProcessBeforeInitialization;
	postProcessBeforeInitialization-->初始化回调方法;
	初始化回调方法-->postProcessAfterInitialization;
	postProcessAfterInitialization-->销毁回调方法
```

### SpEL

即sping expression language，与JSP的EL表达式类似，根据JavaBean风格的getter定义访问对象属性。

自行参考文档。

## 三层架构

### 概述

本章只是借用三层架构的概念学习spring提供的一些注解，并不涉及web部分。

本章算是上一章的延续。

### 注解注册

通过给组件添加注解快速地将其加入IOC容器-不用配置bean了。注解有4种，任何一种都能注册任一组件，不过应用起来有讲究。

- @Component：推荐作用于非三层组件。

- @Respository：推荐作用于dao层组件。
- @Service：推荐作用于service层组件。
- @Contoller：推荐作用于controller层组件。

spring底层不会验证注解所做用的组件是不是相应层的，所以推荐做法是做给程序员看的，不要自找麻烦。

准备好Core的4+1个jar包外加AOP包。注册步骤：

1. 给组件打注解。

2. 告诉spring去哪个包（含子包）下面扫描。

来看个例子：

```java
// bean的id值默认是首字母小写的组件名
@Component
public class Book {}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">
	<!-- 开启对包的扫描，只要组件带有上述4中注解之一，就纳入IOC容器 此标签依赖context命名空间 -->
	<context:component-scan base-package="com.van"></context:component-scan>
</beans>
```

同样通过注解更改bean的默认设置。例如用@Scope更改作用域、用@Component等指定id值。

实现注册等功能，注解方式不是绝对地比XML方式好，<span id="division">各有分工</span>，前者只能做自定义组件的注册，后者适合非自定义组件的注册。

### 排除规则

扫描某包时可指定排除规则，无非两种：

- 不想让某些组件纳入IOC容器。
- 只想让某些组件纳入IOC容器。

```xml
<context:component-scan base-package="com.van">
    <!-- 只要组件带指定注解，就被容器排除在外 -->
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Service"/>
    <!-- 指定的组件被容器排除在外 -->
    <context:exclude-filter type="assignable" expression="com.van.controller.BookController"/>
</context:component-scan>
```

```xml
<!-- 禁用默认过滤规则 -->
<context:component-scan base-package="com.van" use-default-filters="false">
    <!-- 只纳入指定组件以及带指定注解的组件 -->
    <context:exclude-filter type="assignable" expression="com.van.controller.BookController"/>
    <context:include-filter type="annotation" expression="org.springframework.stereotype.Service"/>
</context:component-scan>
```

这两种情况刚好形成一个全集。

### 自动装配

@Autowired在DI上大显神威，摒除了注入对setter的依赖。我们给有关联关系的组件簇的诸实例域打上此注解，IOC容器启动创建这些组件对应的bean时就级联注入。

以三层架构为例梳理详细过程：

```java
@Repository
public class BookDao {
}

@Service
public class BookService {
	@Autowired
	private BookDao bookDao;
}

@Controller
public class BookController {
	@Autowired
	private BookService bookService;
}
```

三层组件均被纳入IOC容器，容器一启动就创建三个bean，接着面对BookService的bean准备注入，先按属性的类型检索BookDao的bean，分三种情况讨论：

- 没找到：抛异常。

- 找到一个：赋值。
- 找到多个：按属性名继续检索，即用属性名匹配这些BookDao的bean的id值，又分两种情况：
  - 找到且仅找到一个：赋值。
  - 没找到：抛异常。我们可以给属性打上Qualifier注解，为属性名取别名去跟诸id值匹配。

如此BookDao的bean就注入BookService的bean，后者注入BookController的bean同理，便不赘述了。

由上可知@Autowired要求最终一定要检索成功，不然抛异常，可以放松一点，找不到装配null：

```java
@Autowire(required=false)
```

注：按类型检索时会检索到子类的bean；一个容器中id值不可能重复；类型是由全限定类名体现的。

@Autowired还可以打给方法、构造器，为参数自动装配，那么要求所有参数都是自定义类型。例如：

```java
@Autowired
public void autoFun(BookDao bookDao, @Qualifier("service") BookService bookService) {
    System.out.println("容器启动，自动执行");
}
```

注入原理同属性的，先按参数类型检索，再按参数名检索。

J2EE提供了Resource注解，也能实现自动装配，与@Autowired比，功能没它强，但扩展性更好，因为J2EE比Spring更通用。

### 单元测试

注：JUnit4不是JRE自带的，也是第三方的。

使用spring提供的单元测试模块进行单元测试。首先要导入spirng的test包与JUnit，然后给测试类打两个注解：

- @RunWith：由JUnit提供，告诉JUnit用其他（这里就指spring）驱动而非默认的进行单元测试。
- @ContextConfiguration：由spring的test包提供，指定容器配置文件的路径。

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:application.xml")
public class SpringTest {
	@Autowired
	BookService bookService;

	@Test
	public void test() {
		bookService.saveBook();
	}
}
```

好处就是容器会自动创建，不用我们手动new。

### 泛型DI

有时候参考组件继承时指定的泛型，对带泛型的属性进行自动注入，本质还是按类型检索。

通过下面这个例子理解一下：

<img src="spring.assets/泛型DI.png" alt="泛型DI" style="zoom:80%;" />

```java
// 不用打注册注解，要注册的是子类，打在子类头上，何况这还是个抽象类，不能实例化
public abstract class BaseDao<T> {
	public abstract void add();
}
// 虽然容器中检索不到BaseDao<User>（BaseDao<Book>）类型的bean，但根据前面的注，其子类型UserDao<User>（BookDao<Book>）的bean能被检索到，这就是继承带来的好处

@Repository
public class UserDao extends BaseDao<User> {
	@Override
	public void add() {
		System.out.println("add a user");
	}
}

@Repository
public class BookDao extends BaseDao<Book> {
	@Override
	public void add() {
		System.out.println("add a book");
	}
}

// 它不用打注册注解，要注册的是子类，打在子类头上
public class BaseService<T> {
	@Autowired
	private BaseDao<T> baseDao;

	public void save() {
		System.out.println("属性自动装配：" + baseDao);
		baseDao.add();
	}
}

@Service
public class UserService extends BaseService<User> {
}

@Service
public class BookService extends BaseService<Book> {
}

/* 测试 */
ClassPathXmlApplicationContext ioc = new ClassPathXmlApplicationContext("generic.xml");
BookService bookService = ioc.getBean("bookService", BookService.class);
UserService userService = ioc.getBean("userService", UserService.class);
// 属性自动装配：generic.dao.BookDao@19e4653c
bookService.save();
// 属性自动装配：generic.dao.UserDao@795509d9
userService.save();
// generic.service.BaseService<generic.bean.Book>
System.out.println(bookService.getClass().getGenericSuperclass());
```

## 源码解读

已知IOC容器启动时创建所有注册组件的单实例对象，我们可以从容器中获取这些对象。那么要问IOC启动时主要都干了些什么，如何创建单实例bean的，如何管理它们的？

执行ClassPathXmlApplicationContext构造器，关键是执行refresh方法，这个方法体加了锁，保证多线程情况下容器仅创建一次。refresh方法体内解析XML中的所有定义，保存在BeanFactory对象中，然后注意finishBeanFactoryInitialization方法，它负责初始化所有非懒加载单实例bean，接着关注其方法体内的preInstantiateSingletons方法，再接着关注此方法体内的getBean方法，这个方法又去调用doGetBean方法，doGetBean方法体内关注getSingleton方法，它就是最终直接创建或获取bean的，其所属类下的Map属性singletonObjects就存放着注册组件的bean，id值作键，bean作值。

IOC容器本质上是一个映射集合，每个映射保存一部分bean。spring中最宏观的设计模式是工厂模式，让专门的类负责对象的创建。

BeanFactory接口负责底层创建对象并加入映射，ApplicationContext是BeanFactory的子接口，负责容器的管理，包括对象依赖注入的准备工作、AOP等。我们统计上述重要方法与这俩接口的关系：

| 方法                            | 直属类与所属接口                                    |
| ------------------------------- | --------------------------------------------------- |
| ClassPathXmlApplicationContext  | ClassPathXmlApplicationContext；ApplicationContext  |
| refresh                         | AbstractApplicationContext；ApplicationContext      |
| finishBeanFactoryInitialization | AbstractApplicationContext；ApplicationContext      |
| preInstantiateSingletons        | DefaultListableBeanFactory；BeanFactory             |
| getBean                         | AbstractBeanFactory；BeanFactory                    |
| doGetBean                       | AbstractBeanFactory；BeanFactory                    |
| getSingleton                    | DefaultSingletonBeanRegistry；SingletonBeanRegistry |

可见沿着调用栈越往下越是BeanFactory发挥作用，越往上越是ApplicationContext发挥作用。

## AOP

### 概述

即Aspect-Oriented Programming-面向切面编程，一种基于OOP的新的编程思想，是指在程序运行期间动态地将某段代码插入到相对于指定方法的指定位置去执行的编程理念。

AOP解除了业务逻辑与辅助逻辑的耦合，提升代码的可维护性。

应用：

- 日志。
- 权限验证。
- 事务控制。联系web里的过滤器。

自行回顾动态代理，项目里给了计算器日志实例，实现了前置、返回、异常、后置通知。

这是一张AOP的相关概念图：

<img src="spring.assets/AOP概念.png" alt="AOP概念"  />

其中。通知方法所在的类叫切面类（通知类），被通知方法（业务方法、目标方法）所在的类叫业务类（目标类）。一个通知方法可切给多个目标方法，一个目标方法也可由多个通知方法所切。

我们仍以计算器日志为例实践spring的AOP。先导包，准备基本的4+1加AOP包加再加Ascpects包，且往往额外带上3个实现增强的AOP：

```
com.springsource.net.sf.cglib
com.springsource.aopalliance
com.springsource.org.aspectj.weaver
```

业务类和切面类都需要注册到容器中。

### 基于注解

5种通知对应5种注解，需要开启：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:aop="http://www.springframework.org/schema/aop"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">
	<context:component-scan base-package="aop.annotation"></context:component-scan>
	<!-- 使Aspect注解生效 -->
	<aop:aspectj-autoproxy></aop:aspectj-autoproxy>
</beans>
```

编写通知类，在诸通知注解处构造切入点表达式即可，就不用动容器配置文件了。

```java
/**
 * 本切面类囊括全部四种通知
 * 
 * @author Van
 */
@Component
@Aspect // 声明本类是一个通知类
public class AnnotationAdvice {
	/**
	 * 前置通知
	 * 
	 * @param joinPoint 封装目标方法的详细信息 通知方法是由spring调用的，他对参数列表很敏感
	 */
	// 切入点表达式 
	@Before("execution(public int aop.annotation.MathCalculator.add(int, int))")
	public void myBefore(JoinPoint joinPoint) {
		System.out.println("执行前置通知 目标对象：" + joinPoint.getTarget() + "；目标方法名：" + joinPoint.getSignature().getName()
				+ "；目标方法参数：" + Arrays.toString(joinPoint.getArgs()));
	}

	/**
	 * 返回通知
	 * 
	 * @param joinPoint
	 * @param returningValue 返回值，名称由返回通知注解决定，类型不要写小了
	 */
	@AfterReturning(pointcut = "execution(public int aop.MathCalculator.minus(int, int))", returning = "result") // 指定接收目标方法返回值的参数名
	public void myAfterReturning(JoinPoint joinPoint, Object result) {
		System.out.println("执行返回通知 目标方法返回值：" + result);
	}

	/**
	 * 异常通知
	 * 
	 * @param joinPoint
	 * @param e         可让参数接收目标方法所抛异常，范围尽量写大
	 */
	@AfterThrowing(pointcut = "execution(public int aop.annotation.MathCalculator.divide(int, int))", throwing = "e") // 指定接收目标方法所抛异常的参数名
	public void myException(JoinPoint joinPoint, Exception e) {
		System.out.println("执行异常通知：" + e.getMessage());
        // 可以继续抛出
	}

	/**
	 * 后置通知
	 */
	@After("execution(public int aop.annotation.MathCalculator.time(int, int))")
	public void myAfter() {
		System.out.println("执行后置通知");
	}
    
	/**
	 * 环绕通知，一箭四雕，还可自定制通知切入顺序
	 * 
	 * @param joinPoint
	 * @return
	 * @throws Throwable
	 */
	@Around("execution(public double aop.annotation.MathCalculator.divide(int, int))")
	public Object myAround(ProceedingJoinPoint joinPoint) throws Throwable {
		// 前置通知
		System.out.println("环绕-前置通知");
		Object result = null;
		try {
			// 执行目标方法
			result = joinPoint.proceed();
			// 返回通知
			System.out.println("环绕-返回通知");
			return result;
		} catch (Exception e) {
			// 异常通知
			System.out.println("环绕-异常通知：" + e);
            // throw new RuntimeException(e);
		} finally {
			// 后置通知
			System.out.println("环绕-后置通知");
		}
        // 返回值类型要和目标方法的相匹配
		return Double.NaN;
	}
}
```

关于切入点表达式，上例中的都是非常具体的写法，格式固定为`execution(权限修饰符 返回值类型 全限定类名.方法签名)`，权限修饰符可选，因为实际只能作用于public方法，另外了解一些增强写法。

带通配符：

- `*`：类比正则表达式，可匹配任意多个字符，但在最内层小括号里，是匹配任意一个参数类型，且不能匹配权限修饰符。
- `..`：匹配任意多个任意参数类型；匹配任意多层路径。

还可以带逻辑运算符。

接着看两种测试：

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:annotationAop.xml")
public class AOPDyamicProxySpringTest {
	@Autowired
	Calculator calculator; // 底层用的是动态代理，故属性类型必须是接口，自动装配实现类实例的代理对象

	@Test
	public void test() {
		int add = calculator.add(2, 3);
	}
}

// 另一个测试类的测试方法，此测试类无属性，没用spring单元测试模块
@Test
public void testDynamicProxy() {
    ClassPathXmlApplicationContext ioc = new ClassPathXmlApplicationContext("annotationAop.xml");
    // 底层用到动态代理模式，故给代理对象指定的类型必须是接口，照父类类型能检索到子类对象
    Calculator calculator = ioc.getBean("mathCalculator", Calculator.class);
    System.out.println(calculator.add(1, 1));
    // aop.MathCalculator@ca30bc1 这里调用代理对象的toString方法，返回被代理对象所属类及虚拟地址
    System.out.println(calculator);
    // class com.sun.proxy.$Proxy17 bean的类型已经是代理类了
    System.out.println(calculator.getClass());
}
```

看上例打印结果，取到的bean的Class实例是代理类，而非`class aop.MathCalculator`-业务类，这就说明底层动态代理起了作用，bean其实是代理对象而非原始业务类对象。业务类和代理类实现同一接口，容器一开始是有业务类的bean的，不过被加工成代理类的bean了，所以在第18行id值为mathCalculator的bean是代理类的bean，指定的类型就不能是业务类了，但可以是父类型-接口。

注：可以给接口打注册注解，但一般不用，它的作用仅是告诉spring容器中有此接口实现类的bean。

业务类可以不实现接口，代理类就也可以不实现，那么底层转而采用cglib代理模式，可参考[设计模式](设计模式.md)里的cglib代理。

```java
// 另一种使用spring单元测试模块的测试就不给了，注意把自动装配属性的类型从接口改为业务类
@Test
public void testCglibProxy() {
    ClassPathXmlApplicationContext ioc = new ClassPathXmlApplicationContext("annotationAop.xml");
    // 底层用到Cglib代理，故给代理对象指定的类型就是业务类，同样是照父类类型能检索到子类对象，代理类就是业务类的子类
    MathCalculator calculator = ioc.getBean("mathCalculator", MathCalculator.class);
    System.out.println(calculator.add(1, 1));
    // class aop.MathCalculator$$EnhancerByCGLIB$$9e68ad1f bean的类型已经是代理类了
    System.out.println(calculator.getClass());
}
```

可以用一个无方法体、空参、返回值类型为void的方法以及Pointcut注解抽取复用的切入点表达式。

```java
@Pointcut("execution(* com.van.service.*.*(..))")
public void multiplePointcut() {
};
// 使用起来就是以multiplePointcut()替换通知注解的值
```

### 基于XML

#### 接口实现

一个普通类可通过实现4种接口之一变成对应切面类，这里我们给一个完整地实现4个接口的例子。

```java
/**
 * 实现MethodBeforeAdvice接口，变为前置通知类；实现AfterReturningAdvice接口，变为返回通知类；实现ThrowsAdvice接口，变为异常通知类；实现MethodInterceptor接口，变为环绕通知类，可容纳前置、后置、异常及最终通知
 * 
 * @author Van
 */
public class ImplAdvice implements MethodBeforeAdvice, AfterReturningAdvice, ThrowsAdvice, MethodInterceptor {
	/**
	 * 前置通知
	 */
	@Override
	public void before(Method method, Object[] args, Object target) throws Throwable {
		System.out.println("执行前置通知方法 " + "目标对象：" + target + "；目标方法名：" + method.getName() + "；目标方法参数个数：" + args.length);
	}

	/**
	 * 返回通知
	 */
	@Override
	public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
		System.out.println("执行返回通知方法" + " 目标方法返回值" + returnValue);
	}

	/**
	 * 异常通知：相当于给目标方法套了个try-catch语句体 方法名固定
	 * 
	 * @param method
	 * @param args
	 * @param target
	 * @param exception
	 */
	public void afterThrowing(Method method, Object[] args, Object target, Throwable exception) {
		System.out.println("执行异常通知方法：" + exception.getMessage());
	}

   	/**
	 * 环绕通知：一箭四雕
	 */
	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
		Object result = null;
		try {
			// 切入前置通知
			System.out.println("通过环绕通知实现前置通知");
			// 执行目标方法，proceed的返回值就是它的返回值
			result = invocation.proceed();
			// 切入返回通知 看这里返回通知就在后置通知前面执行
			System.out.println("通过环绕通知实现返回通知");
			return result;
		} catch (Exception e) {
			// 切入异常通知
			System.out.println("通过环绕通知实现异常通知");
		} finally {
			// 切入后置通知
			System.out.println("通过环绕通知实现后置通知");
		}
		// 就能猜想spring aop实现的返回通知是切在这里，所以排在后置通知之后执行
		return Double.NaN;
        // invoke的返回值类型要和目标方法的相匹配
	}
}
```

可惜没有专门的后置通知接口。接着编写容器配置文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:aop="http://www.springframework.org/schema/aop"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd">
	<!-- 注册切面类、业务类 -->
	<bean id="implAdvice" class="aop.xml.ImplAdvice"></bean>
	<bean id="mathCalculator" class="aop.xml.MathCalculator"></bean>
	<!-- 配置AOP -->
	<aop:config>
		<!-- 切入点（目标方法）便于复用-->
		<aop:pointcut expression="execution(* aop.xml.MathCalculator.*(..))" id="calc"/>
		<!-- 联系切面类与切入点，即指明哪个切面类切给哪个方法 -->
		<aop:advisor advice-ref="implAdvice" pointcut-ref="calc"/>
		<!-- 或不复用，现写 <aop:advisor advice-ref="implAdvice" pointcut="execution(* aop.xml.impl.MathCalculator.*(..))"/> -->
	</aop:config>
</beans>
```

环绕通知通知是最强大的通知，以一敌四。

能想到普通异常通知不执行，因为异常已经被环绕通知捕获了，除非继续抛出。

环绕通知虽然以一敌四，但不够安全，因为能干扰目标正常执行，比如篡改参数、返回值。

#### 配置实现

也可以不实现接口，转而在容器配置文件中配置使得普通类变成切面类。

先定义一个普通类，里面完整地定义了所有通知：

```java
/**
 * 此处看起来就是个普通类，要去容器配置文件中变成切面类
 * 
 * @author Van
 *
 */
public class ConfigAdvice {
	public void beforeAdvice(JoinPoint joinPoint) {
		System.out.println("执行前置通知 目标对象：" + joinPoint.getTarget() + "；目标方法名：" + joinPoint.getSignature().getName()
				+ "；目标方法参数：" + Arrays.toString(joinPoint.getArgs()));
	}

	public void afterReturningAdvice(JoinPoint joinPoint, Object result) {
		System.out.println("执行返回通知 目标方法返回值：" + result);
	}

	public void afterThrowingAdvice(JoinPoint joinPoint, Exception e) {
		System.out.println("执行异常通知：" + e.getMessage());
	}

	public void afterAdvice() {
		System.out.println("执行后置通知");
	}

	public Object aroundAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
		Object result = null;
		try {
			System.out.println("环绕-前置通知");
			result = joinPoint.proceed();
			System.out.println("环绕-返回通知");
			return result;
		} catch (Exception e) {
			System.out.println("环绕-异常通知：" + e);
		} finally {
			System.out.println("环绕-后置通知");
		}
		return Double.NaN;
	}
}
```

然后写配置：

```xml
<!-- 注册准切面类、业务类 -->
<bean id="configAdvice" class="aop.xml.ConfigAdvice"></bean>
<bean id="mathCalculator" class="aop.xml.MathCalculator"></bean>
<!-- 配置AOP -->
<aop:config>
    <!-- 切入点（目标方法）便于复用-->
    <aop:pointcut expression="execution(* aop.xml.MathCalculator.*(..))" id="calc"/>
    <!-- 让某准切面类变成真正的切面类 自定嵌套顺序 -->
    <aop:aspect ref="configAdvice" order="2">
        <aop:before method="beforeAdvice" pointcut-ref="calc"/>
        <aop:after-returning method="afterReturningAdvice" returning="result" pointcut-ref="calc"/>
        <aop:after-throwing method="afterThrowingAdvice" throwing="e" pointcut-ref="calc"/>
        <aop:after method="afterAdvice" pointcut-ref="calc"/>
        <aop:around method="aroundAdvice" pointcut-ref="calc"/>
        <!-- 或不复用，用pointcut属性直接写 -->
    </aop:aspect>
</aop:config>
```

[前面](#division)说了XML方式与注解方式各有所长，这里补充一下，注解快速方便，XML功能完善，我们提倡重要的配置归XML做，不重要的归注解做。

### 通知顺序

当我们为目标方法切入了全部4种通知，执行顺序是这样的：

- 若目标方法无异常：前置通知->方法执行->后置通知->返回通知。
- 若目标方法抛异常：前置通知->方法执行->异常通知->后置通知。

环绕通知就是是个动态代理，让我们自定制了通知切入顺序，故它造成的通知执行顺序不唯一，得看自己是怎么写的。环绕通知与普通通知切的顺序暂且不谈，从spring4到spring5有变化。

当多个切面类作用于同一个目标方法，则按切面类名首字母顺序安排嵌套，也可使用Order注解定制嵌套顺序。

```java
// 打给切面类 数越小，越靠外边
@Order(-3)
```

<img src="spring.assets/多切面.png" alt="多切面" style="zoom:80%;" />

## 事务

### 概述

承接上一章，AOP功能强大，应用广泛，其中的典型就是事务控制。

随便看看spring提供的玩具JDBCTemplate，它和apache提供的DBUtils大致相当，以它为配合学习大头-事务控制。

事务根据实现方式分为两种：

- 编程式事务：就是获取连接、执行、提交、回滚、释放连接这一完整的显式的逻辑，也可以说是声明式事务的基础。

- 声明式事务：spring利用AOP分离执行逻辑与其他逻辑，即将后者封装为切面类，将提交、回滚等变成通知方法。

spring已经为我们准备好了一个完善的事务切面类，叫事务管理器-PlatformTransactionManager接口，其下有多个实现类。

事务依赖了AOP，那么在IOC容器中事务管理器管理的业务类的bean就是个代理对象。

### 基于注解

给个例子，着重看配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:aop="http://www.springframework.org/schema/aop"
	xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
		http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd
		http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.0.xsd">
	<context:component-scan base-package="com.van"></context:component-scan>
    <!-- 数据源 -->
	<context:property-placeholder location="classpath:c3p0.properties" />
	<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
		<property name="user" value="${jdbc.user}"></property>
		<property name="password" value="${jdbc.password}"></property>
		<property name="jdbcUrl" value="${jdbc.jdbcUrl}"></property>
		<property name="driverClass" value="${jdbc.driverClass}"></property>
	</bean>
    <!-- 注册JDBCTemplate以支持dao层组件的属性自动装配 -->
	<bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
		<constructor-arg name="dataSource" ref="dataSource"></constructor-arg>
	</bean>
	<!-- 事务管理器 -->
	<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
		<!-- 事务控制依托的是连接，连接又是从数据源中得到的 -->
		<property name="dataSource" ref="dataSource"></property>
	</bean>
	<!-- 开启事务注解，是打给目标方法的 依赖tx命名空间-->
	<tx:annotation-driven transaction-manager="txManager"/>
</beans>
```

```java
@Repository
public class BookDao {
	@Autowired
	JdbcTemplate jdbcTemplate; // JdbcTemplate做的工作与BaseDao的相同，不过使用JdbcTemplate时基于聚合，使用BaseDao时基于继承

	public int getPrice(String isbn) {
		String sql = "SELECT price FROM book WHERE isbn = ?";
		return jdbcTemplate.queryForObject(sql, Integer.class, isbn);
	}

	public void updateStock(String isbn) {
		// 简便起见，每次只减1
		String sql = "UPDATE book_stock SET stock = stock - 1 WHERE isbn = ?";
		jdbcTemplate.update(sql, isbn);
	}
}

@Repository
public class UserDao {
	@Autowired
	JdbcTemplate jdbcTemplate;

	public void updateBalance(String username, int price) {
		String sql = "UPDATE account SET balance = balance - ? WHERE username = ?";
		jdbcTemplate.update(sql, price, username);
	}
}
```

```java
@Service
public class BookService {
	@Autowired
	private BookDao bookDao;
	@Autowired
	private UserDao userDao;
    
	/**
	 * 哪个用户买了哪本书
	 * 
	 * @param username
	 * @param isbn
	 */
    @Transactional // 声明此方法被事务控制
	public void checkout(String username, String isbn) {
		// 减库存
		bookDao.updateStock(isbn);
		// 查价格
		int price = bookDao.getPrice(isbn);
		// 减余额
		userDao.updateBalance(username, price);
	}
}
```

这个Transactional注解有一些属性值得注意：

- timeout：int类型（秒），事务执行时间超过阈值后自动终止并回滚。
- readOnly：boolean类型，如果事务内都是查询，没有增删改，则最好设为true，取消关闭自动提交等额外操作，节省时间。
- rollbackFor：Class数组类型，回滚底层是在针对非受检异常的try-catch语句的catch中进行的，可设此属性使得catch能针对受检异常，那么对于应当触发回滚的异常我们自己不要提前用try-catch彻底处理掉了。
- noRollbackFor：Class数组类型，设此属性以排除对某些异常的捕获，即不针对这些异常进行回滚。
- isolation：Isolation类型，指事务的隔离级别，取值为Isolation类的几个公有常量。
- propagation：Propagation类型，此属性决定着本方法对应事务的传播行为，常取值两种-`Propagation.REQUIRED`与`Propagation.REQUIRES_NEW`，前者指若上层方法有连接则沿用此连接否则另起新连接，后者指另起新连接。

最后一个项目里有实例，这里就不贴了，转而基于伪代码看更复杂的业务方法的嵌套：

```java
// 方法调用的嵌套，设定B、C、F、G这些不再往下套的直接调用dao层方法 我用数组标识连接，同一个连接上的会一致回滚
multiTx() { // 1
    // REQUIRED 1
    A() {
        // REQUIRES_NEW 2
        B() {...}
        // REQUIRED 1
        C() {...}
    }
    // REQUIRES_NEW 3
    D() {
        // REQUIRED 3
        E() {
            // REQUIRES_NEW 4
            F() {...}
        }
        // REQUIRES_NEW 5
        G() {...}
    }
    // 1回滚
    int num = 2 / 0;
}
// B、F、G里的DML不被回滚，C里的被回滚
```

```java
// 设定B、C、F、G、H这些不再往下套的直接调用dao层方法
multiTx() { // 1
    // REQUIRED 1
    A() {
        // REQUIRES_NEW 2
        B() {...}
        // REQUIRED 1
        C() {...}
    }
    // REQUIRES_NEW 3
    D() {
        // REQUIRED 3
        H() {...}
        // REQUIRED 3
        E() {
            // REQUIRES_NEW 4
            F() {
                ...
                // 4回滚
    			int num = 2 / 0;
            }
        }
        // REQUIRES_NEW 5
        G() {...}
    }
}
// B里的不被回滚，C、F、H里的被回滚，G还没轮到调用
```

事务管理器其实就是环绕通知，用try-catch处理异常并在catch里继续往上抛。

若某业务方法沿用上层方法的连接，则注解的所有属性均会失效，因为此连接受上层方法控制，而这些属性只能作用于另起的连接。

```java
// 使用Propagation.REQUIRED尤为小心，不要被嵌套 
@Transactional(propagation = Propagation.REQUIRED, timeout = 3, readOnly = true)
```

注意被嵌套时方法传播行为是`Propagation.REQUIRES_NEW`时，不要被嵌套方法的this调用，否则仍沿用上层连接，只有新的代理对象才能另起连接。例如不要这样写：

```java
// 三者属同类
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void checkout(String username, String isbn) {
    bookDao.updateStock(isbn);
    int price = bookDao.getPrice(isbn);
    userDao.updateBalance(username, price);
}

@Transactional(propagation = Propagation.REQUIRES_NEW)
public void updatePrice(String isbn, int price){
    bookDao.updatePrice(isbn, price);
}

//这三个方法由一个代理对象调用，共用一个连接
@Transactional
public void multiTx() {
    // 沿用multiTx前置通知获取的连接，另起失效
    checkout("Tom", "ISBN-001");
    updatePrice("ISBN-002", 98);
}
```

### 基于XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:aop="http://www.springframework.org/schema/aop"
	xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
		http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.0.xsd
		http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.0.xsd">
	<context:component-scan base-package="com.van"></context:component-scan>
	<context:property-placeholder location="classpath:c3p0.properties" />
   	<bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
		<constructor-arg name="dataSource" ref="dataSource"></constructor-arg>
	</bean>
	<!-- 数据源 -->
	<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
		<property name="user" value="${jdbc.user}"></property>
		<property name="password" value="${jdbc.password}"></property>
		<property name="jdbcUrl" value="${jdbc.jdbcUrl}"></property>
		<property name="driverClass" value="${jdbc.driverClass}"></property>
	</bean>
	<!-- 事务管理器 -->
	<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
		<!-- 事务控制依托的是连接，连接又是从数据源中得到的 -->
		<property name="dataSource" ref="dataSource"></property>
	</bean>
	<!-- 哪个事务管理器管理哪些业务类的哪些方法 -->
	<tx:advice id="txAdvice" transaction-manager="txManager">
		<tx:attributes>
			<!-- *代表切入点表达式匹配的所有方法 -->
		 	<tx:method name="*" rollback-for="java.lang.Exception"/>
			<tx:method name="checkout" propagation="REQUIRED" timeout="10"/>
			<!-- 切入点表达式匹配的方法中以get开头的，不控制了 -->
			<tx:method name="get*" read-only="true"/>
		</tx:attributes>
	</tx:advice>
    <!-- 事务管理基于AOP -->
	<aop:config>
		<aop:pointcut expression="execution(* com.van.service.*.*(..))" id="txPoint" />
		<aop:advisor advice-ref="txAdvice" pointcut-ref="txPoint"/>
	</aop:config>
</beans>

```

对于重要的业务方法比如结账，推荐采用基于XML的方式。

## 整合Web

我们对Web中的bookstore-upper项目进行改造，引入spring。

整合主要有以下几步：

1. 导包。
2. 配置：
   1. 将下两层组件加入IOC容器。
   2. 自动级联装配各个bean。就省略了大量new了。
   3. 实现声明式事务。就不用做全局事务控制了。
3. 测试。

servlet对象应由tomcat创建的，故不能注册进容器，即不由spring创建，于是其下service层组件属性就不能打注册注解了，也不能打@Autowired做自动装配了，只能手动从容器中获取下层组件对象。

```java
// 工具类中定义方法
public static <T> T getBean(Class<T> cls) {
    // 获取IOC容器 考虑多线程、子父容器等问题
    WebApplicationContext ioc = ContextLoader.getCurrentWebApplicationContext();
    // 获取bean，这里只用于获取service层组件的bean
    return ioc.getBean(cls);
}

// servlet中service层属性的赋值
private BookService bookService = WebUtils.getBean(BookService.class); // 业务类实现接口，那么底层采用动态代理，故应传入接口类型
```

对前面的普通项目，我们是经由测试方法手动启动容器的，而对于Web项目，它没有程序入口，如何启动IOC容器呢？做法是利用spring的Web包提供的一个监听器监听tomcat的启动与关闭，启动了就创建容器，关闭了就销毁容器。

监听器需要我们自己配置：

```xml
<!-- 此监听器实现了ServletContextListener接口，实现两个方法，分别做容器的初始化和销毁工作 -->
<listener>
   <description>启动spring容器</description>
   <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
<!-- IOC容器的位置-->
<context-param>
   <param-name>contextConfigLocation</param-name>
   <param-value>classpath:application.xml</param-value>
</context-param>
```

具体重构请参考bookstore-spring项目。

## 纯注解开发

spring的IOC容器以两种形式存在：

- xml配置文件：aplicationContext.xml（文件名不固定）。
- 配置类：带有Configuration注解的类。

对ioc容器的操作就两种-存bean和取bean，反映在上述第一种形式上的bean的存取前面已经讨论过了，下面着重看后者-完全用注解搭建IOC容器，不再依靠xml配置文件（就可删掉）。

注意两种形式生成的IOC容器是相互独立的，即可以共存且互不影响。我们可以分别用这两种形式得到两个不同的ioc容器。

### 案例

存bean操作体现于配置类，那么我们就在config包下创建一个配置类：

```java
package com.van.config;

import com.van.entity.User;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 加上@Configuration注解，则本类相当于xml配置文件
 */
@Configuration
public class ApplicationContextConfig {
    /**
     * 加上@Bean注解，则本方法相当于配置文件里的bean标签，方法名即id值
     */
    @Bean
    public User getUser() {
        return new User("van");
    }
}
```

此配置类搭建IOC容器，然后取bean：

```java
ApplicationContext context = new AnnotationConfigApplicationContext(ApplicationContextConfig.class);
// getBean方法重载，也可传入User类的反射
User user = (User) context.getBean("getUser");
System.out.println(user);
```

我们注意对比两种形式下获取IOC容器的写法：

```java
// 根据xml搭建
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
// 根据Java类搭建
ApplicationContext context = new AnnotationConfigApplicationContext(ApplicationContextConfig.class);
```

### 用注解存储bean

我们从前面的小例子中看出以Bean注解的方式存放bean，下面宏观地组件类型分两种情况讨论存放过程。

#### 三层组件

给三层组件对应的类添加相应注解。

开启IOC扫描器。又分两种方法，具体还是配置文件与注解。

第一种前面练习过，就不用此方法了，回顾一下开启扫描器的代码：

```xml
<context:component-scan base-package="com.van"></context:component-scan>
```

本来就是要探究脱离xml配置文件条件下构建并使用ioc容器的实现，故最好不用xml。

第二种的实现就是对配置类添加ComponentScan注解：

```java
// 值即被扫描的包名，等价于上述标签的base-packages值
@ComponentScan(value = "com.van")
```

测试那些加了三层组件注解的类是否作为bean被存入ioc容器：

```java
ApplicationContext context = new AnnotationConfigApplicationContext(ApplicationContextConfig.class);
// 所有bean的id值
String[] beanDefinitionNames = context.getBeanDefinitionNames();
for (String beanId : beanDefinitionNames) {
    System.out.println(beanId);
}

// 除日志外的打印结果
applicationContextConfig // 可见配置类自己也作为bean（我纳我自己）
userController
userDao
userService
getUser
```

为了有选择地将某些类纳入容器，可给组件扫描器制定规则。详细语法可参考[spring文档](https://docs.spring.io/spring-framework/docs/4.3.22.RELEASE/spring-framework-reference/htmlsingle/)，此处只给出几个实例：

```java
// 排除service组件
@ComponentScan(value = "com.van", excludeFilters = {@ComponentScan.Filter(type = FilterType.ANNOTATION, value = Service.class)})
// 只纳入dao组件
@ComponentScan(value = "com.van", includeFilters = {@ComponentScan.Filter(type = FilterType.ANNOTATION, value = Repository.class)}, useDefaultFilters = false)
// 值纳入某一个controller组件
@ComponentScan(value = "com.van", includeFilters = {@ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, value = UserController.class)}, useDefaultFilters = false)
```

#### 非三层组件

上述组件扫描器只能扫描到Component一族的组件，就不适用于三层架构之外的组件。

##### Bean注解

针对这些组件（类），开头例子中的Bean注解就是一个常用方法。

其中，bean的id不光可以默认由方法名限定，也可自指定：

```java
@Bean(value = "getUserBean")
@Bean("getUserBean")
```

##### Import注解

## SSM整合

学完springmvc与mybatis，来到这一章。

别的就不说了，导包参考项目，重点熟悉几个配置文件的编写。

这里只提一下没见过的spring整合mybatis：

```xml
<!-- 整合mybatis，底层注册SqlSession工厂，此组件属mybatis-spring包 -->
<bean class="org.mybatis.spring.SqlSessionFactoryBean">
    <!-- 数据源 -->
    <property name="dataSource" ref="c3p0"></property>
    <!-- 全局配置文件地址 -->
    <property name="configLocation" value="classpath:mybatis.xml"></property>
    <!-- SQL映射文件地址 -->
    <property name="mapperLocations" value="classpath:mappers/*.xml"></property>
    <!-- 其他配置一般不在这里弄 -->
</bean>
<!-- dao层接口的自动注入，自动创建SqlSession对象再创建代理对象再赋给service层组件属性 -->
<!-- <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="com.van.dao"></property>
</bean> -->
<mybatis-spring:scan base-package="com.van.dao"/>
```







