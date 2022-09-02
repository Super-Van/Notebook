-- 1.where子句可否使用组函数进行过滤?
# 不能

-- 2.查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees;

-- 3.查询各job_id的员工工资的最大值，最小值，平均值，总和
SELECT job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id;

-- 4.选择具有各个job_id的员工人数
SELECT job_id, COUNT(1)
FROM employees
GROUP BY job_id;

-- 5.查询员工最高工资和最低工资的差距（DIFFERENCE）
SELECT MAX(salary) - MIN(salary) "DIFFERENCE"
FROM employees;

-- 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id HAVING MIN(salary) >= 6000;

-- 这个是错的，因为在分组前已经把各组的低工资记录都过滤掉了
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL AND salary >= 6000
GROUP BY manager_id;

-- 7.查询所有部门的名字，location_id，员工数量和平均工资，并按平均工资降序
SELECT dept.department_name, loc.location_id, COUNT(employee_id), AVG(salary)
FROM employees emp RIGHT OUTER JOIN departments dept ON emp.department_id = dept.department_id LEFT OUTER JOIN locations loc ON dept.location_id = loc.location_id
GROUP BY dept.department_id
ORDER BY AVG(salary) DESC;

-- 8.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT jobs.job_title, dept.department_name, MIN(salary)
FROM employees JOIN jobs ON employees.job_id = jobs.job_id RIGHT OUTER JOIN departments dept ON employees.department_id = dept.department_id
GROUP BY dept.department_id, jobs.job_id;
-- 已知所有员工都有工种，且所有工种都有员工