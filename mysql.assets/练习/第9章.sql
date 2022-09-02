-- 1.查询和Zlotkey相同部门的员工姓名和工资
SELECT last_name, salary
FROM employees
WHERE department_id = ( -- 要是有重名的等号得换成IN
	SELECT department_id
	FROM employees
	WHERE last_name = 'Zlotkey'
);

-- 2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
);

-- 3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
	SELECT MAX(salary)
	FROM employees
	WHERE job_id = 'SA_MAN'	
);

-- 4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id IN (
	SELECT DISTINCT department_id
	FROM employees
	WHERE last_name LIKE '%u%'
);


-- 5.查询在部门的location_id为1700的部门工作的员工的员工号
SELECT employee_id
FROM employees
WHERE department_id IN (
	SELECT department_id
	FROM departments
	WHERE location_id = 1700
);

-- 6.查询由King管理的员工姓名和工资
SELECT last_name, salary
FROM employees
WHERE manager_id IN (
	SELECT employee_id
	FROM employees
	WHERE last_name = 'King'
);

SELECT last_name, salary
FROM employees x
WHERE EXISTS (
	SELECT -1
	FROM employees
	WHERE last_name = 'King' AND employee_id = x.manager_id
);

-- 7.查询工资最低的员工信息: last_name, salary
SELECT last_name, salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);

-- 8.查询平均工资最低的部门信息
SELECT *
FROM departments
WHERE department_id = (
	SELECT department_id
	FROM employees
	GROUP BY department_id HAVING AVG(salary) = (
		SELECT MIN(avg_salary)
		FROM (
				SELECT AVG(salary) AS 'avg_salary'
				FROM employees
				WHERE department_id IS NOT NULL
				GROUP BY department_id
		) temp
	)
);

-- 9.查询平均工资最低的部门信息和该部门的平均工资（相关子查询），与上题不相关子查询对照
SELECT *, (
	SELECT AVG(salary)
	FROM employees
	WHERE department_id = depts.department_id -- 这里也体现相关
) AS 'min_avg_salary' -- 注意SELECT子句里子查询的写法
FROM departments depts
WHERE department_id = (
	SELECT department_id
	FROM (
			SELECT department_id, AVG(salary) AS 'avg_salary'
			FROM employees
			WHERE department_id IS NOT NULL
			GROUP BY department_id
	) x
	WHERE NOT EXISTS (
		SELECT -1
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id HAVING AVG(salary) < x.avg_salary
	)
);

-- 10.查询平均工资最高的 job 信息
SELECT *
FROM jobs
WHERE job_id = (
	SELECT job_id
	FROM employees
	GROUP BY job_id HAVING AVG(salary) >= ALL (
		SELECT AVG(salary)
		FROM employees
		GROUP BY job_id
	)
);

-- 11.查询平均工资高于公司平均工资的部门有哪些?
SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id HAVING AVG(salary) > (
	SELECT AVG(salary)
	FROM employees
);

-- 12.查询出公司中所有 manager 的详细信息
SELECT *
FROM employees x
WHERE EXISTS (
	SELECT -1
	FROM employees
	WHERE manager_id = x.employee_id
);

SELECT *
FROM employees
WHERE employee_id IN (
	SELECT manager_id
	FROM employees
);

-- 13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?
SELECT MIN(salary)
FROM employees
WHERE department_id IN (
	SELECT department_id
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id HAVING MAX(salary) <= ALL (
		SELECT MAX(salary) AS 'max_salary'
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
	)
);

-- 14.查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
SELECT *
FROM employees
WHERE employee_id = (
	SELECT manager_id
	FROM departments
	WHERE department_id = (
		SELECT department_id
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id HAVING AVG(salary) >= ALL (
			SELECT AVG(salary) AS 'avg_salary'
			FROM employees
			WHERE department_id IS NOT NULL
			GROUP BY department_id
		)
	)
);

-- 15. 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号
SELECT department_id
FROM departments x
WHERE department_id NOT IN (
	SELECT DISTINCT department_id
	FROM employees
	WHERE job_id = 'ST_CLERK'
);

SELECT department_id
FROM departments x
WHERE NOT EXISTS (
	SELECT -1
	FROM employees
	WHERE department_id = x.department_id AND job_id = 'ST_CLERK'
);

-- 16. 选择所有没有管理者的员工的last_name
SELECT last_name
FROM employees x
WHERE NOT EXISTS (
	SELECT -1
	FROM employees y
	WHERE x.manager_id = y.employee_id
); -- 虽然逻辑很高级，但太傻了

SELECT last_name
FROM employees
WHERE manager_id IS NULL;

-- 17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'
SELECT employee_id, last_name, hire_date
FROM employees
WHERE manager_id = (
	SELECT employee_id
	FROM employees
	WHERE last_name = 'De Haan'
);

-- 18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）
SELECT employee_id, last_name, salary
FROM employees x
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id HAVING department_id = x.department_id
);

-- 19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）
SELECT department_name
FROM departments
WHERE department_id IN (
	SELECT department_id
	FROM (
		SELECT department_id, COUNT(department_id) AS 'count'
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
	) temp
	WHERE count > 5
); -- 不相关子查询

SELECT department_name
FROM departments x
WHERE EXISTS (
	SELECT -1
	FROM departments y
	WHERE EXISTS (
		SELECT -1
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id HAVING department_id = y.department_id AND y.department_id = x.department_id AND COUNT(department_id) > 5
	)
);

SELECT department_name
FROM departments x
WHERE 5 < ( -- WHERE子句里放子查询
	SELECT COUNT(1)
	FROM employees
	WHERE department_id = x.department_id
); -- 相关，最高效

-- 20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）
SELECT country_id
FROM (
	SELECT DISTINCT country_id
	FROM locations
) x
WHERE EXISTS (
	SELECT -1
	FROM departments y
	WHERE EXISTS (
		SELECT location_id
		FROM locations
		WHERE country_id = x.country_id AND location_id = y.location_id
	)
	HAVING COUNT(department_id) > 2
);

SELECT country_id
FROM (
	SELECT DISTINCT country_id
	FROM locations
) x
WHERE 2 < (
	SELECT COUNT(DISTINCT department_id)
	FROM employees
	WHERE department_id IN (
		SELECT department_id
		FROM departments
		WHERE location_id IN (
				SELECT location_id
				FROM locations
				WHERE country_id = x.country_id
		)
	)
);


