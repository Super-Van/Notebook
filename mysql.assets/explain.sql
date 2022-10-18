-- 只针对SELECT，增删改的EXPLAIN同理 留心优化器的重构

-- table：表名，涉及到几张表就有几条记录，临时表（Extra分量会带有Using temporary）也算
EXPLAIN SELECT * FROM employees;

-- employees因在结果中靠上叫驱动表，departments叫被驱动表，连接时哪个表当驱动表看优化器的选择
EXPLAIN SELECT * FROM employees JOIN departments;

-- 有时是有多少个SELECT子句（一个SELECT子句对应一趟独立查询）就有多少个id
EXPLAIN SELECT * FROM employees WHERE department_id = 60 UNION SELECT * FROM employees WHERE hire_date > '1995-01-01 00:00:00';
-- 有时则不然，因优化器做了优化，将嵌套等价改为连接，那么就只有一个SELECT子句

-- select_type：SIMPLE-非UNION与嵌套的情形

-- PRIMARY-UNION时的左查询或嵌套（优化器未将其转化为连接）时的外查询
EXPLAIN SELECT * FROM employees WHERE department_id = 60 UNION SELECT * FROM employees WHERE salary > 8000;

-- UNION-UNION时的右查询
-- UNION RESULT-UNION的结果

EXPLAIN SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);
-- SUBQUERY-不相关子查询时的内查询

-- DEPENDENT SUBQUERY-相关子查询时的内查询

-- DEPENDENT UNION-带UNION的相关子查询的右查询

-- DERIVED-FROM子句里的子查询
EXPLAIN SELECT MIN(salary) 	FROM (SELECT department_id, AVG(salary) AS "salary"	FROM employees WHERE department_id IS NOT NULL GROUP BY department_id) AS tmp;
	
-- MATERIALIZED-被优化器物化了的子查询

-- partitions：可忽略

-- type（重要）：访问类型，按性能从好到差地讨论其取值

-- system：表中仅一条记录，且引擎为MyISAM

-- const：用唯一索引进行等值匹配
EXPLAIN SELECT * FROM employees WHERE employee_id = 100;

-- eq_ref：连接时对被驱动表用唯一索引进行连接字段的等值匹配
EXPLAIN SELECT employee_id, salary FROM employees emp ORDER BY (SELECT department_name FROM departments	WHERE department_id = emp.department_id);

-- ref：用非唯一索引进行等值匹配
EXPLAIN SELECT * FROM employees WHERE manager_id = 100;

ALTER TABLE employees ADD INDEX idx_mgr_id(manager_id);
-- fulltext

-- ref_or_null：承接ref，等值匹配的值可取NULL
EXPLAIN SELECT * FROM employees WHERE department_id = 80 OR department_id IS NULL;

-- index_merge：使用多个索引
EXPLAIN SELECT * FROM employees WHERE employee_id = 100 OR department_id = 50;

-- unique_subquery，IN接子查询被优化器转为EXISTS接的子查询，且对子查询表用唯一索引做等值匹配

-- range：范围查询-用索引进行非等值-集合（IN、OR、BETWEEN、比较运算符）的匹配
EXPLAIN SELECT * FROM employees WHERE department_id IN (30, 50, 90);

-- index：用到索引，但遍历整个索引

-- ALL：全表扫描
EXPLAIN SELECT * FROM employees;

-- 像阿里巴巴手册要求，至少是range，要求到ref，最好是const

-- possible_keys与key：可能用上的索引实际用到的索引，由优化器选定，成本最低不一定时间最短，可用的越多则甄选的开销越大

-- key len（重要）：针对联合索引，用到的列的长度之和，长度越大越好，说明用到的列越充分

-- ref：与索引列做等值匹配的另一方，常量值、字段名或func等
EXPLAIN SELECT * FROM employees WHERE last_name = 'king';

EXPLAIN SELECT * FROM employees e JOIN jobs j ON e.job_id = j.job_id;
EXPLAIN SELECT * FROM employees WHERE last_name = LOWER('king');

-- rows（重要）：预估读取的记录数，当然越小越好

-- filtered：?/rows，当然越大越好

-- Extra（重要）：自行解读具体的额外信息