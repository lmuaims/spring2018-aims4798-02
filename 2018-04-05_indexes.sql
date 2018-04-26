cd /var/lib/mysql-files/
wget https://goo.gl/wB8Nct -O StateNames.csv.zip
  53s
unzip StateNames.csv.zip

wc -l StateNames.csv
5647427 StateNames.csv

head StateNames.csv
Id,Name,Year,Gender,State,Count
1,Mary,1910,F,AK,14
2,Annie,1910,F,AK,12
3,Anna,1910,F,AK,10
4,Margaret,1910,F,AK,8
5,Helen,1910,F,AK,7
6,Elsie,1910,F,AK,6
7,Lucy,1910,F,AK,6
8,Dorothy,1910,F,AK,5
9,Mary,1911,F,AK,12

USE classwork;

DROP TABLE IF EXISTS state_names;

CREATE TABLE state_names (
    state_name_id INT NOT NULL,
    name VARCHAR(255),
    year INT(4),
    gender ENUM('F','M'),
    state VARCHAR(2),
    name_count INT,
    PRIMARY KEY (state_name_id)
);

LOAD DATA INFILE '/var/lib/mysql-files/StateNames.csv'
INTO TABLE state_names
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
Query OK, 5647426 rows affected (33.79 sec)
Records: 5647426  Deleted: 0  Skipped: 0  Warnings: 0

SELECT COUNT(*)
FROM state_names
WHERE name = 'John';


SELECT COUNT(*)
FROM state_names
WHERE name = 'Luke';


CREATE INDEX name_index ON state_names (name);
Query OK, 0 rows affected (27.36 sec)
Records: 0  Duplicates: 0  Warnings: 0


SELECT COUNT(*)
FROM state_names
WHERE name = 'John';


SELECT COUNT(*)
FROM state_names
WHERE name = 'Jane';


SELECT COUNT(*)
FROM state_names
WHERE year = 1979
AND name = 'Jane';
-- Faster than just year alone b/c name_index used


SELECT COUNT(*)
FROM state_names
WHERE year = 1979;


EXPLAIN SELECT COUNT(*)
FROM state_names
WHERE year = 1980
AND name = 'Jane';


CREATE INDEX year_index ON state_names (year);


EXPLAIN SELECT COUNT(*)
FROM state_names
WHERE year = 1980
AND name = 'Jane';

SELECT COUNT(*)
FROM state_names
WHERE year = 1980
AND name = 'Jane';

DROP INDEX name_index ON state_names;

DROP INDEX year_index ON state_names;


CREATE INDEX name_year_index ON state_names (name, year);


EXPLAIN SELECT COUNT(*)
FROM state_names
WHERE year = 1980
AND name = 'Jane';

SELECT COUNT(*)
FROM state_names
WHERE year = 1980
AND name = 'Jane';
