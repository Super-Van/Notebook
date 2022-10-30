-- 最简单
SELECT 1 + 1 FROM DUAL;

-- 列的别名 as: alias MySQL允许单引号，但ANSI规范的是双引号，不要不守规矩，惹人笑话
SELECT employee_id AS "emp_id", last_name AS "lname", department_id AS dept_id
FROM employees;

-- 去重
SELECT DISTINCT department_id
FROM employees;

SELECT department_id
FROM employees
GROUP BY department_id;

-- 写在所有字段前面，对所有字段去重
SELECT DISTINCT salary, department_id
FROM employees;

-- 空值，仅指null，不包括空串''、0
SELECT employee_id, salary AS "月工资", salary * 12 * (1 + commission_pct) AS "年工资"
FROM employees;

-- 空值的处理，用函数
SELECT employee_id, salary AS "月工资", salary * 12 * (1 + IFNULL(commission_pct, 0)) AS "年工资"
FROM employees;

-- 有关键字冲突的时候只能用反引号 反引号也适用于列别名
SELECT * FROM `order`;

-- 常量
SELECT 'atguigu', employee_id, last_name
FROM employees;

-- 描述表结构，就是诸字段的详情
DESCRIBE employees;
DESC departments;

-- 过滤数据，或叫筛选，带WHERE子句
SELECT *
FROM employees
WHERE department_id = 90;
-- MySQL其实连字符串的大小写都不区分，不讲武德
SELECT *
FROM employees
WHERE last_name = 'king'; -- King也满足条件

-- 算术运算符
-- 同整型相除也可能得浮点型，DIV通过截断统一类型 零除不报错，返回NULL 余数符号与被模数符号一致
SELECT 1 + 1, 1 + 3 * 2, 1 + 2.5, 5 DIV 2, 100 DIV 2, 100 / 2, -4 MOD -3, -4 % -3, 3 / 0 
FROM DUAL;

-- SQL里的+没有拼接作用，某些情况下字符串隐式转换为其他类型
SELECT 100 + '1'
FROM DUAL;

-- 转换不了的作0处理，NULL与其他任何值作算术运算都得NULL
SELECT 100 + 'C', 100 + NULL, NULL / 2
FROM DUAL;

-- 比较运算符，单等号，有三种结果-真（1）、假（0）、NULL
SELECT 1 = 1, 1 = 2, 1 != 2, 1 = '1', 1 = 'a', 0 = 'a'
FROM DUAL;

-- 两边都是字符串，就没有隐式转换了
SELECT '1' = '1', 'a' = 'b'
FROM DUAL;

-- 只要NULL参与就得NULL
SELECT 1 = NULL, NULL = NULL
FROM DUAL;

SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct = NULL; -- 无结果，相当于WHERE NULL

-- 安全等于，专门解决NULL
SELECT 1 <=> NULL, NULL <=> NULL
FROM DUAL;

SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct <=> NULL; -- 与NULL比，是NULL的返回1，非NULL的返回0

-- 关键字IS
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NULL;

-- 以下三个等价
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

SELECT last_name, salary, commission_pct
FROM employees
WHERE NOT commission_pct IS NULL;

SELECT last_name, salary, commission_pct
FROM employees
WHERE NOT commission_pct <=> NULL;

SELECT LEAST('a', 'b', 'c'), GREATEST('a', 'b', 'c'), LEAST(1, 2, 3), GREATEST(1, 2, 3)
FROM DUAL;

-- 逐字符比较
SELECT LEAST(first_name, last_name)
FROM employees;

SELECT employee_id, last_name, salary
FROM employees
WHERE salary BETWEEN 6000 AND 8000; -- 闭区间，上下界不能交换

SELECT last_name, department_id
FROM employees
WHERE department_id IN (10, 20, 30);

SELECT last_name, department_id
FROM employees
WHERE department_id NOT IN (10, 20, 30);

SELECT last_name
FROM employees
WHERE last_name LIKE '%a%';

SELECT last_name
FROM employees
WHERE last_name LIKE '_a%';

SELECT last_name
FROM employees
WHERE last_name LIKE '_\_a%';

SELECT last_name
FROM employees
WHERE last_name LIKE '_$_a%' ESCAPE '$';

