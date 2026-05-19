CREATE DATABASE SQL_Practice;

USE SQL_Practice;

-- =====================================
-- CUSTOMERS TABLE
-- =====================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO Customers VALUES
(1, 'John', 'Delhi'),
(2, 'Sara', 'Mumbai'),
(3, 'David', 'Bangalore'),
(4, 'Emma', 'Hyderabad'),
(5, 'Mike', 'Chennai'),
(6, 'Sophia', 'Pune');

-- =====================================
-- PRODUCTS TABLE
-- =====================================
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price INT
);

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 70000),
(102, 'Mobile', 'Electronics', 30000),
(103, 'Chair', 'Furniture', 5000),
(104, 'Desk', 'Furniture', 12000),
(105, 'Headphones', 'Accessories', 3000),
(106, 'Monitor', 'Electronics', 15000);

-- =====================================
-- ORDERS TABLE
-- =====================================
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders VALUES
(1001, 1, '2025-01-10', 73000),
(1002, 2, '2025-01-15', 30000),
(1003, 1, '2025-02-05', 5000),
(1004, 3, '2025-02-20', 15000),
(1005, 5, '2025-03-01', 12000),
(1006, 2, '2025-03-10', 3000),
(1007, 4, '2025-03-15', 70000);

-- =====================================
-- ORDER_ITEMS TABLE
-- =====================================
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Order_Items VALUES
(1, 1001, 101, 1),
(2, 1001, 105, 1),
(3, 1002, 102, 1),
(4, 1003, 103, 1),
(5, 1004, 106, 1),
(6, 1005, 104, 1),
(7, 1006, 105, 1),
(8, 1007, 101, 1);

-- =====================================
-- VIEW TABLES
-- =====================================
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;


-- =====================================
-- PRACTICE QUESTIONS
-- =====================================

-- BASIC JOINS

-- 1. Show customer names with their order ids.
SELECT O.order_id, C.customer_name
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id;

-- 2. Show customer names with total_amount.
SELECT C.customer_name, O.total_amount
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id;

-- 3. Show product names with quantity ordered.
SELECT P.product_name, O.quantity
FROM Products P
JOIN Order_Items O
ON P.product_id = O.product_id;

-- 4. Show all orders with customer names and cities.
SELECT O.order_id,C.customer_name, C.city
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id;

-- 5. Show all customers even if they never placed an order.
SELECT *
FROM Customers C
LEFT JOIN Orders O
ON C.customer_id = O.customer_id
WHERE O.order_id IS NULL;

-- 6. Find customers who never placed an order.
SELECT C.customer_id,C.customer_name
FROM Customers C
LEFT JOIN Orders O
ON C.customer_id = O.customer_id
WHERE O.order_id IS NULL;

-- 7. Show all products even if never ordered.
SELECT P.product_id,P.product_name
FROM Products P
LEFT JOIN Order_Items O
ON P.product_id = O.product_id;
--WHERE O.product_id IS NULL;

-- 8. Find products that were never ordered.
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Order_Items O
ON P.product_id = O.product_id
WHERE O.order_id IS NULL;

-- MULTIPLE JOINS

-- 9. Show customer name, product name, and quantity.
SELECT C.customer_name, P.product_name, O.quantity
FROM Customers C
JOIN Orders OS ON C.customer_id = OS.customer_id
JOIN Order_Items O ON OS.order_id = O.order_id
JOIN Products P ON O.product_id = P.product_id;

-- 10. Show order id, customer name, product name.
SELECT O.order_id, C.customer_name, P.product_name
FROM Orders O
JOIN Customers C ON C.customer_id = O.customer_id 
JOIN Order_Items OS ON OS.order_id = O.order_id
JOIN Products P ON P.product_id = OS.product_id;

-- 11. Show complete order details. 
SELECT O.order_id, C.customer_name, P.product_name, OS.quantity, O.total_amount
FROM Orders O
JOIN Customers C ON C.customer_id = O.customer_id 
JOIN Order_Items OS ON OS.order_id = O.order_id
JOIN Products P ON P.product_id = OS.product_id;

