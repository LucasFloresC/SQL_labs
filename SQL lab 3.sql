-- ![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

-- # Lab | SQL Queries 3

-- In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official [installation link](https://dev.mysql.com/doc/sakila/en/sakila-installation.html).

-- The database is structured as follows:
-- ![DB schema](https://education-team-2020.s3-eu-west-1.amazonaws.com/data-analytics/database-sakila-schema.png)

-- <br><br>

-- ### Instructions

-- 1. How many distinct (different) actors' last names are there?
-- 2. In how many different languages where the films originally produced? (Use the column `language_id` from the `film` table)
-- 3. How many movies were released with `"PG-13"` rating?
-- 4. Get 10 the longest movies from 2006.
-- 5. How many days has been the company operating (check `DATEDIFF()` function)? FALTA, EN QUE COLUMNA SE VE ESTO??
-- 6. Show rental info with additional columns month and weekday. Get 20.
-- 7. Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week. podemos usar weekday
-- 8. How many rentals were in the last month of activity?

-- 1.
SELECT COUNT(DISTINCT last_name)
FROM sakila.actor;

-- 2.
SELECT COUNT(DISTINCT name)
FROM sakila.language;

-- 3.
SELECT COUNT(rating)
FROM sakila.film
WHERE rating = "PG-13";

-- 4.

SELECT *
FROM sakila.film
WHERE release_year = 2006 
ORDER BY length DESC
LIMIT 10;

-- 5.
SELECT DATEDIFF(curdate(), last_update)  
FROM sakila.rental;


-- 6.

SELECT month(rental_date) AS month, weekday(rental_date) AS weekday
FROM sakila.rental;

-- 7.

SELECT 
*
, CASE
	WHEN weekday(rental_date) IN (5,6)
		THEN "weekend"
    ELSE "workday"
END AS day_type
FROM sakila.rental; 

-- 8.

SELECT month(rental_date),COUNT(*) 
FROM sakila.rental
GROUP BY month(rental_date)