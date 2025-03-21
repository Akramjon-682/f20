-- Task 1: Write a simple SELECT statement using a view named vwStaff to list all staff members from the Staff table.
CREATE VIEW vwStaff AS 
SELECT * FROM Staff;

SELECT * FROM vwStaff;

-- Task 2: Create a view vwItemPrices that displays all items along with their prices from the Items table.
CREATE VIEW vwItemPrices AS 
SELECT ItemID, ItemName, Price FROM Items;

SELECT * FROM vwItemPrices;

-- Task 3: Write a query to create a temporary table called #TempPurchases and insert sample data into it.
CREATE TABLE #TempPurchases (
    PurchaseID INT PRIMARY KEY,
    ClientID INT,
    ItemID INT,
    Quantity INT,
    PurchaseDate DATE
);

INSERT INTO #TempPurchases (PurchaseID, ClientID, ItemID, Quantity, PurchaseDate)
VALUES (1, 101, 201, 5, '2024-03-01'),
       (2, 102, 202, 2, '2024-03-05');

SELECT * FROM #TempPurchases;

-- Task 4: Declare a temporary variable @currentRevenue to store the total revenue for the current month.
DECLARE @currentRevenue DECIMAL(10,2);

SET @currentRevenue = (SELECT SUM(Price * Quantity) FROM Purchases WHERE MONTH(PurchaseDate) = MONTH(GETDATE()));

PRINT @currentRevenue;

-- Task 5: Write a scalar function named fnSquare that accepts a numeric input and returns its square.
CREATE FUNCTION fnSquare(@num INT)
RETURNS INT
AS
BEGIN
    RETURN @num * @num;
END;

SELECT dbo.fnSquare(4) AS SquareResult;

-- Task 6: Create a stored procedure spGetClients to return the list of all clients from the Clients table.
CREATE PROCEDURE spGetClients
AS
BEGIN
    SELECT * FROM Clients;
END;

EXEC spGetClients;

-- Task 7: Write a query that uses the MERGE statement to combine data from Purchases and Clients.
MERGE INTO Clients AS target
USING Purchases AS source
ON target.ClientID = source.ClientID
WHEN MATCHED THEN
    UPDATE SET target.LastPurchaseDate = source.PurchaseDate
WHEN NOT MATCHED THEN
    INSERT (ClientID, ClientName, LastPurchaseDate)
    VALUES (source.ClientID, 'Unknown', source.PurchaseDate);

	select * from Clients
	select * from Purchases








-- Task 8: Create a temporary table #StaffInfo to hold staff details and insert sample rows into it.
CREATE TABLE #StaffInfo (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50)
);

INSERT INTO #StaffInfo (StaffID, Name, Department)
VALUES (1, 'Alice Johnson', 'HR'),
       (2, 'Bob Smith', 'IT');

SELECT * FROM #StaffInfo;

-- Task 9: Write a function fnEvenOdd that takes a numeric parameter and returns a string indicating whether the number is "Even" or "Odd."
CREATE FUNCTION fnEvenOdd(@num INT)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CASE WHEN @num % 2 = 0 THEN 'Even' ELSE 'Odd' END;
END;

SELECT dbo.fnEvenOdd(7) AS NumberType;

-- Task 10: Create a stored procedure spMonthlyRevenue that calculates the total revenue for a specified month and year.
CREATE PROCEDURE spMonthlyRevenue(@month INT, @year INT)
AS
BEGIN
    SELECT SUM(Price * Quantity) AS TotalRevenue
    FROM Purchases
    WHERE MONTH(PurchaseDate) = @month AND YEAR(PurchaseDate) = @year;
END;

EXEC spMonthlyRevenue 3, 2024;

-- Task 11: Write a query to create a view vwRecentItemSales that shows the total sales per item for the last month.
CREATE VIEW vwRecentItemSales AS 
SELECT ItemID, SUM(Quantity) AS TotalSold
FROM Purchases
WHERE PurchaseDate >= DATEADD(MONTH, -1, GETDATE())
GROUP BY ItemID;

SELECT * FROM vwRecentItemSales;

-- Task 12: Declare a temporary variable @currentDate to hold the current date and then print it.
DECLARE @currentDate DATE;
SET @currentDate = GETDATE();
PRINT @currentDate;

-- Task 13: Create a view vwHighQuantityItems that lists items with quantities greater than 100 from the Items table.
CREATE VIEW vwHighQuantityItems AS 
SELECT ItemID, ItemName, Quantity
FROM Items
WHERE Quantity > 100;

