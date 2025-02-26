-- 🟢 Easy-Level Tasks (10)

-- 1. INNER JOIN between Employees and Departments with salary filter
-- Shows only employees with a salary greater than 5000
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 5000;

-- 2. INNER JOIN between Customers and Orders for 2023 orders
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

-- 3. LEFT OUTER JOIN between Employees and Departments
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 4. RIGHT OUTER JOIN between Products and Suppliers    
SELECT p.ProductID, p.ProductName, s.SupplierName
FROM Products p
RIGHT JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- 5. FULL OUTER JOIN between Orders and Payments
SELECT o.OrderID, o.OrderDate, p.PaymentID, p.PaymentDate
FROM Orders o
FULL JOIN Payments p ON o.OrderID = p.OrderID;

-- 6. SELF JOIN to show Employees and their Managers
SELECT e1.EmployeeID, e1.EmployeeName, e2.EmployeeName AS ManagerName
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID;

-- 7. INNER JOIN between Products and Sales with sales greater than 100
SELECT p.ProductID, p.ProductName, s.Quantity
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.Quantity > 100;

-- 8. INNER JOIN between Students and Courses for 'Math 101'
SELECT s.StudentID, s.StudentName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';

-- 9. INNER JOIN between Customers and Orders to show customers with more than 3 orders
SELECT c.CustomerID, c.CustomerName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 3;

-- 10. LEFT JOIN between Employees and Departments for 'HR' employees
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR';

-- 🟠 Medium-Level Tasks (10)

-- 11. INNER JOIN between Employees and Departments for departments with more than 10 employees
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IN (
    SELECT DepartmentID FROM Employees GROUP BY DepartmentID HAVING COUNT(*) > 10
);

-- 12. LEFT JOIN between Products and Sales to find unsold products
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;

-- 13. RIGHT JOIN between Customers and Orders for customers with at least one order
SELECT c.CustomerID, c.CustomerName
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

-- 14. FULL OUTER JOIN between Employees and Departments excluding NULL department values
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
FULL JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IS NOT NULL;

-- 15. SELF JOIN on Employees to find employees with the same manager
SELECT e1.EmployeeID, e1.EmployeeName, e2.EmployeeName AS ManagerName
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.ManagerID AND e1.EmployeeID <> e2.EmployeeID;

-- 16. LEFT JOIN between Orders and Customers for orders in 2022
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2022;

-- 17. INNER JOIN between Employees and Departments for Sales employees with salary > 5000
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' AND e.Salary > 5000;

-- 18. INNER JOIN between Employees and Departments for IT department employees
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';

-- 19. FULL OUTER JOIN between Orders and Payments for only orders with payments
SELECT o.OrderID, p.PaymentID
FROM Orders o
FULL JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NOT NULL;

-- 20. LEFT JOIN between Products and Orders for products without orders
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.ProductID IS NULL;

-- 🔴 Hard-Level Tasks (10)

-- 21. Employees with salary above department average
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > (
    SELECT AVG(e2.Salary) FROM Employees e2 WHERE e2.DepartmentID = e.DepartmentID
);

-- 22. LEFT JOIN Orders and Payments for unpaid orders before 2020
SELECT o.OrderID, o.OrderDate
FROM Orders o
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL AND YEAR(o.OrderDate) < 2020;

-- 23. FULL JOIN Products and Categories for products without categories
SELECT p.ProductID, p.ProductName
FROM Products p
FULL JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IS NULL;

-- 24. SELF JOIN Employees for same manager and salary > 5000
SELECT e1.EmployeeID, e1.EmployeeName, e2.EmployeeName AS ManagerName
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE e1.Salary > 5000;

-- 25. RIGHT JOIN Employees and Departments for departments starting with 'M'
SELECT e.EmployeeID, e.EmployeeName, d.DepartmentName
FROM Employees e
RIGHT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName LIKE 'M%';

-- 26. Write a query to demonstrate the difference between the ON clause and the WHERE clause 
-- by joining Products and Sales, and using WHERE to filter only sales greater than 1000.

SELECT p.ProductID, p.ProductName, s.SaleAmount
FROM Products p
INNER JOIN Sales s 
    ON p.ProductID = s.ProductID
WHERE s.SaleAmount > 1000;


-- 27. Write a query to perform a LEFT OUTER JOIN between Students and Courses, 
-- and use the WHERE clause to show only students who have not enrolled in 'Math 101'.

SELECT s.StudentID, s.StudentName
FROM Students s
LEFT JOIN StudentCourses sc ON s.StudentID = sc.StudentID
LEFT JOIN Courses c ON sc.CourseID = c.CourseID
WHERE c.CourseName IS NULL OR c.CourseName <> 'Math 101';


-- 28. Write a query that explains the logical order of SQL execution 
-- by using a FULL OUTER JOIN between Orders and Payments, 
-- followed by a WHERE clause to filter out the orders with no payment.

SELECT o.OrderID, o.OrderDate, p.PaymentID, p.PaymentAmount
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NOT NULL;


-- 29. Write a query to join Products and Categories using an INNER JOIN, 
-- and use the WHERE clause to filter products that belong to either 'Electronics' or 'Furniture'.

SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');


-- 30. Write a query to perform a CROSS JOIN between Customers and Orders, 
-- and use the WHERE clause to filter the result to show customers with more than 2 orders placed in 2023.

SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
CROSS JOIN Orders o
WHERE o.CustomerID = c.CustomerID 
AND o.OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
HAVING COUNT(o.OrderID) > 2;
