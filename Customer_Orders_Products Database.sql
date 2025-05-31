create database Customers_Orders_Products ;
use Customers_Orders_Products;
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);
INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);

--------  Task 1 :-  
-- 1.	Write a query to retrieve all records from the Customers table..
select * from customers;

-- 2.	Write a query to retrieve the names and email addresses of customers whose names start with 'J'.
select Name,Email from customers where Name like 'J%';

-- 3.	Write a query to retrieve the order details (OrderID, ProductName, Quantity) for all orders..
select OrderID,ProductName,Quantity from orders;

-- 4.	Write a query to calculate the total quantity of products ordered.
select sum(Quantity) from orders;
SELECT SUM(quantity) AS total_quantity FROM orders;

-- 5.	Write a query to retrieve the names of customers who have placed an order.
SELECT DISTINCT Name  
FROM customers c   
JOIN orders o ON c.customerId = o.customerId;

-- 6.	Write a query to retrieve the products with a price greater than $10.00.
select * from products where price > 10;

-- 7.	Write a query to retrieve the customer name and order date for all orders placed on or after '2023-07-05'.
SELECT c.name AS name, o.orderdate  
FROM customers c  
JOIN orders o ON c.customerid = o.customerid  
WHERE o.orderdate >= '2023-07-05';

-- 8.	Write a query to calculate the average price of all products.
select avg(price) from products;

-- 9.	Write a query to retrieve the customer names along with the total quantity of products they have ordered.
SELECT c.name AS Name, SUM(od.quantity) AS total_quantity  
FROM customers c  
JOIN orders o ON c.customerid = o.customerid  
JOIN orders od ON o.orderid = od.orderid  
GROUP BY c.name  
ORDER BY total_quantity DESC;

-- 10.	Write a query to retrieve the products that have not been ordered.
SELECT p.*  FROM products p  
LEFT JOIN orders od ON p.ProductName = od.ProductName 
WHERE od.ProductName IS NULL;


/* Task 2 :- */
-- 1.	Write a query to retrieve the top 5 customers who have placed the highest total quantity of orders.

SELECT c.CustomerID, c.Name, SUM(od.Quantity) AS TotalQuantityOrdered
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN orders od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY TotalQuantityOrdered DESC
LIMIT 5;

-- 2.	Write a query to calculate the average price of products for each product category.

SELECT P.ProductName, Round(AVG(p.Price),2) AS AveragePrice from Products P inner join Orders O ON P.ProductID = O.OrderID
group by(P.ProductName);

-- 3.	Write a query to retrieve the customers who have not placed any orders.
SELECT c.*  
FROM customers c  
LEFT JOIN orders o ON c.CustomerID = o.CustomerID  
WHERE o.orderdate IS NULL;

-- 4.	Write a query to retrieve the order details (OrderID, ProductName, Quantity) for orders placed by customers whose names start with 'M'.
select OrderID, ProductName, Quantity from orders o inner join customers c on c.customerId=o.customerId where Name like 'M%';

-- 5.	Write a query to calculate the total revenue generated from all orders.
SELECT SUM(o.Quantity * p.Price) AS TotalRevenue FROM Products P inner join Orders O ON P.ProductID = O.OrderID;

-- 6.	Write a query to retrieve the customer names along with the total revenue generated from their orders.

SELECT c.Name,SUM(p.price) AS total_revenue
FROM customers c JOIN products p ON c.customerid = p.productid
GROUP BY c.Name ORDER BY total_revenue DESC;

-- 7.	Write a query to retrieve the customers who have placed at least one order for each product category.
SELECT c.customerid, c.Name
FROM customers c
JOIN orders o ON c.customerid = o.customerid
JOIN products p ON o.orderid = p.productid
GROUP BY c.customerid, c.Name
HAVING COUNT(DISTINCT o.orderid) > 1;
  
(SELECT COUNT(DISTINCT productid) FROM products);

-- 8.	Write a query to retrieve the customers who have placed orders on consecutive days.
SELECT DISTINCT o1.customerid, c.Name
FROM orders o1
JOIN orders o2 
    ON o1.customerid = o2.customerid 
JOIN customers c 
    ON o1.customerid = c.customerid
        AND DATEDIFF(o1.orderdate, o2.orderdate);

-- 9.	Write a query to retrieve the top 3 products with the highest average quantity ordered.
SELECT p.productid, p.productname, AVG(o.quantity) AS avg_quantity
FROM orders o
JOIN products p ON o.customerid = p.productid
GROUP BY p.productid, p.productname
ORDER BY avg_quantity DESC
LIMIT 3;

-- 10. Write a query to calculate the percentage of orders that have a quantity greater than the average quantity.
SELECT 
    (COUNT(CASE WHEN o.quantity > (SELECT AVG(quantity) FROM orders) THEN 1 END) * 100.0 / COUNT(*)) AS percentage_above_avg
FROM orders o;


/* Task 3 :- */

-- 1.	Write a query to retrieve the customers who have placed orders for all products.
SELECT o.CustomerID, c.Name AS CustomerName
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY o.CustomerID, c.Name
HAVING COUNT(DISTINCT o.ProductName) = (SELECT COUNT(DISTINCT ProductName) FROM products);

-- No Single Customer Has Ordered All Products

SELECT o.CustomerID, c.Name AS CustomerName, COUNT(DISTINCT o.ProductName) AS ProductsOrdered
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY o.CustomerID, c.Name;

-- 2.	Write a query to retrieve the products that have been ordered by all customers.
SELECT o.ProductName
FROM orders o
GROUP BY o.ProductName
HAVING COUNT(DISTINCT o.CustomerID) = (SELECT COUNT(DISTINCT CustomerID) FROM customers);


