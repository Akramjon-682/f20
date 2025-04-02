-- Create Employees Table
CREATE TABLE Employeess (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT,
    age INT,
    hire_date DATEtime
);

-- Insert Sample Data
INSERT INTO Employeess (id, name, salary, department_id, age, hire_date) VALUES
(1, 'Alice', 50000, 1, 25, '2020-01-10'),
(2, 'Bob', 60000, 1, 30, '2019-02-15'),
(3, 'Charlie', 55000, 2, 35, '2018-03-20'),
(4, 'David', 70000, 2, 40, '2017-05-25'),
(5, 'Eve', 65000, 3, 29, '2021-06-30'),
(6, 'Frank', 80000, 3, 32, '2016-08-15'),
(7, 'Grace', 75000, 1, 27, '2022-09-10'),
(8, 'Hank', 72000, 2, 37, '2023-10-05'),
(9, 'Ivy', 55000, 3, 33, '2015-11-25'),
(10, 'Jack', 90000, 1, 42, '2014-12-30');

-- 1. Assign row numbers to employees ordered by salary
SELECT id, name, salary, ROW_NUMBER() OVER (ORDER BY salary) AS row_num FROM Employeess;

-- 2. Rank products based on their price in descending order
SELECT id, product_name, price, RANK() OVER (ORDER BY price DESC) AS rank_num FROM Products;

-- 3. Rank employees by salary using DENS
E_RANK()
SELECT id, name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank FROM Employees;

-- 4. Display next salary using LEAD()
SELECT id, name, salary, LEAD(salary) OVER (PARTITION BY department_id ORDER BY salary) AS next_salary FROM Employees;

-- 5. Assign a unique row number to each order
SELECT order_id, customer_id, ROW_NUMBER() OVER (ORDER BY order_id) AS order_num FROM Orders;

-- 6. Identify highest and second-highest salaries using RANK()
WITH RankedSalaries AS (
    SELECT 
        id, 
        name, 
        salary, 
        RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM Employeess
)
SELECT id, name, salary, salary_rank 
FROM RankedSalaries
WHERE salary_rank = 2;

-- 7. Show previous salary using LAG()
SELECT id, name, salary, LAG(salary) OVER (ORDER BY salary) AS prev_salary FROM Employeess;

-- 8. Divide employees into 4 salary groups using NTILE(4)
SELECT id, name, salary, NTILE(4) OVER (ORDER BY salary) AS salary_group FROM Employeess;

-- 9. Assign row numbers within each department
SELECT id, name, department_id, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary) AS dept_row_num FROM Employeess;

-- 10. Rank products by price in ascending order using DENSE_RANK()
SELECT id, product_name, price, DENSE_RANK() OVER (ORDER BY price ASC) AS dense_rank FROM Products;

