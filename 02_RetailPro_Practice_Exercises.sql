/*
RETAILPRO PRACTICE EXERCISES
Companion resource for SQL Interview Practice for Beginners
Run after installing the RetailPro database.
*/

USE RetailPro;
GO

/* BEGINNER: SELECT, FROM, WHERE, ORDER BY */
-- 1. Display all customers.
-- 2. Display only FirstName, LastName and City from Customers.
-- 3. Find customers who live in London.
-- 4. List products from highest to lowest UnitPrice.
-- 5. Find products with a UnitPrice greater than 100.

/* NULL VALUES */
-- 6. Find customers whose Email is missing.
-- 7. Find customers whose Email is present.

/* AGGREGATES */
-- 8. Count the number of customers.
-- 9. Calculate the average product price.
-- 10. Find the highest and lowest product prices.
-- 11. Calculate total sales using Orders.TotalAmount.

/* GROUP BY AND HAVING */
-- 12. Count orders placed by each customer.
-- 13. Calculate total order value for each customer.
-- 14. Show customers whose total order value is greater than 500.

/* JOINS */
-- 15. Display each OrderID with the customer's full name.
-- 16. Display each order with the employee assigned to it.
-- 17. Display product names and quantities for each order.
-- 18. Find customers who have never placed an order.

/* BUSINESS QUESTIONS */
-- 19. Find the five products with the highest sales quantity.
-- 20. Calculate monthly revenue.
-- 21. Rank employees by the total value of orders assigned to them.
-- 22. Find the number of orders in each OrderStatus.
-- 23. Find customers with more than one order.

/* INTERMEDIATE */
-- 24. Use CASE to classify products as Budget (under 25), Standard (25 to 100),
--     or Premium (over 100).
-- 25. Use a CTE to calculate each customer's total spend.
-- 26. Use a window function to rank customers by total spend.
-- 27. Use EXISTS to find customers who have placed at least one order.
-- 28. Use a subquery to find products priced above the average product price.
-- 29. Calculate a running total of revenue by order date.
-- 30. Identify any order whose header total does not equal the sum of its detail lines.
