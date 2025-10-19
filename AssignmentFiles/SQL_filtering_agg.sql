-- ==================================
-- FILTERS & AGGREGATION
-- ==================================

USE coffeeshop_db;


-- Q1) Compute total items per order.
--     Return (order_id, total_items) from order_items.
SELECT order_id, SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id;
-- Q2) Compute total items per order for PAID orders only.
--     Return (order_id, total_items). Hint: order_id IN (SELECT ... FROM orders WHERE status='paid').
SELECT oi.order_id, SUM(oi.quantity) AS total_items
FROM order_items AS oi
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.status = 'paid'
GROUP BY order_id;
-- Q3) How many orders were placed per day (all statuses)?
--     Return (order_date, orders_count) from orders.
-- using CAST so it groups by day instead of every single specific hour
SELECT CAST(order_datetime AS DATE), COUNT(*) AS orders_count
FROM orders
GROUP BY CAST(order_datetime AS DATE);

-- Q4) What is the average number of items per PAID order?
--     Use a subquery or CTE over order_items filtered by order_id IN (...).
SELECT AVG(order_totals.total_items) AS average_items_per_paid_order
FROM (SELECT oi.order_id, SUM(oi.quantity) AS total_items
	  FROM order_items AS oi
      JOIN orders AS o ON oi.order_id = o.order_id
      WHERE o.status = 'paid'
      GROUP BY oi.order_id) AS order_totals;
      
-- Q5) Which products (by product_id) have sold the most units overall across all stores?
--     Return (product_id, total_units), sorted desc.
SELECT product_id, SUM(quantity) AS total_units
FROM order_items
GROUP BY product_id
ORDER BY total_units DESC;
-- Q6) Among PAID orders only, which product_ids have the most units sold?
--     Return (product_id, total_units_paid), sorted desc.
--     Hint: order_id IN (SELECT order_id FROM orders WHERE status='paid').
SELECT oi.product_id, SUM(oi.quantity) AS total_units
FROM order_items as oi
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.status = 'paid'
GROUP BY oi.product_id
ORDER BY total_units DESC;
-- Q7) For each store, how many UNIQUE customers have placed a PAID order?
--     Return (store_id, unique_customers) using only the orders table.
SELECT o.store_id, COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders AS o 
WHERE o.status = 'paid'
GROUP BY o.store_id
ORDER BY o.store_id;
-- Q8) Which day of week has the highest number of PAID orders?
--     Return (day_name, orders_count). Hint: DAYNAME(order_datetime). Return ties if any.
SELECT DAYNAME(order_datetime) AS day_name, COUNT(*) AS orders_count
FROM orders
WHERE status = 'paid'
GROUP BY DAYNAME(order_datetime)
ORDER BY orders_count DESC;
-- Q9) Show the calendar days whose total orders (any status) exceed 3.
--     Use HAVING. Return (order_date, orders_count).
SELECT CAST(order_datetime AS DATE) AS order_date, COUNT(*) AS orders_count
FROM orders
GROUP BY CAST(order_datetime AS DATE)
HAVING COUNT(*) > 3
ORDER BY order_date;
-- Q10) Per store, list payment_method and the number of PAID orders.
--      Return (store_id, payment_method, paid_orders_count).
SELECT o.store_id, o.payment_method, COUNT(*) AS paid_orders_count
FROM orders o
WHERE o.status = 'paid' 
GROUP BY o.store_id, o.payment_method
ORDER BY o.store_id, paid_orders_count;
-- Q11) Among PAID orders, what percent used 'app' as the payment_method?
--      Return a single row with pct_app_paid_orders (0–100).
SELECT (COUNT(CASE WHEN o.payment_method = 'app' THEN 1 END) * 100 / COUNT(*)) AS pct_app_paid_orders
FROM orders o
WHERE o.status = 'paid';
-- Q12) Busiest hour: for PAID orders, show (hour_of_day, orders_count) sorted desc.
SELECT EXTRACT(HOUR FROM o.order_datetime) AS hour_of_day, COUNT(*) AS orders_count
FROM orders o 
WHERE o.status = 'paid'
GROUP BY EXTRACT(HOUR FROM o.order_datetime)
ORDER BY orders_count DESC;


-- ================
