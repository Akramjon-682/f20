-- 🟢 Easy-Level Tasks (10)

-- 1. INNER JOIN between Orders and Customers filtering orders placed after 2022
SELECT * 
FROM Orders O
INNER JOIN Customers C 
ON O.CustomerID = C.CustomerID 
AND O.OrderDate > '2022-12-31';

-- 2. JOIN Employees and Departments using OR to show Sales or Marketing employees
SELECT * 
FROM Employees E
INNER JOIN Departments D 
ON E.DepartmentID = D.DepartmentID 
AND (D.DepartmentName = 'Sales' OR D.DepartmentName = 'Marketing');

-- 3. JOIN a derived table with Orders to display products and their corresponding orders
SELECT O.OrderID, P.ProductName, P.Price 
FROM Orders O
JOIN (SELECT * FROM Products WHERE Price > 100) P 
ON O.ProductID = P.ProductID;

-- 4. JOIN a Temp table (Temp_Orders) and Orders to show common orders
SELECT O.* 
FROM Orders O
INNER JOIN Temp_Orders T 
ON O.OrderID = T.OrderID;

-- 5. CROSS APPLY between Employees and a derived table showing top sales per department
SELECT E.EmployeeID, E.Name, S.SaleAmount 
FROM Employees E
CROSS APPLY (
    SELECT TOP 5 SaleAmount 
    FROM Sales S 
    WHERE S.EmployeeID = E.EmployeeID 
    ORDER BY SaleAmount DESC
) AS S;

-- 6. JOIN Customers and Orders filtering Gold loyalty customers who ordered in 2023
SELECT * 
FROM Customers C
INNER JOIN Orders O 
ON C.CustomerID = O.CustomerID 
AND O.OrderDate BETWEEN '2023-01-01' AND '2023-12-31' 
AND C.LoyaltyStatus = 'Gold';

-- 7. JOIN Customers with a derived table showing order count per customer
SELECT C.CustomerID, C.CustomerName, OrderCount 
FROM Customers C
JOIN (SELECT CustomerID, COUNT(*) AS OrderCount FROM Orders GROUP BY CustomerID) O 
ON C.CustomerID = O.CustomerID;

-- 8. JOIN Products and Suppliers using OR to show products supplied by Supplier A or B
SELECT * 
FROM Products P
INNER JOIN Suppliers S 
ON P.SupplierID = S.SupplierID 
AND (S.SupplierName = 'Supplier A' OR S.SupplierName = 'Supplier B');

-- 9. OUTER APPLY between Employees and a derived table showing their most recent order
SELECT E.EmployeeID, E.Name, O.OrderDate 
FROM Employees E
OUTER APPLY (
    SELECT TOP 1 OrderDate 
    FROM Orders 
    WHERE EmployeeID = E.EmployeeID 
    ORDER BY OrderDate DESC
) O;

-- 10. CROSS APPLY between Departments and a table-valued function listing employees
SELECT D.DepartmentName, E.*
FROM Departments D
CROSS APPLY dbo.GetEmployeesByDepartment(D.DepartmentID) E;


--  Medium-Level Tasks (10)

-- 11. JOIN Orders and Customers filtering customers with orders over 5000
SELECT * 
FROM Orders O
INNER JOIN Customers C 
ON O.CustomerID = C.CustomerID 
AND O.TotalAmount > 5000;

-- 12. JOIN Products and Sales using OR to filter sales in 2022 or discounts > 20%
SELECT * 
FROM Products P
INNER JOIN Sales S 
ON P.ProductID = S.ProductID 
AND (S.SaleYear = 2022 OR S.Discount > 20);

-- 13. JOIN Products with a derived table showing total sales per product
SELECT P.ProductID, P.ProductName, S.TotalSales 
FROM Products P
JOIN (SELECT ProductID, SUM(Amount) AS TotalSales FROM Sales GROUP BY ProductID) S 
ON P.ProductID = S.ProductID;

-- 14. JOIN a Temp table (Temp_Products) and Products showing discontinued products
SELECT P.* 
FROM Products P
INNER JOIN Temp_Products T 
ON P.ProductID = T.ProductID 
AND T.Status = 'Discontinued';

-- 15. CROSS APPLY using a table-valued function to show employee sales performance
SELECT E.EmployeeID, E.Name, S.PerformanceRating
FROM Employees E
CROSS APPLY dbo.GetSalesPerformance(E.EmployeeID) S;