-- 3.	Write a query to calculate the total revenue generated from orders placed in each month.
SELECT 
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth,  -- Extracts Year-Month format
    SUM(o.Quantity * p.Price) AS TotalRevenue
FROM orders o
JOIN products p ON o.ProductName = p.ProductName
GROUP BY OrderMonth
ORDER BY OrderMonth;

-- 4.	Write a query to retrieve the products that have been ordered by more than 50% of the customers.
SELECT o.ProductName
FROM orders o
GROUP BY o.ProductName
HAVING COUNT(DISTINCT o.CustomerID) > (SELECT COUNT(DISTINCT CustomerID) FROM customers) / 2;

-- 5.	Write a query to retrieve the top 5 customers who have spent the highest amount of money on orders
SELECT o.CustomerID, c.Name AS CustomerName, SUM(o.Quantity * p.Price) AS TotalSpent
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN products p ON o.ProductName = p.ProductName
GROUP BY o.CustomerID, c.Name
ORDER BY TotalSpent DESC
LIMIT 5;

-- 6.	Write a query to calculate the running total of order quantities for each customer.
SELECT 
    o.CustomerID, 
    c.Name AS CustomerName, 
    o.OrderDate, 
    o.ProductName, 
    o.Quantity, 
    SUM(o.Quantity) OVER (
        PARTITION BY o.CustomerID 
        ORDER BY o.OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
ORDER BY o.CustomerID, o.OrderDate;

-- 7.	Write a query to retrieve the top 3 most recent orders for each customer.
SELECT CustomerID, OrderID, OrderDate, ProductName, Quantity
FROM (
    SELECT 
        o.CustomerID, 
        o.OrderID, 
        o.OrderDate, 
        o.ProductName, 
        o.Quantity, 
        ROW_NUMBER() OVER (
            PARTITION BY o.CustomerID 
            ORDER BY o.OrderDate DESC
        ) AS ranking
    FROM orders o
) ranked_orders
WHERE ranking <= 3
ORDER BY CustomerID, OrderDate DESC;


-- 8.	Write a query to calculate the total revenue generated by each customer in the last 30 days.
SELECT 
    o.CustomerID, 
    c.Name AS CustomerName, 
    SUM(o.Quantity * p.Price) AS TotalRevenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN products p ON o.ProductName = p.ProductName
WHERE o.OrderDate >= CURDATE() - INTERVAL 30 DAY  -- Filters last 30 days
GROUP BY o.CustomerID, c.Name
ORDER BY TotalRevenue DESC;

SELECT 
     o.CustomerID, 
    c.Name AS CustomerName, 
    SUM(o.Quantity * p.Price) AS TotalRevenue
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN products p ON o.ProductName = p.ProductName
WHERE orderdate >= DATE_SUB("2023-07-08", INTERVAL 30 DAY) -- Adjusts for the last 30 days
GROUP BY o.CustomerID, c.Name
ORDER BY TotalRevenue DESC;

-- 9.	Write a query to retrieve the customers who have placed orders for at least two different product categories.
SELECT o.CustomerID, c.Name AS CustomerName
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN products p ON o.ProductName = p.ProductName
GROUP BY o.CustomerID, c.Name
HAVING COUNT(DISTINCT 
    CASE 
        WHEN p.ProductName IN ('Product A', 'Product B') THEN 'Category 1'
        WHEN p.ProductName IN ('Product C', 'Product D') THEN 'Category 2'
        ELSE 'Other'
    END
) >= 2;

-- 10.	Write a query to calculate the average revenue per order for each customer.
SELECT 
   
    c.Name AS CustomerName, 
    AVG(OrderRevenue) AS AvgRevenuePerOrder
FROM (
    SELECT 
        o.CustomerID, 
        o.OrderID, 
        SUM(o.Quantity * p.Price) AS OrderRevenue
    FROM orders o
    JOIN products p ON o.ProductName = p.ProductName
    GROUP BY o.CustomerID, o.OrderID
) OrderTotals
JOIN customers c ON OrderTotals.CustomerID = c.CustomerID
GROUP BY OrderTotals.CustomerID, c.Name
ORDER BY AvgRevenuePerOrder DESC;


-- 11.	Write a query to retrieve the customers who have placed orders for every month of a specific year.
SELECT o.CustomerID, c.Name AS CustomerName
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2023  -- Replace with your desired year
GROUP BY o.CustomerID, c.Name
HAVING COUNT(DISTINCT MONTH(o.OrderDate)) = 12;


-- 12.	Write a query to retrieve the customers who have placed orders for a specific product in consecutive months
WITH MonthlyOrders AS (
    SELECT 
        o.CustomerID, 
        c.Name AS CustomerName, 
        YEAR(o.OrderDate) AS OrderYear, 
        MONTH(o.OrderDate) AS OrderMonth
    FROM orders o
    JOIN customers c ON o.CustomerID = c.CustomerID
    WHERE o.ProductName = 'Product A'  -- Replace with your specific product
    GROUP BY o.CustomerID, c.Name, YEAR(o.OrderDate), MONTH(o.OrderDate)
)
SELECT DISTINCT mo1.CustomerID, mo1.CustomerName
FROM MonthlyOrders mo1
JOIN MonthlyOrders mo2
ON mo1.CustomerID = mo2.CustomerID
AND mo1.OrderYear = mo2.OrderYear
AND mo1.OrderMonth = mo2.OrderMonth - 1  -- Ensures consecutive months
ORDER BY mo1.CustomerID;

-- 13.	Write a query to retrieve the products that have been ordered by a specific customer at least twice.
SELECT o.ProductName, COUNT(o.OrderID) AS OrderCount
FROM orders o
WHERE o.CustomerID = '1'  -- Replace with the specific CustomerID
GROUP BY o.ProductName
HAVING COUNT(o.OrderID) >= 2;






 