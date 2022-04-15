# JDBC

参考视频：[JDBC核心技术视频教程](https://www.bilibili.com/video/BV1eJ411c7rf?spm_id_from=333.999.0.0)。

## 概述

做软件依赖很多数据，那么数据保存在什么地方比较好？

持久化（persistence）：把数据保存到可掉电式（断电之后，数据还在）存储设备。

持久化主要是是将内存中的数据存储在关系型数据库中，当然也可以存储在普通文件、XML文件中，只是不好管理。

JDBC（java database connectivity）意即java与数据库的连接，是一套连接、操作数据库的Java API，面向多种关系数据库，由一组用Java语言编写的类和接口组成，位于java.sql及javax.sql下。

让各数据库厂商基于这同一组规范来做驱动（实现类），方便程序的编写和项目的可移植性。

## 基本流程

导入对应数据库提供的驱动jar包。

加载并注册驱动程序。

获取连接对象，据此创建语句对象。

调用语句对象的方法执行SQL语句，可能返回结果集。

释放资源。

## 获取连接

java.sql.Driver接口是所有厂商提供的驱动程序必须实现的接口，开发者由此接口拿到数据库连接。例如：

```java
try {
    Driver driver = new com.mysql.cj.jdbc.Driver();
    // jdbc：主协议；mysql：子协议
    String url = "jdbc:mysql://localhost:3306/jdbc_learn";
    Properties info = new Properties();
    // 可直接设键值对
    info.setProperty("user", "root");
    info.setProperty("password", "root");
    // connect源码提示至少要有一个user和password
    Connection connection = driver.connect(url, info);
    // com.mysql.cj.jdbc.ConnectionImpl@693fe6c9
    System.out.println(connection);
} catch (SQLException e) {
    e.printStackTrace();
}
```

注：一般普通项目导入的jar包置于lib目录下，lib与src同级，分别对应外来的编译好的字节码与源文件的字节码（bin目录）。

为了增强项目的可移植性，我们不希望驱动包里的Driver实现类出现在源文件中，于是利用反射的动态性，绕过编译器检查，在运行时才确定具体的实现类。

```java
@Test
void testConnection2() throws InstantiationException, IllegalAccessException, ClassNotFoundException, SQLException {
    // 得到对应此实现类的Class对象
    Class driverCls = Class.forName("com.mysql.cj.jdbc.Driver");
    // 由Class对象造本类实例
    Driver driver = (Driver) driverCls.newInstance();
    Properties info = new Properties();
    info.setProperty("user", "root");
    info.setProperty("password", "root");
    Connection connection = driver.connect("jdbc:mysql://localhost:3306/jdbc_learn", info);
    System.out.println(connection);
}
```

更优雅地通过驱动程序管理器类java.sql.DriverManager注册实现类，然后由管理器非实现类获取连接：

```java
@Test
void testConnection3() throws SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
    // 用通配符，泛型就不指明为Object，而仍保持未知
    Class<?> driverCls = Class.forName("com.mysql.cj.jdbc.Driver");
    Driver driver = (Driver) driverCls.newInstance();
    // 注册驱动实现类（的对象）
    DriverManager.registerDriver(driver);
    // 由管理器拿连接
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc_learn", "root", "root");
    System.out.println(connection);
}
```

进一步地，我们可以缩略：

```java
@Test
void testConnection4() throws ClassNotFoundException, SQLException {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/jdbc_learn", "root", "root");
    System.out.println(connection);
}
```

因为第3行相当于加载实现类（把实现类字节码放进内存），而加载的时候这个类的有一段静态代码块会执行，具体执行的就是实例化实现类并注册。

最后将用户名、密码等信息抽离到配置文件中，好处有：

- 以硬编码形式存在，简单来说就是减小CPU的负担，CPU处理软编码，硬编码交给GPU去做。
- 解耦-代码与配置数据相分离，从而避免源代码的修改，改代码一来违反开闭原则，二来得重新打包源文件开销很大。

```properties
driver=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/jdbc_learn
user=root
password=root
```

```java
try {
    // 使用文件流，相对路径起始于项目根目录
    // FileInputStream fis = new FileInputStream("src\\jdbc.properties");
    // 使用类加载器，相对路径起始于源文件目录即src
    InputStream is = ConnectionTest.class.getClassLoader().getResourceAsStream("jdbc.properties");
    Properties info = new Properties();
    info.load(is);
    Class.forName(info.getProperty("driver"));
    Connection connection = DriverManager.getConnection(info.getProperty("url"), info);
    System.out.println(connection);
} catch (ClassNotFoundException | SQLException | IOException e) {
    e.printStackTrace();
}
```

由于tomcat部署项目的时候，会丢弃src之外的东西，故我们把配置文件置于src内。

## CRUD

CRUD：create-创建、read-读取（查询）、update-更新（修改）、delete-删除。

有了Connection对象之后，就能向数据库发送SQL语句及其他命令，并接收返回结果。对数据库的操作由三个接口担纲：

- Statement：执行静态SQL语句并返回结果。
- PreparedStatement：Statement的子接口，预编译SQL语句并存于实现类实例中，从而更高效地执行此语句。
- CallableStatement：执行存储过程。

Statement很少用了，因为有弊端，主要是SQL注入的问题。我们看下面这个例子：

```java
@Test
void testLogin() {
    String username = "AABB";
    String password = "123' or '1' = '1";
    // 要拼上单引号
    String sql = "select user, password from user_table where user = '" + username + "' and password = '" + password
            + "'";
    UserTable userTable = get(sql, UserTable.class);
    if (userTable == null) {
        System.out.println("查无此人");
    } else {
        System.out.println(userTable);
    }
}

/**
 * 泛型方法-通用的动态的查询，查询单条记录
 * 
 * @param <T> 不确定的或未知的目标类-通用性
 * @param sql
 * @param cls 利用反射，传入目标类T的Class实例
 * @return
 */
public <T> T get(String sql, Class<T> cls) {
    T t = null;
    Connection connection = null;
    Statement statement = null;
    try {
        // 连接与注册
        InputStream is = StatementTest.class.getClassLoader().getResourceAsStream("jdbc.properties");
        Properties info = new Properties();
        info.load(is);
        Class.forName(info.getProperty("driver"));
        connection = DriverManager.getConnection(info.getProperty("url"), info);
        statement = connection.createStatement();
        statement.executeQuery(sql);
        ResultSet rs = statement.getResultSet();
        // 结果集元数据（表头）
        ResultSetMetaData metaData = rs.getMetaData();
        // 确认本方法只查一条记录
        if (rs.next()) {
            // 构造目标类的对象
            t = cls.newInstance();
            // 遍历表头
            for (int i = 0; i < metaData.getColumnCount(); i++) {
                // 得到列名 列号从1开始
                String columnLabel = metaData.getColumnLabel(i + 1);
                // 根据列名取属性名
                Field filed = cls.getDeclaredField(columnLabel);
                // 设属性值
                filed.setAccessible(true);
                filed.set(t, rs.getObject(columnLabel));
            }
        }
        return t;
    } catch (ClassNotFoundException | SQLException | IOException | NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException | InstantiationException e) {
        e.printStackTrace();
    } finally {
        // 关闭资源
        try {
            if (statement != null) {
                statement.close();
            }
        } catch (SQLException e1) {
            e1.printStackTrace();
        }
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    return null;
}
```

注：get方法可是理解反射的绝佳例子，须细细品味。

执行测试方法会成功的，然而真实密码是123456，看阴间的第4行，这就是一个典型的SQL注入。

为了避免此问题，转而使用PreparedStatement。看个例子：

```java
Connection connection = null;
PreparedStatement ps = null;
try {
    // 连接省略
    // 预编译SQL语句并返回PreparedStatement实例 带占位符
    String sql = "insert into customers(name, email, birth) values(?, ?, ?)";
    ps = connection.prepareStatement(sql);
    // 填充占位符 setString源码说了下标从1开始
    ps.setString(1, "苏轼");
    ps.setString(2, "poxian@song.com");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    // 两个Date对象的转换
    ps.setDate(3, new Date(sdf.parse("1037-04-11").getTime()));
    ps.executeUpdate();
} catch (Exception e) {
    e.printStackTrace();
} finally {
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
```

连接的获取和关闭是复用的，我们把抽取、封装到一个工具类中：

```java
public class DBUtils {
	/**
	 * 获取连接 每调一次就创建一个新连接
	 * 
	 * @return
	 * @throws Exception 最好往上抛，不然这里处理了外面拿不到连接对象
	 */
	public static Connection getConnection() throws Exception {
		InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("jdbc.properties");
		Properties info = new Properties();
		info.load(is);
		Class.forName(info.getProperty("driver"));
		Connection connection = DriverManager.getConnection(info.getProperty("url"), info);
		return connection;
	}

	/**
	 * 关闭诸资源
	 * 
	 * @param connection
	 * @param statement  可以将范围写大一点，更通用
	 */
	public s void closeResource(Connection connection, Statement statement) {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (statement != null) {
			try {
				statement.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
```

DML的套路是一样的，也可以将其封装成一个方法置于工具类中：

```java
/**
 * 通用DML，针对任意表、任意增删改
 * 
 * @param sql
 * @param args 填充各占位符的值
 * @return 1表成功；0表失败
 */
public static int dml(String sql, Object... args) {
    Connection connection = null;
    PreparedStatement ps = null;
    try {
        // 获取连接
        connection = getConnection();
        // 预编译，拿对象
        ps = connection.prepareStatement(sql);
        // 填充占位符
        for (int i = 0; i < args.length; i++) {
            ps.setObject(i + 1, args[i]);
        }
        // 执行 execute一定返回false，无法表征抛异常与否
        return ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 关闭资源
        closeResource(connection, ps);
    }
    return 0;
}
```

注：表名跟关键字冲突的话，可以包上反引号以区分，如：

```sql
update `order` set order_name = 'J' where order_id = 2;
```

通用的查询方法置于工具类中：

```java
/**
 * 通用查询
 * 
 * @param <T>  目标表对应的目标类
 * @param sql
 * @param cls  目标类的Class实例
 * @param args
 * @return 目标类对象列表
 */
public static <T> List<T> query(String sql, Class<T> cls, Object... args) {
    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        List<T> tList = new ArrayList<>();
        T t = null;
        connection = getConnection();
        ps = connection.prepareStatement(sql);
        for (int i = 0; i < args.length; i++) {
            ps.setObject(i + 1, args[i]);
        }
        // 执行返回结果集
        rs = ps.executeQuery();
        ResultSetMetaData metaData = rs.getMetaData();
        while (rs.next()) {
            t = cls.newInstance();
            for (int i = 0; i < metaData.getColumnCount(); i++) {
                // getColumnLabel比getColumnName更好，配合as关键字解决域名字段名不匹配的问题
                String columnLabel = metaData.getColumnLabel(i + 1);
                Field field = cls.getDeclaredField(columnLabel);
                field.setAccessible(true);
                field.set(t, rs.getObject(columnLabel));
            }
            tList.add(t);
        }
        // 不能写外面，因为这样的话抛异常返回空列表，不抛异常也可能返回空列表
        return tList;
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        closeResource(connection, ps, rs);
    }
    return null;
}
```

PreparedStatement依靠预编译（precompile）和占位符解决注入问题。Statement没有预编译，故注入前后SQL语句的逻辑会变，拿本章开头例子来说：

```sql
-- 本来是且的逻辑
select user, password from user_table where user = 'XXX' and password = 'XXX';
-- 可拼进来东西之后变成了或的逻辑
select user, password from user_table where user = 'AABB' and password = '123' or '1' = '1';
```

而PreparedStatement的预编译能让替换占位符的任何东西，都不被解析成SQL关键字，相当于给它们套了层反引号：

```sql
select user, password from user_table where user = ? and password = ?
select user, password from user_table where user = `'AABB'` and password = `'123' or '1' = '1'`
```

此外，PreparedStatement还有其他的好处：

- 批量执行的效率比Statement的更高。
- 可往占位符里填流，以适应数据库中的Blob数据。

插入带图像分量一条记录：

```java
Connection connection = null;
PreparedStatement ps = null;
try {
    connection = DBUtils.getConnection();
    String sql = "insert into customers values(?, ?, ?, ?, ?)";
    ps = connection.prepareStatement(sql);
    ps.setInt(1, 20);
    ps.setString(2, "joker");
    ps.setString(3, "333@google.com");
    // DBMS让字符串隐式转换为date
    ps.setObject(4, "1999-02-14");
    InputStream is = new FileInputStream("src\\hire.jpg");
    // 不能用setObject，因为它没有实现序列化接口
    ps.setBlob(5, is);
    ps.executeUpdate();
} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBUtils.closeResource(connection, ps);
}
```

查询带图像分量的一条记录：

```java
Connection connection = null;
PreparedStatement ps = null;
ResultSet rs = null;
InputStream bs = null;
OutputStream fos = null;
try {
    connection = DBUtils.getConnection();
    ps = connection.prepareStatement("select id, name, email, birth, photo from customers where id = ?");
    ps.setInt(1, 20);
    rs = ps.executeQuery();
    if (rs.next()) {
        Customer customer = new Customer();
        customer.setId(rs.getInt("id"));
        customer.setName(rs.getString("name"));
        customer.setEmail(rs.getString("email"));
        customer.setBirth(rs.getDate("birth"));
        // 让Customers的一个域引用大规模数据不好，于是这里用不了通用查询了
        bs = rs.getBinaryStream("photo");
        // 写出到本地
        fos = new FileOutputStream("src\\download.jpg");
        byte[] buffer = new byte[1024];
        int len = 0;
        while ((len = bs.read(buffer)) != -1) {
            fos.write(buffer, 0, len);
        }
        System.out.println(customer);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBUtils.closeResource(connection, ps, rs);
    try {
        if (fos != null) {
            fos.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
    try {
        if (bs != null) {
            bs.close();
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

关于批量操作，也是预编译和通配符在发挥作用。我们截一段关键代码看Statement的做法：

```java
for (int i = 0; i < 20000; i++) {
    statement.execute("insert into good(name) values(concat('name_','" + i + "'))");
}
//其他省略 时长是26秒多
```

数据库执行SQL语句完整来说有编译、执行及额外操作，Statement没有预编译，原封不动地把SQL语句交给数据库去编译并执行。那么就上段代码而言，数据库就做了2万次编译、2万次执行，且空间中假设垃圾回收很晚才开始，就最多存在2万个字符串。

再来看PreparedStatement的做法：

```java
// 用不了通用方法，它不支持批量操作
Connection connection = null;
PreparedStatement ps = null;
try {
    // 先不考虑建立连接的开销
    long start = System.currentTimeMillis();
    connection = DBUtils.getConnection();
    ps = connection.prepareStatement("insert into good(name) values(concat('name_', ?))");
    for (int i = 0; i < 20000; i++) {
        ps.setString(1, "" + i + 1);
        ps.executeUpdate();
    }
    long end = System.currentTimeMillis();
    // 24426 24秒
    System.out.println(end - start);
} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBUtils.closeResource(connection, ps);
}
```

PreparedStatement是先将语句编译好，再发给数据库执行，这一点从prepareStatement方法带语句参数可以看出。从上段代码看出就只编译1次（因为通配符是固定的，这个字符串也是固定的）、执行2万次，且空间中仅一个字符串。

进一步，我们可利用数据库自身的批量操作，压缩总的额外操作时间。

```properties
# 先要DBMS支持批量操作
url=jdbc:mysql://localhost:3306/jdbc_learn?rewriteBatchedStatements=true
```

```java
for (int i = 1; i <= 20000; i++) {
    ps.setString(1, "" + i);
    // 累积语句
    ps.addBatch();
    if (i % 500 == 0) {
        // 让DBMS批量执行
        ps.executeBatch();
        // 清空当前这一堆语句
        ps.clearBatch();
    }
}
// 其他省略 时长848
```

再进一步改进，将数据从缓存更新到原库的commit操作是花费一定时间的，上段代码体现了若干次提交，我们压缩成一次：

```java
// 关闭自动提交
connection.setAutoCommit(false);
ps = connection.prepareStatement("insert into good(name) values(concat('name_', ?))");
for (int i = 1; i <= 20000; i++) {
    ps.setString(1, "" + i);
    ps.addBatch();
    if (i % 500 == 0) {
        // 中途这里就不提交了
        ps.executeBatch();
        ps.clearBatch();
    }
}
// 一次性提交
connection.commit();
// 其他省略 时长767
```

## 事务

事务概念就不详讲了，其隔离特性跟线程安全很像。

数据一旦提交，就不可回滚。所以我们要避免在当前事务内隐式提交的情况，包括执行DDL、DCL、DML（部分数据库如此），关闭连接。譬如下例就是个典型的非事务：

```java
// 对MySQL而言，dml方法体内既有关闭连接的坑，又有DML的坑
DBUtils.dml("update user_table set balance = balance - 100", "AA");
DBUtils.dml("update user_table set balance = balance + 100", "BB");
```

据此我们改善通用DML方法，让连接从外部传进来，并且最后不关：

```java
/**
 * 通用DML改良版
 * 
 * @param connection 外部建立的连接
 * @param sql
 * @param args
 * @return
 */
