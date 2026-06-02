-- Project  : E-Commerce Query Lab
-- Dataset  : Northwind (SQLite)
-- Skill    : SELECT, WHERE, ORDER BY, GROUP BY, HAVING, JOIN, Subquery


-- 1. Products priced above the catalog average
-- Using a subquery so the threshold updates automatically if prices change
SELECT
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC;


-- 2. Top 5 most expensive products
SELECT
    ProductName,
    UnitPrice
FROM Products
ORDER BY UnitPrice DESC
LIMIT 5;


-- 3. Total number of orders placed by each customer
SELECT
    CustomerID,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY CustomerID
ORDER BY total_orders DESC;


-- 4. Customers who have placed more than 5 orders
-- HAVING is used here instead of WHERE because the filter applies to an aggregated value
SELECT
    CustomerID,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 5
ORDER BY total_orders DESC;


-- 5. Number of products per category
-- JOIN is required because category names live in a separate table from products
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS product_count
FROM Products AS p
JOIN Categories AS c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY product_count DESC;


-- 6. Order volume by month, ranked from busiest to quietest
SELECT
    strftime('%Y-%m', OrderDate) AS order_month,
    COUNT(*) AS order_count
FROM Orders
GROUP BY order_month
ORDER BY order_count DESC;


-- 7. Products that have never appeared in any order
-- Returns empty set if all products have been ordered at least once
SELECT
    ProductID,
    ProductName
FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID
    FROM "Order Details"
);


-- 8. Average order value per customer
-- Inner query calculates the total value of each order first,
-- then the outer query averages those totals per customer
SELECT
    o.CustomerID,
    ROUND(AVG(od.order_total), 2) AS avg_order_value
FROM Orders AS o
JOIN (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS order_total
    FROM "Order Details"
    GROUP BY OrderID
) AS od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
ORDER BY avg_order_value DESC;
