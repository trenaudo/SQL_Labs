USE sakila;

/*
Challenge - Joining on multiple tables
Write SQL queries to perform the following tasks using the Sakila database:
*/
#List the number of films per category.

SELECT c.category_id,c.name, COUNT(fc.film_id) as number_of_films
FROM category c 
LEFT JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id,c.name;

#Retrieve the store ID, city, and country for each store.

SELECT s.store_id,c.city,co.country 
FROM store s 
LEFT JOIN address a ON s.address_id = a.address_id
LEFT JOIN city c ON c.city_id = a.city_id
LEFT JOIN country co ON c.country_id = co.country_id;


#Calculate the total revenue generated by each store in dollars.
SELECT s.store_id, SUM(amount) AS revenue
FROM staff s
LEFT JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.store_id;

#Determine the average running time of films for each category.
SELECT c.category_id,c.name,ROUND(AVG(length),1) as avg_running_time
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id,c.name;


#Identify the film categories with the longest average running time.
SELECT c.category_id,c.name,ROUND(AVG(length),1) as avg_running_time
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id,c.name
ORDER BY 3 DESC
LIMIT 3;


#Display the top 10 most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS rentals
FROM film f
LEFT JOIN inventory i ON f.film_id=i.film_id
LEFT JOIN rental r ON i.inventory_id=r.inventory_id
GROUP BY f.title
ORDER BY 2 DESC
LIMIT 10;


#Determine if "Academy Dinosaur" can be rented from Store 1.
WITH stock AS
(
SELECT i.store_id, COUNT(i.inventory_id) AS copies
FROM inventory i
LEFT JOIN film f ON i.film_id=f.film_id
WHERE f.title = "Academy Dinosaur"
GROUP BY 1
)
SELECT store_id,
CASE 
	WHEN copies > 0 THEN 'YES' 
	ELSE 'NO' END AS can_be_rented
FROM stock
WHERE store_id = 1







/*Here are some tips to help you successfully complete the lab:

Tip 1: This lab involves joins with multiple tables, which can be challenging. Take your time and follow the steps we discussed in class:

Make sure you understand the relationships between the tables in the database. 
This will help you determine which tables to join and which columns to use in your joins.
Identify a common column for both tables to use in the ON section of the join. 
If there isn't a common column, you may need to add another table with a common column.
Decide which table you want to use as the left table (immediately after FROM) and which will be the right table (immediately after JOIN).
Determine which table you want to include all records from.
This will help you decide which type of JOIN to use. If you want all records from the first table, use a LEFT JOIN. If you want all records from the second table, use a RIGHT JOIN. If you want records from both tables only where there is a match, use an INNER JOIN.
Use table aliases to make your queries easier to read and understand. This is especially important when working with multiple tables.
Write the query
Tip 2: Break down the problem into smaller, more manageable parts. 
For example, you might start by writing a query to retrieve data from just two tables before adding additional tables to the join.
Test your queries as you go, and check the output carefully to make sure it matches what you expect. 
This process takes time, so be patient and go step by step to build your query incrementally.

*/

