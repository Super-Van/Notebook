# Spring

参考视频：[Spring视频教程](https://www.bilibili.com/video/BV1ds411V7HZ)。

框架=注解+反射+设计模式。

可在eclipse中安装spring插件以提升开发效率，下载地址：

```shell
http://download.springsource.com/release/TOOLS/update/e4.5/
```

版本号要与eclipse的版本号一致，一次安装不完整的话就多安装几次，另外还需从商店安装Spring Tools 3（standardalone edition）作起底插件。

## 概述

### 概念

Spring是分层（Spring SE/EE）的应用于全栈的轻量级开源框架。它以IOC（Inverse Of Control-控制反转）和AOP（Aspect Oriented Programming-面向切面编程）为内核，提供了展示层的Spring MVC和持久层的Spring JDBC以及业务层的事务管理等众多企业级应用技术，还能够整合众多知名第三方开源框架和类库，逐渐成为使用最多的Java EE应用开源框架。

### 两大核心

IOC和AOP。

### 发展历程

1997至今，详情省略。

最早是2002年，一个大神叫Rod Johnson，发表了文章《Expert One-on-One J2EE Design and Development》，随后就有人据此研发出Spring框架。最初Spring框架只有两大基石或核心：面向切面编程AOP、控制反转IOC，后来越来越多的新东西被开发出来，诸如Spring data、Spring Boot、Spring Cloud、Spring Social。

### 优势

方便解耦、简化开发。

支持切面编程。

支持声明式事务。

方便程序的测试。

方便继承各种优秀框架。

降低Java EE API的使用难度。

源码是经典的学习范例。

## IOC

### 案例

这个小例子就打印学生的信息。

#### 搭建Spring环境

首先当然是导入jar包，下面的小例子项目用的版本是4.3.9。最好把这些jar包放在项目文件夹里，如在src里新建一个lib文件夹，把jar包放里面。

下载的压缩包文件包括dist（二进制）、doc（文档）、schema等几类，我们下载第一类dist。

解压缩得到的jar包有很多个，视情况决定用谁，基础项目至少用到（5+1）个：

| jar包                 | 适用情况                               |
| --------------------- | -------------------------------------- |
| spring-aop.jar        | 项目具有aop特性                        |
| spring-beans.jar      | 处理bean                               |
| spring-context.jar    | 处理spring的上下文                     |
| spring-core.jar       | spring的核心，其他几个的基础，必不可少 |
| spring-expression.jar | spring表达式                           |
| commons-logging.jar   | 日志，第三方提供                       |

#### 编写配置文件

配置文件applicationContext.xml的写法如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
>
    
	<!-- 本文件产生的所有对象被Spring放进一个叫Spring IOC容器的地方 -->
	<!-- bean：指定类的实例对象。id：唯一标识符；class：指定类的全限定类名 -->
	<bean id="student" class="com.simple.Student">
		<!-- property：本类的属性 name：属性名 value：属性值 -->
		<property name="name" value="Van"></property>
		<property name="gender" value="男"></property>
		<property name="age" value="22"></property>
	</bean>
	<bean id="javaCourse" class="com.course.JavaCourse"></bean>
    
</beans>
```

#### 编写实体类

此过程很简单，就写两个实体类，省略了。

#### 编写测试类

测试类SpringTest.java的写法如下：

```java
package com;

import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

class SpringTest {

	@Test
	public void testFormer() {
		Student student = new Student();
		student.setName("Van");
		student.setGender("男");
		student.setAge(22);
		System.out.println(student);
	}

	@Test
	public void testBean() {
		@SuppressWarnings("resource")
		// Spring上下文对象：context
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		// 从Spring IOC容器中取id为student的对象
		Student student = (Student) context.getBean("student");
		System.out.println(student);
		// 上下两者运行结果一样，而第二种省略了new（初始化新实例）和对实例域的赋值
	}
}
```


从这个例子理解Spring IOC容器。它就像一个装豆子（bean）的竹筒，每个豆子都是一个状态独一无二的对象，当我们需要某个特定的豆子的时候就从竹筒中取。

### 动机

以前对象的初始化和实例域赋值的方式见过千百回了：

```java
Student student = new Student();
student.setAge(20);
```

但是我们很少想到它也有缺点。如每用到一个对象就得new一次，用多了堆里就有好多对象，造成冗余。另有其他缺点。

比如有一个课程接口，其中有一个上课方法，该接口由两个实现类（对应不同的课程）分别实现。一个学生需要上不同的课，因此依赖不同的实现类。

原始（多态方式）的各文件写法列举如下：

```java
package com.course;

/**
 * 课程接口
 * 
 * @author Van
 */
public interface ICourse {

	/**
	 * 上课
	 */
	void learn();
}
```
```java
package com.course;

/**
 * 课程接口的实现类-Python课程类
 * 
 * @author Van
 */
public class PythonCourse implements ICourse {

	@Override
	public void learn() {
		System.out.println("上Python课");
	}

}
```

```java
package com.course;

/**
 * 课程接口的实现类-Java课程类
 * 
 * @author Van
 */
public class JavaCourse implements ICourse {

	@Override
	public void learn() {
		System.out.println("上Java课");
	}

}
```

```java
package com.course;

/**
 * 学生类
 * 
 * @author Van
 */
public class Student {

	/**
	 * 上Java课
	 */
	public void learnJava() {
		ICourse course = new JavaCourse();
		course.learn();
	}

	/**
	 * 上Python课
	 */
	public void learnPython() {
		ICourse course = new PythonCourse();
		course.learn();
	}

}
```

```java
package com.course;

import org.junit.jupiter.api.Test;

/**
 * 测试类
 * 
 * @author Van
 */
class CourseTest {

	@Test
	void testLearn() {
		Student student = new Student();
		student.learnJava();
		student.learnPython();
	}

}
```

从这个例子可看出，想上Java课或Python课就得new（从堆里分出一块空间）一个对象。那么这里仅一个学生，如果有一千一万个学生就得离散地new两千两万个对象，导致对象太分散不好统一管理及冗余问题，后期维护较为麻烦。

克服缺陷，下面就来迎接超级工厂Spring IOC容器的降临。

### IOC容器

从自力更生到拿来主义。

套用万物皆对象的说法，万物皆入Spring。IOC容器可以存放任何对象，好处就是对进行控制反转，控制意指获取对象的方式，以前用的是new，现在用的是getBean方法（从容器中拿），解决了对象冗余问题。可从动作或角色上理解反转：从造变成了拿；从即时生产到一开始就把要用的全部准备好。但到底控制反转这一概念还是很模糊、不好解释，于是业内人士就Spring开了一次大会，将其改为依赖注入。

于是乎梳理一下注入的过程：将属性值注入属性；将属性注入bean；将bean注入进IOC容器。因此使用IOC分两步：

1. 在容器中放对象并给属性赋值。
2. 用某对象的时候从容器里拿。

下面利用IOC容器对前面的例子进行改进。

```java
/**
* 上任意一门课
* 
* @param cname 课程名
*/
void learnCourse(String cname) {
    @SuppressWarnings("resource")
    ApplicationContext context = new ClassPathXmlApplicationContext("applicaitonContext.xml");
    ICourse course = (ICourse) context.getBean(cname);
    // 这里违反了迪米特法则
    course.learn();
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
>
    
	<bean id="student" class="com.course.Student"></bean>
	<bean id="javaCourse" class="com.course.JavaCourse"></bean>
	<bean id="pythonCourse" class="com.course.PythonCourse"></bean>
    
</beans>
```

```java
@Test
void testLearn() {
    @SuppressWarnings("resource")
    ApplicationContext context = new ClassPathXmlApplicationContext("applicaitonContext.xml");
    Student student = (Student) context.getBean("student");
    student.learnCourse("javaCourse");
    student.learnCourse("pythonCourse");
}
```

## DI

### 概述

前面谈过了IOC等价于依赖注入DI（dependency injection）。

前面梳理了注入有三层含义，第一层含义等价于对象的初始化。对于8大基本类型，基于value属性写具体值；对于对象类型，基于ref属性写所依赖bean的id值。只有后者体现了依赖注入中的依赖，即对象间的依赖关系。

### 注入的实现

有三种方式来实现属性的注入。

- 首先是setter（修改器）方式。

  ```java
  package com.course;
  
  /**
   * Course所依赖的Teacher类
   * 
   * @author Van
   */
  public class Teacher {
  
  	private String teacherName;
  	private String gender;
  	private int age;
  
  	public String getTeacherName() {
  		return teacherName;
  	}
  
  	public void setTeacherName(String teacherName) {
  		this.teacherName = teacherName;
  	}
  
  	public String getGender() {
  		return gender;
  	}
  
  	public void setGender(String gender) {
  		this.gender = gender;
  	}
  
  	public int getAge() {
  		return age;
  	}
  
  	public void setAge(int age) {
  		this.age = age;
  	}
  
  	@Override
  	public String toString() {
  		return "Teacher [name=" + teacherName + ", gender=" + gender + ", age=" + age + "]";
  	}
  
  }
  ```

  ```java
  package com.course;
  
  /**
   * 课程类
   * 
   * @author Van
   */
  public class Course {
  
  	private String courseName;
  	// 使用类的组合或内部类，达到对象间的依赖（这里往细里说是关联）
  	private Teacher teacher;
  	private int credit;
  
  	public String getCourseName() {
  		return courseName;
  	}
  
  	public void setCourseName(String courseName) {
  		this.courseName = courseName;
  	}
  
  	public Teacher getTeacher() {
  		return teacher;
  	}
  
  	public void setTeacher(Teacher teacher) {
  		this.teacher = teacher;
  	}
  
  	public int getCredit() {
  		return credit;
  	}
  
  	public void setCredit(int credit) {
  		this.credit = credit;
  	}
  
  	@Override
  	public String toString() {
  		return "Course [courseName=" + courseName + ", teacher=" + teacher + ", credit=" + credit + "]";
  	}
  
  }
  ```

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
  >
      
  	<bean id="teacher" class="com.course.Teacher">
  		<property name="teacherName" value="Mr.Zhang"></property>
  		<property name="gender" value="male"></property>
  		<property name="age" value="22"></property>
  	</bean>
  	<bean id="course" class="com.course.Course">
  		<!-- spring通过拼接set和属性名得到此属性的setter名，进而调用该setter，那么前提条件就是本类中须有此setter -->
  		<property name="courseName" value="CS"></property>
  		<!-- 对象类型不用value，用ref（引用） -->
  		<property name="teacher" ref="teacher"></property>
  		<property name="credit" value="2"></property>
  	</bean>
      
  </beans>
  ```

  ```java
  package com.course;
  
  import static org.junit.jupiter.api.Assertions.fail;
  
  import org.junit.jupiter.api.Test;
  import org.springframework.context.ApplicationContext;
  import org.springframework.context.support.ClassPathXmlApplicationContext;
  
  class CourseTest {
  
  	@Test
  	void test() {
  		fail("Not yet implemented");
  	}
  
  	@Test
  	void testCourse() {
  		@SuppressWarnings("resource")
  		ApplicationContext context = new ClassPathXmlApplicationContext("applicaitonContext.xml");
  		Course course = (Course) context.getBean("course");
  		System.out.println(course);
  	}
  
  }
  ```

- 构造器方式（其他代码省略，下同）：

  ```java
  /**
   * 前提条件是要有构造器
   * 
   * @param teacherName
   * @param gender
   * @param age
   */
  public Teacher(String teacherName, String gender, int age) {
      this.teacherName = teacherName;
      this.gender = gender;
      this.age = age;
  }
  ```

  ```xml
  <bean id="teacher" class="com.course.Teacher">
      <!-- 子标签默认从上至下按构造器参数顺序赋值，欲自定顺序可借助索引index、参数名name、参数类型type等属性赋值（value的默认类型是字符串），建议用name -->
      <constructor-arg value="Mr.Zhang"></constructor-arg>
      <constructor-arg value="male"></constructor-arg>
      <constructor-arg value="22"></constructor-arg>
  </bean>
  ```

- p命名空间注入方式。要先引入命名空间。

  ```xml
  xmlns:p="http://www.springframework.org/schema/p"
  ```
  
  ```xml
  <bean 
  	id="course" 
  	class="com.course.Course" 
  	p:courseName="CS" 
      <!-- 注意这里的ref -->
  	p:teacher-ref="teacher" 
  	p:credit="2">
  </bean>
  ```

往容器中注入bean的前提该bean类必须提供无参构造器，无有参构造器则无需手写无参构造器，因为Java自动提供，但有有参构造器则必须手写无参构造器，因为Java不会自动提供。

### 集合属性的注入

比如建一个类，5个实例域分别使用5大集合类。

```java
package com.collection;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class AllCollectionType {

	private String[] numberArray;
	private List<String> nationList;
	private Set<String> fruitSet;
	private Map<String, String> sportMap;
	private Properties animalProps;

	public String[] getNumberArray() {
		return numberArray;
	}

	public void setNumberArray(String[] numberArray) {
		this.numberArray = numberArray;
	}

	public List<String> getNationList() {
		return nationList;
	}

	public void setNationList(List<String> nationList) {
		this.nationList = nationList;
	}

	public Set<String> getFruitSet() {
		return fruitSet;
	}

	public void setFruitSet(Set<String> fruitSet) {
		this.fruitSet = fruitSet;
	}

	public Map<String, String> getSportMap() {
		return sportMap;
	}

	public void setSportMap(Map<String, String> sportMap) {
		this.sportMap = sportMap;
	}

	public Properties getAnimalProps() {
		return animalProps;
	}

	public void setAnimalProps(Properties animalProps) {
		this.animalProps = animalProps;
	}

	@Override
	public String toString() {
		return "AllCollectionType:\n [numberArray=" + Arrays.toString(numberArray) + "\n nationList=" + nationList
				+ "\n fruitSet=" + fruitSet + "\n sportMap=" + sportMap + "\n animalProps=" + animalProps + "]";
	}

}
```

注意集合注入的写法：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.springframework.org/schema/p"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"
>	
    
	<bean id="allCollectionType" class="com.collection.AllCollectionType">
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
				<entry key="volleyball" value="排球"></entry>
				<entry key="football" value="足球"></entry>
				<entry key="basketball" value="篮球"></entry>
			</map>
		</property>
		<!-- Properties的注入 -->
		<property name="animalProps">
			<props>
				<prop key="cat">猫</prop>
				<prop key="dog">狗</prop>
				<prop key="bird">鸟</prop>
			</props>
		</property>
	</bean>
    
</beans>
```

测试方法随便看看：

```java
@Test
void testColletionIOC() {
    @SuppressWarnings("resource")
    ApplicationContext context = new ClassPathXmlApplicationContext("applicaitonContext.xml");
    AllCollectionType allCollectionType = (AllCollectionType) context.getBean("allCollectionType");
    System.out.println(allCollectionType);
}
```

### 特殊值的注入

特殊值包括特殊字符、空值、null等。

property标签里的赋值不仅可用value属性，还可用value标签。比如：

```xml
<bean id="student" class="com.simple.Student">
    <property name="name">
        <value type="java.lang.String">Tom</value>
    </property>
</bean>
```

用value属性注入和用value标签注入的区别：

|                          | value标签                                           | value属性               |
| ------------------------ | --------------------------------------------------- | ----------------------- |
| 参数值位置               | 双标签之间                                          | 即属性值，由双引号包裹  |
| type属性                 | 可选。指定数据类型                                  | 无                      |
| 参数值包含特殊字符如&、< | 使用`<![CDATA[]]>`标记<br>或使用xml预定义的实体引用 | 使用xml预定义的实体引用 |

xml预定义的部分实体引用见下表：

| 实体引用 | 表示符号 |
| -------- | -------- |
| `&lt;`   | <        |
| `&amp;`  | &        |
| `&gt;`   | >        |

其实同HTML的特殊字符集，故其他符号自己去查。

除上面的特殊符号外，再来看对空值和null（不引用任何对象）的处理。

```xml
<bean id="course" class="com.course.Course">
    <!-- 空字符串 -->
    <property name="courseName" value=""></property>
    <!-- 注意常识，整型无空值 -->
    <property name="credit">
        <value>2</value>
    </property>
    <property name="teacher">
        <null/>
    </property>
</bean>
```

```xml
<!-- 空字符串的另一种处理方法 -->
<property name="courseName">
    <value></value>
</property>
```

```shell
# 输出结果
Course [courseName=, teacher=null, credit=2]
```

### 自动装配

遵循约定优于配置的思想。

自动装配只针对对象，因为仅对象才具有依赖关系，基本类型不支持依赖关系，且IOC容器里只有对象才配有bean标签。

```xml
<bean id="teacher" class="com.course.Teacher">
    <constructor-arg value="Van"></constructor-arg>
    <constructor-arg value="male"></constructor-arg>
    <constructor-arg value="21"></constructor-arg>
</bean>
<!-- autowire明面上的值虽然是byName，实质是byId  -->
<bean id="course" class="com.course.Course" autowire="byName">
	<property name="courseName">
		<value>Spring入门</value>
	</property>
	<property name="credit">
		<value>2</value>
	</property>
    <!-- 不用手动写name值为teacher的property标签，容器会自动找id值等同于本bean中ref属性值的bean -->
</bean>
```

autowire的值除了byName，还有byType，即通过类型来匹配，如果有多个同类型的bean那就报错，还有constructor，即通过构造器（实质是参数列表）来匹配。

可一次性给容器里的所有bean设置自动装配，在bean标签中写：

```xml
default-autowire="byName"
```

局部属性可覆盖全局属性。

应强调，自动装配虽然减少了代码量，但不宜用得太多，因为降低了可读性。

### 用注解注入

千呼万唤始出来，注解才是王道，我们将注解作为单独的一种注入实现方式拎出来讲。

通过注解将bean（包括其属性）注入容器。步骤如下：

1. 声明某类加入IOC容器：

   ```java
   package com.course;
   
   import org.springframework.stereotype.Component;
   
   @Component("teacher")
   public class Teacher {
   	
   }
   ```

   注解的值等价于前面学的bean标签里的id值。

2. 开启对包的扫描：

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
   	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   	xmlns:p="http://www.springframework.org/schema/p"
   	xmlns:context="http://www.springframework.org/schema/context"
   	xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
       http://www.springframework.org/schema/context
   	http://www.springframework.org/schema/context/spring-context.xsd"
   >	
   	<!-- 进行包的扫描，看各个类是否配有相应注解，若有则加入IOC容器 -->
   	<context:component-scan base-package="包1，包2……" />
   </bean>
   ```
   
   相关约束规则鉴于第5、8、9行。

3. 属性的赋值

   ```java
   // Teacher类
   @Component("teacher")
   public class Teacher {
   
   	@Value("QianZhonshu")
   	private String teacherName;
   	@Value("male")
   	private String gender;
   	@Value("22")
   	private int age;
   
       // 注意如果写了有参构造器，那无参构造器也要写，否则bean无法产生
   }
   
   // Course类
   @Component("course")
   public class Course {
   
   	@Value("CS")
   	private String courseName;
   	@Autowired // 自动注入（装配），且用的是byType方式
   	@Qualifier("teacher") // byName，根据名字
   	private Teacher teacher;
   	@Value("2")
   	private int credit;
       
   }
   ```

Component注解的范围过广，故列举一些其他更细化、扫描效率更高的注解。

- dao层注解：@Respository。
- service层注解：@Service。
- controller层注解：@Contoller。

<span id="beanScope">注</span>：理解spring框架基于注解对web项目的管理。bean的默认加载方式是一次性加载而非延迟加载。以三层架构为例，项目（服务器）一启动，各个类如controller、service、dao等都会跟着加载，生成实例放在IOC容器中。此后容器里所有的bean或实例对象长期存在，供多线程使用（类级线程不安全，方法级线程安全），直至关闭服务器才被销毁。可使用lazy注解或bean标签的lazy-init属性实现延迟加载（懒汉式、懒加载）。

## 事务

事务（transaction）的目的：通过事务使得执行某方法时，要么一路成功，要么中途报错回到执行起始点。

注：使用新技术的套路：导包->配置->使用，配置方式又不外乎继承类、实现接口、打注解这几种。

### 导入jar包

除基本6个jar外，还需导入：

- spring-tx。
- 数据库相关jar包。
- commons-dbcp（数据源使用连接池）。
- commons-pool（连接池）。
- spring-jdbc。
- aopalliance。

### 配置

注意第6行，增加tx的命名空间。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.springframework.org/schema/p"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd
	http://www.springframework.org/schema/tx
   	http://www.springframework.org/schema/tx/spring-tx-3.0.xsd">	
   	<!-- 配置数据库相关 -->
	<!-- 数据源 -->
	<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
		<property name="driverClassName" value="com.mysql.cj.jdbc.Driver" />
		<property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false" />
		<property name="username" value="root" />
		<property name="password" value="root" />
	</bean>
	<!-- 核心配置：事务管理器txManager，依赖数据源 -->
	<bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
		<property name="dataSource" ref="dataSource"></property>
	</bean>
	<!-- 增加对事务的支持，依赖事务管理器 -->
	<tx:annotation-driven transaction-manager="txManager" />
    
	<!-- 进行包的扫描，看注解 -->
	<context:component-scan base-package="com.course" />
    
</beans>
```

### 使用

```java
package com;

import java.sql.SQLException;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

public class StudentServiceImpl implements IStudentService {

	// 此注解必需，其中属性暂时不用深究，真正要使用时参考相关文档
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = { SQLException.class,
			ArithmeticException.class })
	@Override
	public void addOneStudent(Student student) {
		// 方法1
		// 方法2
		// 方法3
	}

}
```

## AOP

Aspect-Oriented Programming，面向切面编程。

### 前置通知

顾名思义，前置通知能使得某方法执行前与其连接的前置方法自动执行，无需手动显式调用。那么同一个前置方法可切到多个方法前面，一个方法也可由多个前置方法所切。

通知方法所在的类叫通知类，被通知方法（业务方法）所在的类叫业务类。

把普通类变成有特殊功能的类的方法有：继承父类、实现接口、加注解、配置。

下面要把一个普通类变成一个特殊功能类-前置通知。

#### 导包

除基本的6个jar外，还需导入：

- aopalliance。
- aspectjweaver。

maven项目的pom.xml的依赖如下：

```xml
<dependencies>
	<!-- 面向切面：spring-aop -->
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-aop</artifactId>
		<version>4.3.9.RELEASE</version>
	</dependency>
	<!-- spring-beans -->
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-beans</artifactId>
		<version>4.3.9.RELEASE</version>
	</dependency>
	<!-- spring-context -->
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-context</artifactId>
		<version>4.3.9.RELEASE</version>
	</dependency>
	<!-- spring-core -->
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-core</artifactId>
		<version>4.3.9.RELEASE</version>
	</dependency>
	<!-- spring-expression -->
	<dependency>
		<groupId>org.springframework</groupId>
		<artifactId>spring-expression</artifactId>
		<version>4.3.9.RELEASE</version>
	</dependency>
	<!-- aopalliance -->
	<dependency>
		<groupId>aopalliance</groupId>
		<artifactId>aopalliance</artifactId>
		<version>1.0</version>
	</dependency>
	<!-- aspectjweaver -->
	<dependency>
		<groupId>aspectj</groupId>
		<artifactId>aspectjweaver</artifactId>
		<version>1.5.3</version>
	</dependency>
</dependencies>
```

#### 配置

添加[aop命名空间](https://www.w3cschool.cn/wkspring/omps1mm6.html)。

接着，在applicationContext.xml中编写：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.springframework.org/schema/p"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:aop="http://www.springframework.org/schema/aop"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
    					http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    					http://www.springframework.org/schema/context
						http://www.springframework.org/schema/context/spring-context.xsd
    					http://www.springframework.org/schema/aop 
    					http://www.springframework.org/schema/aop/spring-aop-3.0.xsd "
>	
	<!-- 进行包的扫描，看各个类是否配有注解，若有则加入IOC容器 -->
	<context:component-scan base-package="com.van"></context:component-scan>
	<bean id="student" class="com.van.entity.Student">
		<property name="stuNo" value="1"></property>
		<property name="stuName" value="Van"></property>
		<property name="stuGender" value="男"></property>
		<property name="stuAge" value="22"></property>
	</bean>
	<!-- 配置AOP -->
	<!-- 前置通知连接线的一端：前置通知类，即切面 -->
	<bean id="beforeAdvice" class="com.van.aop.BeforeAdvice"></bean>
	<!-- 业务类（被通知类）和通知类之间的关联，想象成一根连接线 -->
	<aop:config>
		<!-- 前置通知连接线的另一端：业务类方法，即切入点 -->
		<aop:pointcut expression="execution(public void com.van.service.impl.StudentServieImpl.deleteStudent(String)) or execution(public void com.van.service.impl.StudentServieImpl.addStudent(com.van.entity.Student))" id="pointcut"/>
		<!-- 前置通知连接线，属性包括切入点和切面 -->
		<aop:advisor advice-ref="beforeAdvice" pointcut-ref="pointcut"/>
	</aop:config>
</beans>
```

前置通知类：

```java
package com.van.aop;

import java.lang.reflect.Method;

import org.springframework.aop.MethodBeforeAdvice;

/**
 * 普通类实现MethodBeforeAdvice接口，变为前置通知类
 * 
 * @author Van
 */
public class BeforeAdvice implements MethodBeforeAdvice {

	/**
	 * 前置通知的具体内容写在before方法中
	 */
	@Override
	public void before(Method method, Object[] args, Object target) throws Throwable {
		System.out.println("执行前置通知方法");
	}

}
```

此处，被前置通知的方法是service层的方法，代码和效果省略。

### 后置通知

思想上与前置通知类似，一个类可实现AfterReturningAdvice接口来拥有后置通知能力。

后置通知类：

```java
package com.van.aop;

import java.lang.reflect.Method;

import org.springframework.aop.AfterReturningAdvice;

/**
 * 普通类实现AfterReturningAdvice接口，变为后置通知类
 * 
 * @author Van
 */
public class AfterAdvice implements AfterReturningAdvice {

	@Override
	public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
		System.out.println("执行后置通知方法");
		System.out.println("目标对象：" + target);
		System.out.println("目标方法名" + method.getName());
		System.out.println("目标方法参数个数" + args.length);
		System.out.println("目标方法返回值" + returnValue);
	}

}
```

配置方法和前置通知的一样。

### 异常通知

由异常通知接口可得，异常通知的实现类必须包含一个方法：

```java
public void afterThrowing([Method, args, target], ThrowableSubclass)
```

中括号包裹三个参数表示要么都有要么都没有。注意Method类型为java.lang.Reflect。

异常通知类：

```java
package com.van.aop;

import java.lang.reflect.Method;

import org.springframework.aop.ThrowsAdvice;

/**
 * 普通类实现ThrowsAdvice接口，变为异常通知类
 * 
 * @author Van
 */
public class ExceptionAdvice implements ThrowsAdvice {
	public void afterThrowing(Method method, Object[] args, Object target, Throwable exception) {
		System.out.println("执行异常通知方法");
		System.out.println("目标对象：" + target);
		System.out.println("目标方法名" + method.getName());
		System.out.println("目标方法参数个数" + args.length);
		System.out.println("异常信息" + exception.getMessage());
	}
}
```

配置方法和前面的两个是一样的。

只有在发生异常的时候，异常通知的方法才会执行。

### 环绕通知

环绕通知类：

```java
package com.van.aop;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

/**
 * 普通类实现MethodInterceptor接口，变为环绕通知类，可容纳前置、后置及异常通知，一箭三雕
 * 
 * @author Van
 */
public class AroundAdvice implements MethodInterceptor {

	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
		Object result = null;
		try {
			System.out.println("通过环绕通知实现前置通知");
			// 目标方法执行前切入前置通知
			result = invocation.proceed();// 执行目标方法，result为其返回值
			// 目标方法执行后切入后置通知
			System.out.println("通过环绕通知实现后置通知");
		} catch (Exception e) {
			// 此处切入异常通知
			System.out.println("通过环绕通知实现异常通知");
		}
		return result;
	}

}
```

### 用注解实现AOP

导包还是必不可少的。

需要开启注解对AOP的支持：

```xml
<!-- 开启注解对AOP的支持，使得Aspect注解生效 -->
<aop:aspectj-autoproxy></aop:aspectj-autoproxy>
```

通知类：

```java
package com.van.aop;

import java.util.Arrays;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

/**
 * 基于注解的通知类
 * 
 * @author Van
 */
@Component("adviceByAnnotation") // 将本类变为IOC容器的bean
@Aspect // 声明本类是一个通知类，类中方法可作任何一种切面（前置、后置、环绕、异常、最终）
public class AdviceByAnnotation {
	/**
	 * 前置通知 通知类和业务类在此处已连接起来，故无需再在容器中连接
	 * 
	 * @param joinPoint
	 */
	@Before("execution(public * addStudent(..))")
	public void myBefore(JoinPoint joinPoint) {
		System.out.println("基于注解的前置通知");
		System.out.println("执行前置通知方法");
		System.out.println("目标对象：" + joinPoint.getTarget());
		System.out.println("目标方法名" + joinPoint.getSignature().getName());
		System.out.println("目标方法参数" + Arrays.toString(joinPoint.getArgs()));
	}

	/**
	 * 后置通知 参数形式固定 想拿返回值，需要在注解中声明
	 * 
	 * @param joinPoint
	 * @param returningValue 返回值，名称固定
	 */
	@AfterReturning(pointcut = "execution(public * addStudent(..))", returning = "returningValue")
	public void myAfter(JoinPoint joinPoint, Object returningValue) {
		System.out.println("基于注解的后置通知");
		System.out.println("目标方法返回值：" + returningValue);
	}

	/**
	 * 环绕通知
	 * 
	 * @param joinPoint
	 */
	@Around("execution(public * addStudent(..))")
	public void myAround(ProceedingJoinPoint joinPoint) {
		// 前置通知
		try {
			joinPoint.proceed();// 控制目标方法的执行
			// 后置通知
		} catch (Throwable e) {
			// 异常通知
		} finally {
			// 最终通知
		}
	}

	/**
	 * 异常通知
	 * 
	 * @param joinPoint
	 * @param e 被捕获异常的类型需要在声明为参数 这里以空指针异常为例
	 */
	@AfterThrowing(pointcut = "execution(public * addStudent(..))", throwing = "e")
	public void myException(JoinPoint joinPoint, NullPointerException e) {
		System.out.println("基于注解的异常通知：" + e.getMessage());
	}

	@After("execution(public * addStudent(..))")
	public void myAfter() {
		System.out.println("基于注解的最终通知");
	}
}
```

### 用Schema实现AOP

暂弃。

## Spring Web

前面提到了，IOC容器的初始化会带动所有bean的生成及内部属性的赋值，那么IOC容器何时初始化呢？

```java
ApplicationContext context = new ClassPathXmlApplicationContext("applicaitonContext.xml");
```

答案如上，手动初始化。对于普通Java程序，这一句执行完毕，IOC容器便初始化了。

而对于Java Web程序，它没有主函数，如何初始化IOC容器呢？

思路：利用监听器监听tomcat启动与否，启动Web项目时就将IOC容器初始化。

可喜的是，spring-web这一jar包帮我们完成了这项工作。

### 导包

至少用到7个：前六个加上spring-web。

### 配置

项目启动会自动加载web.xml，故需要在web.xml中配置监听器。

```xml
<!-- spring监听器，用于初始化IOC容器 -->
<listener>
   <description>启动spring容器</description>
   <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
<!-- 指定IOC容器的位置-->
<context-param>
   <param-name>contextConfigLocation</param-name>
   <param-value>classpath:application.xml</param-value>
</context-param>
```

### 拆分配置文件



## 整合Mybatis

所有框架碰到Spring都得叫老大，让出控制权，所以我们常说Spring是整个项目的管家。

mybatis工作流程：SqlSessionFactory->SqlSession->StudentMapper->CRUD。

不难看出，mybatis最终是以SqlSessionFactory为入口操作数据库，那么Spring整合mybatis就是将SqlSessionFactory的交给Spring控制和管理。

### 导包

要素过多，此处省略。

### 配置

之前单用mybatis是通过mybatis全局配置文件来产生SqlSessionFactory的，那么现在整合，需通过spring管理SqlSessionFactory，这样一来全局配置文件内容大为减少，转移到spring配置文件中。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans" 
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd"
>

	<!-- 扫描包，去看类上面是否有相应的注解 -->
	<context:component-scan base-package="com.van" />
	<!-- 下面这个不是必须的,可有可无,(spring3.2版本前使用) 配上后兼容性好 -->
	<context:annotation-config />
	
	<!-- Spring整合mybatis -->
    <!-- 加载classpath下的db.properties文件，里面配了数据库连接的一些信息 -->
<context:property-placeholder location="classpath:db.properties"/>
	<!-- 配置数据源 -->
    <bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
		<property name="driverClassName" value="${driver}" />
		<property name="url" value="${url}" />
		<property name="username" value="${username}" />
		<property name="password" value="${password}" />
	</bean>
	<!-- 配置mybatis核心类SqlSessionFactory -->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <!-- 加载数据源 -->
        <property name="dataSource" ref="dataSource"/>
        <!-- 加载SQL映射文件 -->
        <property name="mapperLocations" value="classpath:com/van/dao/*.xml"></property>
        <!-- 加载mybatis全局配置文件 -->
        <property name="configLocation" value="classpath:mybatis-config.xml"></property>
    </bean>
	<!-- SQL映射文件扫描器，用于生成代理对象mapper，且可批量生成实现类 -->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    	<!-- 所扫描的包 -->
    	<property name="basePackage" value="com.van.dao"/>
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
    </bean>
    
</beans>
```

mybatis全局配置文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
	"http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
	<!-- 空空如也 -->
</configuration>

```

测试就省略了，可参考做过的项目。

生成mapper代理对象及dao层实现类有三种方法，知识点太杂也不好理解，此处省略，日后若用到再看视频。

## 全注解开发

注：做项目时一定要注意spirng等依赖和jdk版本的匹配问题。

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

给三层组件对应的类添加相应注解，在[用注解注入](#用注解注入)一节已提到过，代码就省略了。

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

为了有选择地将某些类纳入容器，我们可给组件扫描器制定规则。关于这部分的基础语法及解释可参考[spring文档](https://docs.spring.io/spring-framework/docs/4.3.22.RELEASE/spring-framework-reference/htmlsingle/)，此处只给出几个用例：

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

## Bean的作用域

详细理论参见spring文档[Bean scopes](https://docs.spring.io/spring-framework/docs/4.3.22.RELEASE/spring-framework-reference/htmlsingle/#beans-factory-scopes)。可将本章同前面的一处[注](#beanScope)交叉阅读。

这里主要谈两种作用域：

- singleton（默认）：单例。每个ioc容器中每个bean定义只对应一个对象实例。联系单例模式理解。
- prototype：原型或多实例。与上一种相反。

我们可以简单地验证一下第一种：

```java
ApplicationContext context1 = new AnnotationConfigApplicationContext(ApplicationContextConfig.class);
ApplicationContext context2 = new AnnotationConfigApplicationContext(ApplicationContextConfig.class);
User user1 = (User) context2.getBean("getUserBean");
User user2 = (User) context2.getBean("getUserBean");
// false
System.out.println(context1 == context2);
// true
System.out.println(user1 == user2);
```

于是发现可生成多个ioc容器，但在每个容器中，由某个bean只能得到唯一的对象，所以这里的user1和user2都是对同一块堆空间的引用，相当于对该空间引用两次。

singleton是默认作用域，我们显式地设置一下，同样有xml和注解两种方式。

```xml
<bean id="user" class="com.van.entity.User" scope="singleton"></bean>
```

```java
@Bean("getUserBean")
@Scope("singleton")
```

第二种的设置与上述两方式类似，就是改下值，改为prototype。

除了是否为单例上的不同，它们在加载时间上也有不同：prototype对应懒汉式，即容器在初始化时不创建对象（bean），直到使用（从容器获取对象如getBean方法）时才创建；singleton对应饿汉式，即初始化容器就创建了对象（bean）。

验证singleton的饿汉式也容易，借助构造方法：

```java
// 提前在构造方法中写一行打印语句 测试方法中不调用getBean方法
ApplicationContext context = new AnnotationConfigApplicationContext(ApplicationContextConfig.class);

// 打印结果
构造方法
```

我们希望既有单例又有懒加载（不浪费内存空间），通过xml或注解实现：

```xml
<bean id="user" class="com.van.entity.User" lazy-init="true"></bean>
```

```java
// 针对三层组件
@Controller
@Lazy

// 针对非三层组件
@Bean("getUserBean")
@Scope("singleton")
@Lazy
```

## 条件注解

有时候我们不希望某个bean在任何时候都被纳入容器，那么可通过设定条件来控制。

具体地，我们通过实现Condition接口，重写其方法，并以Condition注解为配合来完成。来看简单的例子：



