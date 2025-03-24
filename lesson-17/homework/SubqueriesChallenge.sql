-- 1. List all items where the price is greater than the average price of all items.
SELECT * 
FROM Items 
WHERE Price > (SELECT AVG(Price) FROM Items);

-- 2. Find staff members who have worked in a division that employs more than 10 people.
SELECT * 
FROM Staff 
WHERE DivisionID IN (
    SELECT DivisionID 
    FROM Staff 
    GROUP BY DivisionID 
    HAVING COUNT(*) > 10
);

-- 3. List all staff members whose salary exceeds the average salary in their respective division.
SELECT * 
FROM Staff s1
WHERE Salary > (
    SELECT AVG(Salary) 
    FROM Staff s2 
    WHERE s1.DivisionID = s2.DivisionID
);
select * from Staff

-- 4. Find all clients who have made a purchase in the Purchases table.
SELECT * 
FROM Clients 
WHERE ClientID IN (SELECT DISTINCT ClientID FROM Purchases);

-- 5. Retrieve all purchases that include at least one detail in the PurchaseDetails table.
SELECT * 
FROM Purchases p
WHERE EXISTS (
    SELECT 1 
    FROM PurchaseDetails pd 
    WHERE p.PurchaseID = pd.PurchaseID
);

-- 6. List all items that have been sold more than 100 times according to the PurchaseDetails table.
SELECT * 
FROM Items 
WHERE ItemID IN (
    SELECT ItemID 
    FROM PurchaseDetails 
    GROUP BY ItemID 
    HAVING SUM(Quantity) > 100
);

-- 7. List all staff members who earn more than the overall company’s average salary.
SELECT * 
FROM Staff 
WHERE Salary > (SELECT AVG(Salary) FROM Staff);

-- 8. Find all vendors that supply items with a price below $50.
SELECT * 
FROM Vendors 
WHERE VendorID IN (
    SELECT VendorID 
    FROM Items 
    WHERE Price < 50
);

-- 9. Determine the maximum item price in the Items table.
SELECT MAX(Price) AS MaxPrice FROM Items;

-- 10. Find the highest total purchase value in the Purchases table.
SELECT MAX(TotalAmount) AS MaxPurchaseValue FROM Purchases;

-- 11. List clients who have never made a purchase.
SELECT * 
FROM Clients 
WHERE ClientID NOT IN (SELECT DISTINCT ClientID FROM Purchases);

-- 12. List all items that belong to the category "Electronics."
SELECT * 
FROM Items 
WHERE CategoryID = (
    SELECT CategoryID 
    FROM Categories 
    WHERE CategoryName = 'Electronics'
);

-- 13. List all purchases that were made after a specified date.
SELECT * 
FROM Purchases 
WHERE PurchaseDate > '2024-01-01';

-- 14. Calculate the total number of items sold in a particular purchase.
SELECT PurchaseID, SUM(Quantity) AS TotalItemsSold 
FROM PurchaseDetails 
GROUP BY PurchaseID;

-- 15. List staff members who have been employed for more than 5 years.
SELECT * 
FROM Staff 
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5;

-- 16. List staff members who earn more than the average salary in their division.
SELECT * 
FROM Staff s1
WHERE Salary > (
    SELECT AVG(Salary) 
    FROM Staff s2 
    WHERE s1.DivisionID = s2.DivisionID
);

-- 17. List purchases that include an item from the Items table.
SELECT * 
FROM Purchases p
WHERE EXISTS (
    SELECT 1 
    FROM PurchaseDetails pd 
    WHERE p.PurchaseID = pd.PurchaseID
);

-- 18. Find clients who have made a purchase within the last 30 days.
SELECT * 
FROM Clients 
WHERE ClientID IN (
    SELECT DISTINCT ClientID 
    FROM Purchases 
    WHERE PurchaseDate >= DATEADD(DAY, -30, GETDATE())
);

-- 19. Identify the oldest item in the Items table.
SELECT * 
FROM Items 
WHERE AddedDate = (SELECT MIN(AddedDate) FROM Items);

-- 20. List staff members who are not assigned to any division.
SELECT * 
FROM Staff 
WHERE DivisionID IS NULL;

-- medium