-- 11. Calculate moving average of price using window functions
SELECT id, product_name, price, AVG(price) OVER (ORDER BY id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg FROM Products;

-- 12. Display next employee’s salary using LEAD()
SELECT id, name, salary, LEAD(salary) OVER (ORDER BY id) AS next_salary FROM Employeess;

-- 13. Compute cumulative sum of SalesAmount
SELECT id, SalesAmount, SUM(SalesAmount) OVER (ORDER BY id) AS cumulative_sales FROM Sales;

-- 14. Identify top 5 most expensive products using ROW_NUMBER()
SELECT id, product_name, price FROM (
    SELECT id, product_name, price, ROW_NUMBER() OVER (ORDER BY price DESC) AS rn FROM Products
) AS ranked WHERE rn <= 5;

-- 15. Calculate total OrderAmount per customer
SELECT customer_id, SUM(OrderAmount) AS total_order_amount FROM Orders GROUP BY customer_id;

-- 16. Rank orders by OrderAmount using RANK()
SELECT order_id, customer_id, OrderAmount, RANK() OVER (ORDER BY OrderAmount DESC) AS order_rank FROM Orders;

-- 17. Compute percentage contribution of SalesAmount by ProductCategory
SELECT category_id, SUM(SalesAmount) AS total_sales, SUM(SalesAmount) * 100.0 / SUM(SUM(SalesAmount)) OVER () AS percentage_contribution FROM Sales GROUP BY category_id;

-- 18. Retrieve next order date using LEAD()
SELECT order_id, customer_id, order_date, LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date FROM Orders;

-- 19. Divide employees into 3 groups by age using NTILE(3)
SELECT id, name, age, NTILE(3) OVER (ORDER BY age) AS age_group FROM Employees;

-- 20. List most recently hired employees using ROW_NUMBER()
SELECT id, name, hire_date FROM (

) AS ranked WHERE rn <= 5;

--medium tasks

-- 1. Compute the cumulative average salary of employees, ordered by Salary.
SELECT EmployeeID, Salary, 
       AVG(Salary) OVER (ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAvgSalary
FROM Employees;

-- 2. Rank products by their total sales while handling ties appropriately.
SELECT ProductID, SUM(SalesAmount) AS TotalSales, 
       RANK() OVER (ORDER BY SUM(SalesAmount) DESC) AS SalesRank
FROM Sales
GROUP BY ProductID;

-- 3. Retrieve the previous order's date for each order using LAG().
SELECT OrderID, CustomerID, OrderDate, 
       LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
FROM Orders;

-- 4. Calculate the moving sum of Price for products with a window frame of 3 rows.
SELECT ProductID, Price, 
       SUM(Price) OVER (ORDER BY ProductID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingSum
FROM Products;

-- 5. Assign employees to four salary ranges using NTILE(4).
SELECT EmployeeID, Salary, 
       NTILE(4) OVER (ORDER BY Salary) AS SalaryRange
FROM Employees;

-- 6. Partition the Sales table by ProductID and calculate total SalesAmount per product.
SELECT ProductID, SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- 7. Rank products by StockQuantity using DENSE_RANK() without gaps.
SELECT ProductID, StockQuantity, 
       DENSE_RANK() OVER (ORDER BY StockQuantity DESC) AS StockRank
FROM Products;

-- 8. Identify the second highest salary in each department using ROW_NUMBER().
SELECT EmployeeID, DepartmentID, Salary
FROM (
    SELECT EmployeeID, DepartmentID, Salary, 
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RowNum
    FROM Employees
) AS RankedSalaries
WHERE RowNum = 2;

-- 9. Calculate the running total of sales for each product in the Sales table.
SELECT ProductID, SaleDate, SalesAmount, 
       SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal
FROM Sales;

-- 10. Display the SalesAmount of the next row for each employee’s sale using LEAD().
SELECT EmployeeID, SaleDate, SalesAmount, 
       LEAD(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS NextSaleAmount
FROM Sales;

-- 11. Determine the highest earners within each department using RANK().
SELECT EmployeeID, DepartmentID, Salary, 
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 12. Partition employees by DepartmentID and rank them by salary.
SELECT EmployeeID, DepartmentID, Salary, 
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RankInDepartment
FROM Employees;

-- 13. Divide products into five groups based on their Price using NTILE(5).
SELECT ProductID, Price, 
       NTILE(5) OVER (ORDER BY Price) AS PriceGroup
FROM Products;

-- 14. Calculate the difference between each employee's salary and the highest salary in their department.
SELECT EmployeeID, DepartmentID, Salary, 
       MAX(Salary) OVER (PARTITION BY DepartmentID) - Salary AS SalaryDifference
FROM Employees;

-- 15. Display the previous product's SalesAmount for each sale using LAG().
SELECT SaleID, ProductID, SalesAmount, 
       LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS PreviousSalesAmount
FROM Sales;

-- 16. Calculate the cumulative sum of OrderAmount for each customer in the Orders table.
SELECT CustomerID, OrderID, OrderDate, OrderAmount, 
       SUM(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS CumulativeOrderAmount
FROM Orders;

-- 17. Identify the 3rd most recent order for each customer using ROW_NUMBER().
SELECT CustomerID, OrderID, OrderDate
FROM (
    SELECT CustomerID, OrderID, OrderDate, 
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum
    FROM Orders
) AS RankedOrders
WHERE RowNum = 3;

-- 18. Partition employees by DepartmentID and rank them by HireDate within each department.
SELECT EmployeeID, DepartmentID, HireDate, 
       RANK() OVER (PARTITION BY DepartmentID ORDER BY HireDate) AS HireDateRank
FROM Employees;

-- 19. Find the 3rd highest Salary in each department using DENSE_RANK().
SELECT EmployeeID, DepartmentID, Salary
FROM (
    SELECT EmployeeID, DepartmentID, Salary, 
           DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
    FROM Employees
) AS RankedSalaries
WHERE Rank = 3;

-- 20. Calculate the difference in OrderDate between consecutive orders using LEAD().
SELECT OrderID, CustomerID, OrderDate, 
       LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) - OrderDate AS DaysBetweenOrders
FROM Orders;

-- hard tasks
-- Employees jadvali
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    Age INT
);

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, HireDate, Age) VALUES
(1, 'Ali', 1, 5000, '2015-06-12', 35),
(2, 'Bobur', 1, 7000, '2012-04-25', 42),
(3, 'Dilnoza', 2, 6500, '2018-08-10', 30),
(4, 'Javohir', 2, 8000, '2010-01-15', 45),
(5, 'Madina', 3, 5500, '2016-09-05', 28),
(6, 'Karim', 3, 9000, '2008-03-22', 50),
(7, 'Shoxrux', 4, 7500, '2013-11-30', 40),
(8, 'Zilola', 4, 6000, '2017-07-20', 32),
(9, 'Murod', 1, 7200, '2011-12-11', 44),
(10, 'Aziza', 2, 6800, '2019-05-18', 31);

-- Sales jadvali
-- Employees jadvali
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    HireDate DATE,
    Age INT
);

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, HireDate, Age) VALUES
(1, 'Ali', 1, 5000, '2015-06-12', 35),
(2, 'Bobur', 1, 7000, '2012-04-25', 42),
(3, 'Dilnoza', 2, 6500, '2018-08-10', 30),
(4, 'Javohir', 2, 8000, '2010-01-15', 45),
(5, 'Madina', 3, 5500, '2016-09-05', 28),
(6, 'Karim', 3, 9000, '2008-03-22', 50),
(7, 'Shoxrux', 4, 7500, '2013-11-30', 40),
(8, 'Zilola', 4, 6000, '2017-07-20', 32),
(9, 'Murod', 1, 7200, '2011-12-11', 44),
(10, 'Aziza', 2, 6800, '2019-05-18', 31);

