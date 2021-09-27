-- SQL is not case-sensitive.

USE sql_store;

-- the order of these clauses matter: SELECT -> FROM -> WHERE -> ORDER BY
SELECT * -- select all
FROM customers
WHERE customer_id = 1
ORDER BY first_name; -- end one sentence with ';'

SELECT 
	first_name, 
    last_name, 
    points, 
    points+10 AS 'algebra calculation', 
    (points*10+100) % 99 AS number_factor
FROM customers;

USE sql_inventory;
SELECT 
	name, 
    unit_price,
    unit_price * 1.1 -- 110% would not work
FROM products;

USE sql_store;
SELECT DISTINCT state -- the key word "DISTINCT" gets all unique data
FROM customers;

SELECT *
FROM customers
WHERE state = 'VA'; -- both '' and "" could work, use '=' rather than '=='

SELECT *
FROM customers
WHERE state <> 'VA' -- != is equal to <>
	OR birth_date > '1990-01-01' -- this is the standard form of writing a date
	AND points > 1000; -- AND has a higher precedence than OR (without parenthesis), no matter it's written first or last

SELECT *
FROM customers
WHERE NOT (birth_date < '1992-08-16' AND points > 1000);

SELECT *
FROM customers
WHERE state IN ('MA', 'NY', 'FL'); -- equals to: state = 'MA' OR state = 'NY' OR state = 'FL', can also be "state NOT IN (...)"
-- this cannot be written as state = 'MA' OR 'NY' OR 'FL', as state = 'MA' will directly gives a boolean

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000; -- points >= 1000 AND points <= 3000

SELECT *
FROM customers
WHERE last_name LIKE 'b%'; -- 'LIKE' takes in the pattern
-- % stands for any number of characters, from 0 to INF
--     'b%' -> string starts with b / B
--     '%b' -> string ends with b / B
--     '%b%' -> string contains b / B (at the beginning, in the middle, or at the end)
-- '_' stands for a single character
--     '_y' -> string contains exactly 2 characters and ends with y / Y
--     'a___' -> string contains exactly 4 characters and starts with a / A

SELECT *
FROM customers
WHERE address LIKE '%trade%' OR
      address LIKE '%avenue%';

SELECT *
FROM customers
WHERE phone NOT LIKE '%9';

SELECT *
FROM customers
WHERE last_name REGEXP 'field'; -- short for "regular expression", equal to last_name LIKE '%field%'
-- '^field' -> string must starts with field
-- 'field$' -> string must ends with field
-- 'field|mac|rose' -> multiple search patterns
-- '^field|mac$|rose' -> string must starts with field, or ends with mac, or contains rose
-- '[gim]e' -> string contains either ge, ie or me
-- 'e[a-h]' -> string contains ea, eb, ..., or eh

SELECT *
FROM customers
WHERE phone IS NOT NULL; -- the negation of "IS NULL"

SELECT *
FROM customers
ORDER BY first_name DESC; -- ASC -> ascending; DESC -> descending

SELECT last_name
FROM customers
ORDER BY state DESC, first_name ASC; -- MySQL supports ordering by the elements not in SELECT

SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3; -- only the first three rows
