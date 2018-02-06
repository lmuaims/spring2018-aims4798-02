-- GROUP BY
SELECT rating, COUNT(*)
FROM film
WHERE rental_duration > 3
GROUP BY rating;

-- HAVING
SELECT rating, COUNT(*)
FROM film
WHERE rental_duration > 3
GROUP BY rating
HAVING COUNT(*) >= 150;

-- WITH ROLLUP
SELECT rating, COUNT(*)
FROM film
WHERE rental_duration > 3
GROUP BY rating
WITH ROLLUP;

-- SELECT Format
SELECT rating, COUNT(*) film_count
FROM film
WHERE rental_duration > 3
GROUP BY rating
HAVING film_count > 150
LIMIT 1,2;

-- CONCAT
SELECT CONCAT(first_name, ' ', last_name) 'Full Name'
FROM actor
ORDER BY RAND()
LIMIT 10;

-- LEFT
SELECT LEFT(payment_date, 13) AS payment_hour,
  SUM(amount) AS sum_amount,
  COUNT(*) AS payment_count
FROM payment
WHERE payment_date BETWEEN '2005-07-30' AND '2005-07-31 23:59:59'
GROUP BY payment_hour;

-- REPEAT
SELECT LEFT(payment_date, 7) AS payment_month,
  SUM(amount) AS sum_amount,
  COUNT(*) AS payment_count,
  REPEAT('+', COUNT(*) / 100) AS payment_count_trend
FROM payment
WHERE payment_date BETWEEN '2005-01-01' and '2005-12-31 23:59:59'
GROUP BY payment_month;

-- FORMAT
SELECT LEFT(payment_date, 7) AS payment_month,
  FORMAT(SUM(amount), 2) AS sum_amount,
  FORMAT(COUNT(*), 0) AS payment_count,
  REPEAT('+', COUNT(*) / 100) AS payment_count_trend
FROM payment
WHERE payment_date BETWEEN '2005-01-01' and '2005-12-31 23:59:59'
GROUP BY payment_month;

-- SUBSTRING
SELECT description, SUBSTRING(description, 3, 30)
FROM film
LIMIT 10;

-- SUBSTRING_INDEX
SELECT SUBSTRING_INDEX(address, ' ', 1) AS address_number,
  SUBSTRING_INDEX(address, ' ', -1) AS street_type
FROM address
LIMIT 10;

-- LCASE and UCASE
SELECT title, LCASE(title), special_features, UCASE(special_features)
FROM film
LIMIT 10;

-- Combining String Functions
SELECT first_name,
LEFT(first_name, 1)
FROM actor
LIMIT 10;

SELECT first_name,
LEFT(first_name, 1),
SUBSTRING(first_name, 2)
FROM actor
LIMIT 10;

SELECT first_name,
LEFT(first_name, 1),
LCASE(SUBSTRING(first_name, 2))
FROM actor
LIMIT 10;

SELECT first_name,
CONCAT(LEFT(first_name, 1), LCASE(SUBSTRING(first_name, 2)))
FROM actor
LIMIT 10;

-- TRIM
SELECT '   hello  ', TRIM('   hello  ');

-- LIKE
-- string%
SELECT address
FROM address
WHERE address LIKE '23%'
LIMIT 10;

-- %string
SELECT address
FROM address
WHERE address LIKE '%way'
LIMIT 10;

-- %string%
SELECT address
FROM address
WHERE address LIKE '%tar%'
LIMIT 10;

-- _
SELECT address
FROM address
WHERE address LIKE '_ %'
LIMIT 10;

-- NOT LIKE
SELECT address
FROM address
WHERE address NOT LIKE '%way'
LIMIT 10;

-- REGEXP
-- ^
SELECT address
FROM address
WHERE address REGEXP '^9'
LIMIT 10;

SELECT address
FROM address
WHERE address REGEXP '^9 '
LIMIT 10;

SELECT address
FROM address
WHERE address NOT REGEXP '^9 '
LIMIT 10;

-- $
SELECT address
FROM address
WHERE address REGEXP 'y$'
LIMIT 10;

-- .
SELECT address
FROM address
WHERE address REGEXP '^9. '
LIMIT 10;

-- [...]
SELECT address
FROM address
WHERE address REGEXP '^[0-9] '
LIMIT 10;

-- [^...]
SELECT address
FROM address
WHERE address REGEXP '^[^1-5]'
LIMIT 10;

-- p1|p2|p3|p#
SELECT address
FROM address
WHERE address REGEXP 'Avenue|Place| Way'
LIMIT 10;

SELECT address
FROM address
WHERE address NOT REGEXP 'Avenue|Place| Way'
LIMIT 10;

-- *
SELECT address
FROM address
WHERE address REGEXP 'Hano*'
LIMIT 10;

-- +
SELECT address
FROM address
WHERE address REGEXP '^[0-9]+ [a-z]+ [a-z]+$'
LIMIT 10;

-- {n}
SELECT address
FROM address
WHERE address REGEXP '^[0-9]{4}'
LIMIT 10;

-- {m,n}
SELECT address
FROM address
WHERE address REGEXP '^[0-9]{3,4}'
LIMIT 10;
