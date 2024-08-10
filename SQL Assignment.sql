--Question No 1
CREATE DATABASE EmployeeDB

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    salary INT,
    managerId INT
);

INSERT INTO Employee (id, name, salary, managerId) VALUES
(1, 'Bilal', 70000, 2),
(2, 'Ali', 60000, NULL),
(3, 'Hanzala', 50000, 2),
(4, 'Hassan', 45000, 3);

--Answer No 1

SELECT e1.name AS EmployeeName
FROM Employee e1
JOIN Employee e2 ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;

--Question No 2

CREATE TABLE Person (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);

INSERT INTO Person (id, email) VALUES
(1, 'Bilal@example.com'),
(2, 'Ali@example.com'),
(3, 'Hanzala@example.com'),
(4, 'Ali@example.com'),
(5, 'Hassan@example.com');

--Answer No 2

SELECT email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;

--Question No 3
--Answer No 3
DELETE FROM Person
WHERE id NOT IN (
    SELECT id
    FROM (
        SELECT MIN(id) AS id
        FROM Person
        GROUP BY email
    ) AS UniqueEmails
);

SELECT * FROM Person

--Question No 4
CREATE TABLE EmployeeUNI (
    id INT PRIMARY KEY,
    uniqueid INT
);
INSERT INTO EmployeeUNI (id, uniqueid) VALUES
(1, 1001),
(3, 1003);

--Answer 4
SELECT e.name, euni.uniqueid
FROM Employee e
LEFT JOIN EmployeeUNI euni
ON e.id = euni.id;

--Question No 5
ALTER TABLE Employee
ADD DepartmentID INT;
EXEC sp_help 'Employee';

UPDATE Employee
SET DepartmentID = 1
WHERE id IN (1, 2, 3, 4);

--Answer No 5
WITH MinSalaries AS (
    SELECT DepartmentID, MIN(Salary) AS MinSalary
    FROM Employee
    GROUP BY DepartmentID
)
SELECT e.id, e.Name, e.DepartmentID, e.Salary
FROM Employee e
JOIN MinSalaries ms
ON e.DepartmentID = ms.DepartmentID AND e.Salary = ms.MinSalary;

--Question No 6

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderItems (
    OrderID INT,
    ItemID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 101, '2024-08-01'),
(2, 102, '2024-08-02'),
(3, 101, '2024-08-03'),
(4, 103, '2024-08-04'),
(5, 102, '2024-08-05');

INSERT INTO OrderItems (OrderID, ItemID, Quantity) VALUES
(1, 201, 5),
(1, 202, 2),
(2, 203, 3),
(3, 204, 4),
(3, 205, 1),
(4, 206, 7),
(5, 207, 8);

--Answer No 6
SELECT TOP 1 o.CustomerID
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.CustomerID
ORDER BY SUM(oi.Quantity) DESC;

--Question No 7

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    JoinDate DATE
);

INSERT INTO Customers (CustomerID, Name, JoinDate) VALUES
(1, 'Ali Shehzad', '2024-01-15'),
(2, 'BIlal Rizwan', '2023-12-20'),
(3, 'Chacha Fazal', '2024-02-01');

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(101, 1, '2024-07-01'),
(102, 2, '2024-07-10'),
(103, 1, '2024-07-20'),
(104, 3, '2024-07-25'),
(105, 2, '2024-07-30');

--Answer No 7
SELECT c.CustomerID, c.Name, c.JoinDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = (
    SELECT MIN(o2.OrderDate)
    FROM Orders o2
    WHERE o2.CustomerID = c.CustomerID
)
AND o.OrderDate >= DATEADD(DAY, -30, GETDATE());

--Question No 8
--Answer No 8
SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

--Question No 9
--Answer No 9
SELECT e.id, e.name, e.salary, e.departmentId
FROM Employee e
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM Employee e2
    WHERE e2.departmentId = e.departmentId
);

--Question No 10
CREATE TABLE Product (
    Product_key INT PRIMARY KEY
);

CREATE TABLE Customer (
    Customer_id INT,
    Product_key INT,
    FOREIGN KEY (Product_key) REFERENCES Product(Product_key)
);

INSERT INTO Product (Product_key) VALUES
(1),
(2),
(3);

INSERT INTO Customer (Customer_id, Product_key) VALUES
(101, 1),
(101, 2),
(101, 3),
(102, 1),
(102, 2),
(103, 1),
(103, 2),
(103, 3);

--Answer No 10
WITH ProductCount AS (
    SELECT COUNT(DISTINCT Product_key) AS TotalProducts
    FROM Product
),
CustomerProductCount AS (
    SELECT Customer_id, COUNT(DISTINCT Product_key) AS BoughtProducts
    FROM Customer
    GROUP BY Customer_id
)
SELECT c.Customer_id
FROM CustomerProductCount c
JOIN ProductCount p ON c.BoughtProducts = p.TotalProducts;
