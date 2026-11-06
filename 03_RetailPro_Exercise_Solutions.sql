/*
RETAILPRO PRACTICE EXERCISE SOLUTIONS
Run after installing the RetailPro database.
SQL Server 2012+ compatible.
*/

USE RetailPro;
GO

-- 1. All customers
SELECT * FROM dbo.Customers;

-- 2. Selected customer columns
SELECT FirstName, LastName, City
FROM dbo.Customers;

-- 3. Customers in London
SELECT CustomerID, FirstName, LastName, City
FROM dbo.Customers
WHERE City = 'London';

-- 4. Products from most expensive to least expensive
SELECT ProductName, UnitPrice
FROM dbo.Products
ORDER BY UnitPrice DESC;

-- 5. Products priced above 100
SELECT ProductName, UnitPrice
FROM dbo.Products
WHERE UnitPrice > 100;

-- 6. Customers with missing email
SELECT CustomerID, FirstName, LastName, Email
FROM dbo.Customers
WHERE Email IS NULL;

-- 7. Customers with an email
SELECT CustomerID, FirstName, LastName, Email
FROM dbo.Customers
WHERE Email IS NOT NULL;

-- 8. Customer count
SELECT COUNT(*) AS CustomerCount
FROM dbo.Customers;

-- 9. Average product price
SELECT AVG(UnitPrice) AS AverageProductPrice
FROM dbo.Products;

-- 10. Highest and lowest prices
SELECT MAX(UnitPrice) AS HighestPrice,
       MIN(UnitPrice) AS LowestPrice
FROM dbo.Products;

-- 11. Total sales
SELECT SUM(TotalAmount) AS TotalSales
FROM dbo.Orders;

-- 12. Number of orders per customer
SELECT CustomerID, COUNT(*) AS NumberOfOrders
FROM dbo.Orders
GROUP BY CustomerID
ORDER BY NumberOfOrders DESC;

-- 13. Total order value per customer
SELECT c.CustomerID, c.FirstName, c.LastName,
       SUM(o.TotalAmount) AS TotalSpend
FROM dbo.Customers AS c
INNER JOIN dbo.Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpend DESC;

-- 14. Customers whose total order value is greater than 500
SELECT c.CustomerID, c.FirstName, c.LastName,
       SUM(o.TotalAmount) AS TotalSpend
FROM dbo.Customers AS c
INNER JOIN dbo.Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.TotalAmount) > 500
ORDER BY TotalSpend DESC;

-- 15. Orders with customer names
SELECT o.OrderID, c.FirstName, c.LastName,
       o.OrderDate, o.TotalAmount
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c
    ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate;

-- 16. Orders with assigned employee
SELECT o.OrderID, e.FirstName, e.LastName,
       o.OrderDate, o.TotalAmount
FROM dbo.Orders AS o
LEFT JOIN dbo.Employees AS e
    ON o.EmployeeID = e.EmployeeID
ORDER BY o.OrderID;

-- 17. Products and quantities on each order
SELECT od.OrderID, p.ProductName, od.Quantity,
       od.UnitPrice, od.LineTotal
FROM dbo.OrderDetails AS od
INNER JOIN dbo.Products AS p
    ON od.ProductID = p.ProductID
ORDER BY od.OrderID, p.ProductName;

-- 18. Customers who have never placed an order
SELECT c.CustomerID, c.FirstName, c.LastName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 19. Five products with the highest total quantity sold
SELECT TOP 5 p.ProductID, p.ProductName,
       SUM(od.Quantity) AS TotalQuantitySold
FROM dbo.Products AS p
INNER JOIN dbo.OrderDetails AS od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantitySold DESC;

-- 20. Monthly revenue
SELECT YEAR(OrderDate) AS SalesYear,
       MONTH(OrderDate) AS SalesMonth,
       SUM(TotalAmount) AS MonthlyRevenue
FROM dbo.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;

-- 21. Employees ranked by assigned order value
SELECT e.EmployeeID, e.FirstName, e.LastName,
       SUM(o.TotalAmount) AS SalesValue
FROM dbo.Employees AS e
INNER JOIN dbo.Orders AS o
    ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY SalesValue DESC;

-- 22. Orders by status
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY OrderStatus;

-- 23. Customers with more than one order
SELECT CustomerID, COUNT(*) AS NumberOfOrders
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- 24. CASE product price classification
SELECT ProductName, UnitPrice,
       CASE
           WHEN UnitPrice < 25 THEN 'Budget'
           WHEN UnitPrice <= 100 THEN 'Standard'
           ELSE 'Premium'
       END AS PriceBand
FROM dbo.Products;

-- 25. CTE for customer spend (includes customers with no orders)
;WITH CustomerSpend AS
(
    SELECT c.CustomerID, c.FirstName, c.LastName,
           ISNULL(SUM(o.TotalAmount), 0) AS TotalSpend
    FROM dbo.Customers AS c
    LEFT JOIN dbo.Orders AS o
        ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT *
FROM CustomerSpend
ORDER BY TotalSpend DESC;

-- 26. Rank customers by total spend
;WITH CustomerSpend AS
(
    SELECT c.CustomerID, c.FirstName, c.LastName,
           SUM(o.TotalAmount) AS TotalSpend
    FROM dbo.Customers AS c
    INNER JOIN dbo.Orders AS o
        ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT CustomerID, FirstName, LastName, TotalSpend,
       RANK() OVER (ORDER BY TotalSpend DESC) AS SpendRank
FROM CustomerSpend
ORDER BY SpendRank;

-- 27. EXISTS: customers with at least one order
SELECT c.CustomerID, c.FirstName, c.LastName
FROM dbo.Customers AS c
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Orders AS o
    WHERE o.CustomerID = c.CustomerID
);

-- 28. Products priced above the average
SELECT ProductName, UnitPrice
FROM dbo.Products
WHERE UnitPrice >
(
    SELECT AVG(UnitPrice)
    FROM dbo.Products
)
ORDER BY UnitPrice DESC;

-- 29. Running total of revenue by order date
SELECT OrderID, OrderDate, TotalAmount,
       SUM(TotalAmount) OVER
       (
           ORDER BY OrderDate, OrderID
           ROWS UNBOUNDED PRECEDING
       ) AS RunningRevenue
FROM dbo.Orders
ORDER BY OrderDate, OrderID;

-- 30. Order header/detail mismatches (expected: no rows)
SELECT o.OrderID, o.TotalAmount AS OrderHeaderTotal,
       SUM(od.LineTotal) AS OrderDetailTotal
FROM dbo.Orders AS o
INNER JOIN dbo.OrderDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.TotalAmount
HAVING o.TotalAmount <> SUM(od.LineTotal);
