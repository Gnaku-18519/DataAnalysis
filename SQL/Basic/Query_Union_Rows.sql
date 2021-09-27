USE sql_store;

SELECT 
	order_id AS ID,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION -- combine records from multiple queries
SELECT 
	order_id AS id,
    order_date,
    'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';
-- remember that the number of columns each query returns should be equal
-- what we have in the first query is used to determine the name of the columns, i.e. the first column will be called "ID" rather than "id"

INSERT INTO customers -- need to fill in all the parts of the table
VALUES (
	DEFAULT, 
    'Jason', 
    'Grayson', 
    '1999-08-16',
    NULL,
    'Central Park',
    'New York City',
    'NY',
    DEFAULT
	);

INSERT INTO customers (
	last_name,
    first_name,
    birth_date,
    address,
    city,
    state,
    points
    ) -- only need to fill in the columns listed respectively
VALUES ( 
    'Todd', 
    'Richard', 
    '1996-12-01',
    'Central Park',
    'New York City',
    'NY',
    '1000'
	);

INSERT INTO shippers (name)
VALUES ('Shipper1'),
	   ('Shipper2'),
       ('Shipper3'); -- insert multiple rows in one set

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2021-9-26', 1);
INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.99), 
    (LAST_INSERT_ID(), 2, 1, 4.99); -- insert hierarchical rows

CREATE TABLE orders_archived AS
SELECT *
FROM orders
WHERE order_date < '2019-10-10'; -- copy multiple rows into a new table (CREATE TABLE can be replaced as INSERT INTO)

USE sql_invoicing;
UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, 
    payment_date = due_date
WHERE invoice_id = 3; -- update a single row

UPDATE invoices
SET 
	payment_total = 33, 
    payment_date = '2021-10-01'
WHERE client_id IN (3,4); -- update multiple rows

UPDATE invoices
SET 
	payment_total = invoice_total * 0.5, 
    payment_date = due_date
WHERE client_id IN 
	(SELECT client_id
	FROM clients
	WHERE state IN ('NY', 'CA')); -- update by subqueries

DELETE FROM invoices
WHERE client_id = 
	(SELECT *
    FROM clients
    WHERE name = 'Myworks'); -- delete rows
