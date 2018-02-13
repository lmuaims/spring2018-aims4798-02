-- #1
-- Which films do not have an actor?
-- List the actor_id associated to each film
-- JOIN aka INNER JOIN
-- Will only return films and its actors if the film_id is in the film_actor table
SELECT film.film_id, film.title, film_actor.actor_id
FROM film
  JOIN film_actor
  ON film.film_id = film_actor.film_id;

-- LEFT JOIN
-- Will return all results, regardless if the film is not in the film_actor
SELECT film.film_id, film.title, film_actor.film_id
FROM film
  LEFT JOIN film_actor
  ON film.film_id = film_actor.film_id;

-- Which films do not have an actor? film_actor.film_id will return NULL if not in film_actor table.
SELECT film.film_id, film.title, film_actor.film_id
FROM film
  LEFT JOIN film_actor
  ON film.film_id = film_actor.film_id
ORDER BY film_actor.film_id DESC;

SELECT film.film_id, film.title, film_actor.film_id
FROM film
  LEFT JOIN film_actor
  ON film.film_id = film_actor.film_id
WHERE film_actor.film_id IS NULL;


-- #2
-- Which comedies are not in inventory?
-- JOIN will return a result only if the film table's film_id foreign key is present in the inventory table
SELECT f.film_id, f.title, i.store_id
FROM film f
  JOIN inventory i
  ON f.film_id = i.film_id;

-- Adding a LEFT JOIN will return all rows from the left, the film table, even if film's film_id doesn't exist in the inventory table
-- List all films and their store_id. i.store_id will return NULL if not in inventory table.
-- Add ORDER BY to easily see the NULL i.store_id at the bottom of the result
SELECT f.film_id, f.title, i.store_id
FROM film f
  LEFT JOIN inventory i
  ON f.film_id = i.film_id
ORDER BY i.store_id DESC;

-- Which films are not in inventory?
SELECT f.film_id, f.title, i.store_id
FROM film f
  LEFT JOIN inventory i
  ON f.film_id = i.film_id
WHERE i.store_id IS NULL;

-- Which comedies are not in inventory?
-- Get category_id from film_category
SELECT f.film_id, f.title, i.store_id
FROM film f
  LEFT JOIN inventory i
  ON f.film_id = i.film_id
  JOIN film_category fc
  ON f.film_id = fc.film_id
  WHERE i.store_id IS NULL;

-- Get category name from category
SELECT f.film_id, f.title, i.store_id, c.name
FROM film f
  LEFT JOIN inventory i
  ON f.film_id = i.film_id
  JOIN film_category fc
  ON f.film_id = fc.film_id
  JOIN category c
  ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND i.store_id IS NULL;


-- #3
-- Generate a list of films that have never been rented.
-- Need to first find the film's inventory id to then join into the rental table
SELECT f.title, i.inventory_id
FROM film f
  JOIN inventory i
  ON f.film_id = i.film_id;

-- LEFT JOIN into rental table to find missing inventory_ids
SELECT f.title, i.inventory_id, r.inventory_id
FROM film f
  JOIN inventory i
  ON f.film_id = i.film_id
  LEFT JOIN rental r
  ON i.inventory_id = r.inventory_id
WHERE r.inventory_id IS NULL;
