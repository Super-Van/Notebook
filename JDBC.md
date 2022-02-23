# JDBC

jdbc是Java操作数据库的唯一技术。

## 持久化

做软件需要保存很多数据，而数据保存到什么地方去？

持久化（persistence）：把数据保存到可掉电式存储设备（断电之后，数据还在，比如硬盘，U盘）中供以后使用。大多数情况下，特别是企业级应用，数据持久化意味着将内存中的数据保存到硬盘上加以“固化”，而持久化的实现过程大多通过各种关系数据库来完成，那么哪些东西可以做持久化？有以下三种：

- 记事本：通过流保存到记事本里面，但是记事本里面删除数据不容易，很少使用。

- XML：把数据存在XML，但是XML查找、删除、修改也比较麻烦。

- 数据库：把数据存在数据库，可以直接通过SQL取到，比较容易。

结论：持久化的主要作用是将内存中的数据存储在关系型数据库中，当然也可以存储在磁盘文件、XML文件中，只是比较麻烦。而要把数据保存到数据库，通过java代码去操作数据库，就必须通过JDBC访问数据库。在Java中，数据库存取技术只能通过JDBC访问数据库。

## 概述

### 概念

JDBC（java database connectivity）意即java与数据库的连接，是一种用于执行SQL语句（DML-数据操纵语言，manipulation；DDL-数据定义语言，definition；DQL-数据查询语言，query）的Java API，可以为多种关系数据库（Oracle、MySQL、SQL Server）提供访问。

### 组成

由一组用Java语言编写的类和接口组成，并由JDK提供。

### 作用

JDBC提供了一种标准，据此可以构建更高级的工具和接口，进而使数据库开发人员能够编写数据库应用程序。JDBC的API在哪里呢？在 JDK的API中。java.sql包装的就是JDBC的API，各大数据库厂商会针对JDBC的API提供各自的实现类即jar包（驱动包）。

JDBC访问数据库的形式主要有两种：

- 直接使用JDBC的API（Application Programming Interface）去访问数据库服务器。

- 间接使用JDBC的API去访问数据库服务器，即用框架封装替换JDBC，可用第三方ORM工具，如Hibernate, MyBatis等，它们的底层依然是JDBC。JDBC是java访问数据库的基石，其他技术都是对jdbc的封装。

## 使用

1. 导入对应数据库提供的驱动jar包。
2. 加载驱动包。只有注册了驱动，Java才能和数据库建立联系。关键语句：`Class.forName(“驱动名”) ;`意即使用反射注册MySQL驱动。此部分代码最好归于静态代码块，类加载的时候就执行，且只执行一次。
3. 获取连接对象，创建语句对象。
4. 执行SQL语句。
5. 释放资源。PreparedStatement、Statement、ResultSet、Connection等对象用完之后，需要释放，不然会一直占用内存。释放顺序：从里到外，先结果集对象，再语句对象，最后连接对象。

## CRUD

CRUD：create-创建、read-读取（查询）、update-更新（修改）、delete-删除。初级写法就是在dao里的impl里的xxxImpl.java中写增删改查各个方法。有些操作存在于多个方法体，譬如加载驱动、获取连接、关闭连接等，那么就需要进行代码重构。

## 代码重构

现在已经完成CRUD的功能，但是有些东西很不爽：

- try-catch 关闭资源的相关代码大量重复。
- 驱动名称、url、username、password 每次都要写，一旦数据库相关参数修改了，那么在代码里要改好多地方，故最好把这些东西抽取出来。
- Class.forName 和拿到连接也要写多次，故道理同上，抽取出来。
- 硬编码问题。此问题通过配置文件db.properties来解决。测试执行时代码里的用户名、密码等参数属硬解码，我们需将其放到资源文件db.properties中去以提高效率。

针对以上问题，改进、抽取之后的具体代码eclipse中均有保存，这里省略。

理解单例模式。工具类JDBCUtil中有加载驱动的静态代码块，及返回单例、获取连接、关闭连接三个方法。单例为静态变量，使得dao层代码创建工具类对象时，调用getInstance方法，驱动就会加载（因为类创建时，静态代码就会执行，那么该从类创建出的任意单例对象，都已加载驱动）。

## PreparedStatement

Statement表示静态SQL语句对象，PreparedStatement是Statement的子接口，表示预编译的SQL语句对象。 

