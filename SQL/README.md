# Null
```SQL
SELECT name
FROM Customer
WHERE referee_id IS NULL
```
# String Pattern
* name not starting with 'M': ```name not like 'M%'```
* ```CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2, LENGTH(name))))``` AS name, where ```LEFT(name, 1)``` is equivalent to ```SUBSTRING(name, 1, 1)```
# Change Column Name
```SQL
SELECT customers.name as 'Customers'
FROM customers
WHERE customers.id not in (
  SELECT customerid from orders
);
```
# Case (interchangable with Where)
```SQL
SELECT xxx,
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END AS yyy
FROM zzz
```
# Update
```SQL
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition
```
