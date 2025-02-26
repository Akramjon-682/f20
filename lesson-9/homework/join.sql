-- 1. Employees va Departments jadvalini INNER JOIN bilan bog‘lash va maoshi 5000 dan katta bo‘lganlarni chiqarish
SELECT e.EmployeeID, e.Name, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 5000;

-- 2. Customers va Orders jadvalini INNER JOIN qilish va 2023-yilda joylashtirilgan buyurtmalarni ko‘rsatish
SELECT c.CustomerID, c.Name, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2023;

-- 3. Employees va Departments jadvalini LEFT JOIN qilish va hamma xodimlarni ko‘rsatish
SELECT e.EmployeeID, e.Name, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 4. Products va Suppliers jadvalini RIGHT JOIN qilish va hamma yetkazib beruvchilarni ko‘rsatish
SELECT p.ProductID, p.ProductName, s.SupplierName
FROM Products p
RIGHT JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- 5. Orders va Payments jadvalini FULL JOIN qilish
SELECT o.OrderID, o.OrderDate, p.PaymentID, p.Amount
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID;

-- 6. Employees jadvali bilan SELF JOIN qilish va rahbarlarini ko‘rsatish
SELECT e1.Name AS EmployeeName, e2.Name AS ManagerName
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID;

-- 7. Products va Sales jadvalini JOIN qilish va 100 dan katta sotilgan mahsulotlarni ko‘rsatish
SELECT p.ProductID, p.ProductName, s.SalesAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SalesAmount > 100;

-- 8. Students va Courses jadvalini INNER JOIN qilish va 'Math 101' kursiga yozilganlarni ko‘rsatish
SELECT s.StudentID, s.Name, c.CourseName
FROM Students s
INNER JOIN StudentCourses sc ON s.StudentID = sc.StudentID
INNER JOIN Courses c ON sc.CourseID = c.CourseID
WHERE c.CourseName = 'Math 101';

-- 9. Customers va Orders jadvalini INNER JOIN qilish va 3 tadan ko‘p buyurtma bergan mijozlarni chiqarish
SELECT c.CustomerID, c.Name, COUNT(o.OrderID) AS OrderCount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
HAVING COUNT(o.OrderID) > 3;

-- 10. Employees va Departments jadvalini LEFT JOIN qilish va 'HR' bo‘limidagi xodimlarni chiqarish
SELECT e.EmployeeID, e.Name, d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR';

--medium

-- 11. 10 dan ortiq xodimi bor bo‘limlardagi xodimlarni chiqarish
SELECT e.EmployeeID, e.Name, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentID IN (
    SELECT DepartmentID FROM Employees GROUP BY DepartmentID HAVING COUNT(*) > 10
);

-- 12. Sotuvlari bo‘lmagan mahsulotlarni chiqarish
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;

-- 13. Kamida 1 ta buyurtma bergan mijozlarni chiqarish
SELECT c.CustomerID, c.Name
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NOT NULL;

-- 14. FULL JOIN va bo‘limi mavjud bo‘lgan xodimlarni chiqarish
SELECT e.EmployeeID, e.Name, d.DepartmentName
FROM Employees e
FULL OUTER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IS NOT NULL;

-- 15. Bir xil rahbarga bo‘ysunuvchi xodimlarni chiqarish
SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID
FROM Employees e1
JOIN Employees e2 ON e1.ManagerID = e2.ManagerID AND e1.EmployeeID <> e2.EmployeeID;

-- 16. 2022-yilda joylashtirilgan buyurtmalarni chiqarish
SELECT o.OrderID, o.OrderDate, c.Name
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2022;

-- 17. 'Sales' bo‘limidagi, 5000 dan katta maosh oluvchi xodimlarni chiqarish
SELECT e.EmployeeID, e.Name, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID AND d.DepartmentName = 'Sales'
WHERE e.Salary > 5000;

-- 18. IT bo‘limidagi xodimlarni chiqarish
SELECT e.EmployeeID, e.Name
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';

-- 19. To‘langan buyurtmalarni chiqarish
SELECT o.OrderID, o.OrderDate, p.PaymentID
FROM Orders o
FULL OUTER JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NOT NULL;

-- 20. Hech qachon buyurtma berilmagan mahsulotlarni chiqarish
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Orders o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

--hard

-- 21. O‘z bo‘limidagi o‘rtacha maoshdan ko‘proq oluvchi xodimlarni chiqarish
SELECT e.EmployeeID, e.Name, e.Salary, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > (
    SELECT AVG(Salary) FROM Employees WHERE DepartmentID = e.DepartmentID
);

-- 22. 2020-yilgacha to‘lanmagan buyurtmalarni chiqarish
SELECT o.OrderID, o.OrderDate
FROM Orders o
LEFT JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentID IS NULL AND o.OrderDate < '2020-01-01';

-- 23. Kategoriyasi yo‘q mahsulotlarni chiqarish
SELECT p.ProductID, p.ProductName
FROM Products p
FULL OUTER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryID IS NULL;

-- 24. Bir xil rahbarga bo‘ysunib, 5000 dan ortiq maosh oluvchi xodimlarni chiqarish
SELECT e1.Name AS Employee1, e2.Name AS Employee2, e1.ManagerID
FROM Employees e1
JOIN Employees e2 ON e1.ManagerID = e2.ManagerID AND e1.EmployeeID <> e2.EmployeeID
WHERE e1.Salary > 5000 AND e2.Salary > 5000;

--25
-- Assuming a table-valued function dbo.GetEmployeeCount returns the number of employees in a department
SELECT d.DepartmentID, d.DepartmentName, e.EmployeeCount
FROM Departments d
CROSS APPLY dbo.GetEmployeeCount(d.DepartmentID) e;
--26
SELECT o.OrderID, o.OrderAmount, c.CustomerName, c.State
FROM Orders o
INNER JOIN Customers c 
ON o.CustomerID = c.CustomerID 
AND c.State = 'California' 
AND o.OrderAmount > 1000;

--27
SELECT e.EmployeeID, e.EmployeeName, e.JobTitle, d.DepartmentName
FROM Employees e
INNER JOIN Departments d 
ON e.DepartmentID = d.DepartmentID 
AND (d.DepartmentName IN ('HR', 'Finance') OR e.JobTitle = 'Executive');

--28
-- Assuming dbo.GetCustomerOrders(CustomerID) returns a table of orders for a given customer
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate, o.OrderAmount
FROM Customers c
OUTER APPLY dbo.GetCustomerOrders(c.CustomerID) o
WHERE o.OrderID IS NULL;


--29
SELECT s.SaleID, p.ProductName, s.Quantity, p.Price
FROM Sales s
INNER JOIN Products p 
ON s.ProductID = p.ProductID 
AND s.Quantity > 100 
AND p.Price > 50;


--30
SELECT e.EmployeeID, e.EmployeeName, e.Salary, d.DepartmentName
FROM Employees e
INNER JOIN Departments d 
ON e.DepartmentID = d.DepartmentID 
AND (d.DepartmentName IN ('Sales', 'Marketing') OR e.Salary > 6000);
