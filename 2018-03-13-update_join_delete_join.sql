### UPDATE JOIN
# 0
CREATE TABLE temp_film LIKE film;

INSERT INTO temp_film SELECT * FROM film;


# 1
ALTER TABLE film_text ADD COLUMN special_features VARCHAR(255);

UPDATE film_text
JOIN temp_film
  ON film_text.film_id = temp_film.film_id
SET film_text.special_features = temp_film.special_features;


# 2
ALTER TABLE film_text ADD COLUMN family_friendly INT(1);
ALTER TABLE temp_film ADD COLUMN family_friendly INT(1);

ALTER TABLE temp_film ADD COLUMN last_updated_by VARCHAR(255);

SELECT USER();

UPDATE temp_film
JOIN film_text
  ON temp_film.film_id = film_text.film_id
SET film_text.family_friendly = 1,
  temp_film.family_friendly = 1,
  temp_film.last_updated_by = USER()
WHERE temp_film.rating IN ('G','PG');


# 3
ALTER TABLE film_text ADD COLUMN nonfiction INT(1);

UPDATE temp_film
JOIN film_text
  ON temp_film.film_id = film_text.film_id
JOIN film_category
  ON temp_film.film_id = film_category.film_id
JOIN category
  ON film_category.category_id = category.category_id
SET film_text.nonfiction = 1
WHERE category.name = 'Documentary';


### DELETE JOIN
# 4
SELECT *
FROM film_text
WHERE nonfiction = 1
LIMIT 3;

SELECT *
FROM temp_film
WHERE film_id = 40;

# delete from both tables
DELETE temp_film, film_text
FROM film_text
JOIN temp_film
  ON film_text.film_id = temp_film.film_id
WHERE film_text.nonfiction = 1;

SELECT *
FROM temp_film
WHERE film_id = 40;

# 5
SELECT *
FROM temp_film
WHERE temp_film.family_friendly = 1
LIMIT 3;

SELECT *
FROM film_text
WHERE film_id = 4;

# delete from a single table
DELETE film_text
FROM film_text
JOIN temp_film
  ON film_text.film_id = temp_film.film_id
WHERE temp_film.family_friendly = 1;

SELECT *
FROM film_text
WHERE film_id = 4;

SELECT *
FROM temp_film
WHERE film_id = 4;
