USE sakila;
SHOW TABLES;
--
CREATE VIEW comedy_film AS
SELECT film.film_id, title, description, release_year, category.name
FROM film
  JOIN film_category
  ON film.film_id = film_category.film_id
  JOIN category
  ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy';

SELECT * FROM comedy_film;

SELECT film_id, title
FROM comedy_film
WHERE film_id NOT IN
  (SELECT film_id
   FROM inventory);

SELECT title, a.first_name, a.last_name
FROM comedy_film cf
  JOIN film_actor af
  ON cf.film_id = af.film_id
  JOIN actor a
  ON af.actor_id = a.actor_id;

CREATE VIEW comedy_film_and_actor AS
SELECT title, actor.first_name,  actor.last_name
FROM comedy_film
  JOIN film_actor
  ON comedy_film.film_id = film_actor.film_id
  JOIN actor
  ON film_actor.actor_id = actor.actor_id;

CREATE OR REPLACE VIEW comedy_film_and_actor AS
SELECT title, actor.first_name,  actor.last_name, comedy_film.name
FROM comedy_film
  JOIN film_actor
  ON comedy_film.film_id = film_actor.film_id
  JOIN actor
  ON film_actor.actor_id = actor.actor_id;

-- we can now use the above VIEW for creating the title of each comedy film and the actors in them.

SELECT title film, GROUP_CONCAT(CONCAT(first_name, ' ', last_name) SEPARATOR ', ') actors, name genre
FROM comedy_film_and_actor
GROUP BY title;

CREATE VIEW actor_full_name_grouped AS
SELECT title film, GROUP_CONCAT(CONCAT(first_name, ' ', last_name) SEPARATOR ', ') actors, name genre
FROM comedy_film_and_actor
GROUP BY title;

SELECT customer_id, last_name, first_name, address.phone, city.city, country.country, store_id
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
  JOIN country
  ON city.country_id = country.country_id;

-- Can you find the customers from Vietnam?
-- Can you find all the customers in the United States who rented comedy films?

-- See how VIEW now can be handy!
CREATE VIEW customer_and_country AS
SELECT customer_id, last_name, first_name, address.phone phone, city.city city, country.country country, store_id
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
  JOIN country
  ON city.country_id = country.country_id;

/* Now we can answer the above question easily by joining
   customer_and_country
   rental
   inventory
   comedy_film */

-- try it out on your own!

SELECT cc.customer_id, cc.last_name, cc.first_name, cc.phone, cf.name, cc.country
FROM customer_and_country cc
  JOIN rental r
  ON cc.customer_id = r.customer_id
  JOIN inventory i
  ON r.inventory_id = i.inventory_id
  JOIN comedy_film cf
  ON i.film_id = cf.film_id
WHERE cc.country = 'United States'
ORDER BY cc.customer_id;

-- Let us now move to the other example
USE classwork;

-- We want to create a master customer list from 2014 and 2015 transactions and
-- also wants to see if there are
-- duplicates in the email because of name or address changes (these are called
-- slow changing dimensions)

-- Remember what you did last time!  You used U___N, but it was really complicated, right!

SELECT email, first_name, last_name, address, city, state, zip
FROM transaction_2014
UNION ALL
SELECT email, first_name, last_name, address, city, state, zip
FROM transaction_2015;

-- How would you remove the duplicates?

SELECT DISTINCT *
FROM
 ((SELECT email, first_name, last_name, address, city, state, zip
  FROM transaction_2014)
 UNION ALL
 (SELECT email, first_name, last_name, address, city, state, zip
  FROM transaction_2015)
 ) AS cust_14_15;

 -- However, there still may be duplicates in the e-mail because of SCD.
 -- How would you isolate them?
 -- With subqueries, it is getting complicated.  But with VIEW, it is easy.

 CREATE VIEW customer_2014_to_2015 AS
 (SELECT email, first_name, last_name, address, city, state, zip
  FROM transaction_2014)
 UNION ALL
 (SELECT email, first_name, last_name, address, city, state, zip
  FROM transaction_2015);

CREATE VIEW unique_customer AS
SELECT DISTINCT *
FROM customer_2014_to_2015;

SELECT email, COUNT(*)
FROM unique_customer
GROUP BY email
HAVING COUNT(*) > 1;

SELECT DISTINCT *
FROM customer_2014_to_2015
WHERE email IN (
    SELECT email
    FROM
    (SELECT DISTINCT *
    FROM customer_2014_to_2015) AS temp
    GROUP BY email HAVING COUNT(*) > 1
);

SELECT *
FROM unique_customer
WHERE email in (
  SELECT email
  FROM unique_customer
  GROUP BY email
  HAVING COUNT(*) > 1
);

CREATE VIEW duplicate_email AS
SELECT email
FROM unique_customer
GROUP BY email
HAVING COUNT(*) > 1;

SELECT DISTINCT *
FROM unique_customer
WHERE email IN
  (SELECT email
  FROM duplicate_email);

SELECT *
FROM unique_customer
WHERE email in (
  SELECT email
  FROM duplicate_email
);

 SELECT *, COUNT(*)
 FROM
   (SELECT DISTINCT *
    FROM customer_2014_to_2015) AS temp
 GROUP BY email HAVING COUNT(*) > 1;

 -- We now can use the above one to isolate the exact culprits!
 -- Leave it to you to figure it out!

 -- The view also can help in creating a master customer table

CREATE TABLE customer_master
SELECT DISTINCT *
FROM customer_2014_to_2015;

 -- finding the offending members

SELECT *
FROM customer_master
GROUP BY email HAVING COUNT(*) > 1;

 -- OR to INSERT only unique email

CREATE TABLE customer_master(
  email VARCHAR(255) NOT NULL UNIQUE,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  address VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  zip VARCHAR(255)
);

INSERT IGNORE INTO customer_master
SELECT DISTINCT email, first_name, last_name, address, city, state, zip
FROM customer_2014_to_2015;

INSERT IGNORE INTO customer_master
SELECT DISTINCT *
FROM customer_2014_to_2015;

SELECT email, first_name, last_name, address, city, state, zip
FROM customer_2014_to_2015
GROUP BY email, first_name, last_name, address, city, state, zip;

SELECT *
FROM customer_master
WHERE email IN
  (SELECT email
  FROM duplicate_email);

-- for existing views, you can do

SHOW CREATE VIEW viewname\G

SHOW CREATE VIEW customer_2014_to_2015\G

-- and can see the structure.
