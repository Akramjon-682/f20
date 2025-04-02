-- 1. Har bir mahsulot uchun, Sales jadvalidagi SaleDate bo‘yicha tartiblangan SalesAmount ning running total (yig‘indisi)
SELECT 
    ProductID, 
    SaleDate, 
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningTotal
FROM Sales;

--------------------------------------------------

-- 2. Orders jadvalidagi har bir mijoz uchun Amount ustunining cumulative (yig‘indisi) summasi
SELECT 
    CustomerID, 
    OrderDate, 
    Amount,
    SUM(Amount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS CumulativeAmount
FROM Orders;

--------------------------------------------------

-- 3. Orders jadvalidagi har bir mijoz (CustomerID) bo‘yicha OrderAmount ustunining running total
SELECT 
    CustomerID, 
    OrderDate, 
    OrderAmount,
    SUM(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
FROM Orders;

--------------------------------------------------

-- 4. Sales jadvalidagi har bir mahsulot uchun, joriy qatorgacha bo‘lgan o‘rtacha SalesAmount ni hisoblash
SELECT 
    ProductID, 
    SaleDate, 
    SalesAmount,
    AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS RunningAvg
FROM Sales;

--------------------------------------------------

-- 5. Orders jadvalidagi OrderAmount ustunini RANK() yordamida reytinglash (kamayish tartibida)
SELECT 
    OrderID, 
    OrderAmount,
    RANK() OVER (ORDER BY OrderAmount DESC) AS OrderRank
FROM Orders;

--------------------------------------------------

-- 6. Sales jadvalidagi har bir mahsulot uchun, LEAD() yordamida keyingi qatorning SalesAmount ni olish
SELECT 
    ProductID, 
    SaleDate, 
    SalesAmount,
    LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS NextAmount
FROM Sales;

--------------------------------------------------

-- 7. Orders jadvalidagi har bir mijoz uchun, SUM() window funksiyasi orqali jami OrderAmount ni hisoblash
SELECT 
    CustomerID, 
    OrderID, 
    OrderAmount,
    SUM(OrderAmount) OVER (PARTITION BY CustomerID) AS TotalCustomerSales
FROM Orders;

--------------------------------------------------

-- 8. Orders jadvalidagi har bir mijoz uchun, OrderDate bo‘yicha hozirgi qatorgacha bo‘lgan buyurtmalar sonini hisoblash (COUNT)
SELECT 
    CustomerID, 
    OrderID, 
    OrderDate,
    COUNT(OrderID) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningOrderCount
FROM Orders;

--------------------------------------------------

-- 9. Sales jadvalidagi har bir mahsulot kategoriyasi (ProductCategory) bo‘yicha SalesAmount ning running total ni hisoblash
SELECT 
    ProductCategory, 
    SaleDate, 
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductCategory ORDER BY SaleDate) AS RunningTotal
FROM Sales;

--------------------------------------------------

-- 10. Orders jadvalidagi har bir buyurtmaga, OrderDate bo‘yicha unikal raqam (ROW_NUMBER) berish
SELECT 
    OrderID, 
    OrderDate,
    ROW_NUMBER() OVER (ORDER BY OrderDate) AS OrderRowNumber
FROM Orders;

--------------------------------------------------

-- 11. Orders jadvalidagi har bir buyurtma uchun, LAG() yordamida oldingi OrderAmount ni topish
SELECT 
    OrderID, 
    CustomerID, 
    OrderDate, 
    OrderAmount,
    LAG(OrderAmount) OVER (ORDER BY OrderDate) AS PrevOrderAmount
FROM Orders;

--------------------------------------------------

-- 12. Products jadvalidagi mahsulotlarni, Price ustuniga qarab 4 teng guruhga bo‘lish (NTILE(4))
SELECT 
    ProductID, 
    ProductName, 
    Price,
    NTILE(4) OVER (ORDER BY Price) AS PriceQuartile
FROM Products;

--------------------------------------------------

-- 13. Sales jadvalidagi har bir sotuvchi (SalespersonID) uchun cumulative sales (SUM) ni hisoblash
SELECT 
    SalespersonID, 
    SaleDate, 
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY SalespersonID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------

-- 14. Products jadvalidagi mahsulotlarni, StockQuantity bo‘yicha DENSE_RANK() yordamida reytinglash
SELECT 
    ProductID, 
    ProductName, 
    StockQuantity,
    DENSE_RANK() OVER (ORDER BY StockQuantity DESC) AS StockRank
FROM Products;

--------------------------------------------------

-- 15. Orders jadvalidagi har bir buyurtma uchun, LEAD() yordamida keyingi OrderAmount ni olish va joriy OrderAmount bilan farqni hisoblash
SELECT 
    OrderID, 
    OrderAmount,
    LEAD(OrderAmount) OVER (ORDER BY OrderDate) - OrderAmount AS DiffToNext
FROM Orders;

--------------------------------------------------

-- 16. Products jadvalidagi mahsulotlarni, Price ustuniga qarab RANK() yordamida reytinglash (kamayish tartibida)
SELECT 
    ProductID, 
    ProductName, 
    Price,
    RANK() OVER (ORDER BY Price DESC) AS PriceRank
FROM Products;

--------------------------------------------------

-- 17. Orders jadvalidagi har bir mijoz uchun, OrderAmount ustunining o‘rtacha qiymatini hisoblash (AVG)
SELECT 
    CustomerID, 
    OrderAmount,
    AVG(OrderAmount) OVER (PARTITION BY CustomerID) AS AvgOrderAmount
FROM Orders;

--------------------------------------------------

-- 18. Employees jadvalidagi xodimlarga, Salary bo‘yicha unikal raqam (ROW_NUMBER) berish
SELECT 
    EmployeeID, 
    Name, 
    Salary,
    ROW_NUMBER() OVER (ORDER BY Salary DESC) AS SalaryRowNumber
FROM Employees;

--------------------------------------------------

-- 19. Sales jadvalidagi har bir do'kon (StoreID) bo‘yicha, SalesAmount ustunining cumulative sum ni hisoblash
SELECT 
    StoreID, 
    SaleDate, 
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY StoreID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------

-- 20. Orders jadvalidagi har bir mijoz uchun, LAG() yordamida oldingi OrderAmount ni aniqlash
SELECT 
    OrderID, 
    CustomerID, 
    OrderDate, 
    OrderAmount,
    LAG(OrderAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PrevOrderAmount
FROM Orders;

-- medium

--------------------------------------------------
-- 1. Cumulative sum of SalesAmount for each employee in the Sales table (ordered by SaleDate)
SELECT 
    EmployeeID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------
-- 2. Difference in OrderAmount between current row and next row in the Orders table using LEAD()
SELECT 
    OrderID,
    OrderDate,
    OrderAmount,
    LEAD(OrderAmount) OVER (ORDER BY OrderDate) - OrderAmount AS DiffToNextOrderAmount
FROM Orders;

--------------------------------------------------
-- 3. Top 5 products based on SalesAmount using ROW_NUMBER() in the Sales table
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT 
    ProductID, 
    TotalSales
FROM (
    SELECT 
        ProductID,
        TotalSales,
        ROW_NUMBER() OVER (ORDER BY TotalSales DESC) AS rn
    FROM ProductSales
) AS RankedProducts
WHERE rn <= 5;

--------------------------------------------------
-- 4. Rank products with the top 10 sales in the Products table using RANK() (ordered by SalesAmount)
-- (Assuming Products table has a SalesAmount column)
WITH RankedProducts AS (
    SELECT 
        ProductID,
        SalesAmount,
        RANK() OVER (ORDER BY SalesAmount DESC) AS SalesRank
    FROM Products
)
SELECT 
    ProductID, 
    SalesAmount, 
    SalesRank
FROM RankedProducts
WHERE SalesRank <= 10;

--------------------------------------------------
-- 5. Number of orders per product in the Sales table using COUNT() as a window function
SELECT 
    ProductID,
    OrderID,
    COUNT(OrderID) OVER (PARTITION BY ProductID) AS OrdersCount
FROM Sales;

--------------------------------------------------
-- 6. Running total of SalesAmount for each ProductCategory in the Sales table
SELECT 
    ProductCategory,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductCategory ORDER BY SaleDate) AS RunningTotal
FROM Sales;

--------------------------------------------------
-- 7. Rank employees by Salary within each DepartmentID using DENSE_RANK()
SELECT 
    EmployeeID,
    DepartmentID,
    Salary,
    DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

--------------------------------------------------
-- 8. Moving average of SalesAmount for each product in the Sales table (window of 5 rows)
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    ( COALESCE(LAG(SalesAmount, 2) OVER (PARTITION BY ProductID ORDER BY SaleDate), 0) +
      COALESCE(LAG(SalesAmount, 1) OVER (PARTITION BY ProductID ORDER BY SaleDate), 0) +
      SalesAmount +
      COALESCE(LEAD(SalesAmount, 1) OVER (PARTITION BY ProductID ORDER BY SaleDate), 0) +
      COALESCE(LEAD(SalesAmount, 2) OVER (PARTITION BY ProductID ORDER BY SaleDate), 0)
    ) / 5.0 AS MovingAvg
FROM Sales;

--------------------------------------------------
-- 9. Divide products in the Products table into 3 groups based on Price using NTILE(3)
SELECT 
    ProductID,
    ProductName,
    Price,
    NTILE(3) OVER (ORDER BY Price) AS PriceGroup
FROM Products;

--------------------------------------------------
-- 10. Retrieve the previous SalesAmount for each employee's sale using LAG()
SELECT 
    EmployeeID,
    SaleDate,
    SalesAmount,
    LAG(SalesAmount) OVER (PARTITION BY EmployeeID ORDER BY SaleDate) AS PrevSalesAmount
FROM Sales;

--------------------------------------------------
-- 11. Cumulative sum of SalesAmount for each salesperson, ordered by SaleDate (assuming SalespersonID exists)
SELECT 
    SalespersonID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY SalespersonID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------
-- 12. Retrieve the SalesAmount of the next sale for each product using LEAD()
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    LEAD(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS NextSalesAmount
FROM Sales;

--------------------------------------------------
-- 13. Moving sum of SalesAmount for each product in the Sales table using a window function (window of 3 rows)
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingSum
FROM Sales;

--------------------------------------------------
-- 14. Identify employees with the top 3 salaries using RANK()
WITH RankedEmployees AS (
    SELECT 
        EmployeeID,
        Name,
        Salary,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees
)
SELECT *
FROM RankedEmployees
WHERE SalaryRank <= 3;

--------------------------------------------------
-- 15. Average order amount for each customer using AVG() window function in the Orders table
SELECT 
    CustomerID,
    OrderID,
    OrderAmount,
    AVG(OrderAmount) OVER (PARTITION BY CustomerID) AS AvgOrderAmount
FROM Orders;

--------------------------------------------------
-- 16. Assign a unique row number to orders in the Orders table, ordered by OrderDate using ROW_NUMBER()
SELECT 
    OrderID,
    OrderDate,
    ROW_NUMBER() OVER (ORDER BY OrderDate) AS OrderRowNumber
FROM Orders;

--------------------------------------------------
-- 17. Running total of SalesAmount for each employee in the Sales table, partitioned by DepartmentID
-- (Assuming Sales table contains DepartmentID along with EmployeeID)
SELECT 
    DepartmentID,
    EmployeeID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY DepartmentID, EmployeeID ORDER BY SaleDate) AS RunningTotal
FROM Sales;

--------------------------------------------------
-- 18. Divide employees in the Employees table into 5 equal groups based on Salary using NTILE(5)
SELECT 
    EmployeeID,
    Name,
    Salary,
    NTILE(5) OVER (ORDER BY Salary) AS SalaryGroup
FROM Employees;

--------------------------------------------------
-- 19. For each product in the Sales table, calculate both the cumulative sum of SalesAmount and the total sales
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS CumulativeSales,
    SUM(SalesAmount) OVER (PARTITION BY ProductID) AS TotalSales
FROM Sales;

--------------------------------------------------
-- 20. Identify products with the top 5 highest SalesAmount in the Sales table using DENSE_RANK()
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
), RankedProducts AS (
    SELECT 
        ProductID,
        TotalSales,
        DENSE_RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    FROM ProductSales
)
SELECT 
    ProductID,
    TotalSales,
    SalesRank