SELECT DISTINCT(O.order_id), C.customer_name, P.product_name, OS.quantity, O.total_amount
FROM Orders O
JOIN Customers C ON C.customer_id = O.customer_id 
JOIN Order_Items OS ON OS.order_id = O.order_id
JOIN Products P ON P.product_id = OS.product_id;

-- 12. Find total quantity sold for each product.
SELECT P.product_id,P.product_name,SUM(O.quantity) AS TOTAL_QUANTINY
FROM Order_Items O
JOIN Products P 
ON P.product_id =O.product_id
GROUP BY P.product_id,P.product_name;

-- GROUP BY + AGGREGATION

-- 13. Find total sales amount by customer.
SELECT C.customer_name, SUM(O.total_amount) AS TOTAL_SALES
FROM Customers C
JOIN Orders O 
ON C.customer_id = O.customer_id
GROUP BY C.customer_name;

-- 14. Find total orders placed by each customer.
SELECT C.customer_name,COUNT(O.order_id) AS TOTAL_ORDERS 
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name;

-- 15. Find highest order amount.
SELECT MAX(total_amount) AS HIGHEST_ORDER_AMOUNT
FROM Orders;
SELECT order_id,MAX(total_amount) AS HIGHEST_ORDER_AMOUNT
FROM Orders GROUP BY order_id 
ORDER BY MAX(total_amount) DESC;

-- 16. Find average order amount.
SELECT AVG(total_amount) AS AVG_ORDER_AMOUNT
FROM Orders;

-- 17. Find total revenue generated.
SELECT SUM((P.price)*(O.quantity)) AS TOTAL_REVENUE
FROM Products P
JOIN Order_Items O
ON P.product_id = O.product_id;

-- 18. Find category-wise revenue.
SELECT P.category,SUM((P.price)*(O.quantity)) AS TOTAL_REVENUE
FROM Products P
JOIN Order_Items O
ON P.product_id = O.product_id
GROUP BY P.category;

-- 19. Find most expensive product.
SELECT TOP 1 product_name, MAX(price) AS EXPENSIVE 
FROM Products GROUP BY product_name 
ORDER BY MAX(price) DESC;

-- 20. Find top 3 customers by spending.
SELECT TOP 3 C.customer_id,C.customer_name, SUM(O.total_amount) AS HIGH_SPENDING
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name
ORDER BY SUM(O.total_amount) DESC;

-- FILTERING

-- 21. Show orders greater than 30000.
SELECT * FROM Orders WHERE total_amount > 30000;

-- 22. Show customers from Mumbai.
SELECT customer_name,city FROM Customers WHERE city = 'Mumbai';

-- 23. Show products belonging to Electronics category.
SELECT product_name FROM Products WHERE category = 'Electronics';

-- 24. Show orders placed in February.
SELECT * FROM Orders WHERE MONTH(order_date) = 2;


-- HAVING

-- 25. Find customers having total spending greater than 50000.
SELECT C.customer_id,C.customer_name, SUM(O.total_amount) AS TOTAL_SPENDINGS 
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name
HAVING SUM(O.total_amount) > 50000;

-- 26. Find products ordered more than once.
SELECT P.product_id,P.product_name, COUNT(*) AS ORDERED
FROM Products P
JOIN Order_Items O
ON P.product_id = O.product_id
GROUP BY P.product_id,P.product_name
HAVING COUNT(*) > 1;


-- SUBQUERIES

-- 27. Find customers who spent more than average spending.
SELECT C.customer_id,C.customer_name, SUM(O.total_amount)
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name
HAVING SUM(O.total_amount) > 
(SELECT AVG(total_amount) FROM Orders);

-- 28. Find products with price greater than average price.
SELECT product_id,product_name,price
FROM Products WHERE price> (SELECT AVG(price) FROM Products);

