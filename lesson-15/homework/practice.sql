
use vazifa15

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT 
);

-- Inserting 20 rows into Employees table
INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'John Doe', NULL),
(2, 'Jane Smith', 1),
(3, 'Michael Brown', 1),
(4, 'Emily Davis', 2),
(5, 'Daniel Wilson', 2),
(6, 'Olivia Taylor', 3),
(7, 'Matthew Anderson', 3),
(8, 'Sophia Thomas', 4),
(9, 'David Jackson', 4),
(10, 'Emma White', 5),
(11, 'James Harris', 5),
(12, 'Lucas Martin', 6),
(13, 'Ava Thompson', 6),
(14, 'Alexander Garcia', 7),
(15, 'Mia Martinez', 7),
(16, 'Elijah Robinson', 8),
(17, 'Charlotte Clark', 8),
(18, 'Benjamin Lewis', 9),
(19, 'Amelia Hall', 9),
(20, 'William Allen', 10);


select * from employees

-- Task 1: Use a Derived Table to Find Employees with Managers
select e1.EmployeeID, e1.EmployeeName as manageer, e2.EmployeeName as employee from  Employees e1 left join (select * from Employees) e2 on e1.ManagerID = e2.EmployeeID



-- Task 2: Use a CTE to Find Employees with Managers
WITH EmployeeManagers AS (
    SELECT e.EmployeeID, e.EmployeeName, m.EmployeeName AS ManagerName
    FROM Employees e
    LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
)
SELECT * FROM EmployeeManagers;

-- Task 3: Compare Results of Derived Table and CTE
-- Both queries give the same result, but using a CTE makes it easier to read and reuse.

-- Task 4: Find Direct Reports for a Given Manager Using CTE (Example: ManagerID = 2)
WITH DirectReports AS (
    SELECT EmployeeID, EmployeeName
    FROM Employees
    WHERE ManagerID = 2
)
SELECT * FROM DirectReports;

-- Task 5: Create a Recursive CTE to Find All Levels of Employees
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL -- Start from the top manager
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, EmployeeID;

-- Task 6: Count Number of Employees at Each Level Using Recursive CTE
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT Level, COUNT(*) AS NumberOfEmployees
FROM EmployeeHierarchy
GROUP BY Level
ORDER BY Level;

-- Task 7: Retrieve Employees Without Managers Using Derived Table
SELECT e.EmployeeID, e.EmployeeName
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IS NULL;

-- Task 8: Retrieve Employees Without Managers Using CTE
WITH NoManagers AS (
    SELECT EmployeeID, EmployeeName
    FROM Employees
    WHERE ManagerID IS NULL
)
SELECT * FROM NoManagers;

-- Task 9: Find Employees Reporting to a Specific Manager Using Recursive CTE (Example: ManagerID = 2)
WITH Reports AS (
    SELECT EmployeeID, EmployeeName, ManagerID
    FROM Employees
    WHERE ManagerID = 2
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID
    FROM Employees e
    INNER JOIN Reports r ON e.ManagerID = r.EmployeeID
)
SELECT * FROM Reports;

-- Task 10: Find the Maximum Depth of Management Hierarchy
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT MAX(Level) AS MaxDepth FROM EmployeeHierarchy;