SELECT last_name
FROM employees
WHERE last_name REGEXP '^s.*n$';

-- 逻辑运算符
SELECT last_name, salary, department_id
FROM employees
WHERE salary > 6000 AND department_id = 50;

SELECT employee_id, last_name, salary
FROM employees
WHERE salary NOT BETWEEN 6000 AND 8000;

SELECT employee_id, last_name, salary
FROM employees
WHERE salary < 6000 OR salary > 8000;

-- 位运算符，用得很少
SELECT 12 | 5, 12 & 5, 12 ^ 5, 12 & ~ 5, ~ 5, 8 >> 1, 2 << 2
FROM DUAL;

-- 排序
SELECT employee_id, last_name, salary
FROM employees
ORDER BY salary DESC; -- 默认ASC

SELECT employee_id, last_name, salary * 12 AS "ANNUAL_SAL"
FROM employees
ORDER BY "ANNUAL_SAL"; -- 列别名可用于ORDER BY、HAVING，不能用于WHERE，因为是筛选出来后才生成列别名

SELECT employee_id, salary 
FROM employees
ORDER BY department_id; -- 可以按非查询字段排序

-- 多级排序
SELECT employee_id, salary 
FROM employees
ORDER BY department_id DESC, salary;

-- LIMIT
SELECT employee_id, last_name
FROM employees
LIMIT 0, 20; -- 偏移量0可省略

SELECT employee_id, last_name
FROM employees
LIMIT 20, 20;

SELECT employee_id, last_name
FROM employees
ORDER BY salary
LIMIT 0, 10; -- ORDER BY与LIMIT垫底，且先ORDER BY后LIMIT，这也是常识，比如找出总分前三名那肯定先排序后截取

-- 连接查询
-- 从优化角度，建议为每个字段指明所属表，多表情况下
SELECT employees.employee_id, employees.department_id, departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

SELECT emp.employee_id, emp.department_id, dept.department_name
FROM employees AS emp, departments AS dept -- 一旦指定了别名，后续逻辑就不能用原名
WHERE emp.department_id = dept.department_id;
-- 表别名若出现在WHERE、JOIN ON、ORDER BY等子句，则起别名时不能添双引号

SELECT e.last_name, d.department_name, l.city
FROM employees AS e, departments AS d, locations AS l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id;

-- 非等值连接
SELECT e.last_name, e.salary, j.grade_level
FROM employees AS e, job_grades AS j
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;

-- 自连接
SELECT emp.employee_id, emp.last_name, mgr.employee_id AS "manager_id", mgr.last_name AS "manager_name"
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id;

-- 结果集所有记录均满足连接条件的连接查询就是内连接，否则就是外连接，外连接分为左外连接与右外连接及全（满）外连接
-- 内连接 SQL99 
SELECT e.last_name, d.department_name, l.city
FROM employees AS e INNER JOIN departments AS d ON e.department_id = d.department_id JOIN locations AS l ON d.location_id = l.location_id; -- INNER可省略

-- 左外连接特征-保留左表的所有记录（其他条件满足），于是不满足连接条件的记录的右表所有分量一定是NULL
SELECT e.employee_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id;
-- 右外连接特征-保留右表的所有记录，于是不满足连接条件的记录的左表所有分量一定是NULL 
SELECT e.employee_id, d.department_name
FROM employees e RIGHT JOIN departments d ON e.department_id = d.department_id; -- OUTER可省略

-- UNION去重，UNION ALL不去重，去重要时间，故实际开发中尽量用后者
-- SQL99定义了7中UNION，MySQL不支持FULL OUTER JOIN，只好间接通过UNION实现
-- 1. 内连接 A交B
SELECT e.employee_id, d.department_name
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id;

-- 2. 左外连接 A
SELECT e.employee_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id;

-- 3. 右外连接 B
SELECT e.employee_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id;

-- 4. A-B即A交B在A上的补集，左外连接基础上去掉一部分
SELECT e.employee_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

