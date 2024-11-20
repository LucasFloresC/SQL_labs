-- All data from actor, film and customer

SELECT *
FROM sakila.actor,sakila.film,sakila.customer;

-- All film titles
SELECT title
FROM sakila.film;

-- Unique film languages under languages

SELECT DISTINCT name as language
FROM sakila.language;

-- How many stores have the company?
-- 2 stores as they only have 2 stores id
SELECT store_id
FROM sakila.store;

-- How many employees?
-- 2 staff employees
SELECT staff_id,first_name
FROM sakila.staff;

-- Actors with first name Scarlett

SELECT actor_id
FROM sakila.actor
WHERE "Scarlett" = first_name;

-- Actors with last name Johansson

SELECT actor_id
FROM sakila.actor
WHERE "Johansson" = last_name;

-- How many movies are available for rent?
-- 16044
SELECT COUNT(rental_id)
FROM sakila.rental;

-- Shortest and longest movie duration

SELECT max(length) as max_duration, min(length) as min_duration
FROM sakila.film;

-- Average movie duration

SELECT avg(length)
FROM sakila.film;

-- longer than 3 hours?

SELECT COUNT(length)
FROM sakila.film
WHERE length > 180;

-- length of the longest film title

SELECT MAX(LENGTH(title))
FROM sakila.film