USE sql_store;

SELECT order_id, first_name, last_name, orders.customer_id -- when the same column exists in multiple tables, we need to qualify them by prefixing them with the name of the table, otherwise it's ambiguous
FROM orders
INNER JOIN customers 
	ON orders.customer_id = customers.customer_id; -- join two tables by one column, "INNER" could be omitted

-- abbreviation
SELECT order_id, first_name, last_name, o.customer_id
FROM orders o -- alias, used to simplify the codes
INNER JOIN customers c
	ON o.customer_id = c.customer_id;

SELECT *
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id; -- join between tables, only need to specify the table that's not in use now

USE sql_hr;
SELECT 
	e.employee_id,
    e.last_name,
    m.last_name AS manager
FROM employees e -- we have to use different aliases and prefix each column with an alias
JOIN employees m
	ON e.reports_to = m.employee_id; -- join a table with itself

USE sql_store;
SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id -- join more than two tables
JOIN order_statuses os
	ON o.status = os.order_status_id;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_Id
    AND oi.product_id = oin.product_id; -- compound join conditions -> multiple conditions to join two tables

-- implicit join syntax
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
-- INNER JOIN -> only include the data that are in both tables
-- OUTER JOIN: for now, o is the left table and c is the right table
--             1. LEFT JOIN -> include all the records from the left table, whether the "ON" condition is true or not
--             2. RIGHT JOIN -> include all the records from the right table, whether the "ON" condition is true or not

SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id -- OUTER JOIN between multiple tables
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM emplyoees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;

SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	USING (customer_id) -- simplify the code from o.customer_id = c.customer_id
LEFT JOIN shippers sh
	USING (shipper_id);

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (order_id, product_id); -- ON oi.order_id = oin.order_id AND oi.product_id = oin.product_id

-- Natural Join -> NOT Recommended
SELECT *
FROM orders o
NATURAL JOIN customers c; -- Database engine automatically join the two tables

SELECT 
	c.first_name AS customer,
	p.name AS product
FROM customers c
CROSS JOIN products p -- combine or join EVERY record from the first table with EVERY record in the second table
ORDER BY c.first_name;
-- can be simplified to (implicit way): 
-- FROM customers c, products p
-- ORDER BY c.first_name
