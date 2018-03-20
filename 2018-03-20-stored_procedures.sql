-- A Simple Table Count Stored Procedure
DELIMITER $$

DROP PROCEDURE IF EXISTS film_count$$

CREATE PROCEDURE film_count()
BEGIN
  SELECT COUNT(*)
  FROM film;
END$$

DELIMITER ;


--
CALL film_count();


-- Variables
-- A Stored Procedure to Calculate Square Root
DELIMITER $$

DROP PROCEDURE IF EXISTS my_sqrt$$

CREATE PROCEDURE my_sqrt(input_number INT)
BEGIN
  DECLARE l_sqrt FLOAT DEFAULT 0;
  SET l_sqrt = SQRT(input_number);
  SELECT l_sqrt;
END$$

DELIMITER ;


--
CALL my_sqrt(49);

CALL my_sqrt(36);


-- A Stored Procedure to Return Total Rental Revenue
DELIMITER $$

DROP PROCEDURE IF EXISTS total_revenue$$

CREATE PROCEDURE total_revenue()
BEGIN
  SELECT SUM(amount)
  FROM payment;
END$$

DELIMITER ;


--
CALL total_revenue();


-- A Stored Procedure to Return Total Rental Revenue
-- using a local variable
DELIMITER $$

DROP PROCEDURE IF EXISTS total_revenue$$

CREATE PROCEDURE total_revenue()
BEGIN
  DECLARE total_revenue DECIMAL(10,2) DEFAULT 0;

  SELECT SUM(amount) INTO total_revenue
  FROM payment;

  SELECT total_revenue;
END$$

DELIMITER ;


-- A Stored Procedure to Return Total Rental Revenue
-- using a local variable and a user-defined variable
DELIMITER $$

DROP PROCEDURE IF EXISTS total_revenue$$

CREATE PROCEDURE total_revenue()
BEGIN
  DECLARE total_revenue DECIMAL(10,2) DEFAULT 0;

  SET @staff_id = 2;

  SELECT SUM(amount) INTO total_revenue
  FROM payment
  WHERE staff_id = @staff_id;

  SELECT total_revenue;
END$$

DELIMITER ;


-- A Stored Procedure to Return Total Revenue
-- using a local variable and a parameter
-- Parameter Modes - IN
DELIMITER $$

DROP PROCEDURE IF EXISTS total_revenue$$

CREATE PROCEDURE total_revenue(in_staff_id INT)
BEGIN
  DECLARE total_revenue DECIMAL(10,2) DEFAULT 0;

  SELECT SUM(amount) INTO total_revenue
  FROM payment
  WHERE staff_id = in_staff_id;

  SELECT total_revenue;
END$$

DELIMITER ;


-- verify results
SELECT staff_id, SUM(amount)
FROM payment
GROUP BY staff_id;


-- Parameter Modes - OUT
DELIMITER $$

DROP PROCEDURE IF EXISTS total_revenue$$

CREATE PROCEDURE total_revenue(in_staff_id INT, OUT out_total_revenue DECIMAL(10,2))
BEGIN
  DECLARE total_revenue DECIMAL(10,2) DEFAULT 0;

  SELECT SUM(amount) INTO total_revenue
  FROM payment
  WHERE staff_id = in_staff_id;

  SELECT total_revenue;

  SET out_total_revenue = total_revenue;
END$$

DELIMITER ;


-- Calling a Stored Procedure with an OUT Parameter
CALL total_revenue(1, @staff_id_1_total_revenue);

SELECT @staff_id_1_total_revenue;

CALL total_revenue(2,@staff_id_2_total_revenue);

SELECT @staff_id_1_total_revenue, @staff_id_2_total_revenue;


-- A Stored Procedure to Return Film Genre
DELIMITER $$

DROP PROCEDURE IF EXISTS film_genre$$

CREATE PROCEDURE film_genre(in_title VARCHAR(255), OUT out_genre VARCHAR(255))
BEGIN

  SET @film_title = in_title;

  PREPARE genre_select_stmt FROM
    'SELECT category.name INTO @genre
    FROM film
      JOIN film_category
      ON film.film_id = film_category.film_id
      JOIN category
      ON film_category.category_id = category.category_id
    WHERE film.title = ?';

  EXECUTE genre_select_stmt USING @film_title;

  DEALLOCATE PREPARE genre_select_stmt;

  SET out_genre = @genre;

END$$

DELIMITER ;


--
CALL film_genre('KING EVOLUTION',@genre);

SELECT category.name
FROM film
  JOIN film_category
  ON film.film_id = film_category.film_id
  JOIN category
  ON film_category.category_id = category.category_id
WHERE film.title = 'KING EVOLUTION';


-- A Stored Procedure to Return a Film's Actors
DELIMITER $$

DROP PROCEDURE IF EXISTS film_actor$$

CREATE PROCEDURE film_actor(in_title VARCHAR(255))
BEGIN

  SET @film_title = in_title;

  PREPARE actor_select_stmt FROM
    'SELECT actor.first_name, actor.last_name
    FROM film
      JOIN film_actor
      ON film.film_id = film_actor.film_id
      JOIN actor
      ON film_actor.actor_id = actor.actor_id
    WHERE film.title = ?';

  EXECUTE actor_select_stmt USING @film_title;

  DEALLOCATE PREPARE actor_select_stmt;

END$$

DELIMITER ;


--
CALL film_actor('KING EVOLUTION');

SELECT actor.first_name, actor.last_name
FROM film
  JOIN film_actor
  ON film.film_id = film_actor.film_id
  JOIN actor
  ON film_actor.actor_id = actor.actor_id
WHERE film.title = 'KING EVOLUTION';
