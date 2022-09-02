CREATE TABLE emp (
	id INT,
	`name` VARCHAR(15),
	hire_date DATE,
	salary DOUBLE(10, 2)
);

-- 插入一条记录
INSERT INTO emp
VALUES (1, 'Tom', '2000-12-1', 2500); -- 注意顺序 隐式转换

INSERT INTO emp (salary, hire_date, `name`, id) -- 自定字段顺序
VALUES (4000, NOW(), 'Bob', 2);

-- 插入多条
INSERT INTO emp
VALUES 
(3, 'zhang', '2002-1-1', 3000),
(4, 'li', '2003-1-1', 3000),
(5, 'wang', '2004-1-1', 3000);

INSERT INTO emp (id, `name`)
VALUES (4, 'John'); -- 没填的自动填默认值，没给默认值默认值就是null

-- 蠕虫复制，即基于现有的表
INSERT INTO emp
SELECT employee_id, last_name, hire_date, salary -- 字段依序一一对应，目标表字段类型长度不可小于原表对应字段类型长度
FROM atguigudb.employees
WHERE department_id IN (60, 70);

-- 更新记录 一般带WHERE子句，不带就是每条记录都受影响
UPDATE emp 
SET hire_date = CURDATE(), salary = salary * 1.5 -- 多字段
WHERE id = 3;

-- 删除记录 一般带WHERE子句
DELETE FROM emp
WHERE id = 200;

-- 8.0新特性-计算列，建表时声明，然后在插入记录时分量自动计算、修改时自动更新
CREATE TABLE calc (
	a INT,
	b INT,
	c INT GENERATED ALWAYS AS (a + b) VIRTUAL
);

INSERT INTO calc (a, b)
VALUES (1, 2);

UPDATE calc
SET a = 2
WHERE a = 1;