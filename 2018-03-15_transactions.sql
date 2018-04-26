/*
EXAMPLE

Scenario:
Add a rental transaction for the film_id 702 at store_id 1 rented by existing customer_id 260.
The transaction was handled by staff_id 1.
Use the current date and time for the rental_date and payment_date by using the NOW() function.
film_id 702's rental_rate is 2.99.
*/

-- First select for the inventory_id based on the film_id and store_id:
SELECT inventory_id
FROM inventory
WHERE film_id = 702
	AND store_id = 1;

-- Check to see if any of the inventory items have not been returned yet:
SELECT rental.inventory_id, rental.return_date
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
WHERE inventory.film_id = 702
	AND inventory.store_id = 1;

/*
inventory_id 3192 hasn't been returned yet as seen by the NULL return_date. Must use one of the other inventory_id's for the insert into rental and payment.

Tables to insert into:
rental
payment

*/

/*  By default, MySQL runs with autocommit mode enabled. This means that as soon as you execute a statement that updates (modifies) a table, MySQL stores the update on disk to make it permanent. The change cannot be rolled back.

To disable autocommit mode implicitly for a single series of statements, use the START TRANSACTION statement:].
*/
START TRANSACTION;

-- INSERT into the rental table
INSERT INTO rental
SET rental_date = NOW(),
	inventory_id = 3193,
	customer_id = 260,
	staff_id = 1;

-- display new rental_id
SELECT LAST_INSERT_ID();

-- assign new rental_id to a user-defined variable for later use
SET @last_insert_rental_id = LAST_INSERT_ID();

-- confirm assigment matches with the ouput from SELECT LAST_INSERT_ID();
SELECT @last_insert_rental_id;

-- INSERT into the payment table
INSERT INTO payment
SET customer_id = 260,
	staff_id = 1,
	rental_id = @last_insert_rental_id,
	amount = 2.99,
	payment_date = NOW();

-- check payment insert status
SELECT *
FROM payment
WHERE rental_id = LAST_INSERT_ID();

-- ROLLBACK INSERTs
ROLLBACK;
-- COMMIT INSERTs
# COMMIT;

-- Should return empty set because of ROLLBACK
SELECT *
FROM payment
WHERE rental_id = LAST_INSERT_ID();

-------------------------------------------------
