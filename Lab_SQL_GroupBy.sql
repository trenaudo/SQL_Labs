/*
In the table actor, what last names are not repeated? For example if you would sort the data in the table actor by last_name, 
you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
These three actors have the same last name. So we do not want to include this last name in our output. 
Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
*/

USE sakila;

SELECT last_name
FROM actor 
GROUP BY 1
HAVING COUNT(actor_id) = 1;


/*
Which last names appear more than once? We would use the same logic as in the previous question 
but this time we want to include the last names of the actors where the last name was present more than once
*/

SELECT last_name
FROM actor 
GROUP BY 1
HAVING COUNT(actor_id) > 1;

#Using the rental table, find out how many rentals were processed by each employee.

SELECT s.staff_id,first_name,last_name, COUNT(rental_id)
FROM rental r
JOIN staff s ON r.staff_id = s.staff_id
GROUP BY 1;


#Using the film table, find out how many films there are of each rating.
SELECT rating, COUNT(film_id) AS No_of_films
FROM film
GROUP BY 1;


#What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
SELECT rating, ROUND(AVG(length),2) AS avg_length
FROM film
GROUP BY 1;

#Which kind of movies (rating) have a mean duration of more than two hours?
SELECT rating, ROUND(AVG(length),2) AS avg_length
FROM film
GROUP BY 1
HAVING avg_length > 120

