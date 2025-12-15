CREATE DATABASE db_course_conversions;
USE db_course_conversions;


CREATE TABLE student_info (
    student_id INT PRIMARY KEY,
    date_registered DATE
);

CREATE TABLE student_engagement (
    student_id INT,
    date_watched DATE
);

CREATE TABLE student_purchases (
    student_id INT,
    date_purchased DATE
);

CREATE TABLE numbers (
    n INT PRIMARY KEY
);
INSERT INTO numbers (n)
SELECT a.n + b.n*10 + c.n*100 + 1
FROM
(SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
(SELECT 0 n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
(SELECT 0 n UNION SELECT 1 UNION SELECT 2) c;


INSERT INTO student_info (student_id, date_registered)
SELECT
    n,
    DATE_ADD('2022-01-01', INTERVAL FLOOR(RAND()*730) DAY)
FROM numbers
WHERE n <= 300;

INSERT INTO student_engagement (student_id, date_watched)
SELECT
    student_id,
    DATE_ADD(date_registered, INTERVAL FLOOR(RAND()*30) DAY)
FROM student_info
WHERE student_id % 4 != 0;

INSERT INTO student_engagement (student_id, date_watched)
SELECT
    student_id,
    DATE_ADD(date_registered, INTERVAL FLOOR(RAND()*60) DAY)
FROM student_info
WHERE student_id % 6 = 0;


INSERT INTO student_purchases (student_id, date_purchased)
SELECT
    e.student_id,
    DATE_ADD(MIN(e.date_watched), INTERVAL FLOOR(RAND()*20) DAY)
FROM student_engagement e
GROUP BY e.student_id
HAVING e.student_id % 3 = 0;



SELECT COUNT(*) FROM student_info;
SELECT COUNT(*) FROM student_engagement;
SELECT COUNT(*) FROM student_purchases;

SELECT MIN(date_registered), MAX(date_registered)
FROM student_info;


SELECT
    e.student_id,
    i.date_registered,
    MIN(e.date_watched) AS first_date_watched,
    MIN(p.date_purchased) AS first_date_purchased,
    DATEDIFF(MIN(e.date_watched), i.date_registered) AS diff_reg_watch,
    DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS diff_watch_purch
FROM student_engagement e
JOIN student_info i
    ON e.student_id = i.student_id
LEFT JOIN student_purchases p
    ON e.student_id = p.student_id
GROUP BY e.student_id, i.date_registered
HAVING first_date_purchased IS NULL
    OR first_date_watched <= first_date_purchased;


show databases;


GRANT ALL PRIVILEGES ON db_course_conversions.* TO 'root'@'localhost';
FLUSH PRIVILEGES;