-- Use a correlated subquery to find all staff who work in the same division as any staff member earning over $100,000.
SELECT DISTINCT s1.* FROM Staff s1
WHERE EXISTS (
    SELECT 1 FROM Staff s2
    WHERE s1.DivisionID = s2.DivisionID AND s2.Salary > 100000
);

-- Write a query to list all staff members who have the highest salary in their division using a subquery.
SELECT * FROM Staff s1
WHERE Salary = (SELECT MAX(Salary) FROM Staff s2 WHERE s1.DivisionID = s2.DivisionID);

-- Create a subquery to list all clients who have made purchases but have never bought an item priced above $200.
select * from clients
select * from purchases
select * from items
select * from PurchaseDetails
SELECT DISTINCT c.* FROM Clients c
WHERE EXISTS (
    SELECT 1 FROM Purchases p WHERE c.ClientID = p.ClientID
)
AND NOT EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    JOIN Items i ON pd.ItemID = i.ItemID 
    WHERE pd.PurchaseID IN (
        SELECT p.PurchaseID FROM Purchases p WHERE p.ClientID = c.ClientID
    )
    AND i.Price > 200
);

-- Write a query that uses a correlated subquery to find items that have been ordered more frequently than the average item.
SELECT i.* FROM Items i
WHERE (SELECT COUNT(*) FROM PurchaseDetails pd WHERE pd.ItemID = i.ItemID)
      > (SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM PurchaseDetails GROUP BY ItemID) AS avg_items);

-- Write a subquery to list clients who have placed more than 3 purchases.
SELECT ClientID FROM Purchases
GROUP BY ClientID
HAVING COUNT(*) > 3;

-- Use a subquery to calculate the number of items ordered in the last 30 days by each client.
SELECT ClientID, 
       (SELECT COUNT(*) FROM PurchaseDetails pd 
        JOIN Purchases p ON pd.PurchaseID = p.PurchaseID 
        WHERE p.ClientID = c.ClientID AND p.PurchaseDate >= DATEADD(DAY, -30, GETDATE())) AS ItemsOrderedLast30Days
FROM Clients c;

-- Create a correlated subquery to list staff whose salary exceeds the average salary of all staff in their division.
SELECT s1.* FROM Staff s1
WHERE Salary > (SELECT AVG(Salary) FROM Staff s2 WHERE s1.DivisionID = s2.DivisionID);

-- Write a query that uses a subquery to list items that have never been ordered.
SELECT * FROM Items
WHERE ItemID NOT IN (SELECT DISTINCT ItemID FROM PurchaseDetails);

-- Create a subquery to list all vendors who supply items priced above the average price of items.
SELECT DISTINCT v.* FROM Vendors v
WHERE EXISTS (
    SELECT 1 FROM Items i WHERE i.VendorID = v.VendorID AND i.Price > (SELECT AVG(Price) FROM Items)
);

-- Write a subquery to compute the total sales for each item in the past year.
SELECT ItemID, SUM(Quantity) AS TotalSold
FROM PurchaseDetails pd
JOIN Purchases p ON pd.PurchaseID = p.PurchaseID
WHERE p.PurchaseDate >= DATEADD(YEAR, -1, GETDATE())
GROUP BY ItemID;

-- Write a correlated subquery to list staff members older than the overall average age of the company.
SELECT * FROM Staff s1
WHERE Age > (SELECT AVG(Age) FROM Staff);

-- Write a query to list items with a price greater than the average price in the Items table.
SELECT * FROM Items WHERE Price > (SELECT AVG(Price) FROM Items);

-- Use a subquery to find clients who have purchased items from a specific category.
SELECT DISTINCT c.* FROM Clients c
WHERE EXISTS (
    SELECT 1 FROM Purchases p
    JOIN PurchaseDetails pd ON p.PurchaseID = pd.PurchaseID
    JOIN Items i ON pd.ItemID = i.ItemID
    WHERE p.ClientID = c.ClientID AND i.Category = 'Electronics'
);

-- Create a subquery to list all items with a quantity available greater than the average stock level.
SELECT * FROM Items WHERE QuantityAvailable > (SELECT AVG(QuantityAvailable) FROM Items);

