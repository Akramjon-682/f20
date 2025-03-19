-- Employees table: Xodimlar haqida ma'lumot
-- Employees jadvali
drop table Employees

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATEtime
);

-- Sales jadvali
CREATE TABLE Sales (
    id INT PRIMARY KEY,
    employee_id INT,
    product_id INT,
    sale_amount DECIMAL(10,2),
    sale_date DATEtime,
    FOREIGN KEY (employee_id) REFERENCES Employees(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

-- Customers jadvali
CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Orders jadvali
CREATE TABLE Orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

-- Products jadvali
CREATE TABLE Products (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10,2)
);

-- Regions jadvali
CREATE TABLE Regions (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Regional_Sales jadvali
CREATE TABLE Regional_Sales (
    id INT PRIMARY KEY,
    region_id INT,
    total_revenue DECIMAL(10,2),
    FOREIGN KEY (region_id) REFERENCES Regions(id)
);

-- Ma'lumotlarni qo'shish
INSERT INTO Employees (id, name, department_id, salary, hire_date) VALUES
(1, 'Alice', 1, 5000, '2018-05-10'),
(2, 'Bob', 2, 6000, '2016-07-20'),
(3, 'Charlie', 1, 5500, '2019-09-15'),
(4, 'David', 3, 4500, '2020-01-30'),
(5, 'Emma', 2, 7000, '2015-12-11');

INSERT INTO Sales (id, employee_id, product_id, sale_amount, sale_date) VALUES
(1, 1, 1, 300, '2024-01-10'),
(2, 2, 2, 600, '2024-01-12'),
(3, 3, 1, 500, '2024-01-15'),
(4, 4, 3, 700, '2024-02-01'),
(5, 5, 2, 1000, '2024-02-05');

INSERT INTO Customers (id, name) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Alice Johnson');

INSERT INTO Orders (id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-05', 150),
(2, 2, '2024-01-10', 300),
(3, 1, '2024-01-15', 200),
(4, 3, '2024-02-01', 400),
(5, 2, '2024-02-05', 500);

INSERT INTO Products (id, name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Phone', 800),
(3, 'Tablet', 600);

INSERT INTO Regions (id, name) VALUES
(1, 'North America'),
(2, 'Europe'),
(3, 'Asia');

INSERT INTO Regional_Sales (id, region_id, total_revenue) VALUES
(1, 1, 50000),
(2, 2, 75000),
(3, 3, 60000);



--Answers
select * from Employees
select * from Sales
-- 1️⃣ Find total sales per employee using a derived table
SELECT e.id, e.name, sales.total_sales
FROM employees e
JOIN (SELECT employee_id, SUM(sale_amount) AS total_sales FROM sales GROUP BY employee_id) sales
ON e.id = sales.employee_id;

-- 2️⃣ Create a CTE to find the average salary of employees
WITH AvgSalary AS (
    SELECT AVG(salary) AS avg_salary FROM employees
)
SELECT * FROM AvgSalary;

-- 3️⃣ Find the highest sales for each product using a derived table
SELECT p.id, p.name, sales.max_sales
FROM products p
JOIN (SELECT product_id, MAX(sale_amount) AS max_sales FROM sales GROUP BY product_id) sales
ON p.id = sales.product_id;

-- 4️⃣ Get names of employees who made more than 5 sales using a CTE
WITH EmployeeSales AS (
    SELECT employee_id, COUNT(*) AS sales_count FROM sales GROUP BY employee_id
)
SELECT e.name FROM  employees e
JOIN EmployeeSales es ON e.id = es.employee_id
WHERE es.sales_count > 5;

-- 5️⃣ List top 5 customers by total purchase amount using a derived table
SELECT c.id, c.name, purchases.total_purchase
FROM customers c
JOIN (SELECT customer_id, SUM(amount) AS total_purchase FROM orders GROUP BY customer_id) purchases
ON c.id = purchases.customer_id
ORDER BY purchases.total_purchase DESC
LIMIT 5;

-- 6️⃣ Find all products with sales greater than $500 using a CTE
WITH HighSales AS (
    SELECT product_id, SUM(sale_amount) AS total_sales FROM sales GROUP BY product_id HAVING SUM(sale_amount) > 500
)
SELECT p.name , hs.total_sales FROM products p
JOIN HighSales hs ON p.id = hs.product_id;

-- 7️⃣ Get total number of orders for each customer using a derived table
SELECT c.id, c.name, order_counts.total_orders
FROM customers c
JOIN (SELECT customer_id, COUNT(*) AS total_orders FROM orders GROUP BY customer_id) order_counts
ON c.id = order_counts.customer_id;

-- 8️⃣ Find employees with salaries above the average salary using a CTE
WITH AvgSalary AS (
    SELECT AVG(salary) AS avg_salary FROM employees
)
SELECT * FROM employees WHERE salary > (SELECT avg_salary FROM AvgSalary);

-- 9️⃣ Find total number of products sold using a derived table
SELECT SUM(quantity) AS total_products_sold FROM (SELECT product_id, SUM(quantity) AS quantity FROM sales GROUP BY product_id) sales_summary;

-- 🔟 Find employees who have not made any sales using a CTE
select * from Employees
select * from Sales
WITH NoSales AS (
    SELECT Employeeid FROM employees WHERE employeeid NOT IN (SELECT DISTINCT saleid FROM sales)
)
SELECT * FROM employees WHERE employeeid IN (SELECT employeeid FROM NoSales);

-- 1️⃣1️⃣ Calculate total revenue for each region using a derived table
SELECT r.name, revenue.total_revenue
FROM regions r
JOIN (SELECT region_id, SUM(amount) AS total_revenue FROM orders GROUP BY region_id) revenue
ON r.id = revenue.region_id;

-- 1️⃣2️⃣ Get employees who worked for more than 5 years using a CTE
WITH EmployeeTenure AS (
    SELECT id, name, DATEDIFF(YEAR, hire_date, GETDATE()) AS years_worked FROM employees
)
SELECT * FROM EmployeeTenure WHERE years_worked > 5;

-- 1️⃣3️⃣ Find customers who made more than 3 orders using a derived table
SELECT c.id, c.name, orders.order_count
FROM customers c
JOIN (SELECT customer_id, COUNT(*) AS order_count FROM orders GROUP BY customer_id) orders
ON c.id = orders.customer_id
WHERE orders.order_count > 3;

-- 1️⃣4️⃣ Find employees with the highest sales in a department using a CTE
select * from Employees
select * from departments
select * from Sales
with max_s as (
select  e.department_id  , MAX(sale_amount) as max_ from Employees e left join Sales s  on e.id = s.employee_id
group by  e.department_id
)
select e.name, d.department_name, s.sale_amount, max_s.max_ from Employees e left join departments d on e.department_id = d.id 
left join Sales s  on e.id = s.employee_id left join max_s   on  e.department_id = max_s.department_id



-- 1️⃣5️⃣ Calculate the average order value for each customer using a derived table
SELECT c.id, c.name, avg_orders.avg_order_value
FROM customers c
JOIN (SELECT customer_id, AVG(amount) AS avg_order_value FROM orders GROUP BY customer_id) avg_orders
ON c.id = avg_orders.customer_id;

-- 1️⃣6️⃣ Find the number of employees in each department using a CTE
WITH DepartmentEmployees AS (
    SELECT department_id, COUNT(*) AS employee_count FROM employees GROUP BY department_id
)
SELECT d.name, de.employee_count FROM departments d
JOIN DepartmentEmployees de ON d.id = de.department_id;

-- 1️⃣7️⃣ Find top-selling products in the last quarter using a derived table
SELECT p.id, p.name, qtr_sales.total_sales
FROM products p
JOIN (SELECT product_id, SUM(sale_amount) AS total_sales FROM sales WHERE sale_date >= DATEADD(QUARTER, -1, GETDATE()) GROUP BY product_id) qtr_sales
ON p.id = qt r_sales.product_id
ORDER BY qtr_sales.total_sales DESC;

-- 1️⃣8️⃣ List employees who have sales higher than $1000 using a CTE
WITH HighSalesEmployees AS (
    SELECT employee_id, SUM(sale_amount) AS total_sales FROM sales GROUP BY employee_id HAVING SUM(sale_amount) > 1000
)
SELECT e.name, hs.total_sales FROM employees e
JOIN HighSalesEmployees hs ON e.id = hs.employee_id;

-- 1️⃣9️⃣ Find the number of orders made by each customer using a derived table
SELECT c.id, c.name, order_count.total_orders
FROM customers c
JOIN (SELECT customer_id, COUNT(*) AS total_orders FROM orders GROUP BY customer_id) order_count
ON c.id = order_count.customer_id;

-- 2️⃣0️⃣ Find the total sales per employee for the last month using a CTE
WITH LastMonthSales AS (
    SELECT employee_id, SUM(sale_amount) AS total_sales FROM sales WHERE sale_date >= DATEADD(MONTH, -1, GETDATE()) GROUP BY employee_id
)
SELECT e.name, lms.total_sales FROM employees e
JOIN LastMonthSales lms ON e.id = lms.employee_id;

--medium tasks	

-- 1️⃣ Write a query using a CTE to calculate the running total of sales for each employee.
WITH RunningTotal AS (
    SELECT employee_id, sale_amount, 
           SUM(sale_amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS running_total
    FROM Sales
)
SELECT * FROM RunningTotal;

-- 2️⃣ Use a recursive CTE to generate a sequence of numbers from 1 to 10.
WITH Numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1 FROM Numbers WHERE num < 10
)
SELECT * FROM Numbers;

-- 3️⃣ Write a query using a derived table to calculate the average sales per region.
SELECT region_id, AVG(total_sales) AS avg_sales 
FROM (SELECT region_id, SUM(sale_amount) AS total_sales FROM Sales GROUP BY region_id) AS DerivedSales
GROUP BY region_id;

-- 4️⃣ Create a CTE to rank employees based on their total sales.
WITH EmployeeRank AS (
    SELECT employee_id, SUM(sale_amount) AS total_sales,
           RANK() OVER (ORDER BY SUM(sale_amount) DESC) AS sales_rank
    FROM Sales
    GROUP BY employee_id
)
SELECT * FROM EmployeeRank;

-- 5️⃣ Use a derived table to find the top 5 employees by the number of orders made.
SELECT e.id, e.name, OrderCount.order_count
FROM Employees e
JOIN (SELECT employee_id, COUNT(*) AS order_count FROM Orders GROUP BY employee_id) AS OrderCount
ON e.id = OrderCount.employee_id
ORDER BY OrderCount.order_count DESC
LIMIT 5;

-- 6️⃣ Write a query using a recursive CTE to list all employees reporting to a specific manager.
WITH EmployeeHierarchy AS (
    SELECT id, name, manager_id FROM Employees WHERE manager_id = 1
    UNION ALL
    SELECT e.id, e.name, e.manager_id FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.id
)
SELECT * FROM EmployeeHierarchy;

-- 7️⃣ Use a CTE to calculate the sales difference between the current month and the previous month.
WITH MonthlySales AS (
    SELECT employee_id, YEAR(sale_date) AS year, MONTH(sale_date) AS month, SUM(sale_amount) AS total_sales
    FROM Sales
    GROUP BY employee_id, YEAR(sale_date), MONTH(sale_date)
)
SELECT employee_id, month, year, total_sales, 
       LAG(total_sales) OVER (PARTITION BY employee_id ORDER BY year, month) AS previous_month_sales,
       total_sales - LAG(total_sales) OVER (PARTITION BY employee_id ORDER BY year, month) AS sales_difference
FROM MonthlySales;

-- 8️⃣ Create a derived table to find the employees who have made the highest sales in each department.
SELECT e.name, e.department_id, max_sales.max_sale
FROM Employees e
JOIN (SELECT employee_id, MAX(sale_amount) AS max_sale FROM Sales GROUP BY employee_id) AS max_sales
ON e.id = max_sales.employee_id;

-- 9️⃣ Write a recursive CTE to find all the ancestors of an employee in a hierarchical organization.
WITH Ancestors AS (
    SELECT id, name, manager_id FROM Employees WHERE id = 5
    UNION ALL
    SELECT e.id, e.name, e.manager_id FROM Employees e
    JOIN Ancestors a ON e.id = a.manager_id
)
SELECT * FROM Ancestors;

-- 1️⃣0️⃣ Use a CTE to find employees who have not sold anything in the last year.
WITH LastYearSales AS (
    SELECT DISTINCT employee_id FROM Sales WHERE sale_date >= DATEADD(YEAR, -1, GETDATE())
)
SELECT * FROM Employees WHERE id NOT IN (SELECT employee_id FROM LastYearSales);

-- 1️⃣1️⃣ Write a query using a derived table to calculate the total sales per region and year.
SELECT region_id, year, SUM(total_sales) AS yearly_sales
FROM (SELECT region_id, YEAR(sale_date) AS year, SUM(sale_amount) AS total_sales FROM Sales GROUP BY region_id, YEAR(sale_date)) AS DerivedSales
GROUP BY region_id, year;

-- 1️⃣2️⃣ Use a recursive CTE to calculate the factorial of a number.
WITH Factorial AS (
    SELECT 1 AS num, 1 AS fact
    UNION ALL
    SELECT num + 1, (num + 1) * fact FROM Factorial WHERE num < 10
)
SELECT * FROM Factorial;

-- 1️⃣3️⃣ Write a query using a derived table to find customers with more than 10 orders.
SELECT c.id, c.name, OrderCount.order_count
FROM Customers c
JOIN (SELECT customer_id, COUNT(*) AS order_count FROM Orders GROUP BY customer_id) AS OrderCount
ON c.id = OrderCount.customer_id
WHERE OrderCount.order_count > 10;

-- 1️⃣4️⃣ Create a recursive CTE to traverse a product category hierarchy.
WITH CategoryHierarchy AS (
    SELECT id, category_name, parent_category_id FROM ProductCategories WHERE parent_category_id IS NULL
    UNION ALL
    SELECT c.id, c.category_name, c.parent_category_id FROM ProductCategories c
    JOIN CategoryHierarchy ch ON c.parent_category_id = ch.id
)
SELECT * FROM CategoryHierarchy;

-- 1️⃣5️⃣ Use a CTE to rank products based on total sales in the last year.
WITH ProductSales AS (
    SELECT product_id, SUM(sale_amount) AS total_sales
    FROM Sales WHERE sale_date >= DATEADD(YEAR, -1, GETDATE())
    GROUP BY product_id
)
SELECT product_id, total_sales, RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM ProductSales;

-- 1️⃣6️⃣ Write a query using a derived table to find the sales per product category.
SELECT pc.category_name, SUM(s.sale_amount) AS total_sales
FROM ProductCategories pc
JOIN Products p ON pc.id = p.category_id
JOIN Sales s ON p.id = s.product_id
GROUP BY pc.category_name;

-- 1️⃣7️⃣ Use a CTE to find the employees who achieved the highest sales growth compared to last year.
WITH SalesGrowth AS (
    SELECT employee_id, 
           SUM(CASE WHEN YEAR(sale_date) = YEAR(GETDATE()) THEN sale_amount ELSE 0 END) AS current_year_sales,
           SUM(CASE WHEN YEAR(sale_date) = YEAR(GETDATE()) - 1 THEN sale_amount ELSE 0 END) AS last_year_sales
    FROM Sales
    GROUP BY employee_id
)
SELECT *, (current_year_sales - last_year_sales) AS sales_growth FROM SalesGrowth ORDER BY sales_growth DESC;

-- 1️⃣8️⃣ Create a derived table to find employees with sales over $5000 in each quarter.
SELECT e.name, q.quarter, q.total_sales
FROM Employees e
JOIN (SELECT employee_id, DATEPART(QUARTER, sale_date) AS quarter, SUM(sale_amount) AS total_sales
      FROM Sales GROUP BY employee_id, DATEPART(QUARTER, sale_date)) AS q
ON e.id = q.employee_id
WHERE q.total_sales > 5000;

-- 1️⃣9️⃣ Write a recursive CTE to list all descendants of a product in a product category tree.
WITH ProductHierarchy AS (
    SELECT id, product_name, parent_product_id FROM Products WHERE parent_product_id IS NULL
    UNION ALL
    SELECT p.id, p.product_name, p.parent_product_id FROM Products p
    JOIN ProductHierarchy ph ON p.parent_product_id = ph.id
)
SELECT * FROM ProductHierarchy;

-- 2️⃣0️⃣ Use a derived table to find the top 3 employees by total sales amount in the last month.
SELECT employee_id, total_sales
FROM (SELECT employee_id, SUM(sale_amount) AS total_sales FROM Sales 
      WHERE sale_date >= DATEADD(MONTH, -1, GETDATE()) 
      GROUP BY employee_id) AS MonthlySales
ORDER BY total_sales DESC
LIMIT 3;

--difficult

-- 1️⃣ Recursive CTE to generate the Fibonacci sequence up to the 20th term
WITH Fibonacci (n, fib1, fib2) AS
(
    SELECT 1, 0, 1  -- Boshlang‘ich qiymatlar
    UNION ALL
    SELECT n + 1, fib2, fib1 + fib2
    FROM Fibonacci
    WHERE n < 20
)
SELECT fib1 AS Fibonacci_Number FROM Fibonacci;

-- 2️⃣ CTE to calculate cumulative sales of employees over the past year
WITH CumulativeSales AS (
    SELECT employee_id, sale_date, SUM(sales_amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS cumulative_sales
    FROM sales
    WHERE sale_date >= DATEADD(YEAR, -1, GETDATE())
)
SELECT * FROM CumulativeSales;

-- 3️⃣ Recursive CTE to find all subordinates of a manager in a hierarchical company structure
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, manager_id, employee_name ,1 as qq FROM Employees WHERE manager_id is null 
    UNION ALL
    SELECT e.employee_id, e.manager_id, e.employee_name, e.qq+1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM EmployeeHierarchy;

-- 4️⃣ Derived table to find employees with sales above the company average for each region
SELECT e.employee_id, e.region, e.sales
FROM Employees e
JOIN (
    SELECT region, AVG(sales) AS avg_sales
    FROM Employees
    GROUP BY region
) AS region_avg ON e.region = region_avg.region
WHERE e.sales > region_avg.avg_sales;

-- 5️⃣ Recursive CTE to calculate the depth of a product in a multi-level product hierarchy
WITH RECURSIVE ProductDepth AS (
    SELECT id, product_name, parent_product_id, 1 AS depth FROM Products WHERE parent_product_id IS NULL
    UNION ALL
    SELECT p.id, p.product_name, p.parent_product_id, pd.depth + 1
    FROM Products p
    JOIN ProductDepth pd ON p.parent_product_id = pd.id
)
SELECT * FROM ProductDepth;

-- 6️⃣ CTE and Derived Table to calculate sales totals for each department and product
WITH DepartmentSales AS (
    SELECT department_id, product_id, SUM(sales_amount) AS total_sales
    FROM Sales
    GROUP BY department_id, product_id
)
SELECT d.department_name, ds.product_id, ds.total_sales
FROM DepartmentSales ds
JOIN Departments d ON ds.department_id = d.department_id;

-- 7️⃣ Recursive CTE to list all direct and indirect reports of a specific manager
WITH RECURSIVE Reports AS (
    SELECT employee_id, manager_id FROM Employees WHERE manager_id = ?
    UNION ALL
    SELECT e.employee_id, e.manager_id
    FROM Employees e
    JOIN Reports r ON e.manager_id = r.employee_id
)
SELECT * FROM Reports;

-- 8️⃣ Derived Table to find the employees who made the most sales in the last 6 months
SELECT e.employee_id, e.employee_name, s.total_sales
FROM Employees e
JOIN (
    SELECT employee_id, SUM(sales_amount) AS total_sales
    FROM Sales
    WHERE sale_date >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY employee_id
) AS recent_sales ON e.employee_id = recent_sales.employee_id
ORDER BY s.total_sales DESC;

-- 9️⃣ Recursive CTE to calculate the total cost of an order, including taxes and discounts
WITH OrderCost AS (
    SELECT order_id, product_id, (price * quantity) AS base_cost, (price * quantity * tax_rate) AS tax, (price * quantity * discount_rate) AS discount
    FROM OrderDetails
)
SELECT order_id, SUM(base_cost + tax - discount) AS total_order_cost FROM OrderCost GROUP BY order_id;

-- 🔟 CTE to find employees with the largest sales growth rate over the past year
WITH SalesGrowth AS (
    SELECT employee_id, (SUM(sales_amount) FILTER (WHERE year = EXTRACT(YEAR FROM CURRENT_DATE)) - 
                         SUM(sales_amount) FILTER (WHERE year = EXTRACT(YEAR FROM CURRENT_DATE) - 1)) / 
                         SUM(sales_amount) FILTER (WHERE year = EXTRACT(YEAR FROM CURRENT_DATE) - 1) AS growth_rate
    FROM Sales
    GROUP BY employee_id
)
SELECT * FROM SalesGrowth ORDER BY growth_rate DESC;

-- 1️1️ Recursive CTE to calculate the total number of sales for each employee over all years
WITH RECURSIVE EmployeeSales AS (
    SELECT employee_id, SUM(sales_amount) AS total_sales FROM Sales GROUP BY employee_id
)
SELECT * FROM EmployeeSales;

-- 12️ CTE and Derived Table to find highest-selling product and employee who sold it
WITH ProductSales AS (
    SELECT product_id, SUM(sales_amount) AS total_sales FROM Sales GROUP BY product_id
)
SELECT e.employee_id, e.employee_name, ps.product_id, ps.total_sales
FROM Employees e
JOIN Sales s ON e.employee_id = s.employee_id
JOIN ProductSales ps ON s.product_id = ps.product_id
ORDER BY ps.total_sales DESC LIMIT 1;

-- 1️3️ Recursive CTE to calculate all generations of an organization’s hierarchy
WITH RECURSIVE OrgHierarchy AS (
    SELECT employee_id, manager_id, 1 AS generation FROM Employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.manager_id, oh.generation + 1
    FROM Employees e
    JOIN OrgHierarchy oh ON e.manager_id = oh.employee_id
)
SELECT * FROM OrgHierarchy;

-- 1️4️ CTE to find employees who made sales greater than the average of their department
WITH DepartmentAvg AS (
    SELECT department_id, AVG(sales_amount) AS avg_sales FROM Sales GROUP BY department_id
)
SELECT e.employee_id, e.sales FROM Employees e
JOIN DepartmentAvg da ON e.department_id = da.department_id
WHERE e.sales > da.avg_sales;

-- 1️5️ Derived Table to find the average sales per employee by region
SELECT region, AVG(sales) AS avg_sales FROM (
    SELECT employee_id, region, SUM(sales_amount) AS sales FROM Sales GROUP BY employee_id, region
) AS region_sales
GROUP BY region;

-- 1️6️ Recursive CTE to identify employees with a direct or indirect report relationship to a specific manager
WITH RECURSIVE ReportHierarchy AS (
    SELECT employee_id, manager_id FROM Employees WHERE manager_id = ?
    UNION ALL
    SELECT e.employee_id, e.manager_id
    FROM Employees e
    JOIN ReportHierarchy rh ON e.manager_id = rh.employee_id
)
SELECT * FROM ReportHierarchy;

-- 1️7️ CTE to calculate the average number of products sold by each employee in the last year
WITH EmployeeProductSales AS (
    SELECT employee_id, COUNT(product_id) AS total_products FROM Sales WHERE sale_date >= DATEADD(YEAR, -1, GETDATE()) GROUP BY employee_id
)
SELECT * FROM EmployeeProductSales;

-- 1️8️ Derived Table and CTE to analyze sales performance by employee and product category
WITH SalesByCategory AS (
    SELECT employee_id, category_id, SUM(sales_amount) AS total_sales FROM Sales GROUP BY employee_id, category_id
)
SELECT * FROM SalesByCategory;

-- 1️9️ Recursive CTE to list all departments reporting to a specific parent department
WITH RECURSIVE DeptHierarchy AS (
    SELECT department_id, parent_department_id FROM Departments WHERE parent_department_id = ?
    UNION ALL
    SELECT d.department_id, d.parent_department_id FROM Departments d JOIN DeptHierarchy dh ON d.parent_department_id = dh.department_id
)
SELECT * FROM DeptHierarchy;

-- 2️0️ Recursive CTE to calculate the number of levels in a product category hierarchy
WITH RECURSIVE CategoryLevels AS (
    SELECT id, category_name, parent_category_id, 1 AS level FROM Categories WHERE parent_category_id IS NULL
    UNION ALL
    SELECT c.id, c.category_name, c.parent_category_id, cl.level + 1
    FROM Categories c
    JOIN CategoryLevels cl ON c.parent_category_id = cl.id
)
SELECT MAX(level) AS max_levels FROM CategoryLevels;