FROM RankedProducts
WHERE SalesRank <= 5;



--- hard tasks

--------------------------------------------------
-- 1. For each product and store in the Sales table,
--    calculate the running total of SalesAmount (ordered by SaleDate)
SELECT 
    ProductID,
    StoreID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductID, StoreID ORDER BY SaleDate) AS RunningTotal
FROM Sales;

--------------------------------------------------
-- 2. In the Orders table, calculate the percentage change in OrderAmount 
--    between the current row and the next row using LEAD()
SELECT 
    OrderID,
    OrderDate,
    OrderAmount,
    ((LEAD(OrderAmount) OVER (ORDER BY OrderDate) - OrderAmount) * 100.0 / OrderAmount) AS PercentChange
FROM Orders;

--------------------------------------------------
-- 3. Return the top 3 products by SalesAmount using ROW_NUMBER() 
--    (aggregating SalesAmount per product) and handling ties appropriately.
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT 
    ProductID, 
    TotalSales
FROM (
    SELECT 
        ProductID,
        TotalSales,
        ROW_NUMBER() OVER (ORDER BY TotalSales DESC) AS rn
    FROM ProductSales
) AS RankedProducts
WHERE rn <= 3;

--------------------------------------------------
-- 4. In the Employees table, assign a rank to each employee based on Salary,
--    partitioned by DepartmentID using RANK()
SELECT 
    EmployeeID,
    DepartmentID,
    Salary,
    RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

