-- 普通CTE
WITH cte_original
AS (
	SELECT AVG(salary) AS avg_sal
	FROM employees
) -- 不要分号

SELECT employee_id, last_name, salary, avg_sal, salary - avg_sal AS diff
FROM employees JOIN cte_original;

-- 递归CTE，自己调自己