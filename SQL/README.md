# Null
```SQL
SELECT name
FROM Customer
WHERE referee_id IS NULL
```
# Change Column Name
```SQL
SELECT customers.name as 'Customers'
FROM customers
WHERE customers.id not in (
  SELECT customerid from orders
);
```
# Case
Syntax:
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
# String Pattern
* name not starting with 'M': ```name not like 'M%'```