--------------------------------------------------
-- 5. Find the top 10% of orders in the Orders table based on OrderAmount
--    using the NTILE() function (group 1 corresponds to the top 10%)
SELECT 
    OrderID,
    OrderAmount
FROM (
    SELECT 
        OrderID,
        OrderAmount,
        NTILE(10) OVER (ORDER BY OrderAmount DESC) AS OrderGroup
    FROM Orders
) AS T
WHERE OrderGroup = 1;

--------------------------------------------------
-- 6. For each product in the Sales table, calculate the change in SalesAmount 
--    between the previous and current sale using LAG()
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    SalesAmount - LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS DiffFromPrev
FROM Sales;

--------------------------------------------------
-- 7. Compute the cumulative average of SalesAmount for each product,
--    ordered by SaleDate using AVG() with an appropriate window frame.
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    AVG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate
                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAvg
FROM Sales;

--------------------------------------------------
-- 8. Identify the products with the top 5 highest SalesAmount in the Products table
--    using DENSE_RANK() (ignoring ties)
--    (Assuming the Products table has a SalesAmount column)
WITH RankedProducts AS (
    SELECT 
        ProductID,
        SalesAmount,
        DENSE_RANK() OVER (ORDER BY SalesAmount DESC) AS SalesRank
    FROM Products
)
SELECT 
    ProductID,
    SalesAmount,
    SalesRank
