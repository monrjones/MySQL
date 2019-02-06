-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;
--  1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT concat(first_name, ' ', last_name) FROM actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name ='Joe';
-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM actor
WHERE last_name LIKE '%LI%';
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country
WHERE country in ('Afghanistan', 'Bangladesh',  'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD description BLOB;
SELECT * FROM actor;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description;
SELECT * FROM actor;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT('Number of Times Last Name Occurs')
FROM actor
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT('Number of Times Last Name Occurs')
FROM actor
GROUP BY last_name HAVING COUNT(last_name) >1;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

SELECT actor_id
FROM actor
where first_name ='GROUCHO' AND last_name ='WILLIAMS';
UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = '172';
SELECT actor_id, first_name, last_name
from actor;
-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = '172';
SELECT actor_id, first_name, last_name
from actor;
-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
DESCRIBE address;
-- 
SHOW CREATE TABLE address;
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT * FROM address;
SELECT * FROM  staff;
SELECT staff.first_name, staff.last_name, address.address 
FROM address
INNER JOIN staff ON
address.address_id = staff.address_id;
--  6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT * FROM payment;
SELECT * FROM staff;
SELECT first_name, last_name, sum(amount)
FROM staff
INNER JOIN payment
ON staff.staff_id = payment.payment_id
GROUP BY staff.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, COUNT(actor_id)
FROM film 
INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
GROUP BY title;
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, COUNT(inventory_id)
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
GROUP BY title;
-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT last_name, first_name, SUM(amount)
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film
WHERE language_id IN
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND title LIKE "K%" OR title LIKE "Q%";
-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT last_name, first_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id 
    FROM film_actor
	WHERE film_id IN 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip")
	);
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT country, last_name, first_name, email
FROM country 
INNER JOIN customer 
ON country.country_id = customer.customer_id
WHERE country = 'Canada';
--  7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title, category
FROM film_list
WHERE category = "family";
-- Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_id) 
FROM rental 
INNER JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
INNER JOIN film 
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;
-- Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment p 
ON p.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);
-- Write a query to display for each store its store ID, city, and country.
SELECT * FROM store;
SELECT * FROM city;
SELECT * FROM country;

SELECT store_id, city, country
FROM store 
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON city.city_id = address.city_id
INNER JOIN country
ON country.country_id = city.country_id;
-- List the top five genres in gross revenue in descending order.
SELECT name, SUM(amount)
FROM category 
INNER JOIN film_category 
ON category.category_id = film_category.category_id
INNER JOIN inventory 
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW topfive_genre AS
SELECT name, SUM(amount)
FROM category 
INNER JOIN film_category 
ON category.category_id = film_category.category_id
INNER JOIN inventory 
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;
-- How would you display the view that you created in 8a?
SELECT * FROM topfive_genre;
-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW topfive_genre;