-- Sales jadvali
drop table sales
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    SaleDate DATE,
    SalesAmount DECIMAL(10,2)
);

INSERT INTO Sales (SaleID, EmployeeID, SaleDate, SalesAmount) VALUES
(1, 1, '2024-01-01', 1000),
(2, 2, '2024-01-05', 1200),
(3, 3, '2024-01-07', 900),
(4, 4, '2024-01-10', 1500),
(5, 5, '2024-01-12', 800),
(6, 6, '2024-01-15', 2000),
(7, 7, '2024-01-18', 1300),
(8, 8, '2024-01-20', 1100),
(9, 9, '2024-01-25', 1700),
(10, 10, '2024-01-28', 1400);

-- Orders jadvali
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, OrderAmount) VALUES
(1, 101, '2024-01-01', 250),
(2, 102, '2024-01-03', 400),
(3, 103, '2024-01-05', 320),
(4, 104, '2024-01-07', 500),
(5, 105, '2024-01-10', 700),
(6, 106, '2024-01-12', 280),
(7, 107, '2024-01-15', 650),
(8, 108, '2024-01-17', 900),
(9, 109, '2024-01-20', 720),
(10, 110, '2024-01-25', 450);

-- Products jadvali
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    StockQuantity INT
);

INSERT INTO Products (ProductID, CategoryID, ProductName, Price, StockQuantity) VALUES
(1, 1, 'Laptop', 1200, 50),
(2, 1, 'Monitor', 300, 80),
(3, 2, 'Keyboard', 50, 200),
(4, 2, 'Mouse', 25, 300),
(5, 3, 'Printer', 400, 40),
(6, 3, 'Scanner', 350, 30),
(7, 4, 'Smartphone', 800, 100),
(8, 4, 'Tablet', 600, 120),
(9, 5, 'Headphones', 100, 150),
(10, 5, 'Speakers', 150, 90);



-- 1. Rank products by their sales (handling ties) but exclude the top 10% of products by sales.
select * from Sales ;
select * from Products;

-- 2. List employees with over 5 years of service, ordered by their HireDate.
SELECT EmployeeID, Name, HireDate
FROM (
    SELECT EmployeeID, Name, HireDate, 
           ROW_NUMBER() OVER (ORDER BY HireDate) AS RowNum
    FROM Employees
    WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
) AS FilteredEmployees;

