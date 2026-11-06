/*
RETAILPRO PRACTICE DATABASE
Companion resource for: SQL Interview Practice for Beginners
Platform: Microsoft SQL Server 2012 or later

IMPORTANT:
- This script creates a NEW database named RetailPro.
- It will stop if RetailPro already exists; it will not overwrite your database.
- If you have already created an earlier RetailPro database while testing this book,
  either keep using that database for now or back it up and rename/drop it yourself
  before running this clean public-release setup script.
- All names and business records are fictional.
*/

USE master;
GO

IF DB_ID(N'RetailPro') IS NOT NULL
BEGIN
    RAISERROR('RetailPro already exists. No changes have been made. Back up and rename or remove the existing database before running this setup script.', 16, 1);
    RETURN;
END;
GO

CREATE DATABASE RetailPro;
GO
USE RetailPro;
GO

CREATE TABLE dbo.Customers
(
    CustomerID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NULL,
    City NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL CONSTRAINT DF_Customers_Country DEFAULT ('United Kingdom'),
    RegistrationDate DATE NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (CustomerID)
);
GO

CREATE TABLE dbo.Employees
(
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(80) NOT NULL,
    Department NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID)
);
GO

CREATE TABLE dbo.Products
(
    ProductID INT IDENTITY(1,1) NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT (1),
    CONSTRAINT PK_Products PRIMARY KEY (ProductID),
    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT CK_Products_StockQuantity CHECK (StockQuantity >= 0)
);
GO

CREATE TABLE dbo.Orders
(
    OrderID INT IDENTITY(1,1) NOT NULL,
    CustomerID INT NOT NULL,
    EmployeeID INT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL CONSTRAINT DF_Orders_TotalAmount DEFAULT (0),
    OrderStatus NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID)
        REFERENCES dbo.Employees(EmployeeID),
    CONSTRAINT CK_Orders_TotalAmount CHECK (TotalAmount >= 0)
);
GO

CREATE TABLE dbo.OrderDetails
(
    OrderDetailID INT IDENTITY(1,1) NOT NULL,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal AS (CONVERT(DECIMAL(12,2), Quantity * UnitPrice)) PERSISTED,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderDetailID),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID),
    CONSTRAINT CK_OrderDetails_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderDetails_UnitPrice CHECK (UnitPrice >= 0)
);
GO

INSERT INTO dbo.Customers
    (FirstName, LastName, Email, City, Country, RegistrationDate)
VALUES
('John', 'Smith', 'john.smith@example.com', 'London', 'United Kingdom', '2024-01-15'),
('Sarah', 'Johnson', 'sarah.johnson@example.com', 'Manchester', 'United Kingdom', '2024-02-10'),
('David', 'Brown', 'david.brown@example.com', 'Liverpool', 'United Kingdom', '2024-03-05'),
('Mary', 'Wilson', 'mary.wilson@example.com', 'Birmingham', 'United Kingdom', '2024-03-18'),
('James', 'Taylor', 'james.taylor@example.com', 'Leeds', 'United Kingdom', '2024-04-02'),
('Emma', 'Davies', NULL, 'Manchester', 'United Kingdom', '2024-04-19'),
('Daniel', 'Evans', 'daniel.evans@example.com', 'Bristol', 'United Kingdom', '2024-05-11'),
('Olivia', 'Thomas', 'olivia.thomas@example.com', 'London', 'United Kingdom', '2024-06-01'),
('Michael', 'Roberts', NULL, 'Cardiff', 'United Kingdom', '2024-06-21'),
('Sophie', 'Walker', 'sophie.walker@example.com', 'Sheffield', 'United Kingdom', '2024-07-09'),
('Peter', 'Wright', 'peter.wright@example.com', 'Nottingham', 'United Kingdom', '2024-08-14'),
('Grace', 'Hall', 'grace.hall@example.com', 'Leicester', 'United Kingdom', '2024-09-03'),
('Joseph', 'Green', 'joseph.green@example.com', 'London', 'United Kingdom', '2024-09-22'),
('Amelia', 'Adams', 'amelia.adams@example.com', 'York', 'United Kingdom', '2024-10-12'),
('Noah', 'Nelson', 'noah.nelson@example.com', 'Manchester', 'United Kingdom', '2024-11-07');
GO

INSERT INTO dbo.Employees
    (FirstName, LastName, JobTitle, Department, HireDate)
VALUES
('Amara', 'Jones', 'Sales Executive', 'Sales', '2022-03-14'),
('Oliver', 'King', 'Sales Executive', 'Sales', '2021-07-05'),
('Fatima', 'Ahmed', 'Account Manager', 'Sales', '2023-01-16'),
('Thomas', 'Clark', 'Sales Manager', 'Sales', '2020-11-02'),
('Chloe', 'Lewis', 'Operations Coordinator', 'Operations', '2022-09-12');
GO

INSERT INTO dbo.Products
    (ProductName, Category, UnitPrice, StockQuantity, IsActive)
VALUES
('Laptop 14 inch', 'Electronics', 699.99, 25, 1),
('Wireless Mouse', 'Electronics', 19.99, 120, 1),
('USB-C Hub', 'Electronics', 39.50, 65, 1),
('Office Chair', 'Furniture', 149.00, 18, 1),
('Standing Desk', 'Furniture', 329.00, 12, 1),
('Notebook Pack', 'Stationery', 6.99, 200, 1),
('Desk Lamp', 'Furniture', 24.99, 45, 1),
('Water Bottle', 'Accessories', 12.50, 90, 1),
('Keyboard', 'Electronics', 49.99, 55, 1),
('Monitor 27 inch', 'Electronics', 229.00, 20, 1);
GO