FROM RankedProducts
WHERE SalesRank <= 5;

--------------------------------------------------
-- 9. Partition the Sales table by ProductCategory and calculate the running total 
--    of SalesAmount for each category.
SELECT 
    ProductCategory,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY ProductCategory ORDER BY SaleDate) AS RunningTotal
FROM Sales;

--------------------------------------------------
-- 10. In the Orders table, use both LEAD() and LAG() together to find the difference 
--     in OrderAmount between the previous and next rows.
SELECT 
    OrderID,
    OrderDate,
    OrderAmount,
    LAG(OrderAmount) OVER (ORDER BY OrderDate) AS PrevOrderAmount,
    LEAD(OrderAmount) OVER (ORDER BY OrderDate) AS NextOrderAmount,
    (LEAD(OrderAmount) OVER (ORDER BY OrderDate) - LAG(OrderAmount) OVER (ORDER BY OrderDate)) AS DiffBetween
FROM Orders;

--------------------------------------------------
-- 11. For each salesperson in the Sales table, calculate the cumulative total 
--     of SalesAmount ordered by SaleDate using SUM() as a window function.
SELECT 
    SalespersonID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY SalespersonID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------
-- 12. Divide products in the Products table into 10 groups based on Price using NTILE(10)
SELECT 
    ProductID,
    ProductName,
    Price,
    NTILE(10) OVER (ORDER BY Price) AS PriceDecile
