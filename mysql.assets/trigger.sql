CREATE TABLE test_trigger_log (
 ID INT,
 t_log VARCHAR(50)
);

-- 由于中途出现分号，把结束符改成别的符号
DELIMITER //

-- 创建触发器
CREATE TRIGGER before_insert_emp
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
	INSERT INTO test_trigger_log(t_log)
	VALUES ('before insert');
END //

DELIMITER ; -- 改回来

DELIMITER $

CREATE TRIGGER after_insert_emp
AFTER INSERT ON emp
FOR EACH ROW
BEGIN
	INSERT INTO test_trigger_log(t_log)
	VALUES ('after insert')
END $

DELIMITER ;

DELIMITER //
CREATE TRIGGER salary_check
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
	DECLARE mgr_sal DOUBLE;
	SELECT salary INTO mgr_sal
	FROM emp
	WHERE NEW.manager_id = employee_id;
	IF NEW.salary > mgr_sal
		THEN SIGNAL SQLSTATE 'HY000' MESSAGE _TEXT = '薪资不能高于领导'
	END IF;
END $
DELIMITER ;

-- 查看触发器
SHOW TRIGGERS\G

SHOW CREATE TRIGGER salary_check;

-- 删除触发器
DROP TRIGGER IF EXISTS salary_check;

SELECT * FROM emp GROUP BY department_id;