-- 16. JOIN Employees and Departments filtering HR employees with salary > 5000
SELECT * 
FROM Employees E
INNER JOIN Departments D 
ON E.DepartmentID = D.DepartmentID 
AND D.DepartmentName = 'HR' 
AND E.Salary > 5000;

-- 17. JOIN Orders and Payments using OR to show fully or partially paid orders
SELECT * 
FROM Orders O
INNER JOIN Payments P 
ON O.OrderID = P.OrderID 
AND (P.PaymentStatus = 'Paid' OR P.PaymentStatus = 'Partial');

-- 18. OUTER APPLY to return all customers with their most recent order
SELECT C.CustomerID, C.Name, O.OrderDate
FROM Customers C
OUTER APPLY (
    SELECT TOP 1 OrderDate 
    FROM Orders 
    WHERE CustomerID = C.CustomerID 
    ORDER BY OrderDate DESC
) O;

-- 19. JOIN Products and Sales filtering products sold in 2023 with rating > 4
SELECT * 
FROM Products P
INNER JOIN Sales S 
ON P.ProductID = S.ProductID 
AND S.SaleYear = 2023 
AND P.Rating > 4;

-- 20. JOIN Employees and Departments using OR to filter Sales employees or Managers
SELECT * 
FROM Employees E
INNER JOIN Departments D 
ON E.DepartmentID = D.DepartmentID 
AND (D.DepartmentName = 'Sales' OR E.JobTitle LIKE '%Manager%');


--  Hard-Level Tasks (10)

-- 21. JOIN Orders and Customers filtering New York customers with >10 orders
SELECT * 
FROM Orders O
INNER JOIN Customers C 
ON O.CustomerID = C.CustomerID 
AND C.City = 'New York' 
AND (SELECT COUNT(*) FROM Orders WHERE CustomerID = C.CustomerID) > 10;

-- 22. JOIN Products and Sales showing Electronics or products with >15% discount
SELECT * 
FROM Products P
INNER JOIN Sales S 
ON P.ProductID = S.ProductID 
AND (P.Category = 'Electronics' OR S.Discount > 15);

-- 23. JOIN Categories with a derived table showing product count per category
SELECT C.CategoryID, C.CategoryName, P.ProductCount
FROM Categories C
JOIN (SELECT CategoryID, COUNT(*) AS ProductCount FROM Products GROUP BY CategoryID) P 
ON C.CategoryID = P.CategoryID;

-- 24. JOIN Employees with a Temp table using a complex ON condition
SELECT * 
FROM Employees E
INNER JOIN Temp_Employees T 
ON E.EmployeeID = T.EmployeeID 
AND E.Salary > 4000 
AND E.Department = 'IT';

-- 25. CROSS APPLY using a function to count employees per department
SELECT D.DepartmentID, D.DepartmentName, E.EmployeeCount
FROM Departments D
CROSS APPLY dbo.CountEmployeesByDepartment(D.DepartmentID) E;

-- 26. JOIN Orders and Customers filtering California customers with orders >1000
SELECT * 
FROM Orders O
INNER JOIN Customers C 
ON O.CustomerID = C.CustomerID 
AND C.State = 'California' 
AND O.TotalAmount > 1000;

-- 27. JOIN Employees and Departments using OR for HR/Finance or Executives
SELECT * 
FROM Employees E
INNER JOIN Departments D 
ON E.DepartmentID = D.DepartmentID 
AND (D.DepartmentName IN ('HR', 'Finance') OR E.JobTitle = 'Executive');

-- 28. OUTER APPLY to return all customers with their orders (including none)
SELECT C.CustomerID, C.Name, O.OrderDate
FROM Customers C
OUTER APPLY (
    SELECT OrderDate 
    FROM Orders 
    WHERE CustomerID = C.CustomerID
) O;

-- 29. JOIN Sales and Products filtering quantity >100 and price >50
SELECT * 
FROM Sales S
INNER JOIN Products P 
ON S.ProductID = P.ProductID 
AND S.Quantity > 100 
AND P.Price > 50;

-- 30. JOIN Employees and Departments filtering Sales/Marketing employees with salary >6000
SELECT * 
FROM Employees E
INNER JOIN Departments D 
ON E.DepartmentID = D.DepartmentID 
AND (D.DepartmentName IN ('Sales', 'Marketing') AND E.Salary > 6000);