-- Write a correlated subquery to list all staff who work in the same division as those who have received a bonus.
SELECT DISTINCT s1.* FROM Staff s1
WHERE EXISTS (
    SELECT 1 FROM Staff s2 WHERE s1.DivisionID = s2.DivisionID AND s2.Bonus IS NOT NULL
);

-- Write a query using a subquery to list staff members with salaries in the top 10% of all staff.
select * from staff
SELECT * FROM Staff 
SELECT * FROM Staff
WHERE Salary >= (
    SELECT DISTINCT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY Salary) 
    OVER () AS Salary_90th
    FROM Staff
);


WITH SalaryRanked AS (
    SELECT *, 
           PERCENT_RANK() OVER (ORDER BY Salary DESC) AS SalaryPercentile
    FROM Staff
)
SELECT * FROM SalaryRanked
WHERE SalaryPercentile >= 0.90;

-- Create a correlated subquery to identify the division that employs the most staff.

select * from staff
SELECT DivisionID, COUNT(*) AS StaffCount
FROM Staff
GROUP BY DivisionID
HAVING COUNT(*) = (
    SELECT MAX(StaffCount)
    FROM (
        SELECT DivisionID, COUNT(*) AS StaffCount
        FROM Staff
        GROUP BY DivisionID
    ) AS DivisionCounts
)
ORDER BY DivisionID DESC;
--
SELECT TOP 1 DivisionID, COUNT(*) AS StaffCount
FROM Staff
GROUP BY DivisionID
ORDER BY COUNT(*) DESC;
--
select * from staff
select top 1 divisionid , count(*) from staff
	group by divisionid
	order by  count(*) desc 
	OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;
-- birinchisidan keyingi ikkinchisi natijani olish
select * from staff
select  divisionid , count(*) from staff
	group by divisionid
	order by  count(*) desc 
	OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;
	   	  
-- Write a subquery to find the purchase with the highest total value.
select purchaseid , max(totalamount) as max_amount from purchases group by purchaseid order by max_amount desc
--
SELECT TOP 1 PurchaseID, SUM(TotalAmount) AS TotalValue
FROM Purchases
GROUP BY PurchaseID
ORDER BY TotalValue DESC;

-- Use a correlated subquery to list staff who earn more than the average salary of their division and have more than 5 years of service.
SELECT * FROM Staff s1
WHERE Salary > (SELECT AVG(Salary) FROM Staff s2 WHERE s1.DivisionID = s2.DivisionID)
AND YearsOfService > 5;

-- Create a query to list clients who have never purchased an item with a price higher than $100.
SELECT DISTINCT c.* FROM Clients c
WHERE EXISTS (
    SELECT 1 FROM Purchases p WHERE c.ClientID = p.ClientID
)
AND NOT EXISTS (
    SELECT 1 FROM PurchaseDetails pd 
    JOIN Items i ON pd.ItemID = i.ItemID 
    WHERE pd.PurchaseID IN (
        SELECT p.PurchaseID FROM Purchases p WHERE p.ClientID = c.ClientID
    )
    AND i.Price > 100
);
-- 2 - answer
SELECT * 
FROM Clients
WHERE ClientID NOT IN (
    -- This subquery selects all ClientIDs that have purchased at least one item costing over $100.
    SELECT p.ClientID
    FROM Purchases p
    JOIN PurchaseDetails pd ON p.PurchaseID = pd.PurchaseID
    JOIN Items i ON pd.ItemID = i.ItemID
    WHERE i.Price > 100
);

-- difficult tasks

------------------------------------------------------------
-- 1. List all staff who earn more than the average salary 
--    in their division, excluding the staff member with the highest salary in that division.
------------------------------------------------------------
select * from staff
SELECT *
FROM Staff s1
WHERE Salary > (
        SELECT AVG(Salary)
        FROM Staff s2
        WHERE s2.DivisionID = s1.DivisionID
    )
  AND Salary < (
        SELECT MAX(Salary)
        FROM Staff s3
        WHERE s3.DivisionID = s1.DivisionID
    );

	--2 answer

	with avg_max as (
	select 
		staffid,name,divisionid,salary,
		avg(salary) over (partition by divisionid) as avg_,
		max(salary) over (partition by divisionid) as max_ 
		from staff
	)
	select staffid,name,divisionid,salary from avg_max
		 where salary > avg_ and salary < max_
		 ;+

