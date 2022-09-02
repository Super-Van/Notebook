-- 查看某表的约束
SELECT *
FROM information_schema.table_constraints
WHERE table_name = 'employees'; -- 遍历所有库

-- 添加非空约束NOT NULL 所类型都能取NULL，只能设给某一列
CREATE TABLE tmp (
	id INT,
	last_name VARCHAR(20) NOT NULL,
	email VARCHAR(50) -- 像这个50也是一种约束
);

-- 前提是不能存在NULL分量
ALTER TABLE tmp
MODIFY email VARCHAR(50) NOT NULL;

-- 添加唯一约束UNIQUE 允许多个NULL分量
CREATE TABLE tmp (
	id INT UNIQUE, -- 列级约束
	last_name VARCHAR(20),
	email VARCHAR(50), 
	CONSTRAINT UQ_email UNIQUE(email) -- 表级约束，可填多列
);

ALTER TABLE tmp
ADD UNIQUE(sno);

ALTER TABLE tmp
ADD CONSTRAINT UQ_sno UNIQUE(sno, last_name);

ALTER TABLE tmp
MODIFY last_name VARCHAR(20) UNIQUE;

-- 添加唯一约束时会自动产生唯一索引，约束实际由这个索引控制，那么删约束就得靠删索引，索引名同约束名，多列时默认取首列名
ALTER TABLE tmp
DROP INDEX sno;

-- 一个表只能有一个主键PRIMARY KEY，要么列级要么表级，主键约束比UNIQUE更进一步，禁止NULL
CREATE TABLE tmp (
	id INT PRIMARY KEY,
	last_name VARCHAR(20)
);

CREATE TABLE tmp (
	id INT, -- 主属性自带唯一、非空约束
	last_name VARCHAR(20),
	CONSTRAINT PK_tmp PRIMARY KEY(id, last_name); -- 约束名总是PRIMARY，这里取的没用，CONSTRAINT PK_tmp可省略
);

ALTER TABLE tmp
ADD PRIMARY KEY(id);

-- 删除主键（实际开发中不要删，删主键就是删索引，破坏底层数据的存储结构B+，导致重新组织数据，没事找事）
ALTER TABLE tmp
DROP PRIMARY KEY;

-- 列值自增AUTO_INCREMENT 自增列必须是整型的，且带主键或唯一约束
CREATE TABLE tmp (
	id INT PRIMARY KEY AUTO_INCREMENT, -- 默认初值是1
	last_name VARCHAR(20)
);
-- 插入时对应字段就不用填，若实在是填了，填了0或NULL，则实际填的是自增值，否则按包括自己填的值及已删值（裂缝问题）在内的所有分量里的最大值继续自增。5.7版本重启服务可解决裂缝问题，即内存刷新了，只能去现有的所有分量中找最大值，而8.0有重做日志，关服务前会把自增值持久化到外存，启动时又读回来

ALTER TABLE tmp
MODIFY id INT AUTO_INCREMENT;

-- 删除自增功能
ALTER TABLE tmp
MODIFY id INT AUTO_INCREMENT;

-- 添加外键FOREIGN KEY 主表、父表、被参考表、被引用表；外键定义在从表、子表、参考表、引用表。引用的列必须有索引，即是主键或带唯一约束，因为引用的分量在主表内必须是唯一的，引用只能引唯一值。先创建主表，再创建从表；先删除从表（记录），再删除主表（记录）。创建外键时会为该列自动创建一个索引，名同列名，删除外键时须手动删除对应索引

CREATE TABLE sc (
	sno INT,
	cno INT,
	score INT,
	PRIMARY KEY (sno, cno),
	CONSTRAINT FK_sc_student_sno FOREIGN KEY sno REFERENCES student(sno), -- CONSTRAINT FK_sc_student_sno可省略
	CONSTRAINT FK_sc_student_cno FOREIGN KEY cno REFERENCES course(cno),
);

ALTER TABLE sc
ADD CONSTRAINT FK_sc_course_cno FOREIGN KEY(cno) REFERENCES course(cno) ON UPDATE CASCADE ON DELETE RESTRICT; -- 建议约束级别

-- 约束级别有CASCADE、SET NULL、NO ACTION、RESTRICT、SET DEFAULT

-- 删除外键
ALTER TABLE sc
DROP FOREIGN KEY FK_sc_course_cno;

SHOW INDEX FROM sc;

ALTER TABLE sc
DROP INDEX FK_sc_course_cno; -- 虽然索引名同列名，但通过外键名删

-- 添加CHECK约束 5.7不支持
CREATE TABLE tmp (
	id INT,
	last_name VARCHAR(15),
	gender CHAR(1) CHECK(gender IN ('男', '女')),
	salary DECIMAL(10, 2)
);

ALTER TABLE tmp
ADD CONSTRAINT CK_salary CHECK(salary > 500);

-- 添加DEFAULT约束
CREATE TABLE tmp (
	id INT,
	last_name VARCHAR(15),
	salary DECIMAL(10, 2) DEFAULT 2000;
);

-- 修改DEFAULT
ALTER TABLE tmp
MODIFY salary DECIMAL(10, 2) DEFAULT 4000;

-- 删除DEFAULT
ALTER TABLE tmp
MODIFY salary DECIMAL(10, 2);