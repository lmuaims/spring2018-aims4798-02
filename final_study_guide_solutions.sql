

-- #5 i.
LOAD DATA INFILE '/var/lib/mysql-files/offices_to_load.csv'
INTO TABLE offices
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' (officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode)
SET territory = 'NA';

-- #5 ii.
SELECT customerName, contactFirstName, contactLastName, phone
INTO OUTFILE '/var/lib/mysql-files/customers_2018042901.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
FROM customers;


-- #10
SELECT DATE_ADD(CURDATE(), INTERVAL 3 MONTH) AS 3_months_after_today;


-- #11
SELECT products.productCode
FROM products
  LEFT JOIN orderdetails
    ON products.productCode = orderdetails.productCode
WHERE orderdetails.productCode IS NULL;


-- #12
CREATE OR REPLACE VIEW products_to_reorder AS
  SELECT products.productCode, productName
  FROM products
  WHERE products.quantityInStock < 100;

-- #13
UPDATE orders
JOIN customers
  ON orders.customerNumber = customers.customerNumber
JOIN payments
  ON customers.customerNumber = payments.customerNumber
SET orders.comments = CONCAT('PAID: ', payments.paymentDate)
WHERE orders.comments IS NULL;


-- #16 i.
DELIMITER $$

DROP PROCEDURE IF EXISTS most_recent_orderDate_status$$

CREATE PROCEDURE most_recent_orderDate_status(in_customers_phone VARCHAR(255), OUT out_order_status VARCHAR(255))
BEGIN

SET @customers_phone = in_customers_phone;

PREPARE status_select FROM
    'SELECT orders.status INTO @order_status
    FROM customers
    JOIN orders
      ON customers.customerNumber = orders.customerNumber
    WHERE phone = ?
    ORDER BY orderDate DESC
    LIMIT 1;';

EXECUTE status_select USING @customers_phone;

DEALLOCATE PREPARE status_select;

# (#17 i.)
IF (@order_status = 'On Hold') THEN
  SELECT 'Follow up!';
END IF;

SET out_order_status = @order_status;

END$$

DELIMITER ;


# On Hold example
CALL most_recent_orderDate_status('4085553659', @order_status);
SELECT @order_status;

CALL most_recent_orderDate_status('07-98 9555', @order_status);
SELECT @order_status;


-- #16 ii.
DELIMITER $$

DROP PROCEDURE IF EXISTS insert_productlines_product$$

CREATE PROCEDURE insert_productlines_product(in_productLine VARCHAR(255), in_textDescription VARCHAR(255), in_productCode VARCHAR(255), in_productName VARCHAR(255), in_productScale VARCHAR(255), in_productVendor VARCHAR(255), in_productDescription VARCHAR(255), in_quantityInStock INT, in_buyPrice DECIMAL(10,2), in_MSRP DECIMAL(10,2))
BEGIN

# (#18 i.)
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
  SELECT 'SQLEXCEPTION HANDLER INVOKED';
  ROLLBACK;
END;

DECLARE EXIT HANDLER FOR SQLWARNING
BEGIN
  SELECT 'SQLWARNING HANDLER INVOKED';
  ROLLBACK;
END;

SET @productLine = in_productLine;
SET @textDescription = in_textDescription;
SET @productCode = in_productCode;
SET @productName = in_productName;
SET @productScale = in_productScale;
SET @productVendor = in_productVendor;
SET @productDescription = in_productDescription;
SET @quantityInStock = in_quantityInStock;
SET @buyPrice = in_buyPrice;
SET @MSRP = in_MSRP;

START TRANSACTION;

INSERT INTO productlines (productLine, textDescription)
VALUES (@productLine, @textDescription);

INSERT INTO products (productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP)
VALUES (@productCode, @productName, @productLine, @productScale, @productVendor, @productDescription, @quantityInStock, @buyPrice, @MSRP);

COMMIT;


END$$

DELIMITER ;


CALL insert_productlines_product('Boats', 'State of the art boat replicas.', 'S12_1430823', '1980 Ranger', '1:18', 'Acme Productions', '1:18 die-cast of the 1980 Ranger', '2008', 90.06, 112.11);


-- #19 i.
ALTER TABLE customers ADD COLUMN payment_sum DECIMAL (10,2);

DELIMITER $$

CREATE TRIGGER payments_after_insert
  AFTER INSERT on payments
  FOR EACH ROW

BEGIN

  UPDATE customers
  SET payment_sum = payment_sum + NEW.amount
  WHERE customerNumber = NEW.customerNumber;

END$$

DELIMITER ;


# BEFORE
SELECT payment_sum
FROM customers
WHERE customerNumber = 131;

# Run INSERT to set off payments_after_insert trigger
INSERT INTO payments SET customerNumber = 131, checkNumber = 'ABC1234', paymentDate = CURDATE(), amount = 14308.23;

# AFTER
SELECT payment_sum
FROM customers
WHERE customerNumber = 131;


-- 19 ii.
CREATE TABLE customers_audit LIKE customers;


DELIMITER $$

DROP TRIGGER IF EXISTS customers_after_update$$

CREATE TRIGGER customers_after_update
  AFTER UPDATE on customers
  FOR EACH ROW

BEGIN

  INSERT INTO customers_audit (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit, payment_sum)
  VALUES (OLD.customerNumber, OLD.customerName, OLD.contactLastName, OLD.contactFirstName, OLD.phone, OLD.addressLine1, OLD.addressLine2, OLD.city, OLD.state, OLD.postalCode, OLD.country, OLD.salesRepEmployeeNumber, OLD.creditLimit, OLD.payment_sum);


END$$

DELIMITER ;


# UPDATE customers table to engage trigger
UPDATE customers SET contactFirstName = 'Susan' WHERE customerNumber = 450;

# verify trigger worked by SELECTING from the audit table. You should see the old values.
SELECT * FROM customers_audit\G


-- #20 i.
CREATE INDEX country_index ON customers (country);

-- #20 ii.
CREATE INDEX paymentDate_amount_index ON payments (paymentDate, amount);

-- #20 iii.
Keys used in SELECT:
country_index
customerNumber


-- #22 i.
mysqldump -u aims -p classicmodels > classicmodels_2018042901.sql

-- #22 ii.
mysqldump -u aims -p --all-databases > all_databases_2018042901.sql

-- #22 iii.
CREATE DATABASE classicmodels_backup_final_exercise;

mysql -u aims -p classicmodels_backup_final_exercise < classicmodels_2018042901.sql