-- 3. Divide employees into 10 groups based on Salary using NTILE(10).
SELECT EmployeeID, Salary, 
       NTILE(10) OVER (ORDER BY Salary) AS SalaryGroup
FROM Employees;

-- 4. Calculate the next SalesAmount for each sale and compare with current using LEAD().
SELECT EmployeeID, SaleDate, SalesAmount, 
       LEAD(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS NextSaleAmount,
       (LEAD(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) - SalesAmount) AS Difference
FROM Sales;

-- 5. Compute the average Price for each category.
SELECT CategoryID, AVG(Price) AS AvgPrice
FROM Products
GROUP BY CategoryID;

-- 6. Determine the top 3 most-sold products using RANK().
SELECT ProductID, SUM(SalesAmount) AS TotalSales, 
       RANK() OVER (ORDER BY SUM(SalesAmount) DESC) AS SalesRank
FROM Sales
GROUP BY ProductID
HAVING RANK() OVER (ORDER BY SUM(SalesAmount) DESC) <= 3;

-- 7. List the top 5 highest-paid employees from each department using ROW_NUMBER().
SELECT EmployeeID, DepartmentID, Salary
FROM (
    SELECT EmployeeID, DepartmentID, Salary, 
           ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
    FROM Employees
) AS RankedEmployees
WHERE Rank <= 5;

-- 8. Compute the moving average of sales over a 5-day window using LEAD() and LAG().

CREATE TABLE Saless (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SaleDate DATE,
    SalesAmount DECIMAL(10,2)
);

INSERT INTO Saless (SaleID, EmployeeID, ProductID, SaleDate, SalesAmount) VALUES
(1, 1, 1, '2024-01-01', 1000),
(2, 2, 2, '2024-01-05', 1200),
(3, 3, 3, '2024-01-07', 900),
(4, 4, 4, '2024-01-10', 1500),
(5, 5, 5, '2024-01-12', 800),
(6, 6, 6, '2024-01-15', 2000),
(7, 7, 7, '2024-01-18', 1300),
(8, 8, 8, '2024-01-20', 1100),
(9, 9, 9, '2024-01-25', 1700),
(10, 10, 10, '2024-01-28', 1400);

WITH av AS (
  SELECT 
    saledate,
    salesamount,
    (
      COALESCE(LAG(salesamount, 2) OVER (ORDER BY saledate), 0) +
      COALESCE(LAG(salesamount, 1) OVER (ORDER BY saledate), 0) +
      COALESCE(salesamount, 0) +
      COALESCE(LEAD(salesamount, 1) OVER (ORDER BY saledate), 0) +
      COALESCE(LEAD(salesamount, 2) OVER (ORDER BY saledate), 0)
    ) / 5.0 AS avgd
  FROM saless
)
SELECT * FROM av;

-- 9. Find the products with the top 5 highest sales figures using DENSE_RANK().
WITH RankedProducts AS (
  SELECT 
    ProductID, 
    SUM(SalesAmount) AS TotalSales,
    DENSE_RANK() OVER (ORDER BY SUM(SalesAmount) DESC) AS SalesRank
  FROM Saless
  GROUP BY ProductID
)
SELECT *
FROM RankedProducts
WHERE SalesRank <= 5;

-- 

SELECT * FROM Saless;
WITH  topp AS (
SELECT 
	PRODUCTid,Salesamount,
	dense_rank() over ( order by salesamount desc) as rk
from Saless 
)
select * from topp 
where rk <=5

-- 10. Partition orders by OrderAmount into four quartiles using NTILE(4).

select * from Orders
select *, 
	NTILE(4) over ( order by orderamount desc) as ntt
from Orders
--
SELECT OrderID, CustomerID, OrderAmount,
       NTILE(4) OVER (ORDER BY OrderAmount) AS Quartile
FROM Orders;

-- 11. Assign a unique sequence to each order and rank within each CustomerID using ROW_NUMBER().

select 
	*,
	ROW_NUMBER() over (partition by customerid order by orderamount ) as rk
from Orders
3
--
SELECT CustomerID, OrderID, OrderDate, 
       ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS OrderRank
FROM Orders;

-- 12. Partition employees by DepartmentID and calculate the total number of employees in each department.
CREATE TABLE Employeese (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employeese (EmployeeID, DepartmentID, Name, Salary)
VALUES 
    (1, 1, 'Alice', 5000),
    (2, 1, 'Bob', 6000),
    (3, 2, 'Charlie', 5500),
    (4, 2, 'David', 7000),
    (5, 3, 'Eve', 6500),
    (6, 3, 'Frank', 4800),
    (7, 1, 'Grace', 6200),
    (8, 2, 'Heidi', 5100),
    (9, 3, 'Ivan', 7200),
    (10, 1, 'Judy', 5300);

-- 12. Partition employees by DepartmentID and calculate the total number of employees in each department.
select * from Employeese
SELECT DepartmentID, (COUNT(EmployeeID) over (partition by departmentid)) AS TotalEmployees
FROM Employeese
;

-- 13. List the top 3 highest salaries and the bottom 3 salaries within each department using RANK().






SELECT EmployeeID, DepartmentID, Salary, RankInDept, BottomRank
FROM (
    SELECT EmployeeID, DepartmentID, Salary, 
           RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RankInDept,
           RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary ASC) AS BottomRank
    FROM Employeese
) AS RankedEmployees
WHERE RankInDept <= 3 OR BottomRank <= 3;

-- 14. Calculate the percentage change in SalesAmount from the previous sale using LAG().
SELECT EmployeeID, SaleDate, SalesAmount, 
       LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS PrevSalesAmount,
       ((SalesAmount - LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate)) * 100.0 /
        LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate)) AS PercentageChange
