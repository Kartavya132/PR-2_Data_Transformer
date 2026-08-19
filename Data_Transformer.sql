CREATE DATABASE data_transformer;
USE data_transformer;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,  
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);


INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02'),
(3, 'Robert', 'Brown', 'robert.brown@email.com', '2023-01-10'),
(4, 'Emily', 'Davis', 'emily.davis@email.com', '2022-08-22'),
(5, 'Michael', 'Wilson', 'michael.wilson@email.com', '2023-05-30'),
(6, 'Sarah', 'Taylor', 'sarah.taylor@email.com', '2021-06-18'); -- no orders, for LEFT JOIN demo

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75),
(103, 1, '2023-07-10', 1200.00),
(104, 3, '2023-07-15', 600.00),
(105, 4, '2023-08-02', 75.25),
(106, 2, '2023-08-05', 950.00),
(107, 99, '2023-08-10', 300.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00),
(3, 'David', 'Martinez', 'IT', '2019-07-11', 72000.00),
(4, 'Linda', 'Garcia', 'Sales', '2022-02-28', 42000.00),
(5, 'James', 'Anderson', 'Finance', '2020-11-05', 61000.00);


SELECT o.OrderID, o.OrderDate, o.TotalAmount,
       c.CustomerID, c.FirstName, c.LastName
FROM Orders as o
INNER JOIN Customers as c ON o.CustomerID = c.CustomerID;

SELECT c.CustomerID, c.FirstName, c.LastName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers as c
LEFT JOIN Orders as o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID;


SELECT o.OrderID, o.OrderDate, o.TotalAmount,
       c.CustomerID, c.FirstName, c.LastName
FROM Customers as c
RIGHT JOIN Orders as o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID;

SELECT c.CustomerID, c.FirstName, c.LastName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers as c
LEFT JOIN Orders as o ON c.CustomerID = o.CustomerID
UNION
SELECT c.CustomerID, c.FirstName, c.LastName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers as c
RIGHT JOIN Orders as o ON c.CustomerID = o.CustomerID;

SELECT DISTINCT c.CustomerID, c.FirstName, c.LastName
FROM Customers as c
JOIN Orders as o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);


SELECT EmployeeID, FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);


SELECT OrderID, OrderDate,
       YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth
FROM Orders;


SELECT OrderID, OrderDate,
       DATEDIFF(CURDATE(), OrderDate) AS DaysSinceOrder
FROM Orders;


SELECT OrderID,
       DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders;


SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;


SELECT CustomerID, FirstName,
       REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedName
FROM Customers;


SELECT CustomerID,
       UPPER(FirstName) AS FirstNameUpper,
       LOWER(LastName) AS LastNameLower
FROM Customers;


SELECT CustomerID, TRIM(Email) AS CleanedEmail
FROM Customers;


SELECT OrderID, CustomerID, OrderDate, TotalAmount,
       SUM(TotalAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;


SELECT OrderID, CustomerID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS OrderRank
FROM Orders;


SELECT OrderID, TotalAmount,
       CASE
           WHEN TotalAmount > 1000 THEN TotalAmount * 0.90
           WHEN TotalAmount > 500  THEN TotalAmount * 0.95
           ELSE TotalAmount
       END AS AmountAfterDiscount,
       CASE
           WHEN TotalAmount > 1000 THEN '10% off'
           WHEN TotalAmount > 500  THEN '5% off'
           ELSE 'No discount'
       END AS DiscountApplied
FROM Orders;

SELECT EmployeeID, FirstName, LastName, Salary,
       CASE
           WHEN Salary >= 60000 THEN 'High'
           WHEN Salary >= 45000 THEN 'Medium'
           ELSE 'Low'
       END AS SalaryCategory
FROM Employees;
