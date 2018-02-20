# cd /var/lib/mysql-files
# wget https://goo.gl/qeNBsB -O transactions_2014.csv
# wget https://goo.gl/kfi6cr -O transactions_2015.csv

USE classwork;

CREATE TABLE transaction_2014 (
  order_id INT(15) DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  first_name VARCHAR(255) DEFAULT NULL,
  last_name VARCHAR(255) DEFAULT NULL,
  address VARCHAR(255) DEFAULT NULL,
  city VARCHAR(255) DEFAULT NULL,
  state VARCHAR(255) DEFAULT NULL,
  zip VARCHAR(255) DEFAULT NULL,
  order_date DATE DEFAULT NULL,
  total FLOAT(15,2) DEFAULT NULL);


 LOAD DATA INFILE '/var/lib/mysql-files/transactions_2014.csv' INTO TABLE transaction_2014
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\'' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
    (order_id, email, @var1, first_name, last_name, address, city, state, zip, @var2, @order_date, total)
	SET order_date = STR_TO_DATE(@order_date, "%m/%d/%Y");

CREATE TABLE transaction2015 LIKE transaction2014;

LOAD DATA INFILE '/var/lib/mysql-files/transactions_2015.csv' INTO TABLE transaction_2015
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
    (order_id, email, @var1, first_name, last_name, address, city, state, zip, @var2, @order_date, total)
	SET order_date = STR_TO_DATE(@order_date, "%m/%d/%Y");

CREATE TABLE customer (
  email VARCHAR(255) NOT NULL UNIQUE,
	last_name VARCHAR(255),
	first_name VARCHAR(255),
	address VARCHAR(255),
	city VARCHAR(255),
	state VARCHAR(255),
	zip VARCHAR(255));
