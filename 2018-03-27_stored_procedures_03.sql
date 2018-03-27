-- LOOP - LEAVE - END LOOP
-- Count to 10
DELIMITER $$

DROP PROCEDURE IF EXISTS loop_leave_end_loop_example$$

CREATE PROCEDURE loop_leave_end_loop_example()
BEGIN

  DECLARE count INT DEFAULT 0;

  -- BEGIN LOOP
  count_to_10_loop: LOOP

      SET count = count + 1;

      SELECT count AS 'Current Count';

      -- Need the LEAVE otherwise LOOP will count forever
      IF count = 10 THEN
        LEAVE count_to_10_loop;
      END IF;

  END LOOP count_to_10_loop;
  -- END LOOP

END$$

DELIMITER ;

CALL loop_leave_end_loop_example();

--------------------------------------------------------------------------------------------------------------------
-- WHILE
-- Count to 10
DELIMITER $$

DROP PROCEDURE IF EXISTS while_loop_example$$

CREATE PROCEDURE while_loop_example()
BEGIN

  DECLARE count INT DEFAULT 0;

  -- BEGIN LOOP
  count_to_10_loop: WHILE count < 10 DO

      SET count = count + 1;

      SELECT count AS 'Current Count';

      -- Don't need a LEAVE because of the WHILE expression check

  END WHILE count_to_10_loop;
  -- END LOOP

END$$

DELIMITER ;

CALL while_loop_example();


--------------------------------------------------------------------------------------------------------------------
-- REPEAT .. UNTIL
-- Count to 10
DELIMITER $$

DROP PROCEDURE IF EXISTS repeat_until_loop_example$$

CREATE PROCEDURE repeat_until_loop_example()
BEGIN

  DECLARE count INT DEFAULT 0;

  -- BEGIN LOOP
  count_to_10_loop: REPEAT

      SET count = count + 1;

      SELECT count AS 'Current Count';

      -- Don't need a LEAVE because of the UNTIL expression check

  UNTIL count = 10
  END REPEAT count_to_10_loop;
  -- END LOOP

END$$

DELIMITER ;

CALL repeat_until_loop_example();



--------------------------------------------------------------------------------------------------------------------
-- CURSOR
-- Fetch a single row
DELIMITER $$

DROP PROCEDURE IF EXISTS single_row_cursor_example$$

CREATE PROCEDURE single_row_cursor_example()
BEGIN

  -- DECLARE variables for FETCH INTO variables list
  DECLARE selected_film_id INT;
  DECLARE selected_title VARCHAR(255);

  -- DECLARE CURSOR
  DECLARE film_cursor CURSOR FOR
    SELECT film_id, title
    FROM film
    ORDER BY RAND()
    LIMIT 1;

  -- BEGIN CURSOR operations
  OPEN film_cursor;

  FETCH film_cursor INTO selected_film_id, selected_title;
  -- Do something with FETCH INTO variables
  SELECT selected_film_id, selected_title;

  CLOSE film_cursor;
  -- END CURSOR operations

END$$

DELIMITER ;

CALL single_row_cursor_example();


--------------------------------------------------------------------------------------------------------------------
CREATE TABLE `film_select_log` (
  film_id INT,
  title varchar(255),
  selected_on timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);


--------------------------------------------------------------------------------------------------------------------

-- LOOP - LEAVE - END LOOP
-- CURSOR
DELIMITER $$

DROP PROCEDURE IF EXISTS film_select_loop_leave_end_loop_example$$

CREATE PROCEDURE film_select_loop_leave_end_loop_example()
BEGIN

  -- DECLARE variables for FETCH INTO variables list
  DECLARE selected_film_id INT;
  DECLARE selected_title VARCHAR(255);

  -- DECLARE CURSOR
  DECLARE film_cursor CURSOR FOR
    SELECT film_id, title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  -- BEGIN CURSOR operations
  -- Initialize results to CURSOR
  OPEN film_cursor;

  -- Label and start LOOP
  select_cursor_loop: LOOP

    -- Set SELECT results into DECLARED variables
    FETCH film_cursor INTO selected_film_id, selected_title;

    -- Print out film_id and title
    SELECT selected_film_id, selected_title;

    -- Log SELECTED films
    INSERT INTO film_select_log (film_id, title) VALUES (selected_film_id, selected_title);

  END LOOP select_cursor_loop;

  CLOSE film_cursor;
  -- END CURSOR operations

END$$

DELIMITER ;


CALL film_select_loop_leave_end_loop_example();
FATAL ERROR:
ERROR 1329 (02000): No data - zero rows fetched, selected, or processed

SELECT * FROM film_select_log;



--------------------------------------------------------------------------------------------------------------------
-- LOOP - LEAVE - END LOOP
-- CURSOR
-- DECLARE ... HANDLER to fix fatal error
DELIMITER $$

DROP PROCEDURE IF EXISTS film_select_loop_leave_end_loop_example$$

