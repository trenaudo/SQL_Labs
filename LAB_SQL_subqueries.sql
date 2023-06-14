USE sakila;

/*Challenge
Write SQL queries to perform the following tasks using the Sakila database:
*/

#Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(inventory_id) AS Inventory
FROM inventory
WHERE film_id = (SELECT film_id
						FROM film 
							WHERE title = "Hunchback Impossible");
                            
#List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT title, length
FROM film 
WHERE length > (SELECT AVG(length) 
					FROM film)
ORDER BY 2;

#Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT first_name,last_name
FROM actor
WHERE actor_id IN(
					SELECT actor_id
						FROM film_actor
							WHERE film_id = (
												SELECT film_id
													FROM film
														WHERE title = "Alone Trip"));

#Sales have been lagging among young families, and you want to target family movies for a promotion. 
#Identify all movies categorized as family films.

SELECT title FROM film
	WHERE film_id IN (
					SELECT film_id
						FROM film_category
							WHERE category_id = (
													SELECT category_id
														FROM category
															WHERE name LIKE "family"));


#Retrieve the name and email of customers from Canada using both subqueries and joins. 
#To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT first_name,email FROM customer 
WHERE address_id IN(
					SELECT address_id FROM address a
						LEFT JOIN city c ON a.city_id = c.city_id
						LEFT JOIN country co ON c.country_id=co.country_id
						WHERE country = "Canada");

#Determine which films were starred by the most prolific actor in the Sakila database. 
#A prolific actor is defined as the actor who has acted in the most number of films. 
#First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

CREATE VIEW  prolific AS
                        (SELECT actor_id, COUNT(actor_id)
							FROM film_actor
								GROUP BY 1
									ORDER BY 2 DESC
										LIMIT 1);

SELECT title FROM film 
WHERE film_id IN (
					(SELECT film_id FROM film_actor
							WHERE actor_id = 
											(SELECT actor_id FROM prolific)));
					
#Find the films rented by the most profitable customer in the Sakila database. 
#You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

CREATE VIEW profitable AS (
SELECT customer_id,SUM(amount) FROM payment
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 1);

SELECT title FROM film
WHERE film_id IN (
					SELECT film_id FROM inventory
						WHERE inventory_id IN (SELECT inventory_id 
							FROM rental
								WHERE customer_id = 
												(SELECT customer_id FROM profitable)));

#Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
#You can use subqueries to accomplish this.

CREATE OR REPLACE VIEW sum_amount_client AS (
SELECT customer_id,(SUM(amount)) AS sum_amount FROM payment
GROUP BY 1);

CREATE OR REPLACE VIEW avg_amount_client AS (
SELECT avg(sum_amount) AS avg_amount FROM sum_amount_client);

SELECT c.customer_id,c.first_name,c.last_name, SUM(amount) AS total_amount_spent
FROM payment p
LEFT JOIN customer c ON p.customer_id=c.customer_id
GROUP BY 1,2,3

HAVING SUM(amount) > (
						SELECT AVG(avg_amount) 	
							FROM avg_amount_client)
ORDER BY 2						

