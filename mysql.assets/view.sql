-- 创建视图（相当于存起来的SELECT语句）
CREATE VIEW emp_view
AS
SELECT employee_id, last_name, salary
FROM emp;

-- 下面俩等价
CREATE VIEW emp_view
AS
SELECT employee_id emp_id, last_name lname, salary
FROM emp;

CREATE VIEW emp_view(emp_id, lname, salary)
AS
SELECT employee_id, last_name, salary
FROM emp;

-- 查看视图
SHOW TABLES; -- 含表及视图

DESC dept_sal_view;

SHOW TABLE STATUS LIKE 'emp_view' \G -- \G使得行列转置

SHOW CREATE VIEW emp_view;

-- 更新视图
CREATE VIEW dept_sal_view
AS
SELECT department_id, AVG(salary) avg_sal
FROM emp
WHERE department_id IS NOT NULL
GROUP BY department_id;

-- 下面俩更新都不成立，教材中讲了一般行列子集视图才可更新，且还得看表的约束情况，以及一些特殊的视图（尚待研究），且各DBMS各有要求
UPDATE dept_sal_view
SET avg_sal = avg * 1.5;

UPDATE dept_sal_view
SET department_id = department_id * 2;

-- 对定义在视图上的视图，基视图应是一个不可更新视图

-- 修改视图
CREATE OR REPLACE VIEW emp_view
AS
SELECT employee_id
FROM emp;

ALTER VIEW emp_view
AS
SELECT employee_id
FROM emp;

-- 删除视图
DROP VIEW IF EXISTS emp_view, dept_sal_view;