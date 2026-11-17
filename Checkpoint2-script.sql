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
-- Statement 06: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 07: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 08: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 09: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 10: Nue Lopez: XX%, Garret Clark: XX%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 12: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 13: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 14: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 15: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 16: Nue Lopez: 10%, Garret Clark: XX%
-- Statement 17: Nue Lopez: 10%, Garret Clark: XX%
-- Statement 18: Nue Lopez: 10%, Garret Clark: XX%
-- Statement 19: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 20: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 21: Nue Lopez: XX%, Garret Clark: XX%
--
-- SECTION 3: COMPLEX STATEMENTS
-- Statement 22: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 23: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 24: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 25: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 26: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 27: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 28: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 29: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 30: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 31: Nue Lopez: XX%, Garret Clark: XX%
-- Statement 32: Nue Lopez: XX%, Garret Clark: XX%
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
-- Explanation: Query retrieves three items: custID, custName, and custBalance. 
--  We must track them down from decreasing order based on their balance owed.
-- ----------------------------------------------------------------------------
SELECT custID AS [Customer ID], custName AS 'Customer Name', custBalance AS `Balance Owed`
FROM customers
WHERE custBalance > 0  
ORDER BY custBalance DESC;

-- ----------------------------------------------------------------------------
-- Statement 02: Shipping orders to Merced County in 2023. 
-- Explanation: Counting the amount of orders shipped in Merced county this year.  
-- ----------------------------------------------------------------------------
SELECT COUNT(orderID) AS [Merced Orders in 2023]
FROM orders
WHERE (shipAddr LIKE '%MERCED%' OR shipAddr LIKE '%ATWATER%' OR shipAddr LIKE '%LOS BANOS%')
    AND orderDate LIKE '2023%';

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


-- ============================================================================
-- SECTION 2: INTERMEDIATE STATEMENTS (Roughly 10 Statements)
-- Focus: Multi-table inner joins, left outer joins, aggregation with GROUP BY 
--        and HAVING, scalar subqueries, table aliasing, and conditional updates.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 11: Central Valley Customers Above Average Balance With Orders
-- Explanation: Counts distinct customers from every county have placed at 
--              least one order and have more than the average account balance.
-- ----------------------------------------------------------------------------
SELECT COUNT(DISTINCT(c.custID)) AS [Customer Count], ROUND(AVG(c.custBalance), 2) AS [Average Balance]
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
HAVING COUNT(c.custID) >= 1
;


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
SELECT c.custID AS [Customer ID], c.custName AS [Customer Name], COUNT(o.orderID) AS [Total Orders], SUM(c.custBalance) AS [Total Balance]
FROM customers c
LEFT JOIN orders o ON c.custID = o.custID
GROUP BY c.custID, c.custName
HAVING COUNT(o.orderID) <= 5
ORDER BY [Total Orders] DESC, c.custID;

-- ----------------------------------------------------------------------------
-- Statement 15: Vendors Supplying High-Cost Merchandise
-- Explanation: Joins vendors and supply to figure out each vendor's supplied 
--          product count and wholesale cost. Filter for suppliers having at 
--          least one item over $1,000. 
-- ----------------------------------------------------------------------------
SELECT v.vendorID AS [Vendor ID], v.vendorName AS [Vendor Name], COUNT(s.productID) AS [Products Supplied], ROUND(MIN(s.wholesaleCost), 2) AS [Lowest Cost], ROUND(MAX(s.wholesaleCost), 2) AS [Highest Cost]
FROM vendors v
JOIN supply s ON v.vendorID = s.vendorID
GROUP BY v.vendorID, v.vendorName
HAVING MAX(s.wholesaleCost) > 1000
ORDER BY [Highest Cost] DESC;

-- ----------------------------------------------------------------------------
-- Statement 16: [Brief Title]
-- Explanation: Scalar Subquery
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here];


-- ----------------------------------------------------------------------------
-- Statement 17: [Brief Title]
-- Explanation: table aliasing
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here];

-- ----------------------------------------------------------------------------
-- Statement 18: [Brief Title]
-- Explanation: conditional update
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here];

-- ----------------------------------------------------------------------------
-- Statement 19: [Brief Title]
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here];


-- ----------------------------------------------------------------------------
-- Statement 20: [Brief Title]
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here];



-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 21: Most expensive furniture products never ordered by NBA players.
-- Explanation: Uses multi-table NOT IN subquery in orderItems, orders, and 
--              customers to find the top 10 most expnesive furniture products
--              never purchased by a customer from the domain hoops.example 
--              email address.  
-- ----------------------------------------------------------------------------
SELECT p.productID AS [Product ID], p.productName AS [Product Name], p.productType AS "Category", p.productPrice AS "Price"
FROM products p
WHERE p.productType = 'Furniture' 
    AND p.productID NOT IN (SELECT DISTINCT oi.productID
                            FROM orderItems oi
                            JOIN orders o ON oi.orderID = o.orderID --same
                            JOIN customers c ON o.custID = c.custID 
                            WHERE c.custEmail LIKE '%hoops.example')
