SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;

SELECT billing_country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

SELECT billing_city, SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;

SELECT c.customer_id,c.first_name,c.last_name ,SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

----moderate
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.email
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t         ON il.track_id = t.track_id
JOIN genre g         ON t.genre_id = g.genre_id
WHERE c.email LIKE 'A%'
ORDER BY c.email ASC;

SELECT
       ar.name AS artist_name,
       COUNT(t.track_id) AS total_rock_tracks
FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id
JOIN track t  ON al.album_id = t.album_id
JOIN genre g  ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.name
ORDER BY total_rock_tracks DESC
LIMIT 10;

SELECT
       name,
       milliseconds
FROM track
WHERE milliseconds >
      (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

------Advance
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i       ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t         ON il.track_id = t.track_id
JOIN album al        ON t.album_id = al.album_id
JOIN artist ar       ON al.artist_id = ar.artist_id
GROUP BY
    customer_name,
    ar.name
ORDER BY total_spent DESC;

SELECT country, genre, purchase_count
FROM (
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        COUNT(*) AS purchase_count,
        DENSE_RANK() OVER (
            PARTITION BY i.billing_country
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.name
) t
WHERE rnk = 1;

SELECT country, customer_name, total_spent
FROM (
    SELECT
        i.billing_country AS country,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(il.unit_price * il.quantity) AS total_spent,
        DENSE_RANK() OVER (
            PARTITION BY i.billing_country
            ORDER BY SUM(il.unit_price * il.quantity) DESC
        ) AS rnk
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY i.billing_country, customer_name
) t
WHERE rnk = 1;



