# 练习一
CREATE DATABASE test04_emp;

use test04_emp;

CREATE TABLE emp2(
	id INT,
	emp_name VARCHAR(15)
);

CREATE TABLE dept2(
	id INT,
	dept_name VARCHAR(15)
);

#1.向表emp2的id列中添加PRIMARY KEY约束
ALTER TABLE emp2
ADD PRIMARY KEY (id);

#2. 向表dept2的id列中添加PRIMARY KEY约束
ALTER TABLE dep2
ADD PRIMARY KEY (id);

#3. 向表emp2中添加列dept_id，并在其中定义FOREIGN KEY约束，与之相关联的列是dept2表中的id列。
ALTER TABLE emp2
ADD dept_id VARCHAR(15);

ALTER TABLE emp2
ADD CONSTRAINT FK_emp2_dept2_dept_id FOREIGN KEY(dept_id) REFERENCES dept2(id);

# 练习二
CREATE TABLE books (
	id INT,
	`name` VARCHAR(50),
	`authors` VARCHAR(100),
	price FLOAT,
	pubdate YEAR,
	note VARCHAR(100),
	num INT
);

-- 使用ALTER语句给books按如下要求增加相应的约束
ALTER TABLE books
MODIFY id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE books
MODIFY `name` VARCHAR(50) NOT NULL;

ALTER TABLE books
MODIFY `authors` VARCHAR(100) NOT NULL;

ALTER TABLE books
MODIFY price FLOAT NOT NULL;

ALTER TABLE books
MODIFY pubdate YEAR NOT NULL;

ALTER TABLE books
MODIFY num INT(11) NOT NULL;