FROM Products;

--------------------------------------------------
-- 13. Compute the moving average of OrderAmount in the Orders table using AVG() 
--     with a window frame (e.g., 1 preceding to 1 following row)
SELECT 
    OrderID,
    OrderDate,
    OrderAmount,
    AVG(OrderAmount) OVER (ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg
FROM Orders;

--------------------------------------------------
-- 14. Rank employees by Salary within each department using ROW_NUMBER()
SELECT 
    EmployeeID,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RowNum
FROM Employees;

--------------------------------------------------
-- 15. Calculate the number of orders per customer in the Orders table using COUNT()
--     as a window function.
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    COUNT(OrderID) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS OrdersCount
FROM Orders;

--------------------------------------------------
-- 16. Identify the products with the top 3 highest sales numbers in the Sales table,
--     considering ties, using RANK()
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
), RankedProducts AS (
    SELECT 
        ProductID,
        TotalSales,
        RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    FROM ProductSales
)
SELECT 
    ProductID,
    TotalSales,
    SalesRank
FROM RankedProducts
WHERE SalesRank <= 3;

--------------------------------------------------
-- 17. Compute the cumulative sales total for each employee and product in the Sales table.
SELECT 
    EmployeeID,
    ProductID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY EmployeeID, ProductID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------
-- 18. Identify the employees with the highest sales within each department in the Sales table
--     using DENSE_RANK() (assumes Sales table has EmployeeID and DepartmentID).
WITH EmployeeSales AS (
    SELECT 
        EmployeeID,
        DepartmentID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DepartmentID
), RankedEmployees AS (
    SELECT 
        EmployeeID,
        DepartmentID,
        TotalSales,
        DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY TotalSales DESC) AS SalesRank
    FROM EmployeeSales
)
SELECT 
    EmployeeID,
    DepartmentID,
    TotalSales,
    SalesRank
FROM RankedEmployees
WHERE SalesRank = 1;

--------------------------------------------------
-- 19. Partition the Sales table by StoreID and calculate the cumulative total 
--     of SalesAmount for each store.
SELECT 
    StoreID,
    SaleDate,
    SalesAmount,
    SUM(SalesAmount) OVER (PARTITION BY StoreID ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

--------------------------------------------------
-- 20. For each product in the Sales table, calculate the difference in SalesAmount 
--     between the previous and current sale using LAG().
SELECT 
    ProductID,
    SaleDate,
    SalesAmount,
    SalesAmount - LAG(SalesAmount) OVER (PARTITION BY ProductID ORDER BY SaleDate) AS DiffFromPrev
FROM Sales;