public static int dmlBetter(Connection connection, String sql, Object... args) {
    PreparedStatement ps = null;
    try {
        ps = connection.prepareStatement(sql);
        for (int i = 0; i < args.length; i++) {
            ps.setObject(i + 1, args[i]);
        }
        return ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 里面不关连接，让外面去关
        closeResource(null, ps);
    }
    return 0;
}
```

附带讲，这样改一并解决了重复建立、关闭连接增大开销的问题，由此通用查询方法也得改。

然后还得解决DML的坑，即关闭DML的自动提交，注意这个关闭对DDL、关连接的隐式提交是无效的。

```java
Connection connection = null;
try {
    connection = getConnection();
    // 关闭DML自动提交
    connection.setAutoCommit(false);
    dmlBetter(connection, "update user_table set balance = balance - 100", "AA");
    dmlBetter(connection, "update user_table set balance = balance + 100", "BB");
    // 提交，更新原库
    connection.commit();
} catch (Exception e) {
    try {
        // 回滚，针对缓存，虽然不针对原库但对用户是有意义的
        connection.rollback();
    } catch (SQLException e1) {
        e1.printStackTrace();
    }
    e.printStackTrace();
} finally {
    // 妙啊，不用重载
    closeResource(connection, null);
}

// 插一句，后面要学的数据库连接池为保持连接复用的纯洁性，在关闭连接前把自动提交恢复为true
finally {
    try {
        connection.setAutoCommit(true);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    closeResource(connection, null);
}
```

关于事物四大特性及隔离性相关的并发问题，参阅Oracle笔记。四种隔离级别对并发性与同步性做了多级权衡。

注：MySQL支持SQL99标准定义的全部四种隔离级别，默认隔离级别为repeatable read。

下面通过JDBC验证MySQL默认的隔离级别：

```java
@Test
void testTransactionA() throws Exception {
    Connection connection = getConnection();
    // 关闭自动提交
    connection.setAutoCommit(false);
    // 查看默认隔离界别 可重复读
    System.out.println(connection.getTransactionIsolation());
    // 第一次查 2000
    String sql = "select user, password, balance from user_table where user = ?";
    List<UserTable> userTables1 = queryBetter(connection, sql, UserTable.class, "CC");
    System.out.println("事务A第一次查：" + userTables1.get(0));
    // 点完此方法马上去点下一个方法
    Thread.sleep(5000);
    // 第二次查 即使原库更新了，也还是2000
    List<UserTable> userTables2 = queryBetter(connection, sql, UserTable.class, "CC");
    System.out.println("事务A第二次查：" + userTables2.get(0));
}

@Test
void testTransactionB() throws Exception {
    Connection connection = getConnection();
    System.out.println(connection.getTransactionIsolation());
    // 关闭自动提交
    connection.setAutoCommit(false);
    // 第一次查 2000
    String selectSQL = "select user, password, balance from user_table where user = ?";
    List<UserTable> userTables1 = queryBetter(connection, selectSQL, UserTable.class, "CC");
    System.out.println("事务B第一次查：" + userTables1.get(0));
    // 执行update语句
    String updateSQL = "update user_table set balance = 3000 where user = ?";
    dmlBetter(connection, updateSQL, "CC");
    // 第二次查 3000
    List<UserTable> userTables2 = queryBetter(connection, selectSQL, UserTable.class, "CC");
    System.out.println("事务B第二次查：" + userTables2.get(0));
    connection.commit();
    // 连接不手动关闭的话，此连接会一直在DMBS中占着，导致内存泄漏，除非重启DBMS
}
```

## DAO

data access object-数据访问对象，是一组直接访问数据的类和接口，包括了纯粹CRUD，不包含任何业务逻辑。

首先定义一个通用的DAO，不针对具体的表，故应当是抽象类（虽无抽象方法）：

```java
/**
 * 对任意表的通用CRUD
 * 
 * @author Van
 *
 */
public abstract class BaseDao {
	/**
	 * 通用增删改
	 * 
	 * @param connection
	 * @param sql
	 * @param args
	 * @return
	 */
	public static int dml(Connection connection, String sql, Object... args) {
		PreparedStatement ps = null;
		try {
			ps = connection.prepareStatement(sql);
			for (int i = 0; i < args.length; i++) {
				ps.setObject(i + 1, args[i]);
			}
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(null, ps);
		}
		return 0;
	}

	/**
	 * 通用查询多条
	 * 
	 * @param <T>
	 * @param connection
	 * @param sql
	 * @param cls
	 * @param args
	 * @return 对象列表
	 */
	public static <T> List<T> queryList(Connection connection, String sql, Class<T> cls, Object... args) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			List<T> tList = new ArrayList<>();
			T t = null;
			ps = connection.prepareStatement(sql);
			for (int i = 0; i < args.length; i++) {
				ps.setObject(i + 1, args[i]);
			}
			rs = ps.executeQuery();
			ResultSetMetaData metaData = rs.getMetaData();
			while (rs.next()) {
				t = cls.newInstance();
				for (int i = 0; i < metaData.getColumnCount(); i++) {
					String columnLabel = metaData.getColumnLabel(i + 1);
					Field field = cls.getDeclaredField(columnLabel);
					field.setAccessible(true);
					field.set(t, rs.getObject(columnLabel));
				}
				tList.add(t);
			}
			return tList;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(null, ps, rs);
		}
		return null;
	}

	/**
	 * 通用查询一条
	 * 
	 * @param <T>
	 * @param connection
	 * @param sql
	 * @param cls
	 * @param args
	 * @return 一个对象
	 */
	public static <T> T queryOne(Connection connection, String sql, Class<T> cls, Object... args) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		T t = null;
		try {
			ps = connection.prepareStatement(sql);
			for (int i = 0; i < args.length; i++) {
				ps.setObject(i + 1, args[i]);
			}
			rs = ps.executeQuery();
			ResultSetMetaData metaData = rs.getMetaData();
			if (rs.next()) {
				t = cls.newInstance();
				for (int i = 0; i < metaData.getColumnCount(); i++) {
					String columnLabel = metaData.getColumnLabel(i + 1);
					Field field = cls.getDeclaredField(columnLabel);
					field.setAccessible(true);
					field.set(t, rs.getObject(columnLabel));
				}
			}
			return t;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(null, ps, rs);
		}
		return t;
	}

	/**
	 * 通用查询单值
	 * 
	 * @param <T>
	 * @param connection
	 * @param sql
	 * @param cls
	 * @param args
	 * @return
	 */
	public static <T> T queryValue(Connection connection, String sql, Object... args) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = connection.prepareStatement(sql);
			for (int i = 0; i < args.length; i++) {
				ps.setObject(i + 1, args[i]);
			}
			rs = ps.executeQuery();
			if (rs.next()) {
				return (T) rs.getObject(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(null, ps, rs);
		}
		return null;
	}
}
```

然后定义针对具体表的CRUD规范即接口：

```java
public interface CustomerDao {
	/**
	 * 将一个对象以记录形式插入表
	 * 
	 * @param connection
	 * @param customer
	 */
	void insert(Connection connection, Customer customer);