CREATE PROCEDURE film_select_loop_leave_end_loop_example()
BEGIN

  -- DECLARE variables for FETCH INTO variables list
  DECLARE selected_film_id INT;
  DECLARE selected_title VARCHAR(255);
  -- DECLARE variable for LOOP termination
  DECLARE done INT DEFAULT 0;

  -- DECLARE CURSOR
  DECLARE film_cursor CURSOR FOR
    SELECT film_id, title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  -- DECLARE NOT FOUND HANDLER
  DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET done = 1;

  -- BEGIN CURSOR operations
  -- Initialize results to CURSOR
  OPEN film_cursor;

  -- Label and start LOOP
  select_cursor_loop: LOOP

    -- Set SELECT results into DECLARED variables
    FETCH film_cursor INTO selected_film_id, selected_title;

    -- Exit loop if no more rows to process
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;

    -- Print out film_id and title
    SELECT selected_film_id, selected_title;

    -- Log SELECTED films
    INSERT INTO film_select_log (film_id, title) VALUES (selected_film_id, selected_title);

  END LOOP select_cursor_loop;

  CLOSE film_cursor;
  -- END CURSOR operations

END$$

DELIMITER ;


CALL film_select_loop_leave_end_loop_example();


--------------------------------------------------------------------------------------------------------------------
-- Error Handling with TRANSACTIONS
TRUNCATE TABLE film_select_log;

DELIMITER $$

DROP PROCEDURE IF EXISTS film_select_log_insert_example$$

CREATE PROCEDURE film_select_log_insert_example()
BEGIN
  -- DECLARE SQLEXCEPTION HANDLER
  -- Multiple statements require BEGIN ... END
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SELECT 'SQLEXCEPTION HANDLER INVOKED';
    ROLLBACK;
  END;

  -- DECLARE SQLWARNING HANDLER
  DECLARE EXIT HANDLER FOR SQLWARNING
  BEGIN
    SELECT 'SQLWARNING HANDLER INVOKED';
    ROLLBACK;
  END;

  START TRANSACTION;

  INSERT INTO film_select_log (film_id, title) VALUES (101, 'FILM 101');
  SELECT * FROM film_select_log;
  -- INSERT INTO film_select_log (film_id, title) VALUES ('TWO', 'FILM 102');
  -- SELECT * FROM film_select_log;
  -- INSERT INTO film_select_log (film_id, title) VALUES (THREE, 'FILM 103');
  -- SELECT * FROM film_select_log;

END$$

DELIMITER ;

-- 1
CALL film_select_log_insert_example();

-- 2
CALL film_select_log_insert_example();
SHOW WARNINGS;
SELECT * FROM film_select_log;

-- 3
CALL film_select_log_insert_example();
SHOW WARNINGS;
SELECT * FROM film_select_log;

-- 4
-- Fix SQL
CALL film_select_log_insert_example();



--------------------------------------------------------------------------------------------------------------------
-- WHILE LOOP
DELIMITER $$

DROP PROCEDURE IF EXISTS film_select_while_loop_example$$

CREATE PROCEDURE film_select_while_loop_example()
BEGIN

  -- DECLARE variables for FETCH INTO variables list
  DECLARE selected_film_id INT;
  DECLARE selected_title VARCHAR(255);
  -- DECLARE variable for LOOP termination
  DECLARE done INT DEFAULT 0;

  -- DECLARE CURSOR
  DECLARE film_cursor CURSOR FOR
    SELECT film_id, title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  -- DECLARE NOT FOUND HANDLER
  DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET done = 1;

  -- BEGIN CURSOR operations
  -- Initialize results to CURSOR
  OPEN film_cursor;

  -- Label and start LOOP
  select_cursor_loop: WHILE done = 0 DO

    -- Set SELECT results into DECLARED variables
    FETCH film_cursor INTO selected_film_id, selected_title;

    -- Exit loop if no more rows to process
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;

    -- Print out film_id and title
    SELECT selected_film_id, selected_title;

    -- Log SELECTED films
    INSERT INTO film_select_log (film_id, title) VALUES (selected_film_id, selected_title);

  END WHILE select_cursor_loop;

  CLOSE film_cursor;
  -- END CURSOR operations

END$$

DELIMITER ;


CALL film_select_while_loop_example();

--------------------------------------------------------------------------------------------------------------------
-- REPEAT UNTIL LOOP
DELIMITER $$

DROP PROCEDURE IF EXISTS film_select_repeat_until_loop_example$$

CREATE PROCEDURE film_select_repeat_until_loop_example()
BEGIN

  -- DECLARE variables for FETCH INTO variables list
  DECLARE selected_film_id INT;
  DECLARE selected_title VARCHAR(255);
  -- DECLARE variable for LOOP termination
  DECLARE done INT DEFAULT 0;

  -- DECLARE CURSOR
  DECLARE film_cursor CURSOR FOR
    SELECT film_id, title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  -- DECLARE NOT FOUND HANDLER
  DECLARE CONTINUE HANDLER FOR NOT FOUND
      SET done = 1;

  -- BEGIN CURSOR operations
  -- Initialize results to CURSOR
  OPEN film_cursor;

  -- Label and start LOOP
  select_cursor_loop: REPEAT

    -- Set SELECT results into DECLARED variables
    FETCH film_cursor INTO selected_film_id, selected_title;

    -- Exit loop if no more rows to process
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;

    -- Print out film_id and title
    SELECT selected_film_id, selected_title;

    -- Log SELECTED films
    INSERT INTO film_select_log (film_id, title) VALUES (selected_film_id, selected_title);

  UNTIL done = 1
  END REPEAT select_cursor_loop;

  CLOSE film_cursor;
  -- END CURSOR operations

END$$

DELIMITER ;


CALL film_select_repeat_until_loop_example();