------------------------------------------------------------
-- 2. List items that have been purchased by clients 
--    who have placed more than 5 orders.
------------------------------------------------------------
SELECT DISTINCT i.*
FROM Items i
JOIN PurchaseDetails pd ON i.ItemID = pd.ItemID
WHERE pd.PurchaseID IN (
    SELECT p.PurchaseID
    FROM Purchases p
    WHERE p.ClientID IN (
        SELECT ClientID
        FROM Purchases
        GROUP BY ClientID
        HAVING COUNT(*) > 5
    )
);

------------------------------------------------------------
-- 3. List all staff who are older than the overall average age 
--    and earn more than the average company salary.
------------------------------------------------------------









SELECT *
FROM Staff
WHERE Age > (SELECT AVG(Age) FROM Staff)
  AND Salary > (SELECT AVG(Salary) FROM Staff);

------------------------------------------------------------
-- 4. List staff who work in a division that has more than 5 staff members 
--    earning over $100,000.
------------------------------------------------------------
SELECT *
FROM Staff s1
WHERE (
    SELECT COUNT(*) 
    FROM Staff s2 
    WHERE s2.DivisionID = s1.DivisionID AND s2.Salary > 100000
) > 5;

------------------------------------------------------------
-- 5. List all items that have not been purchased by any client in the past year.
------------------------------------------------------------

SELECT *
FROM Items
WHERE ItemID NOT IN (
    SELECT DISTINCT pd.ItemID
    FROM PurchaseDetails pd
    JOIN Purchases p ON pd.PurchaseID = p.PurchaseID
    WHERE p.PurchaseDate >= DATEADD(YEAR, -1, GETDATE())
);

------------------------------------------------------------
-- 6. List all clients who have made purchases that include items 
--    from at least two different categories.
------------------------------------------------------------
SELECT ClientID
FROM Purchases p
JOIN PurchaseDetails pd ON p.PurchaseID = pd.PurchaseID
JOIN Items i ON pd.ItemID = i.ItemID
GROUP BY ClientID
HAVING COUNT(DISTINCT i.Category) >= 2;

------------------------------------------------------------
-- 7. List staff who earn more than the average salary of staff in the same job position.
--    (Assuming a JobTitle column exists in Staff)
------------------------------------------------------------
SELECT *
FROM Staff s1
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Staff s2
    WHERE s2.JobTitle = s1.JobTitle
);

------------------------------------------------------------
-- 8. List items that are in the top 10% by price among all items.
------------------------------------------------------------
SELECT *
FROM Items
WHERE Price >= (
    SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY Price) FROM Items
);

------------------------------------------------------------
-- 9. List staff whose salary is in the top 10% within their division using a correlated subquery.
------------------------------------------------------------
WITH StaffRank AS (
    SELECT *, PERCENT_RANK() OVER (PARTITION BY DivisionID ORDER BY Salary DESC) AS RankValue
    FROM Staff
)
SELECT *
FROM StaffRank
WHERE RankValue >= 0.90;

------------------------------------------------------------
-- 10. List all staff who have not received any bonus in the last 6 months.
--     (Assuming a BonusDate column in Staff; if bonus is stored differently, adjust accordingly)
------------------------------------------------------------
SELECT *
FROM Staff
WHERE Bonus IS NULL OR BonusDate < DATEADD(MONTH, -6, GETDATE());

------------------------------------------------------------
-- 11. List items that have been ordered more frequently than the average number of orders per item.
------------------------------------------------------------
SELECT *
FROM Items i
WHERE (
    SELECT COUNT(*) FROM PurchaseDetails pd WHERE pd.ItemID = i.ItemID
) > (
    SELECT AVG(OrderCount) 
    FROM (
         SELECT COUNT(*) AS OrderCount FROM PurchaseDetails GROUP BY ItemID
    ) AS T
);

