-- Maintaining Denormalized Data

DROP TABLE IF EXISTS customer_rental_total;

CREATE TABLE customer_rental_total (
  customer_id INT,
  payment_total DECIMAL(5,2) DEFAULT 0,
  rental_count INT DEFAULT 0,
  PRIMARY KEY (customer_id)
);


----------------------------------------------------------------------------------------------------
-- Maintaining Denormalized Data - INSERT TRIGGER
-- Increment customer_rental_total.rental_count on new INSERTS into rental

DELIMITER $$

CREATE TRIGGER rental_before_insert
  BEFORE INSERT on rental
  FOR EACH ROW

BEGIN

  INSERT INTO customer_rental_total (customer_id, rental_count)
  VALUES (NEW.customer_id, 1)
  ON DUPLICATE KEY UPDATE rental_count = rental_count + 1;

END$$

DELIMITER ;

-- ERROR 1235 (42000): This version of MySQL doesn't yet support 'multiple triggers with the same action time and event for one table'

DROP TRIGGER rental_date;

DELETE FROM rental WHERE rental_date > CURDATE();

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id )
VALUES (NOW(), 1710, 143, 1);
SELECT * FROM customer_rental_total;

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id )
VALUES (NOW(), 1710, 143, 1);
SELECT * FROM customer_rental_total;



----------------------------------------------------------------------------------------------------
-- Maintaining Denormalized Data - INSERT TRIGGER
-- UPDATE payment_total on new INSERTS into payment table

DELIMITER $$

CREATE TRIGGER payment_before_insert
  BEFORE INSERT on payment
  FOR EACH ROW

BEGIN

  INSERT INTO customer_rental_total (customer_id, payment_total)
  VALUES (NEW.customer_id, NEW.amount)
  ON DUPLICATE KEY UPDATE payment_total = payment_total + NEW.amount;

END$$

DELIMITER ;


DROP TRIGGER payment_date;

SELECT LAST_INSERT_ID();

DELETE FROM payment WHERE payment_date > CURDATE();

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (143, 1, 16057, 1.99, NOW());
SELECT * FROM customer_rental_total;

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (143, 1, 16057, 1.99, NOW());
SELECT * FROM customer_rental_total;



----------------------------------------------------------------------------------------------------
-- Audit Logging - UPDATE TRIGGER

DROP TABLE IF EXISTS payment_log;

CREATE TABLE payment_log (
  user VARCHAR(255),
  payment_id INT,
  old_amount DECIMAL(5,2),
  new_amount DECIMAL(5,2),
  log_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



----------------------------------------------------------------------------------------------------
-- Audit Logging - UPDATE TRIGGER

DELIMITER $$

CREATE TRIGGER payment_after_update
  AFTER UPDATE ON payment
  FOR EACH ROW

BEGIN

  INSERT INTO payment_log (user, payment_id, old_amount, new_amount)
  VALUES (USER(), NEW.payment_id, OLD.amount, NEW.amount);

END$$

DELIMITER ;


SELECT amount FROM payment WHERE payment_id = 6529;

UPDATE payment SET amount = 0.99 WHERE payment_id = 6529;
SELECT * FROM payment_log;

UPDATE payment SET amount = 2.99 WHERE payment_id = 6529;
SELECT * FROM payment_log;
