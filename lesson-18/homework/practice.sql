------------------------------------------------------------
-- Level 1, Task 1: Find Employees with Minimum Salary
-- Retrieve employees who earn the minimum salary in the company.
------------------------------------------------------------
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

------------------------------------------------------------
-- Level 1, Task 2: Find Products Above Average Price
-- Retrieve products priced above the average price.
------------------------------------------------------------
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

------------------------------------------------------------
-- Level 2, Task 3: Find Employees in Sales Department
-- Retrieve employees who work in the "Sales" department.
------------------------------------------------------------
SELECT e.*
FROM employees e
WHERE department_id = (
    SELECT id FROM departments WHERE department_name = 'Sales'
);

------------------------------------------------------------
-- Level 2, Task 4: Find Customers with No Orders
-- Retrieve customers who have not placed any orders.
------------------------------------------------------------
SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
);

------------------------------------------------------------
-- Level 3, Task 5: Find Products with Max Price in Each Category
-- Retrieve products with the highest price in each category.
------------------------------------------------------------
SELECT p1.*
FROM products p1
WHERE p1.price = (
    SELECT MAX(p2.price)
    FROM products p2
    WHERE p2.category_id = p1.category_id
);

------------------------------------------------------------
-- Level 3, Task 6: Find Employees in Department with Highest Average Salary
-- Retrieve employees working in the department with the highest average salary.
------------------------------------------------------------
SELECT e.*
FROM employees e
WHERE e.department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);

------------------------------------------------------------
-- Level 4, Task 7: Find Employees Earning Above Department Average
-- Retrieve employees earning more than the average salary in their department.
------------------------------------------------------------
SELECT *
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

------------------------------------------------------------
-- Level 4, Task 8: Find Students with Highest Grade per Course
-- Retrieve students who received the highest grade in each course.
------------------------------------------------------------
SELECT s.*
FROM students s
WHERE s.student_id IN (
    SELECT student_id
    FROM grades g1
    WHERE g1.grade = (
         SELECT MAX(g2.grade)
         FROM grades g2
         WHERE g2.course_id = g1.course_id
    )
);

------------------------------------------------------------
-- Level 5, Task 9: Find Third-Highest Price per Category
-- Retrieve products with the third-highest price in each category.
------------------------------------------------------------
WITH RankedProducts AS (
    SELECT id, product_name, price, category_id,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM products
)
SELECT *
FROM RankedProducts
WHERE rn = 3;

------------------------------------------------------------
-- Level 5, Task 10: Find Employees Between Company Average and Department Max Salary
-- Retrieve employees with salaries above the company average but below the maximum in their department.
------------------------------------------------------------
SELECT *
FROM employees e
WHERE e.salary > (SELECT AVG(salary) FROM employees)
  AND e.salary < (SELECT MAX(salary) FROM employees WHERE department_id = e.department_id);
-- Table: employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2),
    department_id INT
);

-- Insert at least 10 rows into employees
INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alice', 50000, 1),
(2, 'Bob', 60000, 1),
(3, 'Charlie', 50000, 1),
(4, 'David', 70000, 2),
(5, 'Eva', 75000, 2),
(6, 'Frank', 65000, 2),
(7, 'Grace', 80000, 3),
(8, 'Hank', 82000, 3),
(9, 'Ivy', 78000, 3),
(10, 'Jack', 90000, 3);

------------------------------------------------------------
-- Table: products
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    category_id INT
);

-- Insert at least 10 rows into products
INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Laptop', 1200, 1),
(2, 'Tablet', 400, 1),
(3, 'Smartphone', 800, 1),
(4, 'Monitor', 300, 2),
(5, 'Keyboard', 50, 2),
(6, 'Mouse', 30, 2),
(7, 'Headphones', 150, 3),
(8, 'Speakers', 200, 3),
(9, 'Printer', 350, 4),
(10, 'Scanner', 250, 4);

------------------------------------------------------------
-- Table: departments
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Insert sample departments
INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR'),
(3, 'IT');

------------------------------------------------------------
-- Table: customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Insert at least 10 rows into customers
INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan'),
(4, 'Judy'),
(5, 'Karl'),
(6, 'Leo'),
(7, 'Mona'),
(8, 'Nina'),
(9, 'Oscar'),
(10, 'Paul');

------------------------------------------------------------
-- Table: orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert at least 10 rows into orders
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2024-01-10'),
(2, 1, '2024-02-15'),
(3, 2, '2024-03-05'),
(4, 3, '2024-03-10'),
(5, 4, '2024-04-12'),
(6, 5, '2024-05-20'),
(7, 6, '2024-06-25'),
(8, 7, '2024-07-30'),
(9, 8, '2024-08-15'),
(10, 9, '2024-09-05');

------------------------------------------------------------
-- Table: students
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Insert at least 10 rows into students
INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma'),
(4, 'Victor'),
(5, 'Wendy'),
(6, 'Xavier'),
(7, 'Yvonne'),
(8, 'Zack'),
(9, 'Amy'),
(10, 'Brian');

------------------------------------------------------------
-- Table: grades
CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Insert sample rows into grades
INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 101, 90),
(4, 102, 88),
(5, 102, 92),
(6, 102, 75),
(7, 103, 80),
(8, 103, 85),
(9, 103, 90),
(10, 104, 87),
(1, 104, 93);

------------------------------------------------------------
-- Table: Sales
-- For tasks using Sales, assume Sales has columns: SaleID, StaffID, TotalAmount, SaleDate.
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    StaffID INT,
    TotalAmount DECIMAL(10,2),
    SaleDate DATE
);

-- Insert sample rows into Sales (at least 10 rows)
INSERT INTO Sales (SaleID, StaffID, TotalAmount, SaleDate) VALUES
(1, 1, 5000, '2024-01-15'),
(2, 2, 7000, '2024-02-20'),
(3, 3, 6000, '2024-03-10'),
(4, 4, 8000, '2024-04-05'),
(5, 5, 6500, '2024-05-12'),
(6, 6, 9000, '2024-06-18'),
(7, 7, 7500, '2024-07-22'),
(8, 8, 8500, '2024-08-30'),
(9, 9, 6200, '2024-09-15'),
(10, 10, 9500, '2024-10-10');
