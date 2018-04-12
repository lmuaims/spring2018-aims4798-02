CREATE TABLE inventory_status (
  film_id INT,
  store_id INT,
  units_in_stock INT,
  PRIMARY KEY (film_id, store_id)
);

# populate inventory_status
INSERT INTO inventory_status (film_id, store_id, units_in_stock)
SELECT film_id, store_id, COUNT(*) AS units_in_stock
FROM inventory
GROUP BY film_id, store_id;

----------------------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS rental_after_insert$$

CREATE TRIGGER rental_after_insert
  AFTER INSERT on rental
  FOR EACH ROW

BEGIN

  SELECT film_id, store_id INTO @film_id, @store_id
  FROM inventory
  WHERE inventory_id = NEW.inventory_id;

  UPDATE inventory_status
  SET units_in_stock = units_in_stock - 1
  WHERE film_id = @film_id
    AND store_id = @store_id;

END$$

DELIMITER ;

----------------------------------------------------------------------------

SELECT * FROM inventory WHERE inventory_id = 999;

SELECT * FROM inventory_status WHERE film_id = 223 AND store_id = 2;

INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id )
VALUES (NOW(), 999, 143, 1);

SELECT * FROM inventory_status WHERE film_id = 223 AND store_id = 2;

----------------------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS rental_after_update$$

CREATE TRIGGER rental_after_update
  AFTER UPDATE on rental
  FOR EACH ROW

BEGIN

  # need to use <=> for NULL safe comparison
  IF NOT NEW.return_date <=> OLD.return_date THEN

    SELECT film_id, store_id INTO @film_id, @store_id
    FROM inventory
    WHERE inventory_id = OLD.inventory_id;

    UPDATE inventory_status
    SET units_in_stock = units_in_stock + 1
    WHERE film_id = @film_id
      AND store_id = @store_id;

  END IF;

END$$

DELIMITER ;

----------------------------------------------------------------------------

SELECT LAST_INSERT_ID();

UPDATE rental SET return_date = NOW() WHERE rental_id = 16060;

SELECT * FROM inventory_status WHERE film_id = 223 AND store_id = 2;
