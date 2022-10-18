CREATE TABLE goods(
	id INT PRIMARY KEY AUTO_INCREMENT,
	category_id INT,
	category VARCHAR(15),
	`NAME` VARCHAR(30),
	price DECIMAL(10,2),
	stock INT,
	upper_time DATETIME
);

INSERT INTO goods(category_id, category, `NAME`, price, stock, upper_time)
VALUES
(1, '女装/女士精品', 'T恤', 39.90, 1000, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '连衣裙', 79.90, 2500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '卫衣', 89.90, 1500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '牛仔裤', 89.90, 3500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '百褶裙', 29.90, 500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '呢绒外套', 399.90, 1200, '2020-11-10 00:00:00'),
(2, '户外运动', '自行车', 399.90, 1000, '2020-11-10 00:00:00'),
(2, '户外运动', '山地自行车', 1399.90, 2500, '2020-11-10 00:00:00'),
(2, '户外运动', '登山杖', 59.90, 1500, '2020-11-10 00:00:00'),
(2, '户外运动', '骑行装备', 399.90, 3500, '2020-11-10 00:00:00'),
(2, '户外运动', '运动外套', 799.90, 500, '2020-11-10 00:00:00'),
(2, '户外运动', '滑板', 499.90, 1200, '2020-11-10 00:00:00');

-- 序号函数 按category_id分组，组内按price排序
-- ROW_NUMBER()：给组内记录标序号，序号单调递增
SELECT
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num, -- 因为是组内序号，故函数与操作都在派生列上
	id, category_id, category, `name`, price, stock
FROM goods;

-- RANK()：像ROW_NUMBER()，但对相等排序分量，标相同的序号，且后续若干序号空缺
SELECT
	RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num, -- 于是存在相等的row_num分量
	id, category_id, category, `name`, price, stock
FROM goods;

-- DENSE_RANK()：像RANK()，但无空缺
SELECT
	DENSE_RANK()() OVER(PARTITION BY category_id ORDER BY price DESC) AS row_num,
	id, category_id, category, `name`, price, stock
FROM goods;

-- 分布函数
-- PERCENT_RANK()：(RANK()结果 - 1) / (总记录数 - 1)
SELECT
	RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS r,
	PERCENT_RANK() OVER(PARTITION BY category_id ORDER BY price DESC) AS pr,
	id, category_id, category, `name`, price, stock
FROM goods;

SELECT
	RANK() OVER w AS r,
	PERCENT_RANK() OVER w AS pr,
	id, category_id, category, `name`, price, stock
FROM goods 
WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);

-- CUME_DIST()：所有记录中price分量小于等于当前price分量的记录数占总记录数几何
SELECT
	CUME_DIST() OVER(PARTITION BY category_id ORDER BY price DESC) AS cd, -- 关注ORDER BY
	id, category_id, category, `name`, price, stock
FROM goods;

-- 前后函数
-- LAG()：组内前若干条记录的某列分量
SELECT
	id, category_id, category, `name`,  stock, price, pre_price, price - pre_price AS diff -- 求逐级差价
FROM (
	SELECT
	id, category_id, category, `name`, price, stock,
	LAG(price, 1) OVER(PARTITION BY category_id ORDER BY price DESC) AS pre_price
FROM goods
) AS t;

-- LEAD()：方向相反

-- 首尾函数
-- FIRST_VALUE()：取组内某列最值
SELECT
	FIRST_VALUE(price) OVER (PARTITION BY category_id ORDER BY price) AS fv,
	id, category_id, category, `name`, price, stock
FROM goods;

-- NTH_VALUE()：取组内按某列排序后该列第几个分量
SELECT
	id, category_id, category, `name`, price, stock,
	NTH_VALUE(price, 2) OVER (PARTITION BY category_id ORDER BY price) AS second_value,
	NTH_VALUE(price, 3) OVER (PARTITION BY category_id ORDER BY price) AS third_value
FROM goods;

-- 其他