-- 5. B-A即A交B在B上的补集，右外连接基础上去掉一部分
SELECT e.employee_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- 6. 满外连接=A并(B-A)或B并(A-B)
SELECT e.employee_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id
UNION ALL
SELECT e.employee_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- 7. (A-B)并(B-A)
SELECT e.employee_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL
UNION ALL
SELECT e.employee_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- 自然连接，自动将同名字段作连接字段并在结果中去掉同名两列中的一列，同名字段一多就不好了
SELECT e.employee_id, d.department_name
FROM employees e NATURAL JOIN departments d; -- 不用写ON子句，多了个NATURAL

-- 等价于
SELECT e.employee_id, d.department_name
FROM employees e INNER JOIN departments d ON e.department_id = d.department_id AND e.manager_id = d.manager_id;

-- 自然连接带USING，指定某组同名字段
SELECT e.employee_id, d.department_name
FROM employees e NATURAL JOIN departments d
USING (department_id)

-- 函数在不同DBMS之间的通用性很差

-- 单行函数：输入1个，输出多个；多行（聚集或分组）函数：输入多个，输出1个

-- 数值函数
SELECT ABS(-2), SIGN(0), SIGN(-2), PI(), CEIL(32.2), CEILING(-20.2), FLOOR(13.2), FLOOR(-2.5), MOD(-12, -5)
FROM DUAL;

-- 随机数（0-1）
SELECT RAND(), RAND(), RAND(10), RAND(10), RAND(-1), RAND(-1) -- 可带随机种子
FROM DUAL;

-- 四舍五入与截断 正数表示保留几位小数，负数表示从十位开始舍入到哪个整数位，默认（0）舍入到个位 TRUNCATE同理，但必须要指定第二个参数
SELECT ROUND(1.234), ROUND(1.235, 2), ROUND(123.5, -1), ROUND(150.5, -2), TRUNCATE(125.5, -1)
FROM DUAL;

-- 函数的嵌套调用
SELECT TRUNCATE(ROUND(1.53, 2),0)
FROM DUAL;

-- 三角函数，省略

-- 指数对数
SELECT POW(2, 3), POWER(2, 2), EXP(1), LN(EXP(2)), LOG2(8), LOG10(100), LOG(3, 9)
FROM DUAL;

-- 进制转换
SELECT BIN(10), HEX(10), OCT(10)
FROM DUAL;

-- 字符串函数
SELECT 
	ASCII('Apple'), -- 第一个字符的ASCII值
	CHAR_LENGTH('We'), CHAR_LENGTH('我们'), LENGTH('We'), LENGTH('我们') -- 一个中文字符占3字节，UTF-8中
FROM DUAL;

SELECT CONCAT(emp.last_name, ' works for', mgr.first_name) employment
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.manager_id;

SELECT CONCAT_WS('-', 'I', 'LOVE', 'HIM')
FROM DUAL;

-- 字符串的索引起始于1
SELECT
	INSERT('HelloVan', 6, 2, 'B'), -- HelloBn 从某位置开始替换，替换多少个字符，剩下的接在后面
	REPLACE('HelloVan', 'Van', 'Bob') -- 替换子串，找不到就保持原状
FROM DUAL;

SELECT UPPER('apple'), LOWER('MI')
FROM DUAL;

SELECT *
FROM employees
WHERE last_name = LOWER('king'); -- 即便如此，也能查出King，太不严谨了

-- 从左（右）开始取几个字符，越界了就是全取
SELECT LEFT('COFFEE', 4), RIGHT('HOME', 2), LEFT('COFFEE', 10)
FROM DUAL;

-- 补齐 RPAD-左对齐；LPAD-右对齐
SELECT employee_id, RPAD(last_name, 6, '-'), LPAD(salary, 10, '*') -- 数值到字符串的隐式转换
FROM employees;

SELECT TRIM('  l ove   '), LTRIM('  l ove   '), RTRIM('  l ove   '), TRIM('0' FROM '0 l ove 00') -- 扩展，去除指定字符
FROM DUAL;

-- 复制
SELECT REPEAT('I', 3)
FROM DUAL;

-- 空格
SELECT SPACE(2)
FROM DUAL;

-- 逐字符比较 1-左边大；-1-右边大
SELECT STRCMP('ac', 'abcde')
FROM DUAL;

-- 子串
SELECT SUBSTR('index', 2, 2)
FROM DUAL;

