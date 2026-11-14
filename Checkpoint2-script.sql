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
-- Statement 05: 2 new customers
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here;

-- ----------------------------------------------------------------------------
-- Statement 06: Employee promoted to Manager
-- Explanation: [Explanation here].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement ## Here];

-- [Continue Statements 03 through 10...]






-- ----------------------------------------------------------------------------
-- Statement 11: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the join logic, filtering, 
--              or conditional modification].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 11 Here];

-- [Continue Statements 12 through 21...]


-- ============================================================================
-- SECTION 3: COMPLEX STATEMENTS (Roughly 10 Statements)
-- Focus: Correlated subqueries (EXISTS/NOT EXISTS), set operations 
--        (UNION, INTERSECT, EXCEPT), Common Table Expressions (WITH / CTEs), 
--        window functions (ROW_NUMBER, DENSE_RANK), VIEW creation/querying, 
--        multi-condition triggers, and complex analytics.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Statement 22: [Brief Title]
-- Explanation: [1 to 2 sentences explaining the complex query/trigger logic].
-- ----------------------------------------------------------------------------
-- [Insert SQL Statement 22 Here];

-- [Continue Statements 23 through 32...]
