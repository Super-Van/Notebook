-- 显示所有员工的姓名，部门号和部门名称
SELECT e.last_name, e.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id;

-- 查询90号部门员工的job_id和90号部门的location_id
SELECT e.job_id, l.location_id
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id LEFT OUTER JOIN locations l ON d.location_id = l.location_id
WHERE e.department_id = 90;

-- 优化，针对筛选条件，避免不必要的匹配
SELECT e.job_id, l.location_id
FROM (
	SELECT job_id, department_id
	FROM employees
	WHERE department_id = 90
) AS e INNER JOIN (
	SELECT department_id, location_id
	FROM departments
	WHERE department_id = 90
) AS d ON e.department_id = d.department_id INNER JOIN locations l ON d.location_id = l.location_id;

-- 选择所有有奖金的员工的 last_name , department_name , location_id , city
SELECT e.last_name, d.department_name, l.location_id, l.city
FROM (
	SELECT last_name, department_id
	FROM employees
	WHERE commission_pct IS NOT NULL
) e LEFT OUTER JOIN departments d ON e.department_id = d.department_id LEFT OUTER JOIN locations l ON d.location_id = l.location_id;

-- 选择city在Toronto工作的员工的 last_name , job_id , department_id , department_name
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id INNER JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e INNER JOIN (
	SELECT department_id, department_name
	FROM departments
	WHERE location_id IN (
		SELECT location_id
		FROM locations
		WHERE city = 'Toronto'
)) d ON e.department_id = d.department_id;

-- 查询员工所在的部门名称、部门地址、姓名、工作、工资，其中员工所在部门的部门名称为’Executive’
SELECT d.department_name, l.location_id, e.last_name, e.job_id, e.salary
FROM (
	SELECT department_id, location_id, department_name
	FROM departments
	WHERE department_name = 'Executive'
) d INNER JOIN employees e ON d.department_id = e.department_id INNER JOIN locations l ON d.location_id = l.location_id;

-- 选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式

-- 查询哪些部门没有员工
SELECT d.department_id, d.department_name
FROM departments d LEFT OUTER JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

SELECT department_id, department_name
FROM departments
WHERE department_id NOT IN ( 
	SELECT DISTINCT department_id
	FROM employees
	WHERE department_id IS NOT NULL -- IN 集合里不能有NULL
);

SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS ( 
	SELECT *
	FROM employees e
	WHERE d.department_id = e.department_id
);

-- 查询哪个城市没有部门
SELECT l.city
FROM locations l LEFT OUTER JOIN departments d ON l.location_id = d.location_id
WHERE d.department_id IS NULL;

-- 查询部门名为 Sales 或 IT 的员工信息
SELECT e.last_name, e.salary
FROM employees e INNER JOIN (
	SELECT department_id
	FROM departments
	WHERE department_name IN ('Sales', 'IT')
) d ON e.department_id = d.department_id;