预编译语句PreparedStatement 是java.sql中的一个接口，它是Statement的子接口。通过Statement对象执行SQL语句时，需要将SQL语句发送给DBMS，由 DBMS进行编译后再执行。预编译语句则不同，在创建PreparedStatement 对象时就将制定的SQL语句立即发送给DBMS进行编译（相较于前者提前了，这一点从conn.prepareStatement(sql)方法带参数可以看出），当预编译语句被执行时，DBMS直接运行编译后的SQL语句。

Statement和PreparedStatement的区别：

- 前者在创建语句对象时不需要传入sql，如：statement = conn.createStatement()，而后者在创建预编译语句对象时需要传入sql，如：ps = conn.prepareStatement(sql)。
- 在执行sql语句的时候，前者需要传入sql，而后者不需要。

## 示例

下面这个是JDBC工具类：

```java
package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class JDBCUtil {
	private static Properties p = null;
	private static JDBCUtil instance = null;// 单例模式

	// 加载驱动，dao里的方法使用instance时，这个instance就是预加载好的
	static {
		p = new Properties();
		try {			p.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties"));
			Class.forName(p.getProperty("jdbc.driver"));
			instance = new JDBCUtil();
		} catch (IOException | ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public static JDBCUtil getInstance() {
		return instance;// 返回静态变量instance，已加载驱动，为获取连接及后续操作做铺垫
	}

	public Connection getConn() {
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(p.getProperty("jdbc.url"), p.getProperty("username"),
					p.getProperty("password"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}

	public void close(ResultSet rs, PreparedStatement ps, Connection conn) {
		if (rs != null)
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				if (ps != null)
					try {
						ps.close();
					} catch (SQLException e) {
						e.printStackTrace();
					} finally {
						if (conn != null)
							try {
								conn.close();
							} catch (SQLException e) {
								e.printStackTrace();
							}
					}
			}
	}
}
```

下面这个是使用JDBC的代码：

```java
package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import dao.ProductDao;
import jdbc.JDBCUtil;
import model.Product;

public class ProductDaoImpl implements ProductDao {
	private JDBCUtil jdbc = JDBCUtil.getInstance();

	@Override
	public void insertProduct(Product product) {
		Connection conn = jdbc.getConn();
		PreparedStatement ps = null;
		String sql = "insert into product(productName,dir_id,salePrice,supplier,brand,cutoff,costPrice) values(?,?,?,?,?,?,?)";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, product.getProductName());
			ps.setLong(2, product.getDir_id());
			ps.setDouble(3, product.getSalePrice());
			ps.setString(4, product.getSupplier());
			ps.setString(5, product.getBrand());
			ps.setDouble(6, product.getCutoff());
			ps.setDouble(7, product.getCostPrice());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			jdbc.close(null, ps, conn);
		}
	}

	@Override
	public void deleteProduct(long id) {
		Connection conn = jdbc.getConn();
		PreparedStatement ps = null;
		String sql = "delete from product where id=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setLong(1, id);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			jdbc.close(null, ps, conn);
		}
	}

	@Override
	public void updateProduct(Product product) {
		Connection conn = jdbc.getConn();
		PreparedStatement ps = null;
		String sql = "update product set productName=? where id=1";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, product.getProductName());
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			jdbc.close(null, ps, conn);
		}
	}

	@Override
	public List<Product> selectProduct() {
		List<Product> productList = new LinkedList<>();
		Connection conn = jdbc.getConn();
		PreparedStatement ps = null;
		String sql = "select* from product";
		try {
			ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Product product = new Product(rs.getLong("id"), rs.getString("productName"), rs.getLong("dir_id"),
						rs.getDouble("salePrice"), rs.getString("supplier"), rs.getString("brand"),
						rs.getDouble("cutoff"), rs.getDouble("costPrice"));
				productList.add(product);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			jdbc.close(null, ps, conn);
		}
		return productList;
	}
}
```

下面这个是运用事务控制的代码：

```java
package service.impl;

import java.sql.Connection;
import java.sql.SQLException;

import dao.UserDao;
import dao.impl.UserDaoImpl;
import jdbc.JDBCUtil;
import model.User;
import service.UserService;

public class UserServiceImpl implements UserService {
	JDBCUtil jdbc = JDBCUtil.getInstance();
	Connection conn = jdbc.getConn();

	@Override
	public void transform(User from, User to, double balance) {
		UserDao dao = new UserDaoImpl();
		// 事务控制
		try {
			conn.setAutoCommit(false);
			from.setBalance(from.getBalance() - balance);
			to.setBalance(to.getBalance() + balance);
			dao.updateUser(from, conn);
			dao.updateUser(to, conn);
			conn.commit();
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		} finally {
			jdbc.close(null, null, conn);
		}
	}
}
```