-- 子串位置，找不到返回0 普遍不区分大小写
SELECT LOCATE('D', 'index'), POSITION('D' IN 'index'), INSTR('index', 'D')
FROM DUAL;

-- 多选一
SELECT ELT(2, 'I', 'LOVE', 'HIM')
FROM DUAL;

-- 字符串在后面的字符串列表中首次出现的位置
SELECT
	FIELD('B', 'a', 'b', 'c'),
	FIND_IN_SET('b', 'a,b,c') -- 里面就不要了添空格了FROM DUAL;

-- 满足相等条件则返回NULL，否则返回第一个参数
SELECT employee_id, NULLIF(LENGTH(first_name), LENGTH(last_name)) compare
FROM employees;

-- 日期时间相关函数
-- 获取日期、时间 
SELECT
	-- 成对相同
	CURDATE(), CURRENT_DATE(), -- 仅日期
	CURTIME(), CURRENT_TIME(), -- 仅时间
	NOW(), SYSDATE(), -- 日期加时间
	UTC_DATE(), UTC_TIME(), -- 格林威治时间
	-- 数值形式
	CURRENT_DATE() + 0, CURRENT_TIME() + 0, NOW() + 0
FROM DUAL;

-- 日期与时间戳的转换 注意隐式转换
SELECT UNIX_TIMESTAMP(), UNIX_TIMESTAMP('2022-5-25 21:31:01'), FROM_UNIXTIME(1653485461)
FROM DUAL;

-- 获取年月日时分秒 后三个方法不难想到只能传时间了
SELECT YEAR(CURDATE()), MONTH('2020-4-1 21:31:01'), DAY(CURTIME()), HOUR(CURRENT_TIME()), MINUTE(CURRENT_TIME()), SECOND(CURRENT_TIME())
FROM DUAL;

SELECT
	MONTHNAME(CURRENT_DATE()), -- 月份名
	DAYNAME(CURTIME()), -- 星期几名
	WEEKDAY(CURRENT_TIME()), -- 星期几数（星期一是0）
	QUARTER(CURRENT_DATE()), -- 四季数（春天是1）
	WEEK('2018-01-6'), -- 当年的第几周（从0开始）
	DAYOFYEAR('2018-1-1'), -- 当年的第几天（从1开始）
	DAYOFMONTH(CURDATE()), -- 当月的第几天（从1开始）
	DAYOFWEEK(CURDATE()) -- 当周的第几天（星期天是0）
FROM DUAL;

-- 日期提取函数 FROM左侧值有很多种，自己去查
SELECT EXTRACT(SECOND FROM NOW()), EXTRACT(QUARTER FROM NOW())
FROM DUAL;

-- 时间与一天内秒数的转换
SELECT SEC_TO_TIME(79566), TIME_TO_SEC(NOW())
FROM DUAL;

-- 时间日期的计算 日期时间点的返回形式千奇百怪，不必刻意理解，反正能统一等价为时间戳
SELECT
	DATE_ADD(NOW(), INTERVAL 1 YEAR),
	DATE_ADD(NOW(), INTERVAL -1 MONTH),
	DATE_ADD('2020-03-2 15:04:01', INTERVAL 2 SECOND),
	DATE_ADD('2020-3-2', INTERVAL '1_2' YEAR_MONTH),
	DATE_SUB('2020-3-2', INTERVAL 1 MONTH),
	ADDDATE('2020-3-02', INTERVAL -1 SECOND),
	ADDDATE('2020-03-2', INTERVAL '2_10' MINUTE_SECOND),
	SUBDATE('2020-3-2', INTERVAL 30 DAY),
	ADDTIME(CURRENT_TIME(), 30), -- 30是秒数，一般写60秒以内的，以外的用下一种写法
	SUBTIME(NOW(), 2),
	SUBTIME(NOW(), '1:1:2'), -- 倒退1小时1分2秒
	DATEDIFF(NOW(), '2021-10-01'), -- 日期间隔天数
	TIMEDIFF('2021-10-1 00:00:00', NOW()), -- 时间间隔，结果以时:分:秒表示，右边比左边早才返回正数
	FROM_DAYS(366), -- 自0年1月1日起多少天后的日期
	TO_DAYS('2020-10-1'), -- 某日期距0年1月1日的天数
	LAST_DAY(NOW()), -- 某日期所在月的最后一天日期
	MAKEDATE(YEAR(NOW()), 12), -- 给定年份的第几天对应的日期
	MAKETIME(10, 21, 2),
	PERIOD_ADD(20220528110301, 20) -- 20是秒数