------------------------------------------------------------
-- 12. List all clients who made purchases last year for items priced above the average price.
------------------------------------------------------------
SELECT DISTINCT p.ClientID
FROM Purchases p
JOIN PurchaseDetails pd ON p.PurchaseID = pd.PurchaseID
JOIN Items i ON pd.ItemID = i.ItemID
WHERE p.PurchaseDate >= DATEADD(YEAR, -1, GETDATE())
  AND i.Price > (SELECT AVG(Price) FROM Items);

------------------------------------------------------------
-- 13. Identify the division with the highest average salary using a correlated subquery.
------------------------------------------------------------
SELECT TOP 1 DivisionID, AVG(Salary) AS AvgSalary
FROM Staff
GROUP BY DivisionID
ORDER BY AVG(Salary) DESC;

------------------------------------------------------------
-- 14. List items that have been purchased by clients who have placed more than 10 orders.
------------------------------------------------------------
SELECT DISTINCT i.*
FROM Items i
JOIN PurchaseDetails pd ON i.ItemID = pd.ItemID
WHERE pd.PurchaseID IN (
    SELECT p.PurchaseID
    FROM Purchases p
    WHERE p.ClientID IN (
        SELECT ClientID
        FROM Purchases
        GROUP BY ClientID
        HAVING COUNT(*) > 10
    )
);

------------------------------------------------------------
-- 15. List staff who work in the division with the highest total sales.
------------------------------------------------------------
SELECT *
FROM Staff
WHERE DivisionID = (
    SELECT TOP 1 s.DivisionID
    FROM Staff s
    JOIN Sales sal ON s.StaffID = sal.StaffID
    GROUP BY s.DivisionID
    ORDER BY SUM(sal.TotalAmount) DESC
);

------------------------------------------------------------
-- 16. List staff whose salary is in the top 5% of the entire company.
------------------------------------------------------------
-- Use a CTE to compute the 95th percentile salary, ensuring only one scalar value is returned.
WITH SalaryThreshold AS (
    SELECT DISTINCT 
           PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Salary) OVER () AS Threshold
    FROM Staff
)
-- Now join with the Staff table to select those with salary greater or equal than the threshold.
SELECT s.*
FROM Staff s
CROSS JOIN SalaryThreshold st
WHERE s.Salary >= st.Threshold;

------------------------------------------------------------
-- 17. List items that have not been purchased by any client in the past month.
------------------------------------------------------------
SELECT *
FROM Items
WHERE ItemID NOT IN (
    SELECT DISTINCT pd.ItemID
    FROM PurchaseDetails pd
    JOIN Purchases p ON pd.PurchaseID = p.PurchaseID
    WHERE p.PurchaseDate >= DATEADD(MONTH, -1, GETDATE())
);

------------------------------------------------------------
-- 18. List staff who work in the same division as staff members with the highest purchase totals.
--     (Assuming Sales table has StaffID; first, find staff with highest purchase totals, then list all staff in their division)
------------------------------------------------------------
WITH TopPurchaser AS (
    SELECT TOP 1 StaffID
    FROM Sales
    GROUP BY StaffID
    ORDER BY SUM(TotalAmount) DESC
)
SELECT DISTINCT s.*
FROM Staff s
WHERE s.DivisionID = (
    SELECT DivisionID FROM Staff WHERE StaffID = (SELECT TOP 1 StaffID FROM TopPurchaser)
);

------------------------------------------------------------
-- 19. List clients who have not made any purchases in the last 6 months and have spent less than $100.
------------------------------------------------------------
SELECT *
FROM Clients
WHERE ClientID NOT IN (
    SELECT ClientID FROM Purchases WHERE PurchaseDate >= DATEADD(MONTH, -6, GETDATE())
)
AND ClientID IN (
    SELECT p.ClientID
    FROM Purchases p
    GROUP BY p.ClientID
    HAVING SUM(p.TotalAmount) < 100
);

------------------------------------------------------------
-- 20. List all staff who have been employed for more than 10 years and have made purchases for items worth more than $1,000.
--     (Assuming Purchases table has a StaffID column linking purchases to staff)
------------------------------------------------------------
SELECT DISTINCT s.*
FROM Staff s
WHERE s.YearsOfService > 10
  AND s.StaffID IN (
        SELECT p.StaffID
        FROM Purchases p
        GROUP BY p.StaffID
        HAVING SUM(p.TotalAmount) > 1000
  );

