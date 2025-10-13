USE coffeeshop_db;

-- =========================================================
-- BASICS PRACTICE
-- Instructions: Answer each prompt by writing a SELECT query
-- directly below it. Keep your work; you'll submit this file.
-- =========================================================

-- Q1) List all products (show product name and price), sorted by price descending.
select name, price from products
order by price desc;
-- Q2) Show all customers who live in the city of 'Lihue'.
select first_name, last_name, city from customers
where city = 'Lihue';
-- Q3) Return the first 5 orders by earliest order_datetime (order_id, order_datetime).
select order_id, order_datetime from orders
order by order_datetime asc
limit 5;
-- Q4) Find all products with the word 'Latte' in the name.
select name from products
where name like '%Latte%';
-- Q5) Show distinct payment methods used in the dataset.
SELECT DISTINCT payment_method 
FROM orders;
-- Q6) For each store, list its name and city/state (one row per store).
SELECT name, city, state
FROM stores;
-- Q7) From orders, show order_id, status, and a computed column total_items
--     that counts how many items are in each order.
SELECT o.order_id, o.status, COUNT(oi.product_id) AS total_items
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;
-- Q8) Show orders placed on '2025-09-04' (any time that day).
SELECT *
FROM orders
WHERE order_datetime >= '2025-09-04 00:00:00' AND order_datetime < '2025-09-05 00:00:00';
-- Q9) Return the top 3 most expensive products (price, name).
SELECT price, name 
FROM products
ORDER BY price DESC
LIMIT 3;
-- Q10) Show customer full names as a single column 'customer_name'
--      in the format "Last, First".
SELECT CONCAT(last_name, ', ', first_name) AS customer_name
FROM customers;