FROM DUAL;

-- 日期时间的格式化与解析，即日期时间与字符串的显式转换
SELECT
	DATE_FORMAT(NOW(), '%Y-%m-%d'), DATE_FORMAT(NOW(), '%Y.%c.%e'),
	TIME_FORMAT(NOW(), '%H:%i:%S'),
	DATE_FORMAT(NOW(), '%Y-%m-%d %k:%i:%S %W %r'),
	STR_TO_DATE('2022-5-28 11:35:41 Saturday', '%Y-%m-%d %k:%i:%S %W'), -- 按指定格式解析某字符串
	GET_FORMAT(DATE, 'ISO'), GET_FORMAT(TIME, 'ISO'), GET_FORMAT(DATETIME, 'USA'), -- 得到某种格式，不用手写格式了
	TIME_FORMAT(CURRENT_TIME(), GET_FORMAT(TIME, 'ISO'))
FROM DUAL;

-- 流程控制函数
SELECT last_name, commission_pct, IF(commission_pct IS NOT NULL, commission_pct, 0) "details", salary * 12 * (1 + IF(commission_pct IS NOT NULL, commission_pct, 0)) "annual_salary"
FROM employees;

-- IF条件更灵活，IFNULL只有判断是否为NULL的条件
SELECT last_name, commission_pct, IFNULL(commission_pct, 0) "details"
FROM employees;

-- 相当于多if-else
SELECT
	last_name,
	salary,
	CASE -- 适合非判等的情况
		WHEN salary >= 15000 THEN '高薪'
		WHEN salary >= 10000 THEN '潜力股'
		WHEN salary >= 8000 THEN '屌丝'
		ELSE '草根'
	END AS 'details', -- 省略也行，不过填的就是NULL了
	department_id
FROM employees;

-- 相当于switch-case
SELECT
	employee_id,
	last_name,
	department_id,
	salary,
	CASE department_id -- 适合判等的情况
		WHEN 10 THEN salary * 1.1
		WHEN 20 THEN salary * 1.2
		ELSE salary * 1.3
	END AS 'details'
FROM employees
WHERE department_id IN (10, 20, 30);

-- SQL天然体现了循环，更高级的循环在存储过程中

-- 加密与解密函数，现在推行尽早加密，在后台就该加密，不要等到数据库来做
SELECT
	MD5('MYSQL'),
	SHA('MYSQL') -- sha比md5更安全，两者是不可逆的，既然无法解密，那么验证用的就是暗文，这说明明文唯一对应暗文
FROM DUAL;

-- PASSWORD、ENCODE、DECODE函数被弃用了

-- MySQL信息函数
SELECT
	VERSION(),
	CONNECTION_ID(),
	DATABASE(),
	SCHEMA(),
	USER(),
	CURRENT_USER(),
	CHARSET('王阳明'),
	COLLATION('王阳明')
FROM DUAL;

-- 杂项
SELECT
	FORMAT(12.25, 1), FORMAT(12.25, 0), FORMAT(12.25, -2),
	CONV(16, 10, 2), CONV(NULL, 10, 2),
	INET_ATON('192.168.10.100'), INET_NTOA(3232238180),
	BENCHMARK(1000, MD5('PERFORMANCE')), -- 用于测试DBMS的执行性能，填的值永远是0，时间要看控制台
	CONVERT('王阳明' USING 'GBK')
FROM DUAL;

-- 常用聚集函数
SELECT
	AVG(salary), SUM(salary), -- 作用于非数值虽不报错，但没意义
	MAX(salary), MIN(salary), 
	SUM(commission_pct), AVG(commission_pct), -- 这不像+，NULL参与求和不会带偏其他的，不会得NULL
	MAX(last_name), -- 逐字符比较
	MAX(hire_date) -- 最近的