SELECT * FROM vwHighQuantityItems;

-- Task 14: Write a query to create a temporary table #ClientOrders and join it with the Purchases table to display client orders.
CREATE TABLE #ClientOrders (
    OrderID INT PRIMARY KEY,
    ClientID INT,
    OrderDate DATE
);

INSERT INTO #ClientOrders (OrderID, ClientID, OrderDate)
VALUES (1, 101, '2024-03-01'),
       (2, 102, '2024-03-05');

SELECT c.OrderID, c.ClientID, c.OrderDate, p.ItemID, p.Quantity
FROM #ClientOrders c
JOIN Purchases p ON c.ClientID = p.ClientID;

-- Task 15: Create a stored procedure spStaffDetails that takes a staff ID as a parameter and returns the staff member’s name and department.
CREATE PROCEDURE spStaffDetails(@staffID INT)
AS
BEGIN
    SELECT Name, Department FROM Staff WHERE StaffID = @staffID;
END;

EXEC spStaffDetails 1;

-- Task 16: Write a simple function fnAddNumbers that takes two numeric parameters and returns their sum.
CREATE FUNCTION fnAddNumbers(@num1 INT, @num2 INT)
RETURNS INT
AS
BEGIN
    RETURN @num1 + @num2;
END;

SELECT dbo.fnAddNumbers(10, 20) AS SumResult;

-- Task 17: Write a MERGE statement to update the Items table with new pricing data sourced from a temporary table #NewItemPrices.
CREATE TABLE #NewItemPrices (
    ItemID INT PRIMARY KEY,
    NewPrice DECIMAL(10,2)
);

INSERT INTO #NewItemPrices (ItemID, NewPrice)
VALUES (201, 25.99),
       (202, 18.50);

MERGE INTO Items AS target
USING #NewItemPrices AS source
ON target.ItemID = source.ItemID
WHEN MATCHED THEN
    UPDATE SET target.Price = source.NewPrice;

SELECT * FROM Items;

-- Task 18: Create a view vwStaffSalaries that displays staff names along with their salaries.
CREATE VIEW vwStaffSalaries AS 
SELECT StaffID, Name, Salary FROM Staff;

SELECT * FROM vwStaffSalaries;

-- Task 19: Write a stored procedure spClientPurchases that returns all purchases for a specific client given the client ID.
CREATE PROCEDURE spClientPurchases(@clientID INT)
AS
BEGIN
    SELECT * FROM Purchases WHERE ClientID = @clientID;
END;

EXEC spClientPurchases 101;

-- Task 20: Write a function fnStringLength that returns the length of a given string parameter.
CREATE FUNCTION fnStringLength(@inputString VARCHAR(255))
RETURNS INT
AS
BEGIN
    RETURN LEN(@inputString);
END;

SELECT dbo.fnStringLength('Hello, World!') AS StringLength;

--medium

-- 1. Create a view vwClientOrderHistory that shows all purchases made by a specific client, including the purchase dates.
CREATE VIEW vwClientOrderHistory AS
SELECT p.ClientID, c.ClientName, p.PurchaseID, p.PurchaseDate, p.TotalAmount
FROM Purchases p
JOIN Clients c ON p.ClientID = c.ClientID;

-- 2. Write a query to create a temporary table #YearlyItemSales that stores item sales data for the current year.
CREATE TABLE #YearlyItemSales (
    ItemID INT,
    TotalSold INT,
    Revenue DECIMAL(10,2)
);

INSERT INTO #YearlyItemSales
SELECT ItemID, SUM(Quantity), SUM(TotalAmount)
FROM Purchases
WHERE YEAR(PurchaseDate) = YEAR(GETDATE())
GROUP BY ItemID;

-- 3. Develop a stored procedure spUpdatePurchaseStatus that accepts a purchase ID and updates its status.
CREATE PROCEDURE spUpdatePurchaseStatus (@PurchaseID INT, @NewStatus VARCHAR(50))
AS
BEGIN
    UPDATE Purchases
    SET Status = @NewStatus
    WHERE PurchaseID = @PurchaseID;
END;

-- 4. Write a MERGE statement to insert new records into the Purchases table if they don’t exist, or update them if they do.
MERGE INTO Purchases AS target
USING (SELECT PurchaseID, ClientID, PurchaseDate, TotalAmount FROM NewPurchases) AS source
ON target.PurchaseID = source.PurchaseID
WHEN MATCHED THEN
    UPDATE SET target.TotalAmount = source.TotalAmount
