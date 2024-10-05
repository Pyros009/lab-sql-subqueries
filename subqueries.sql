# 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
Select f.title, count(f.title) as nr_copies
from film as f
Inner join inventory as i
ON f.film_id=i.film_id
WHERE f.title = "Hunchback Impossible"
;

# 2 List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SElect avg(length) from film)
;

# 3 Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT title, actor_name
FROM (
    SELECT f.title, a.actor_id
    FROM film AS f
    INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
    INNER JOIN actor AS a ON fa.actor_id = a.actor_id
) AS film_actor_ids
JOIN (
    SELECT actor_id, CONCAT(first_name, " ", last_name) AS actor_name
    FROM actor
) AS actor_names ON film_actor_ids.actor_id = actor_names.actor_id
WHERE film_actor_ids.title = "Alone Trip";

# 4 Sales have been lagging among young families, and you want to target family movies for a promotion. 
# Identify all movies categorized as family films.
SELECT f.title, f_c.category
FROM film AS f
INNER JOIN (
    SELECT fc.film_id, c.name AS category
    FROM film_category AS fc
    INNER JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name LIKE '%Family%'
) AS f_c ON f.film_id = f_c.film_id;

# 5 Retrieve the name and email of customers from Canada using both subqueries and joins. 
SELECT Concat( c.first_name, " ", c.last_name) as client_name, c.email
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city AS ct ON a.city_id = ct.city_id
INNER JOIN country AS co ON co.country_id = ct.country_id
WHERE co.country = "Canada"
;

# 6 Determine which films were starred by the most prolific actor in the Sakila database. 
SELECT f.title, CONCAT(a.first_name, " ", a.last_name) AS actor_name
FROM film AS f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
INNER JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE fa.actor_id = (
    SELECT fa.actor_id
    FROM film_actor AS fa
    GROUP BY fa.actor_id
    ORDER BY COUNT(fa.film_id) DESC
    LIMIT 1)
    ;

# 7 Find the films rented by the most profitable customer (the customer who has made the largest sum of payments) in the Sakila database. 
SELECT f.title, 
    CONCAT(c.first_name, " ", c.last_name) AS customer_name
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN customer AS c ON r.customer_id = c.customer_id
WHERE c.customer_id = (
    SELECT c.customer_id
    FROM customer AS c
    INNER JOIN payment AS p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
    ORDER BY SUM(p.amount) DESC
    LIMIT 1)
    ;

# 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT c.customer_id, SUM(p.amount) AS total_spent
FROM customer AS c
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(p.amount) AS total_spent
        FROM payment AS p
        GROUP BY p.customer_id
    ) AS customer_totals)
ORDER BY total_spent DESC
;
