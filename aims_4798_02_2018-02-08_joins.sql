-- JOIN
SELECT city.city, country.country
FROM city
  JOIN country
  ON city.country_id = country.country_id
ORDER BY RAND()
LIMIT 10;

SELECT c1.city, c2.country
FROM city c1
  JOIN country c2
  ON c1.country_id = c2.country_id
ORDER BY RAND()
LIMIT 10;

SELECT c2.country, COUNT(*)
FROM city c1
  JOIN country c2
  ON c1.country_id = c2.country_id
GROUP BY c2.country
HAVING COUNT(*) > 10
ORDER BY COUNT(*) DESC;

SHOW CREATE TABLE film;
SHOW CREATE TABLE language;

SELECT film.title, language.name
FROM film
  JOIN language
  ON film.language_id = language.language_id
ORDER BY RAND()
LIMIT 10;

-- 3 Table JOIN
SHOW CREATE TABLE film;
SHOW CREATE TABLE film_category;
SHOW CREATE TABLE category;

SELECT film.film_id, film.title, film_category.film_id, film_category.category_id
FROM film
  JOIN film_category
  ON film.film_id = film_category.film_id
ORDER BY RAND()
LIMIT 10;

SELECT film.film_id, film.title, film_category.film_id, film_category.category_id, category.name, category.category_id
FROM film
  JOIN film_category
  ON film.film_id = film_category.film_id
  JOIN category
  ON film_category.category_id = category.category_id
ORDER BY RAND()
LIMIT 10;

SELECT category.name, COUNT(*) category_count
FROM film
  JOIN film_category
  ON film.film_id = film_category.film_id
  JOIN category
  ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY category_count DESC;

SELECT category_id FROM film_category WHERE name = 'Drama';
SELECT COUNT(*) FROM film_category WHERE category_id = 7;
SELECT COUNT(*) FROM film_category WHERE category_id = (SELECT category_id FROM category WHERE name = 'Drama');

-- 4 Table JOIN
SHOW CREATE TABLE customer;
SHOW CREATE TABLE address;
SHOW CREATE TABLE city;
SHOW CREATE TABLE country;

SELECT customer_id, first_name, last_name, email, address_id
FROM customer
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, address.city_id
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, address.city_id, city.city
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, address.city_id, city.city, country.country
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
  JOIN country
  ON city.country_id = country.country_id
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, address.city_id, city.city, country.country
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
  JOIN country
  ON city.country_id = country.country_id
ORDER BY RAND()
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id, address.city_id, city.city, country.country
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
  JOIN country
  ON city.country_id = country.country_id
WHERE country.country = 'Canada'
LIMIT 10;

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, city.city, country.country
INTO OUTFILE '/var/lib/mysql-files/candadian_customers_2017020801.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM customer
  JOIN address
  ON customer.address_id = address.address_id
  JOIN city
  ON address.city_id = city.city_id
  JOIN country
  ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 5 Table JOIN
SHOW CREATE TABLE actor;
SHOW CREATE TABLE film_actor;
SHOW CREATE TABLE film;
SHOW CREATE TABLE film_category;
SHOW CREATE TABLE category;

SELECT first_name, last_name
FROM actor
LIMIT 10;

SELECT CONCAT(first_name, ' ', last_name) actor_full_name
FROM actor
LIMIT 10;

SELECT CONCAT(actor.first_name, ' ', actor.last_name) actor_full_name, film_actor.film_id
FROM actor
  JOIN film_actor
  ON actor.actor_id = film_actor.actor_id
ORDER BY RAND()
LIMIT 10;

SELECT CONCAT(actor.first_name, ' ', actor.last_name) actor_full_name, film_actor.film_id, film.title
FROM actor
  JOIN film_actor
  ON actor.actor_id = film_actor.actor_id
  JOIN film
  ON film_actor.film_id = film.film_id
ORDER BY RAND()
LIMIT 10;

SELECT CONCAT(actor.first_name, ' ', actor.last_name) actor_full_name, film_actor.film_id, film.title, film_category.category_id
FROM actor
  JOIN film_actor
  ON actor.actor_id = film_actor.actor_id
  JOIN film
  ON film_actor.film_id = film.film_id
  JOIN film_category
  ON film_category.film_id = film.film_id
ORDER BY RAND()
LIMIT 10;

SELECT CONCAT(actor.first_name, ' ', actor.last_name) actor_full_name, film_actor.film_id, film.title, film_category.category_id, category.name
FROM actor
  JOIN film_actor
  ON actor.actor_id = film_actor.actor_id
  JOIN film
  ON film_actor.film_id = film.film_id
  JOIN film_category
  ON film_category.film_id = film.film_id
  JOIN category
  ON film_category.category_id = category.category_id
ORDER BY RAND()
LIMIT 10;

SELECT CONCAT(actor.first_name, ' ', actor.last_name) actor_full_name, film.title, category.name
FROM actor
  JOIN film_actor
  ON actor.actor_id = film_actor.actor_id
  JOIN film
  ON film_actor.film_id = film.film_id
  JOIN film_category
  ON film_category.film_id = film.film_id
  JOIN category
  ON film_category.category_id = category.category_id
WHERE category.name = 'Drama';