WHEN NOT MATCHED THEN
    INSERT (PurchaseID, ClientID, PurchaseDate, TotalAmount)
    VALUES (source.PurchaseID, source.ClientID, source.PurchaseDate, source.TotalAmount);

-- 5. Declare a temporary variable @avgItemSale that stores the average sale amount for a particular item.
DECLARE @avgItemSale DECIMAL(10,2);
SET @avgItemSale = (SELECT AVG(TotalAmount) FROM Purchases WHERE ItemID = 101);

-- 6. Create a view vwItemOrderDetails that combines data from Purchases and Items to display item names and quantities ordered.
CREATE VIEW vwItemOrderDetails AS
SELECT p.PurchaseID, i.ItemName, p.Quantity
FROM Purchases p
JOIN Items i ON p.ItemID = i.ItemID;

-- 7. Write a function fnCalcDiscount that computes a discount amount based on a given percentage for an order.
CREATE FUNCTION fnCalcDiscount(@TotalAmount DECIMAL(10,2), @DiscountPercent DECIMAL(5,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @TotalAmount * (@DiscountPercent / 100);
END;

-- 8. Create a stored procedure spDeleteOldPurchases to delete records of purchases older than a specified date.
CREATE PROCEDURE spDeleteOldPurchases (@DateCutoff DATE)
AS
BEGIN
    DELETE FROM Purchases WHERE PurchaseDate < @DateCutoff;
END;

-- 9. Write a MERGE statement that updates staff salaries in the Staff table based on new data from a temporary table #SalaryUpdates.
MERGE INTO Staff AS target
USING #SalaryUpdates AS source
ON target.StaffID = source.StaffID
WHEN MATCHED THEN
    UPDATE SET target.Salary = source.NewSalary;

-- 10. Create a view vwStaffRevenue that displays the total revenue per staff member by joining the Staff and Sales tables.
CREATE VIEW vwStaffRevenue AS
SELECT s.StaffID, s.StaffName, SUM(p.TotalAmount) AS TotalRevenue
FROM Staff s
JOIN Purchases p ON s.StaffID = p.StaffID
GROUP BY s.StaffID, s.StaffName;

-- 11. Write a function fnWeekdayName that takes a date as input and returns the corresponding weekday.
CREATE FUNCTION fnWeekdayName(@inputDate DATE)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN DATENAME(WEEKDAY, @inputDate);
END;

-- 12. Create a temporary table #TempStaff to store staff data and use an INSERT INTO ... SELECT statement to populate it from another table.
CREATE TABLE #TempStaff (
    StaffID INT,
    StaffName VARCHAR(100),
    Role VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO #TempStaff
SELECT StaffID, StaffName, Role, Salary FROM Staff;

-- 13. Write a query that uses a temporary variable to store and then display a client's total number of purchases.
DECLARE @TotalPurchases INT;
SET @TotalPurchases = (SELECT COUNT(*) FROM Purchases WHERE ClientID = 101);
SELECT @TotalPurchases AS TotalPurchases;

-- 14. Create a stored procedure spClientDetails that accepts a client ID and returns full details of the client along with their purchase history.
CREATE PROCEDURE spClientDetails (@ClientID INT)
AS
BEGIN
    SELECT * FROM Clients WHERE ClientID = @ClientID;
    SELECT * FROM Purchases WHERE ClientID = @ClientID;
END;

-- 15. Write a MERGE statement to update stock quantities in the Items table based on incoming data from a Delivery table.
MERGE INTO Items AS target
USING Delivery AS source
ON target.ItemID = source.ItemID
WHEN MATCHED THEN
    UPDATE SET target.StockQuantity = target.StockQuantity + source.DeliveredQuantity;

-- 16. Create a stored procedure spMultiply that takes two numeric parameters, calculates their product, and returns the result.
CREATE PROCEDURE spMultiply (@num1 INT, @num2 INT, @result INT OUTPUT)
AS
BEGIN
    SET @result = @num1 * @num2;
END;

-- 17. Write a function fnCalcTax to compute the sales tax for a given purchase amount.
CREATE FUNCTION fnCalcTax(@Amount DECIMAL(10,2), @TaxRate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Amount * (@TaxRate / 100);
END;

-- 18. Create a view vwTopPerformingStaff that combines staff and purchase data to show which staff members have fulfilled the most orders.
CREATE VIEW vwTopPerformingStaff AS
SELECT s.StaffID, s.StaffName, COUNT(p.PurchaseID) AS OrdersFulfilled
FROM Staff s
JOIN Purchases p ON s.StaffID = p.StaffID
GROUP BY s.StaffID, s.StaffName
ORDER BY OrdersFulfilled DESC;

-- 19. Write a MERGE statement to synchronize the Clients table with new records from a temporary data source #ClientDataTemp.
MERGE INTO Clients AS target
USING #ClientDataTemp AS source
ON target.ClientID = source.ClientID
WHEN MATCHED THEN
    UPDATE SET target.ClientName = source.ClientName
WHEN NOT MATCHED THEN
    INSERT (ClientID, ClientName)
    VALUES (source.ClientID, source.ClientName);

-- 20. Create a stored procedure spTopItems to return the top 5 best-selling items.
CREATE PROCEDURE spTopItems
AS
BEGIN
    SELECT TOP 5 ItemID, ItemName, SUM(Quantity) AS TotalSold
    FROM Purchases
    GROUP BY ItemID, ItemName
    ORDER BY TotalSold DESC;
END;

--difficult tasks

-- 1. Write a stored procedure spTopSalesStaff to determine the staff member with the highest total revenue in a given year.
CREATE PROCEDURE spTopSalesStaff(@year INT)
AS
BEGIN
    SELECT TOP 1 StaffID, SUM(TotalAmount) AS TotalRevenue
    FROM Sales
    WHERE YEAR(SaleDate) = @year
    GROUP BY StaffID
    ORDER BY TotalRevenue DESC;
END;

-- 2. Create a view vwClientOrderStats that shows the number of purchases per client and the total purchase value.
CREATE VIEW vwClientOrderStats AS
SELECT ClientID, COUNT(*) AS PurchaseCount, SUM(TotalAmount) AS TotalValue
FROM Purchases
GROUP BY ClientID;

-- 3. Write a MERGE statement to synchronize two tables, Purchases and Items, with both updates and inserts based on the latest sales data.
MERGE INTO Purchases AS target
USING Items AS source
ON target.ItemID = source.ItemID
WHEN MATCHED THEN
    UPDATE SET target.Quantity = source.Stock
WHEN NOT MATCHED THEN
    INSERT (ItemID, Quantity, TotalAmount)
    VALUES (source.ItemID, 0, 0);

-- 4. Create a function fnMonthlyRevenue that returns the total revenue for a specific year and month.
CREATE FUNCTION fnMonthlyRevenue(@year INT, @month INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @revenue DECIMAL(10,2);
    SET @revenue = (SELECT SUM(TotalAmount) FROM Sales WHERE YEAR(SaleDate) = @year AND MONTH(SaleDate) = @month);
    RETURN @revenue;
END;

-- 5. Write a complex stored procedure spProcessOrderTotals that accepts multiple parameters, calculates order totals, and updates order status accordingly.
CREATE PROCEDURE spProcessOrderTotals(@OrderID INT, @NewStatus VARCHAR(50))
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);
    SET @Total = (SELECT SUM(TotalAmount) FROM OrderDetails WHERE OrderID = @OrderID);
    UPDATE Orders SET Status = @NewStatus, TotalAmount = @Total WHERE OrderID = @OrderID;
END;

-- 6. Create a temporary table #StaffSalesData that joins staff records with their respective sales figures and use it in a subsequent calculation.
CREATE TABLE #StaffSalesData (StaffID INT, TotalSales DECIMAL(10,2));
INSERT INTO #StaffSalesData
SELECT StaffID, SUM(TotalAmount) FROM Sales GROUP BY StaffID;

-- 7. Write a MERGE statement to manage updates and deletions from a temporary table #SalesTemp into the main Sales table.
MERGE INTO Sales AS target
USING #SalesTemp AS source
ON target.SaleID = source.SaleID
WHEN MATCHED THEN UPDATE SET target.TotalAmount = source.TotalAmount
WHEN NOT MATCHED THEN INSERT (SaleID, TotalAmount) VALUES (source.SaleID, source.TotalAmount);

-- 8. Create a stored procedure spOrdersByDateRange that accepts a start and end date, returning all purchases made within that period.
CREATE PROCEDURE spOrdersByDateRange(@StartDate DATE, @EndDate DATE)
AS
BEGIN
    SELECT * FROM Purchases WHERE PurchaseDate BETWEEN @StartDate AND @EndDate;
END;

-- 9. Write a function fnCompoundInterest to calculate compound interest for an investment.
CREATE FUNCTION fnCompoundInterest(@Principal DECIMAL(10,2), @Rate FLOAT, @Time INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Principal * POWER((1 + @Rate/100), @Time);
END;

-- 10. Create a view vwQuotaExceeders that lists staff members who have exceeded their sales quotas.
CREATE VIEW vwQuotaExceeders AS
SELECT StaffID, SUM(TotalAmount) AS TotalSales
FROM Sales
GROUP BY StaffID
HAVING SUM(TotalAmount) > (SELECT AVG(Quota) FROM Staff);

-- 11. Create a stored procedure spSyncProductStock that merges product details with stock levels and updates stock quantities.
CREATE PROCEDURE spSyncProductStock
AS
BEGIN
    MERGE INTO Stock AS target
    USING Products AS source
    ON target.ProductID = source.ProductID
    WHEN MATCHED THEN UPDATE SET target.Quantity = target.Quantity + source.NewStock;
END;

-- 12. Write a MERGE statement to update staff records by comparing current data with an external data file.
MERGE INTO Staff AS target
USING ExternalStaffData AS source
ON target.StaffID = source.StaffID
WHEN MATCHED THEN UPDATE SET target.Salary = source.Salary
WHEN NOT MATCHED THEN INSERT (StaffID, Name, Salary) VALUES (source.StaffID, source.Name, source.Salary);

-- 13. Create a function fnDateDiffDays that accepts two dates and returns the number of days between them.
CREATE FUNCTION fnDateDiffDays(@Date1 DATE, @Date2 DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @Date1, @Date2);
END;

-- 14. Write a stored procedure spUpdateItemPrices that adjusts product prices based on sales data.
CREATE PROCEDURE spUpdateItemPrices
AS
BEGIN
    UPDATE Items
    SET Price = Price * 1.05
    WHERE ItemID IN (SELECT DISTINCT ItemID FROM Sales WHERE SaleDate > DATEADD(MONTH, -6, GETDATE()));
END;

-- 15. Write a MERGE statement that compares client data and synchronizes the Clients table with a temporary data source.
MERGE INTO Clients AS target
USING #ClientDataTemp AS source
ON target.ClientID = source.ClientID
WHEN MATCHED THEN UPDATE SET target.Name = source.Name, target.Email = source.Email
WHEN NOT MATCHED THEN INSERT (ClientID, Name, Email) VALUES (source.ClientID, source.Name, source.Email);

-- 16. Create a stored procedure spRegionalSalesReport that returns total revenue per region.
CREATE PROCEDURE spRegionalSalesReport
AS
BEGIN
    SELECT Region, SUM(TotalAmount) AS TotalRevenue, AVG(TotalAmount) AS AvgSale
    FROM Sales
    GROUP BY Region;
END;

-- 17. Write a function fnProfitMargin that calculates the profit margin for each item in a purchase.
CREATE FUNCTION fnProfitMargin(@Revenue DECIMAL(10,2), @Cost DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (@Revenue - @Cost) / @Revenue * 100;
END;

-- 18. Create a temporary table #TempStaffMerge and write a query to merge its data into the Staff table.
CREATE TABLE #TempStaffMerge (StaffID INT, Name VARCHAR(50), Salary DECIMAL(10,2));
MERGE INTO Staff AS target
USING #TempStaffMerge AS source
ON target.StaffID = source.StaffID
WHEN MATCHED THEN UPDATE SET target.Name = source.Name, target.Salary = source.Salary
WHEN NOT MATCHED THEN INSERT (StaffID, Name, Salary) VALUES (source.StaffID, source.Name, source.Salary);

-- 19. Write a stored procedure spBackupData to create backup copies of critical data before performing deletions.
CREATE PROCEDURE spBackupData(@TableName VARCHAR(50))
AS
BEGIN
    DECLARE @BackupQuery NVARCHAR(MAX);
    SET @BackupQuery = 'SELECT * INTO ' + @TableName + '_Backup FROM ' + @TableName;
    EXEC sp_executesql @BackupQuery;
END;

-- 20. Write a stored procedure spTopSalesReport that generates a ranked report of the top 10 staff members based on sales.
CREATE PROCEDURE spTopSalesReport
AS
BEGIN
    SELECT TOP 10 StaffID, SUM(TotalAmount) AS TotalSales, RANK() OVER (ORDER BY SUM(TotalAmount) DESC) AS Rank
    FROM Sales
    GROUP BY StaffID;
END;
