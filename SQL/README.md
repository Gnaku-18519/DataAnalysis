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
