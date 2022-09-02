-- 1. 创建数据库test01_office,指明字符集为utf8。并在此数据库下执行下述操作
CREATE DATABASE test01_office CHARACTER SET 'utf8';

-- 2. 创建表dept01
/*
字段 类型
id INT(7)
NAME VARCHAR(25)
*/
CREATE TABLE IF NOT EXISTS dept01 (
	id INT(7);
	`NAME`, VARCHAR(25)
);

-- 3. 将表departments中的数据插入新表dept02中
CREATE TABLE dept02
AS
SELECT *
FROM atguigudb.departments; -- 跨库

-- 4. 创建表emp01
/*
字段 类型
id INT(7)
first_name VARCHAR (25)
last_name VARCHAR(25)
dept_id INT(7)
*/
CREATE TABLE emp01 (
	id INT(7),
	first_name VARCHAR(25),
	last_name VARCHAR(25),
	dept_id INT(7)
);

-- 5. 将列last_name的长度增加到50
ALTER TABLE
MODIFY last_name VARCHAR(50);

-- 6. 根据表employees创建emp02
CREATE TABLE emp02
AS
SELECT *
FROM atguigudb.employees;

-- 7. 删除表emp01
DROP TABLE IF EXISTS emp01;

-- 8. 将表emp02重命名为emp01
RENAME TABLE emp02 TO emp01;

-- 9.在表dept02和emp01中添加新列test_column，并检查所作的操作
ALTER TABLE dept02, emp01
ADD test_column VARCHAR(10);

DESC TABLE dept02;

DESC TABLES emp01;

ALTER TABLE emp01, emp01
ADD test_column VARCHAR(10);

-- 10.直接删除表emp01中的列 department_id
ALTER TABLE emp01
DROP COLUMN department_id;


# 1、创建数据库 test02_market
CREATE test02_market;

# 2、创建数据表 customers
CREATE TABLE customers (
	c_num INT,
	c_name VARCHAR(50)，
	c_contact VARCHAR(50),
	c_city VARCHAR(50),
	c_birth DATE
);

# 3、将 c_contact 字段移动到 c_birth 字段后面
ALTER TABLE customers
MODIFY c_contact VARCHAR(50) AFTER c_birth;

# 4、将 c_name 字段数据类型改为 varchar(70)
ALTER TABLE customers
MODIFY c_name VARCHAR(70);

# 5、将c_contact字段改名为c_phone
ALTER TABLE customers
CHANGE c_contact c_phone VARCHAR(70);

# 6、增加c_gender字段到c_name后面，数据类型为char(1)
ALTER TABLE customers
ADD c_gender CHAR(1) AFTER c_name;

# 7、将表名改为customers_info
RENAME TABLE customers TO customers_info;

# 8、删除字段c_city
ALTER TABLE customers
DROP COLUMN c_city;


-- 1、创建数据库test03_company
CREATE TABLE test03_company;

-- 2、创建表offices
CREATE TABLE offices (
	officeCode INT,
	city VARCHAR(30),
	address VARCHAR(50),
	country VARCHAR(50),
	postalCode VARHCAR(25)
);

-- 3、创建表employees
CREATE TABLE employees (
	empNum INT,
	lastName VARCHAR(50),
	firstName VARCHAR(50),
	mobile VARCHAR(25),
	`code` INT,
	jobTitle VARCHAR(50),
	birth DATE,
	note VARCHAR(255),
	sex VARCHAR(5)
);

-- 4、将表employees的mobile字段修改到code字段后面
ALTER TABLE employees
MODIFY mobile VARCHAR(25) AFTER code;
-- 5、将表employees的birth字段改名为birthday
ALTER TABLE employees
CHANGE birth birthday DATE;

-- 6、修改sex字段，数据类型为char(1)
ALTER TABLE employees
MODIFY sex CHAR(1);

-- 7、删除字段note
ALTER TABLE employees
DROP COLUMN note;

-- 8、增加字段名favoriate_activity，数据类型为varchar(100)
ALTER TABLE employees
ADD favoriate_activity VARCHAR(100);

-- 9、将表employees的名称修改为 employees_info
RENAME employees TO employees_info;