-- 查看系统变量
SHOW GLOBAL VARIABLES; -- 617个

SHOW SESSION VARIABLES; -- 640个
-- 两者有交集

-- 默认查会话系统变量
SHOW VARIABLES;

-- 模糊查询
SHOW VARIABLES LIKE 'admin_%';

SHOW VARIABLES LIKE 'character_%';

-- 精确查询
SELECT @@global.max_connections;

SELECT @@session.character_set_client;

SELECT @@character_set_client; -- 先找会话，找不到再找系统

-- 修改系统变量 一是通过my.ini修改，重启服务生效，二是用SET命令
-- 针对本次服务实例有效，重启就重置
SET @@global.autocommit = false;

SET GLOBAL max_connections = 171;

-- 改会话不影响全局，仅针对本次会话有效
SET @@session.autocommit = true;

SET SESSION character_set_client = 'gbk';

-- 缺省GLOBAL/SESSION，改的是会话
SET autocommit = 0;


-- 声明会话用户变量，作用域为当前会话
SET @nick_name = 'van';
SET @age := 22;
SET @a = 0;
SET @b = 1;
SET @add = @a + @b;

SELECT @count := COUNT(1)
FROM employees;

SELECT AVG(salary) INTO @avg_sal
FROM employees;

-- 查询会话用户变量
SELECT @avg_sal;