/* Thirty orders. TotalAmount is calculated from the detail lines below. */
INSERT INTO dbo.Orders
    (CustomerID, EmployeeID, OrderDate, TotalAmount, OrderStatus)
VALUES
(1,1,'2025-01-10',0,'Completed'),
(2,2,'2025-01-12',0,'Completed'),
(1,1,'2025-01-15',0,'Completed'),
(3,3,'2025-02-03',0,'Completed'),
(4,2,'2025-02-11',0,'Completed'),
(5,4,'2025-02-18',0,'Completed'),
(2,1,'2025-03-02',0,'Completed'),
(6,3,'2025-03-09',0,'Completed'),
(7,2,'2025-03-15',0,'Completed'),
(8,1,'2025-04-01',0,'Completed'),
(9,4,'2025-04-08',0,'Completed'),
(10,2,'2025-04-16',0,'Completed'),
(1,3,'2025-05-04',0,'Completed'),
(3,1,'2025-05-12',0,'Completed'),
(5,4,'2025-05-21',0,'Completed'),
(6,2,'2025-06-06',0,'Completed'),
(7,1,'2025-06-14',0,'Completed'),
(8,3,'2025-06-25',0,'Completed'),
(2,4,'2025-07-03',0,'Completed'),
(4,2,'2025-07-17',0,'Completed'),
(9,1,'2025-08-02',0,'Completed'),
(10,3,'2025-08-19',0,'Completed'),
(11,2,'2025-09-05',0,'Completed'),
(12,1,'2025-09-22',0,'Completed'),
(13,4,'2025-10-11',0,'Completed'),
(14,3,'2025-10-29',0,'Completed'),
(14,2,'2025-11-08',0,'Completed'),
(1,1,'2025-11-20',0,'Completed'),
(6,4,'2025-12-02',0,'Completed'),
(8,3,'2025-12-15',0,'Completed');
GO

INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1,1,1,699.99),(1,2,2,19.99),
(2,3,1,39.50),(2,6,2,6.99),
(3,5,1,329.00),(3,7,2,24.99),
(4,4,1,149.00),
(5,5,1,329.00),
(6,10,1,229.00),(6,6,4,6.99),
(7,1,1,699.99),
(8,2,1,19.99),(8,7,2,24.99),
(9,10,1,229.00),(9,8,4,12.50),
(10,9,1,49.99),
(11,1,1,699.99),(11,4,2,149.00),
(12,6,2,6.99),(12,8,2,11.50),
(13,10,1,229.00),
(14,1,1,699.99),(14,2,1,19.99),
(15,7,1,24.99),
(16,5,1,329.00),(16,8,4,12.50),
(17,3,1,39.50),(17,6,2,6.99),
(18,1,1,699.99),
(19,4,1,149.00),(19,8,2,15.00),
(20,10,1,229.00),(20,9,1,20.00),
(21,8,1,12.50),
(22,5,1,329.00),(22,3,1,39.50),(22,2,1,19.99),
(23,6,4,6.99),(23,8,2,12.50),
(24,1,1,699.99),(24,10,1,229.00),
(25,4,1,149.00),
(26,5,1,329.00),(26,3,1,39.50),
(27,1,1,699.99),(27,2,1,19.99),
(28,3,1,39.50),
(29,10,1,229.00),(29,9,1,20.00),
(30,1,1,699.99);
GO

/* Keep order-header totals consistent with the sum of their detail lines. */
UPDATE o
SET TotalAmount = x.OrderTotal
FROM dbo.Orders AS o
INNER JOIN
(
    SELECT OrderID, SUM(LineTotal) AS OrderTotal
    FROM dbo.OrderDetails
    GROUP BY OrderID
) AS x
    ON o.OrderID = x.OrderID;
GO

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON dbo.Orders(CustomerID);
CREATE NONCLUSTERED INDEX IX_Orders_EmployeeID ON dbo.Orders(EmployeeID);
CREATE NONCLUSTERED INDEX IX_Orders_OrderDate ON dbo.Orders(OrderDate);
CREATE NONCLUSTERED INDEX IX_OrderDetails_ProductID ON dbo.OrderDetails(ProductID);
GO

/* Validation: expected row counts are Customers 15, Employees 5, Products 10,
   Orders 30 and OrderDetails 50. */
SELECT 'Customers' AS TableName, COUNT(*) AS RecordCount FROM dbo.Customers
UNION ALL SELECT 'Employees', COUNT(*) FROM dbo.Employees
UNION ALL SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL SELECT 'OrderDetails', COUNT(*) FROM dbo.OrderDetails;
GO

/* This query should return no rows if every order header matches its detail lines. */
SELECT
    o.OrderID,
    o.TotalAmount AS OrderHeaderTotal,
    SUM(od.LineTotal) AS OrderDetailTotal
FROM dbo.Orders AS o
INNER JOIN dbo.OrderDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.TotalAmount
HAVING o.TotalAmount <> SUM(od.LineTotal);
GO

PRINT 'RetailPro practice database created and validation completed.';
GO