FROM employees;

-- 能排序的就能比较大小，就有最值
SELECT last_name, hire_date
FROM employees
WHERE hire_date >= '1997-01-01';

-- 含指定字段分量的记录数
SELECT
	COUNT(salary), COUNT(2 * salary), COUNT(2), -- 这个2就相当于每条记录的代号，最后统计总共有多少个2
	COUNT(commission_pct) -- NULL不会参与计数
FROM employees;
-- 哪一种效率高，得看存储引擎

-- 求平均奖金率，就不能简单地用AVG，它略过了奖金率为NULL的员工，会偏高
SELECT SUM(commission_pct) / COUNT(1), AVG(commission_pct)
FROM employees;

-- 分组 分量为NULL的会归到一组
SELECT department_id, AVG(salary), SUM(salary)
FROM employees
GROUP BY department_id;
-- 梳理顺序：WHERE->GROUP BY->ORDER BY->LIMIT

-- 多级分组
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id;

-- SELECT子句中非聚集函数字段必须出现在GROUP BY子句中
-- 像这样虽不报错，但没意义，所以注意有时能查出结果但不一定对
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id;

-- 汇总声明
SELECT department_id, AVG(salary), SUM(salary)
FROM employees
GROUP BY department_id WITH ROLLUP; -- 多出一条记录，对上面所以记录进行平均与求和
-- 那么WITH ROLLUP不要与ORDER BY同时出现，因前者只能位于末行

-- HAVING对分出来的组进行过滤，一般出现在GROUP BY子句中，WHERE是对记录进行过滤，先过滤记录，后过滤组
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id HAVING MAX(salary) > 20000;
-- 聚集函数只能出现在HAVING与SELECT子句中，而不能出现在WHERE子句中，即只能作用于组

-- 默认整表一个组
SELECT MAX(salary)
FROM employees
-- WHERE department_id = 10
HAVING MAX(salary) > 100;

-- 有意思的来了，WHERE PK HAVING
SELECT department_id, MAX(salary)
FROM employees
WHERE department_id IN (10, 20, 30, 40) -- 先过滤
GROUP BY department_id -- 后分组
HAVING MAX(salary) > 10000;

-- 两个结果是一样的，但上面的效率更高，下面这个做了无谓的分组
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id -- 先分组
HAVING MAX(salary) > 10000 AND department_id IN (10, 20, 30, 40); -- 后筛选组，不是边分组边筛选

-- SQL执行原理（可能）：FROM->ON->LEFT|RIGHT JOIN->WHERE->GROUP BY->HAVING->SELECT->DISTINCT->ORDER BY->LIMIT
-- 由此顺序可解释列别名不能在WHERE子句中使用

-- 子查询，可出现在除GROUP BY与LIMIT之外的任何子句中
SELECT last_name, salary
FROM employees
WHERE salary > (
	SELECT salary
	FROM employees
	WHERE last_name = 'Abel'
);

-- 非等值自连接等价实现
SELECT e1.last_name, e1.salary
FROM employees e1, employees e2
WHERE e2.last_name = 'Abel' AND e1.salary > e2.salary;
-- 看起来后者扫描次数少，更快，但其实前者更快，原理留待之后讨论，故实际应用中，常用多表连接而非嵌套查询

-- 术语：外查询（主查询）、内查询（子查询）
-- 子查询先于主查询执行，结果给主查询使用，推荐子查询写在操作符的右侧
-- 有单行子查询与多行子查询，视结果集记录数而定；有相关子查询与不相关子查询

-- 单行子查询，涉及一些单行操作符即比较运算符
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);
-- 用ORDER BY+LIMIT效率更高，但如果有多个人工资最低就不能用这个了

SELECT employee_id, manager_id, department_id
FROM employees
WHERE (manager_id = (
	SELECT manager_id
	FROM employees
	WHERE employee_id = 141
) AND department_id = (
	SELECT department_id
	FROM employees
	WHERE employee_id = 141
));

-- 这种写法了解即可，快不了多少，因为有索引，定位到目标记录极快
SELECT employee_id, manager_id, department_id
FROM employees
WHERE (manager_id, department_id) = (
	SELECT manager_id, department_id
	FROM employees
	WHERE employee_id = 141
);