	/**
	 * 根据id删除记录
	 * 
	 * @param connection
	 * @param id
	 */
	void deleteById(Connection connection, int id);

	/**
	 * 根据新对象修改记录
	 * 
	 * @param connection
	 * @param customer
	 */
	void update(Connection connection, Customer customer);

	/**
	 * 根据id查一条记录
	 * 
	 * @param connection
	 * @param id
	 * @return 转成对象
	 */
	Customer selectById(Connection connection, int id);

	/**
	 * 查询所有记录
	 * 
	 * @param connection
	 * @return 转成对象列表
	 */
	List<Customer> selectAll(Connection connection);

	/**
	 * 查询总记录数
	 * 
	 * @param connection
	 * @return
	 */
	long selectCount(Connection connection);

	/**
	 * 查询最大生日
	 * 
	 * @param connection
	 * @return
	 */
	Date selectMaxBirth(Connection connection);
}
```

接着定义接口的实现类，它继承BaseDao以使用通用SQL方法：

```java
public class CustomerDaoImpl extends BaseDao implements CustomerDao {

	@Override
	public void insert(Connection connection, Customer customer) {
		String sql = "insert into customers(name, email, birth) values(?, ?, ?)";
		dml(connection, sql, customer.getName(), customer.getEmail(), customer.getBirth());
	}

