-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: [Captain Clark's Furniture and Appliance Store DBMS]
-- Team Members: Nue Lopez, Garret Clark
-- File: Checkpoint2-script.sql
-- ============================================================================


-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- Explain any modifications to your relational schema made since Checkpoint 1.
-- (e.g., added indexes, modified check constraints, renamed columns, or 
--  clarified weak entity vs. junction relationships). If no changes were made, 
--  explicitly state: "No modifications made to the Checkpoint 1 schema."
--
-- Modifications:
-- 1. Schema Modifications Since Checkpoint 1:
--      * Added color (BOOLEAN) to products
--      * Added isManager (BOOLEAN) to employees

-- 2. [Description of schema modification 2]
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY (GROUPED AT THE TOP)
-- ============================================================================
-- Identify the member contributions to each query or modification statement
-- below. Each statement must sum to 100% across the 2 team members.
--
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 02: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 03: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 04: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 05: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 06: Nue Lopez: 20%, Garret Clark: 80%
-- Statement 07: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 08: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 09: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 10: Nue Lopez: XX%, Garret Clark: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 12: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 13: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 14: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 15: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 16: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 17: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 18: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 19: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 20: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 21: Nue Lopez: XX%, Garret Clark: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 23: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 24: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 25: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 26: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 27: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 28: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 29: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 30: Nue Lopez: XX%, Garret Clark: XX%
-- ============================================================================

-- Ensure SQLite foreign key constraints are enforced
PRAGMA foreign_keys = ON;

-- Set output format for readability during evaluation
.headers on
.mode column


-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS (Roughly 10 Statements)
-- Focus: Single-table projections/filters, simple inserts/updates/deletes, 
--        basic sorting, simple aggregate functions, and pattern matching.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 01: Find the customer's ID, name, and balance. 
-- Explanation: Query retrieves three ____: custID, custName, and custBalance. 
--  We must track them down from decreasing order based on their balance owed.
-- ----------------------------------------------------------------------------
SELECT custID AS [Customer ID], custName AS 'Customer Name', custBalance AS `Balance Owed`
FROM customers
WHERE custBalance > 0
ORDER BY custBalance DESC;

-- ----------------------------------------------------------------------------
-- Statement 02: Orders in Merced County in 2026. 
-- Explanation: Counting the amount of orders shipped in Merced county this year.  
-- ----------------------------------------------------------------------------
SELECT COUNT(orderID)
FROM orders
WHERE (shipAddr LIKE '%MERCED%' OR shipAddr LIKE '%ATWATER%' OR shipAddr LIKE '%LOS BANOS%')
    AND orderDate LIKE '2026%';

-- ----------------------------------------------------------------------------
-- Statement 03: Select furniture that is not a bed or a mattress. 
-- Explanation: Finding furnitures that is not a bed or a mattress in 
--  alphabetical order. Extraction used for potentially more complicated queries 
--  down below. We are keeping items that belong in a bedroom, just removing the 
--  items people sleep on. 
-- ----------------------------------------------------------------------------
SELECT productName AS [ITEM]
FROM products
WHERE productType LIKE 'FURNITURE'
AND productName NOT LIKE '% Bed %' AND productName NOT LIKE '% Bed'
AND productName NOT LIKE '%Mattress%'
AND productDescription NOT LIKE '% bed %' AND productDescription NOT LIKE '% bed'
AND productDescription NOT LIKE '%mattress%'
ORDER BY productName ASC;


-- ----------------------------------------------------------------------------
-- Statement 04: Top 5 Affordable Appliances within $300.
-- Explanation: Selecting top 5 appliances ordered from most to least expensive.
-- ----------------------------------------------------------------------------
SELECT productID AS `Product ID`, productName AS [Appliance Name], productPrice AS 'Price'
FROM products
WHERE productType LIKE 'Appliance'
AND productPrice <= 300
ORDER BY productPrice DESC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- Statement 05: Employee promoted to Manager
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
UPDATE employees
SET isManager = TRUE
WHERE employeeID = 3;

-- ----------------------------------------------------------------------------
-- Statement 06: 2 new customers
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here;


-- [Continue Statements 03 through 10...]




-- ----------------------------------------------------------------------------
-- Statement 11: Central Valley Customers Above Average Balance With Orders
-- Explanation: Counts distinct customers from every county have placed at 
--              least one order and have more than the average account balance.
-- ----------------------------------------------------------------------------
SELECT COUNT(DISTINCT(c.custID)) AS [Customer Count], AVG(c.custBalance) AS [Average Balance]
FROM customers c
JOIN orders o ON c.custID = o.custID
WHERE (c.custAddr LIKE '% Merced, CA %'
OR c.custAddr LIKE '% Atwater, CA %'
OR c.custAddr LIKE '% Los Banos, CA %'
OR c.custAddr LIKE '% Madera, CA %'
OR c.custAddr LIKE '% Fresno, CA %'
OR c.custAddr LIKE '% Modesto, CA %'
OR c.custAddr LIKE '% Turlock, CA %')
AND c.custBalance > (SELECT AVG(custBalance) FROM customers)
HAVING COUNT(c.custID) >= 1;


-- ----------------------------------------------------------------------------
-- Statement 12: Find the Highest valued 2026 Orders with Customer and Associate Details 
-- Explanation: Joins orders, customers, and employees to list the top 10 
--              highest-priced 2026 orders over $1,000 along with the customer 
--              and assisting associate names.
-- ----------------------------------------------------------------------------
SELECT o.orderID, o.orderDate, c.custName AS [Customer Name], e.employeeName AS `Employee Name`, o.totalPrice AS 'Total Price'
FROM orders o
JOIN customers c ON c.custID = o.custID
JOIN employees e ON e.employeeID = o.employeeID
WHERE o.totalPrice > 1000 AND o.orderDate >= '2026-01-01'
ORDER BY o.totalPrice DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- Statement 13: Find Employee of the Month 
-- Explanation: Find the Employee of the Month. This employee (not manager(s))
--            helped generate a large revenue for this company. We want to 
--          list the amount they helped assist in sales and number of customers.
-- ----------------------------------------------------------------------------
SELECT e.employeeName AS [Employee of the Month], SUM(o.totalPrice) AS [Sales], COUNT(DISTINCT(o.custID)) AS [Customer Count], COUNT(o.orderID) AS [Order Count]
FROM employees e
JOIN orders o ON o.employeeID = e.employeeID
JOIN customers c ON o.custID = c.custID
WHERE e.isManager = FALSE
AND o.orderDate LIKE '2026-09-%' --Commenting this line lists Alyssa Flores as all time seller. 
GROUP BY e.employeeID, e.employeeName
ORDER BY SUM(o.totalPrice) DESC
LIMIT 1;

-- ----------------------------------------------------------------------------
-- Statement 14: Infrequent customers
-- Explanation: List customers having five or less orders and their total spend.
-- ----------------------------------------------------------------------------
SELECT c.custID AS [Customer ID], c.custName AS [Customer Name], COUNT(o.orderID) AS [Total Orders], SUM(c.custBalance) AS [Total Valance]
FROM customers c
LEFT JOIN orders o ON c.custID = o.custID
GROUP BY c.custID, c.custName
HAVING COUNT(o.orderID) <= 5
ORDER BY [Total Orders] DESC, c.custID;


-- [Continue Statements 16 through 20...]


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 21 Here];

-- [Continue Statements 23 through 32...]
