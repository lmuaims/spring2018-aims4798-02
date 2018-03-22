-- IF family_friendly_check
DELIMITER $$

DROP PROCEDURE IF EXISTS family_friendly_if_check$$

CREATE PROCEDURE family_friendly_if_check(in_title VARCHAR(255), OUT out_family_friendly INT)
BEGIN

  SET @film_title = in_title;

  PREPARE rating_select_stmt FROM
    'SELECT rating INTO @rating
    FROM film
    WHERE film.title = ?';

  EXECUTE rating_select_stmt USING @film_title;

  DEALLOCATE PREPARE rating_select_stmt;

  SELECT @rating;

  IF (@rating = 'G') THEN
    SET out_family_friendly = 1;
  ELSEIF (@rating = 'PG') THEN
    SET out_family_friendly = 1;
  ELSE
    SET out_family_friendly = 0;
  END IF;

END$$

DELIMITER ;


--
CALL family_friendly_if_check('CAT CONEHEADS', @family_friendly);
SELECT @family_friendly;

CALL family_friendly_if_check('KING EVOLUTION', @family_friendly);
SELECT @family_friendly;

-- NULL title
CALL family_friendly_if_check('LMU AIMS', @family_friendly);
SELECT @family_friendly;


-- CASE
DELIMITER $$

DROP PROCEDURE IF EXISTS family_friendly_case_check$$

CREATE PROCEDURE family_friendly_case_check(in_title VARCHAR(255), OUT out_family_friendly INT)
BEGIN

  SET @film_title = in_title;

  PREPARE rating_select_stmt FROM
    'SELECT rating INTO @rating
    FROM film
    WHERE film.title = ?';

  EXECUTE rating_select_stmt USING @film_title;

  DEALLOCATE PREPARE rating_select_stmt;

  SELECT @rating;

  CASE @rating
    WHEN 'G' THEN
      SET out_family_friendly = 1;
    WHEN 'PG' THEN
      SET out_family_friendly = 1;
    ELSE
      SET out_family_friendly = 0;
  END CASE;

END$$

DELIMITER ;


--
CALL family_friendly_case_check('CAT CONEHEADS', @family_friendly);
CALL family_friendly_case_check('ROOM ROMAN', @family_friendly);
CALL family_friendly_case_check('KING EVOLUTION', @family_friendly);


-- LOOP - LEAVE - END LOOP
-- CURSOR
DELIMITER $$

DROP PROCEDURE IF EXISTS title_select$$

CREATE PROCEDURE title_select()
BEGIN

  DECLARE film_title VARCHAR(255);
  -- DECLARE done INT DEFAULT 0;

  DECLARE select_cursor CURSOR FOR
    SELECT title
    FROM film
    ORDER BY RAND()
    LIMIT 5;
  /*
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
      -- prevent infinite loop
      SET done = 1;
      -- error handling for: | Error | 1329 | No data - zero rows fetched, selected, or processed |
      SELECT 1 INTO @handler_invoked FROM (SELECT 1) AS t;
    END;
  */
  OPEN select_cursor;
  select_cursor_loop: LOOP
    FETCH select_cursor INTO film_title;
    SELECT film_title;
    -- prevent infinite loop
    /*
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;
    */
  END LOOP select_cursor_loop;
  CLOSE select_cursor;

END$$

DELIMITER ;


--
CALL title_select();
ERROR 1329 (02000): No data - zero rows fetched, selected, or processed
-- need to add DECLARE HANDLER


-- WITH ERROR HANDLING
DELIMITER $$

DROP PROCEDURE IF EXISTS title_select$$

CREATE PROCEDURE title_select()
BEGIN

  DECLARE film_title VARCHAR(255);
  DECLARE done INT DEFAULT 0;

  DECLARE select_cursor CURSOR FOR
    SELECT title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
      SET done = 1;
      SELECT 1 INTO @handler_invoked FROM (SELECT 1) AS t;
    END;
  OPEN select_cursor;
  select_cursor_loop: LOOP
    FETCH select_cursor INTO film_title;
    SELECT film_title;
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;
  END LOOP select_cursor_loop;
  CLOSE select_cursor;

END$$

DELIMITER ;


--
CALL title_select();


-- WHILE
DELIMITER $$

DROP PROCEDURE IF EXISTS title_select_while$$

CREATE PROCEDURE title_select_while()
BEGIN

  DECLARE film_title VARCHAR(255);
  DECLARE done INT DEFAULT 0;

  DECLARE select_cursor CURSOR FOR
    SELECT title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
      SET done = 1;
      SELECT 1 INTO @handler_invoked FROM (SELECT 1) AS t;
    END;

  OPEN select_cursor;
  select_cursor_loop: WHILE done = 0 DO
    FETCH select_cursor INTO film_title;
    SELECT film_title;
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;
  END WHILE select_cursor_loop;
  CLOSE select_cursor;

END$$

DELIMITER ;

--
CALL title_select_while();


-- REPEAT .. UNTIL
DELIMITER $$

DROP PROCEDURE IF EXISTS title_select_repeat_until$$

CREATE PROCEDURE title_select_repeat_until()
BEGIN

  DECLARE film_title VARCHAR(255);
  DECLARE done INT DEFAULT 0;

  DECLARE select_cursor CURSOR FOR
    SELECT title
    FROM film
    ORDER BY RAND()
    LIMIT 5;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
      SET done = 1;
      SELECT 1 INTO @handler_invoked FROM (SELECT 1) AS t;
    END;

  OPEN select_cursor;
  select_cursor_loop: REPEAT
    FETCH select_cursor INTO film_title;
    SELECT film_title;
    IF done = 1 THEN
      LEAVE select_cursor_loop;
    END IF;
  UNTIL done = 1
  END REPEAT select_cursor_loop;
  CLOSE select_cursor;

END$$

DELIMITER ;


--
CALL title_select_repeat_until();