-- 29. Find second highest priced product.
SELECT MAX(price) AS SECOND_HIGHEST
FROM Products WHERE price < (SELECT MAX(price) FROM Products);


-- WINDOW FUNCTION PRACTICE (Later)

-- 30. Rank customers based on total spending.
SELECT C.customer_id,C.customer_name, SUM(O.total_amount) AS TOTAL_SPENDING,
RANK() OVER( ORDER BY SUM(O.total_amount) DESC) AS RANKING
FROM Orders O
JOIN Customers C
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name;

-- 31. Find highest spending customer using RANK().
SELECT TOP 1 C.customer_id,C.customer_name, SUM(O.total_amount) AS HIGH_SPENDING,
RANK() OVER( ORDER BY SUM(O.total_amount) DESC) AS RANKING
FROM Orders O
JOIN Customers C
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name;

SELECT *
FROM
(
    SELECT 
        C.customer_id,
        C.customer_name,
        SUM(O.total_amount) AS HIGH_SPENDING,
        RANK() OVER(ORDER BY SUM(O.total_amount) DESC) AS RANKING
    FROM Orders O
    JOIN Customers C
    ON C.customer_id = O.customer_id
    GROUP BY C.customer_id, C.customer_name
) X
WHERE RANKING = 1;

-- 32. Show running total of sales.
SELECT order_date, total_amount, SUM(total_amount) OVER 
(ORDER BY order_date) 
AS TOTAL_SALES
FROM Orders;

-- ADVANCED CHALLENGES

-- 33. Find month-wise revenue.
SELECT MONTH(OS.order_date) AS MONTH_NO,SUM((P.price)*(O.quantity)) AS TOTAL_REVENUE
FROM Orders OS
JOIN Order_Items O ON OS.order_id = O.order_id
JOIN Products P ON P.product_id = O.product_id
GROUP BY MONTH(OS.order_date)
ORDER BY MONTH_NO;

-- 34. Find customer who ordered maximum products.
SELECT C.customer_id,C.customer_name, COUNT(O.order_id) AS MAX_OREDERD
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY C.customer_id,C.customer_name
ORDER BY MAX_OREDERD DESC;

-- 35. Find best-selling category.
SELECT P.category,SUM(O.total_amount) AS BEST 
FROM Orders O
JOIN Order_Items OS ON OS.order_id =O.order_id
JOIN Products P ON OS.product_id = P.product_id
GROUP BY P.category;

-- 36. Find customers who ordered both Laptop and Headphones
SELECT C.customer_id,C.customer_name, P.product_name
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
JOIN Order_Items OS ON OS.order_id = O.order_id
JOIN Products P ON P.product_id = OS.product_id
WHERE P.product_name IN ('Laptop','Headphones');
 
-- 37. Find orders containing more than one product.
SELECT O.order_id, COUNT(P.product_id) AS COUNTS
FROM Order_Items O
JOIN Products P
ON P.product_id = O.product_id
GROUP BY O.order_id
HAVING COUNT(P.product_id) > 1;

-- 38. Find products purchased by John.
SELECT C.customer_name,P.product_name
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
JOIN Order_Items OS ON O.order_id = OS.order_id
JOIN Products P
ON OS.product_id = P.product_id 
WHERE C.customer_name = 'John';

-- 39. Find customers who purchased Electronics items.
SELECT C.customer_id,C.customer_name,P.category
FROM Customers C
JOIN Orders O ON C.customer_id = O.customer_id
JOIN Order_Items OI ON O.order_id = OI.order_id
JOIN Products P
ON OI.product_id = P.product_id
WHERE P.category = 'Electronics';

-- 40. Find product generating highest revenue.
SELECT P.product_id,P.product_name, SUM(P.price * O.quantity) AS HIGH_REVENUE
FROM Products P
JOIN Order_Items O
ON P.product_id = O.product_id
GROUP BY P.product_id,P.product_name
ORDER BY SUM(P.price * O.quantity) DESC;