	@Override
	public void deleteById(Connection connection, int id) {
		String sql = "delete from customers where id = ?";
		dml(connection, sql, id);
	}

	@Override
	public void update(Connection connection, Customer customer) {
		String sql = "update customers set name = ?, email = ?, birth = ? where id = ?";
		dml(connection, sql, customer.getName(), customer.getEmail(), customer.getBirth(), customer.getId());
	}

	@Override
	public Customer selectById(Connection connection, int id) {
		String sql = "select id, name, email, birth from customers where id = ?";
		return queryOne(connection, sql, Customer.class, id);
	}

	@Override
	public List<Customer> selectAll(Connection connection) {
		String sql = "select id, name, email, birth from customers";
		return queryList(connection, sql, Customer.class);
	}

	@Override
	public long selectCount(Connection connection) {
		String sql = "select count(id) from customers";
		return queryValue(connection, sql);
	}

	@Override
	public Date selectMaxBirth(Connection connection) {
		String sql = "select max(birth) from customers";
		return queryValue(connection, sql);
	}

}
```

针对诸方法做单元测试：

```java
class CustomerDaoImplTest {
	private CustomerDao dao = new CustomerDaoImpl();

	@Test
	void testInsert() {
		Connection connection = null;
		try {
			connection = getConnection();
			dao.insert(connection, new Customer(-1, "李白", "libai@google.com", new Date(2342342342L)));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

	@Test
	void testDeleteById() {
		Connection connection = null;
		try {
			connection = getConnection();
			dao.deleteById(connection, 20);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

	@Test
	void testUpdate() {
		Connection connection = null;
		try {
			connection = getConnection();
			dao.update(connection, new Customer(21, "杜甫", "dufu@outlook.com", new Date(2323235555555L)));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

	@Test
	void testSelectById() {
		Connection connection = null;
		try {
			connection = getConnection();
			Customer customer = dao.selectById(connection, 2);
			System.out.println(customer);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

	@Test
	void testSelectAll() {
		Connection connection = null;
		try {
			connection = getConnection();
			List<Customer> customers = dao.selectAll(connection);
			customers.forEach(System.out::println);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

	@Test
	void testSelectCount() {
		Connection connection = null;
		try {
			connection = getConnection();
			long count = dao.selectCount(connection);
			System.out.println(count);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

	@Test
	void testSelectMaxBirth() {
		Connection connection = null;
		try {
			connection = getConnection();
			Date maxBirth = dao.selectMaxBirth(connection);
			System.out.println(maxBirth);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeResource(connection, null);
		}
	}

}
```

针对其他表的规范接口和实现类同理，这里就不写了。

我们可对上述代码做些改进，解决诸查询方法中Class参数冗余的问题，详见项目jdbc。

## 数据库连接池

### 概述

此前随意的连接的获取与关闭存在以下问题：

- 每次DBMS建立连接包括加载连接到内存、验证用户等一些工作，断开连接也需要一些工作，合起来需要花费一定时间。那么巨大的数据库访问量就带来大量的时间与空间的开销。频繁、无上限的连接操作极端条件下能造成DBS的崩溃。

- 若连接未能手动关闭，就会导致DBMS的内存泄漏，除非重启数据库。

- 连接对象数不能被控制，没有上限，系统资源毫不顾惜地分配出去，也是最终造成DBS崩溃。

为了解决这些问题，引入数据库连接池技术。

它的思想是：在应用程序这一端为数据库连接准备一个缓冲池，预先在缓冲池内放置一定数量的连接，当需要时就从中取一个，用完之后放回（这只是形象化的说法，本质上是控制对象状态）。

它负责分配、管理、释放（由占用变可用）连接，允许某应用程序重复使用现有的连接，而无需另外新建。

最大数据库连接数决定了连接池最多或最少包含多少个连接，当某应用程序请求连接而无可用连接时，请求将进入等待队列。

它可根据占用超时的设定，强制释放连接，避免内存泄漏之类的问题。

优点梳理：

- 提高程序响应时间。
- 降低资源消耗。
- 便于连接管理。

### 使用

JDBC里用javax.sql.DataSource表示数据库连接池，DataSource只是一个接口，已经由各开源组织实现，如DBCP、C3P0、Proxool、BoneCP、Druid。

DataSource通称为数据源，包含连接池和连接池管理两部分，习惯上直接等同于连接池。它取代了DriverManager。

其他的就不演示了。只看Druid的，这是[文档](https://github.com/alibaba/druid)。

```properties
# 基本配置
driverClassName=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/jdbc_learn
username=root
password=root
# 管理性配置
initialSize=10
maxActive=10
```

```java
// 利用静态代码和静态域，只生成一个连接池
public class DruidUtils {
	private static DataSource source;
	static {
		try {
			Properties props = new Properties();
			InputStream is = new FileInputStream("src\\druid.properties");
			props.load(is);
			source = DruidDataSourceFactory.createDataSource(props);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static Connection getConnection() throws SQLException {
		return source.getConnection();
	}
}
```

```java
try {
    Connection connection = DruidUtils.getConnection();
    Customer customer = dao.selectById(connection, 2);
    System.out.println(customer);
} catch (SQLException e) {
    e.printStackTrace();
}
```

怎么导包请参考项目。

## Apache DBUtils

这是Apache提供的基于JDBC的一套工具API，包括通用SQL方法等，比我们写的更严谨、更丰富、健壮性更好。

详细示例就不给了，记得导包。

提一下其中的ResultHanddler接口，用于指定（记录）结果集以何种形式返回，体现于具体的实现类，如BeanHandler-单个对象、BeanListHandler-对象列表、MapHandler-等价为多键值对的单个对象等。我们也可定制一个实现类：

```java
try {
    QueryRunner runner = new QueryRunner();
    Connection connection = DruidUtils.getConnection();
    String sql = "select from customers where id = ?";
    // 模拟BeanHandler
    ResultSetHandler<Customer> handler = new ResultSetHandler<Customer>() {

        /**
         * 本方法的返回值就是query方法的返回值
         */
        @Override
        public Customer handle(ResultSet rs) throws SQLException {
            Customer customer = new Customer();
            if (rs.next()) {
                customer.setId(rs.getInt(1));
                customer.setName(rs.getString(2));
                customer.setEmail(rs.getString(3));
                customer.setBirth(rs.getDate(4));
            }
            return customer;
        }

    };
    Customer customer = runner.query(connection, sql, handler, 19);
    System.out.println(customer);
} catch (SQLException e) {
    e.printStackTrace();
}
```

