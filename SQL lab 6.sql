/*
![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | SQL Queries 8

In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

The database is structured as follows:
![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

### Instructions

1. Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length, rating and rank.  
3. How many films are there for each of the categories in the category table? **Hint**: Use appropriate join between the tables "category" and "film_category".
4. Which actor has appeared in the most films? **Hint**: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
5. Which is the most active customer (the customer that has rented the most number of films)? **Hint**: Use appropriate join between the tables "customer" and "rental" and count the `rental_id` for each customer.
6. List the number of films per category.
7. Display the first and the last names, as well as the address, of each staff member.
8. Display the total amount rung up by each staff member in August 2005.
9. List all films and the number of actors who are listed for each film.
10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer. List the customers alphabetically by their last names.
11. Write a query to display for each store its store ID, city, and country.
12. Write a query to display how much business, in dollars, each store brought in.????
13. What is the average running time of films by category?
14. Which film categories are longest?
15. Display the most frequently rented movies in descending order.
16. List the top five genres in gross revenue in descending order. COMO SACO EL TOP 5, RANK?
17. Is "Academy Dinosaur" available for rent from Store 1?

*/

-- 1.

SELECT title, length, RANK() OVER (ORDER BY length) 
FROM sakila.film;

-- 2.

SELECT title, length, rating, RANK() OVER (ORDER BY length,rating) 
FROM sakila.film;

-- 3.

SELECT category.name , COUNT(*) AS total_movies
FROM sakila.film_category AS film
LEFT JOIN sakila.category AS category 
ON film.category_id = category.category_id
GROUP BY category.name;

-- 4.

SELECT COUNT(first_name), first_name
FROM sakila.film_actor AS film
LEFT JOIN sakila.actor AS actor
ON film.actor_id = actor.actor_id
GROUP BY first_name;

-- 5.

SELECT COUNT(rental_id), first_name
FROM sakila.customer AS customer
LEFT JOIN sakila.rental AS rental
ON customer.customer_id = rental.customer_id
GROUP BY first_name;

-- 6.

SELECT  title, category_id
FROM sakila.film AS film
LEFT JOIN sakila.film_category AS category
ON film.film_id = category.film_id;

-- 7.

SELECT first_name, last_name, address
FROM sakila.staff AS staff
LEFT JOIN sakila.address AS adress
ON staff.address_id = adress.address_id;

-- 8.

SELECT first_name, last_name, SUM(amount)
FROM sakila.payment AS payment
LEFT JOIN sakila.staff AS staff
ON payment.staff_id = staff.staff_id
GROUP BY first_name, last_name;

-- 9. 

SELECT film_id, first_name ,last_name
FROM sakila.film_actor AS film
LEFT JOIN  sakila.actor AS actor
ON film.actor_id = actor.actor_id;

-- 10. 

SELECT last_name, SUM(amount)
FROM sakila.customer AS customer
LEFT JOIN sakila.payment AS payment
ON customer.customer_id = payment.customer_id
GROUP BY last_name;

-- 11. 
SELECT store_id,city,country 
FROM sakila.country AS country
LEFT JOIN sakila.city AS city
ON country.country_id = city.country_id
LEFT JOIN sakila.address AS address
ON city.city_id = address.city_id
LEFT JOIN sakila.store AS store
ON store.address_id = address.address_id
ORDER BY store_id DESC;

-- 12. 


-- 13. 

SELECT cat.category_id, name, AVG(rental_duration) 
FROM sakila.film AS film
LEFT JOIN sakila.film_category AS cat
ON film.film_id = cat.film_id
LEFT JOIN sakila.category AS category
ON cat.category_id = category.category_id
GROUP BY category_id;

-- 14. 

SELECT cat.category_id, name, length
FROM sakila.film AS film
LEFT JOIN sakila.film_category AS cat
ON film.film_id = cat.film_id
LEFT JOIN sakila.category AS category
ON cat.category_id = category.category_id
ORDER BY length DESC;

-- 15. 

SELECT film_id, description, rental_rate
FROM sakila.film
ORDER BY rental_rate DESC;

-- 16. 

SELECT cat.category_id, category.name, sum(amount) AS gross_revenue
FROM sakila.payment AS payment
LEFT JOIN sakila.rental AS rental
ON payment.rental_id = rental.rental_id
LEFT JOIN sakila.inventory AS inventory
ON inventory.inventory_id = rental.rental_id
LEFT JOIN sakila.film AS film
ON film.film_id = inventory.film_id
LEFT JOIN sakila.film_category AS cat
ON cat.film_id = film.film_id
LEFT JOIN sakila.category AS category
ON category.category_id = cat.category_id
GROUP BY category_id
ORDER BY gross_revenue DESC;

-- 17. 

SELECT title, rental_id,convert(return_date,date) AS returnal , CURDATE() AS today, DATEDIFF(return_date,CURDATE()) AS diff
FROM sakila.film AS film
LEFT JOIN sakila.inventory AS inventory
ON film.film_id = inventory.film_id
LEFT JOIN sakila.rental AS rental
ON rental.inventory_id = inventory.inventory_id
WHERE title = 'academy dinosaur' AND store_id = 1
ORDER BY diff ASC;
-- La parte de las fechas es solo a modo de prueba para ver si si actualmente estaria disponible

