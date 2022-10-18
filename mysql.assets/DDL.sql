-- 使用默认的编码方式及排列规则utf8mb4、utf8mb4_0900_ai_ci
CREATE DATABASE test;

CREATE DATABASE test CHARACTER SET 'utf8';

-- 展示完整的创建语句
SHOW CREATE DATABASE test;

-- 避免创建时报重复异常，不存在才创建，否则啥都没干
CREATE DATABASE IF NOT EXISTS test CHARACTER SET 'utf8';

SHOW DATABASES;

USE test;

SHOW TABLES;

SHOW TABLES FROM mysql;

-- 当前数据库
SELECT DATABASE() FROM DUAL;

-- 一般改库就改字符集，且在建表前改，后期改成本就太大了 库名是改不了的
ALTER DATABASE test CHARACTER SET "utf8";

-- 删库
DROP DATABASE test;

DROP DATABASE IF EXISTS test;

-- 建表
CREATE TABLE IF NOT EXISTS emp (
	id INT,
	emp_name VARCHAR(15),
	hire_date DATE
);

-- 默认用本库的编码方式与排列规则
SHOW CREATE TABLE emp;

-- 基于查询，建表+插入，主键等约束不会一并带过来
CREATE TABLE emp_simple
AS
SELECT id, emp_name
FROM emp;

-- 基于查询，仅建表
CREATE TABLE emp_simple
AS
SELECT id, emp_name
FROM emp
WHERE 1 = 2; -- LIMIT 0

-- 描述结构
DESC emp_simple;

-- 修改表
-- 添加字段
ALTER TABLE emp
ADD salary DOUBLE(10, 2) FIRST; -- 默认追加为尾字段

ALTER TABLE emp
ADD phone VARCHAR(45) AFTER emp_name; -- 某字段后添加

-- 修改字段 一般不改类型，改长度、默认值、位置
ALTER TABLE emp
MODIFY emp_name VARCHAR(25) DEFAULT "anonymous";
-- 改长度有可能报错，因存在溢出的分量

-- 重命名字段
ALTER TABLE emp
CHANGE salary monthly_salary DOUBLE(10, 2); -- 类型还得跟着

-- 删除字段 分量连带被清空
ALTER TABLE emp
DROP COLUMN phone;

-- 重命名表
RENAME TABLE emp TO my_emp;

ALTER TABLE my_emp RENAME TO emp;

-- 删除表 包括结构与数据
DROP TABLE IF EXISTS emp_simple;

-- 清空表 先删除然后以原结构重建
TRUNCATE TABLE emp;

-- 删除多表 8.0才有DDL的原子化
DROP TABLE emp, emp_simple; -- 只要有一个失败前面的就回滚

