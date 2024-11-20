/*
![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | SQL Subqueries

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. Create appropriate joins wherever necessary. 

### Instructions

1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
2. List all films whose length is longer than the average of all the films. ESTA BIEN??
3. Use subqueries to display all actors who appear in the film _Alone Trip_.
4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
*/

-- 1. 

SELECT COUNT(*)
FROM sakila.inventory
WHERE film_id = (
SELECT film_id
FROM sakila.film
WHERE title = 'hunchback impossible');

-- 2. 

SELECT title
FROM sakila.film
WHERE length > (
SELECT AVG(length)
FROM sakila.film
);

-- 3. 
SELECT *
FROM sakila.actor
WHERE actor_id IN (
	SELECT actor_id
	FROM sakila.film_actor
		WHERE film_id = (
		SELECT film_id 
		FROM sakila.film
		WHERE title = 'alone trip'
        )
	);

-- 4. 
SELECT *
FROM sakila.film
WHERE film_id IN (
	SELECT film_id
	FROM sakila.film_category
	WHERE category_id IN (
		SELECT category_id
		FROM sakila.category
	)
);

-- 5. 
SELECT first_name, last_name, email
FROM sakila.customer
	WHERE address_id IN (
	SELECT address_id
	FROM sakila.address
	WHERE city_id IN (
		SELECT city_id
		FROM sakila.city
		WHERE country_id IN (
			SELECT country_id 
			FROM sakila.country
			WHERE country = 'canada'
		)
	)
); 


SELECT customer.first_name, customer.last_name, customer.email 
FROM sakila.customer AS customer
LEFT JOIN sakila.address AS address 
ON customer.address_id = address.address_id
LEFT JOIN sakila.city AS city
ON address.city_id = city.city_id
LEFT JOIN sakila.country AS country
ON city.country_id = country.country_id
WHERE country = 'canada';

-- 6. 

select * from sakila.actor WHERE actor_id in 
(select actor_id From (
SELECT actor_id, COUNT(*)
FROM sakila.film_actor
GROUP BY actor_id
Order by count(*) DESC limit 1) sub1);

-- 7. 


SELECT r.customer_id, f.title 
FROM sakila.rental AS r
LEFT JOIN sakila.inventory AS i
ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.film AS f
ON i.film_id = f.film_id
WHERE customer_id = (
	SELECT customer_id FROM (
		SELECT customer_id, sum(amount)
FROM sakila.payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1) sub);

-- RANK
SELECT 
	r.customer_id
    , f.title
FROM sakila.rental r
LEFT JOIN sakila.inventory i
ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.film f
ON i.film_id = f.film_id
LEFT JOIN (
	SELECT
		*
		, rank() over (order by total_amount DESC) AS ranking
	FROM (
		SELECT 
			customer_id
			, sum(amount) AS total_amount
		FROM sakila.payment
		GROUP BY customer_id) 
        sub
	) sub2
	ON r.customer_id = sub2.customer_id
WHERE ranking = 1