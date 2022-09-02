-- 隐式的创建就不举例了

-- 显式
CREATE TABLE book (
	book_id INT,
	book_name VARCHAR(100),
	`authors` VARCHAR(100),
	info VARCHAR(100),
	`comment` VARCHAR(100),
	year_publication YEAR,
	-- 作用就是基于book_name做查询时提升效率，尤当数据量大
	INDEX idx_bname(book_name)
);

-- 查看索引
SHOW INDEX FROM book;

SHOW CREATE TABLE book;

-- 先行感受EXPLAIN
EXPLAIN SELECT * FROM book WHERE book_name = 'mysql高级';

CREATE TABLE book (
	book_id INT,
	book_name VARCHAR(100),
	`authors` VARCHAR(100),
	info VARCHAR(100),
	`comment` VARCHAR(100),
	year_publication YEAR,
	-- 创建唯一索引字段组就必须保持唯一性
	UNIQUE INDEX idx_bname_cmt(book_name, `comment`)
);

-- 定义了主键就自动生成主键索引
-- 删除主键就自动删除主键索引
ALTER TABLE tmp
DROP PRIMARY KEY;

-- 创建联合索引
CREATE TABLE book (
	book_id INT,
	book_name VARCHAR(100),
	`authors` VARCHAR(100),
	info VARCHAR(100),
	`comment` VARCHAR(100),
	year_publication YEAR,
	-- 严格按照字段声明顺序搭建B+树
	INDEX mul_bid_bname_pub(book_name, `comment`, year_publication)
);

-- 像这样查索引就会失效，key分量为NULL
EXPLAIN SELECT * FROM book WHERE `comment` = '热销中';

-- 全文索引（对FULLTEXT）、空间索引（对GEOMETRY）略

-- 表已建立之后创建索引，两套等价
ALTER TABLE book
ADD INDEX idx_cmt(`comment`);

ALTER TABLE book
ADD UNIQUE INDEX uk_idx_bname(book_name);

ALTER TABLE book
ADD INDEX mul_bid_bname_info(book_id, book_name, info);

CREATE INDEX idx_cmt ON book(`comment`);

CREATE UNIQUE INDEX uk_idx_bname ON book(book_name);

CREATE INDEX mul_bid_bname_info ON book(book_id, book_name, info);

-- 删除索引，比如某时间段内进行大规模增删改，完了再添回来
-- 因唯一约束依赖唯一索引，删索引就是删约束，故若有AUTO_INCREMENT，则会阻止
ALTER TABLE book
DROP INDEX idx_cmt;

DROP INDEX uk_idx_bname ON book;

-- 删除字段，那么联合索引中的此字段也会跟着删除，B+树就会重构
ALTER TABLE book
DROP COLUMN book_name;
-- 最极端的是联合索引中的字段都被删了，那么这个B+树也就没了

-- 指定字段的升降序 8.0之后的InnoDB才支持，此前统一为升序
CREATE TABLE tmp (
	a INT,
	b INT,
	-- 先照a字段升序排列，再按b字段降序排列
	INDEX idx_a_b(a ASC, b DESC)
);

-- 就适合此类查找
SELECT * FROM tmp
ORDER BY a ASC, b DESC;

-- 这样就完了
SELECT * FROM tmp
ORDER BY a DESC, b ASC;

-- 隐藏索引 不删除而使其绝对失效，常用于衡量此索引性能
CREATE TABLE book (
	book_id INT,
	book_name VARCHAR(100),
	`authors` VARCHAR(100),
	info VARCHAR(100),
	`comment` VARCHAR(100),
	year_publication YEAR,
	INDEX idx_bname(book_name) INVISIBLE -- 默认有效，即省略VISIBLE
);

ALTER TABLE book
ADD INDEX idx_pub(year_publication) INVISIBLE;

-- 修改显隐性
ALTER TABLE book
ALTER INDEX idx_pub(year_publication) VISIBLE;
-- 即使索引被隐藏，也仍一直随着表数据变化而调整树结构，存在不小开销，故长期隐藏的最好还是删掉