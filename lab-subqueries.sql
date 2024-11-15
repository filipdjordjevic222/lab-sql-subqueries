Select count(*) as number_of_copies
from inventory
where film_id = (
select film_id
from film
where title = 'Hunchback Impossible');

-- list of films that are longer than average
select title
from film
where length > (
 select avg(length)
 from film 
);

-- all actors from film "Alone Trip"
select first_name, last_name
from actor
where actor_id in(
 select actor_id
 from film_actor
 where film_id = (
 select film_id
 from film
 where title = "Alone Trip")
);

-- bonus
-- family films
select  f.title from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = "Family";

-- name email form cust from canada
select c.first_name, c.last_name, c.email
from customer c
join address a on c.address_id =a.address_id
join city ci on a.city_id= ci.city_id
join country co on ci.country_id = co.country_id
where co.country = "Canada";

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);
-- most ptofilic actor
select actor_id
from film_actor
group by actor_id
order by count(film_id) desc
limit 1;

select f.title
from film f
where f.film_id in (
select fa.film_id
from film_actor fa
where fa.actor_id = (
select actor_id
from film_actor
group by actor_id
order by count(film_id) desc
limit 1
)
);


-- film rented by most profitable costumer
select customer_id
from payment
group by customer_id
order by sum(amount)desc
limit 1;

SELECT f.title
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE r.rental_id IN (
        SELECT p.rental_id
        FROM payment p
        WHERE p.customer_id = (
            SELECT customer_id
            FROM payment
            GROUP BY customer_id
            ORDER BY SUM(amount) DESC
            LIMIT 1
        )
    )
);


-- clients with who spend more than average
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
    ) AS avg_spent
);