SELECT department_id, MIN(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id HAVING MIN(salary) > (
	SELECT MIN(salary)
	FROM employees
	WHERE department_id = 50
);

SELECT
	employee_id,
	last_name,
	CASE department_id
		WHEN (
			SELECT department_id
			FROM departments
			WHERE location_id = 1800
		) THEN 'Canada'
		ELSE 'USA'
	END AS "location"
FROM employees;

-- 单行操作符接一个多行子查询会报错

-- 多行子查询，涉及多行操作符IN、ANY、ALL、SOME
SELECT last_name, job_id, salary
FROM employees
WHERE job_id <> 'IT_PROG' AND salary < ANY ( -- 等价于小于最大值，后者效率高
	SELECT salary
	FROM employees
	WHERE job_id = 'IT_PROG'
);
-- 有的题目描述得不严谨，死抠任一或任意相当于存在，高中课本里任一或任意相当于所有

-- 这种写法最简单，可惜MySQL里聚集函数不能嵌套，Oracle可以
SELECT department_id, MIN(AVG(salary))
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id;

-- 于是只能曲线救国
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id HAVING AVG(salary) = (
	SELECT MIN(salary) -- 注意外面要再套一层去找部门号，这里直接查出来不一定对应最小值
	FROM (
		SELECT department_id, AVG(salary) AS "salary"
		FROM employees
		WHERE department_id IS NOT NULL
		GROUP BY department_id
	) temp -- 嵌在FROM后面的子查询结果要有表名
);

--  这个用到ALL
SELECT department_id, AVG(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id HAVING AVG(salary) <= ALL (
	SELECT AVG(salary)
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id
);

-- 相关子查询：内查询使用外查询的列，相关子查询与等价的不相关子查询谁效率更高，自己算时间复杂度
SELECT last_name, salary, department_id
FROM employees e1
WHERE salary > (
	SELECT AVG(salary)
	FROM employees e2
	WHERE department_id = e1.department_id -- 外查询当前记录的部门号
);

-- 等价地，在FROM子句中写子查询，加上连接
SELECT emp.last_name, emp.salary, emp.department_id
FROM employees emp, (
	SELECT department_id, AVG(salary) "salary"
	FROM employees
	GROUP BY department_id
) temp
WHERE emp.department_id = temp.department_id AND emp.salary > temp.salary;

-- 在ORDER BY子句中写子查询
SELECT employee_id, salary
FROM employees emp
ORDER BY (
	SELECT department_name
	FROM departments
	WHERE department_id = emp.department_id
);
-- 可等价为连接查询

SELECT x.employee_id, x.last_name, x.job_id
FROM employees x
WHERE 2 <= (
	SELECT COUNT(1)
	FROM job_history
	WHERE employee_id = x.employee_id
);

-- 等价的连接查询
SELECT x.employee_id, x.last_name, x.job_id, COUNT(x.employee_id)
FROM employees x JOIN job_history y ON x.employee_id = y.employee_id GROUP BY x.employee_id HAVING COUNT(1) >= 2;

-- 下面两个关键字以true结果为核心
-- EXISTS
SELECT employee_id, last_name, job_id, department_id
FROM employees emp
WHERE EXISTS ( -- 子查询遍历，只要有一条记录满足条件，这里就得到true，就不继续遍历
	SELECT 1 -- 子查询返回的是真假，不是数据，故列名随便
	FROM employees
	WHERE manager_id = emp.employee_id -- 重要的是条件，WHERE或HAVING都可
);

-- NOT EXISTS
SELECT department_id, department_name
FROM departments dept
WHERE NOT EXISTS ( -- 子查询遍历，只有结果集为空才得到true，所以会遍历所有
	SELECT 2
	FROM employees
	WHERE department_id = dept.department_id
);

-- 即使子查询中不出现相关列，也是多层循环，而且没意义
SELECT department_id
FROM employees
WHERE EXISTS (
	SELECT *
	FROM employees
	WHERE job_id = 'ST_CLERK' -- 遍历到第一条就得TRUE，返回到外层查询了
);

-- 相当于
SELECT department_id
FROM employees
WHERE TRUE;