ORDER BY p.productPrice DESC
LIMIT 10;   

-- ----------------------------------------------------------------------------
-- Statement 22: Customers going to store but not making any purchases in 2026
-- Explanation: Find customers using EXISTS, NOT EXISTS, and Subqueries to 
--      find customers receiving help but have not yet placed an order in 2026.  
-- ----------------------------------------------------------------------------
SELECT c.custID AS [Customer ID], c.custName AS [Customer Name], c.custEmail AS [Customer Email]
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM helps h 
    WHERE h.custID = c.custID 
        AND h.interactionDate >= '2026-01-01'
    ) --date larger than 2026
    AND NOT EXISTS
    (SELECT 1 FROM orders o 
        WHERE o.custID = c.custID 
            AND o.orderDate >= '2026-01-01')
ORDER BY c.custID;

-- ----------------------------------------------------------------------------
-- Statement 23: Clearance Products are missing from Overflow Backstock
-- Explanation: List products stocked in the Clearance & Outlet Corner 
--      (locationID 23) that are not in Overflow Backstock Bay (locationID 24) 
--      using EXCEPT (-). 
-- ----------------------------------------------------------------------------
SELECT p.productID AS [Product ID], p.productName AS [Product Name], p.productType AS [Category]
FROM products p
JOIN inventoryStock i ON p.productID = i.productID
WHERE i.locationID = 23
EXCEPT
SELECT p1.productID, p1.productName, p1.productType 
    FROM products p1
    JOIN inventoryStock i ON p1.productID = i.productID
    WHERE i.locationID = 24
ORDER BY [Product ID];


-- ----------------------------------------------------------------------------
-- Statement 24: Creating view for Order Lineitem Costs and Revenue Breakdown
-- Explanation: Creates view by joining orders, employees, customers, 
--      orderItems, and products to find average wholesaleCost in the store 
--      from supply to find the wholesale cost and revenue. 
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS View_CostOfOrderBreakdown;
CREATE VIEW View_CostOfOrderBreakdown AS 
    SELECT o.orderID, o.orderDate, o.orderPriority, e.employeeID, employeeName, c.custID, c.custName, p.productID, 
        p.productName, p.productType, oi.quantity, 
        p.productPrice AS unitRetailPrice, 
    (SELECT ROUND (AVG(s.wholesaleCost), 2)
FROM supply s
WHERE s.productID = p.productID) AS avgWholesaleCost,
ROUND(oi.quantity * p.productPrice, 2) AS lineRetailRevenue,
ROUND(oi.quantity * (SELECT AVG(s.wholesaleCost) FROM supply s WHERE s.productID = p.productID), 2) AS lineWholesaleCost
FROM orders o
JOIN employees e ON o.employeeID = e.employeeID
JOIN customers c ON o.custID = c.custID
JOIN orderItems oi ON o.orderID = oi.orderID
JOIN products p ON oi.productID = p.productID;

-- ----------------------------------------------------------------------------
-- Statement 25: List Employee Sales by Order Priority and Gross Profit
-- Explanation: Queries the view using conditional CASE and ELSE conditions/
--      statements (if-else statements) to sort each employee's retail 
--      revenue based on the three priority level orders. The final calculated 
--      results are totals of each employee's wholesale cost and gross profit, 
--      sorted from lowest to highest.
-- ----------------------------------------------------------------------------
SELECT employeeID AS [Employee ID], employeeName AS [Employee Name], 
    ROUND(SUM(CASE WHEN orderPriority = 1 THEN lineRetailRevenue ELSE 0 END), 2) AS [Priority 1 Sale], 
    ROUND(SUM(CASE WHEN orderPriority = 2 THEN lineRetailRevenue ELSE 0 END), 2) AS [Priority 2 Sale], 
    ROUND(SUM(CASE WHEN orderPriority = 3 THEN lineRetailRevenue ELSE 0 END), 2) AS [Priority 3 Sale], 
    ROUND(SUM(lineWholesaleCost), 2) AS [Total Wholesale Cost], 
    ROUND(SUM(lineRetailRevenue - lineWholesaleCost), 2) AS [Gross Profit]
FROM View_CostOfOrderBreakdown
GROUP BY employeeID, employeeName
ORDER BY "Gross Profit" DESC;

-- ----------------------------------------------------------------------------
-- Statement 26: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 2# Here];

-- ----------------------------------------------------------------------------
-- Statement 27: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 2# Here];

-- ----------------------------------------------------------------------------
-- Statement 28: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 2# Here];

-- ----------------------------------------------------------------------------
-- Statement 29: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 2# Here];


-- ----------------------------------------------------------------------------
-- Statement 30: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 2# Here];