FROM Sales;
--

SELECT 
    EmployeeID, 
    SaleDate, 
    SalesAmount, 
    LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS PrevSalesAmount,
    CASE 
      WHEN LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) = 0 
           OR LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) IS NULL
      THEN NULL
      ELSE ((SalesAmount - LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate)) * 100.0 /
            LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate))
    END AS PercentageChange
FROM Sales;

-- 15. Compute both the cumulative sum and cumulative average of sales for each product.
SELECT ProductID, SaleDate, SalesAmount, 
       SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeSum,
       AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeAvg
FROM Sales;

-- 16. Rank employees by Age into 3 groups using NTILE(3).
SELECT EmployeeID, Age, 
       NTILE(3) OVER (ORDER BY Age) AS AgeGroup
FROM Employees;

-- 17. Identify the top 10 employees with the highest sales using ROW_NUMBER().
SELECT EmployeeID, SalesAmount
FROM (
    SELECT EmployeeID, SalesAmount, 
           ROW_NUMBER() OVER (ORDER BY SalesAmount DESC) AS Rank
    FROM Sales
) AS RankedSales
WHERE Rank <= 10;

-- 18. Calculate the difference between each product's Price and the next product's Price using LEAD().
SELECT ProductID, Price, 
       LEAD(Price) OVER (ORDER BY Price) - Price AS PriceDifference
FROM Products;
select * from Products

-- 19. Rank employees based on a performance score using DENSE_RANK().
SELECT EmployeeID, PerformanceScore, 
       DENSE_RANK() OVER (ORDER BY PerformanceScore DESC) AS PerformanceRank
FROM EmployeePerformance;

-- 20. Determine the difference in SalesAmount relative to the previous and next orders using LAG() and LEAD().
SELECT OrderID, ProductID, SalesAmount,
       COALESCE( LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate),0) AS PrevSalesAmount,
       coalesce(LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate),0) AS NextSalesAmount,
       coalesce(SalesAmount,0) - coalesce(LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate),0) AS DiffFromPrev,
       coalesce(LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY OrderDate),0) - coalesce(SalesAmount,0) AS DiffFromNext
FROM Orderss;
select * from Orderss



CREATE TABLE Orderss (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    OrderDate DATE,
    SalesAmount DECIMAL(10,2)
);
INSERT INTO Orderss (OrderID, ProductID, OrderDate, SalesAmount) VALUES
(1, 1, '2024-01-01', 1000),
(2, 1, '2024-01-03', 1200),
(3, 1, '2024-01-05', 900),
(4, 1, '2024-01-07', 1500),
(5, 1, '2024-01-09', 800),
(6, 2, '2024-01-02', 2000),
(7, 2, '2024-01-04', 1800),
(8, 2, '2024-01-06', 2200),
(9, 2, '2024-01-08', 2100),
(10, 2, '2024-01-10', 2300);
