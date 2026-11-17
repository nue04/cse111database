-- ============================================================================
-- CSE 111 Fall 2026: Project Checkpoint 2 Script
-- Project Title: [Captain Clark's Furniture and Appliance Store DBMS]
-- Team Members: Nue Lopez, Garret Clark
-- File: Checkpoint2-script.sql
-- GitHub for easy access to instructors: https://github.com/nue04/cse111database
-- ============================================================================


-- ============================================================================
-- SCHEMA MODIFICATIONS SINCE CHECKPOINT 1
-- ============================================================================
-- Modifications:
-- 1. Schema Modifications Since Checkpoint 1:
--      * Added color (BOOLEAN) to products.
--      * Added isManager (BOOLEAN) to employees.

-- 2. Constraint & View Refinements
--      * Added CHECK (productPrice >= 0.00) on products. Enhanced orderItems.quantity 
--          from CHECK (quantity >= 0) to CHECK (quantity > 0).
--      * Added a virtual view labeled View_CostOfOrderBreakdown.
-- ============================================================================

-- ============================================================================
-- MEMBER CONTRIBUTIONS SUMMARY
-- ============================================================================
-- SECTION 1: SIMPLE STATEMENTS
-- Statement 01: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 02: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 03: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 04: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 05: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 06: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 07: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 08: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 09: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 10: Nue Lopez: 0%, Garret Clark: 100%
--
-- SECTION 2: INTERMEDIATE STATEMENTS
-- Statement 11: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 12: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 13: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 14: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 15: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 16: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 17: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 18: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 19: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 20: Nue Lopez: 0%, Garret Clark: 100%

-- SECTION 3: COMPLEX STATEMENTS
-- Statement 21: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 22: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 23: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 24: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 25: Nue Lopez: 100%, Garret Clark: 0%
-- Statement 26: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 27: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 28: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 29: Nue Lopez: 0%, Garret Clark: 100%
-- Statement 30: Nue Lopez: 0%, Garret Clark: 100%
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
-- Explanation: Promote Samantha Miller to manager.
-- ----------------------------------------------------------------------------
UPDATE employees
SET isManager = TRUE
WHERE employeeID = 3;

-- ----------------------------------------------------------------------------
-- Statement 06: High Cost Furniture Finder
-- Explanation: This statement searches for items priced at a minimum of $500 
--              or higher. It also retrieves the product's ID, name, and price 
--              of the furniture.
-- ----------------------------------------------------------------------------
SELECT productID, productName, productPrice
FROM products
WHERE productType = 'Furniture' AND productPrice >= 500.00
ORDER BY productPrice DESC;

-- ----------------------------------------------------------------------------
-- Statement 07: Customer Account Balance
-- Explanation: This statement finds the total number of registered customers, 
--              and the combined account balances between all customers. The 
--              average balance is also included.
-- ----------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_customers,
    SUM(custBalance) AS total_outstanding_balance,
    ROUND(AVG(custBalance), 2) AS average_customer_balance
FROM customers;

-- ----------------------------------------------------------------------------
-- Statement 08: Walnut Product Catalog Search
-- Explanation: This statement retrieves the ID, name, category, and retail 
--              price of products containing 'Walnut' in their name, which is 
--              then ordered by price.
-- ----------------------------------------------------------------------------
SELECT productID, productName, productType, productPrice
FROM products
WHERE productName LIKE '%Walnut%'
ORDER BY productPrice ASC;

-- ----------------------------------------------------------------------------
-- Statement 09: New Merchandise Vendor Registration
-- Explanation: Inserts a new supplier into the vendors table with contact and 
--              address details.
-- ----------------------------------------------------------------------------
INSERT INTO vendors (vendorID, vendorName, vendorPhone, vendorEmail, vendorAddress)
VALUES (
    126, 
    'Central Valley Woodworks', 
    '209-555-0194', 
    'orders@cvwoodworks.example', 
    '1420 Industrial Way, Merced, CA 95340'
);

-- ----------------------------------------------------------------------------
-- Statement 10: Single-Row Customer Balance Payment
-- Explanation: This statement records a $100.00 payment toward customer ID 5's 
--              account balance, using a primary-key search to find them.
-- ----------------------------------------------------------------------------


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
-- Statement 16: Store Inventory Breakdown
-- Explanation: This statement retrieves each stocked product's ID, name, and 
--              category along with the aisle, section, shelf, and quantity of 
--              the item that the store has.
-- ----------------------------------------------------------------------------
SELECT 
    P.productID,
    P.productName,
    P.productType,
    L.aisleNumber,
    L.sectionName,
    L.shelfNumber,
    I.quantityOnHand
FROM inventorystock I
JOIN products P ON I.productID = P.productID
JOIN locationsinstore L ON I.locationID = L.locationID
ORDER BY L.aisleNumber ASC, L.shelfNumber ASC, P.productName ASC;

-- ----------------------------------------------------------------------------
-- Statement 17: Multi-Product Vendor Supply Retrieval
-- Explanation: This statement lists vendors that supply at least three unique 
--              products to the store, along with the total item count and 
--              average cost of the items.
-- ----------------------------------------------------------------------------
SELECT 
    V.vendorID,
    V.vendorName,
    COUNT(S.productID) AS products_supplied,
    ROUND(AVG(S.wholesaleCost), 2) AS avg_wholesale_cost
FROM vendors V
JOIN supply S ON V.vendorID = S.vendorID
GROUP BY V.vendorID, V.vendorName
HAVING COUNT(S.productID) >= 3
ORDER BY avg_wholesale_cost DESC;

-- ----------------------------------------------------------------------------
-- Statement 18: Employee Order Workload & Revenue Summary
-- Explanation: This statement displays every employee that the store has, 
--              along with their total amount of assisted orders and total 
--              sales revenue that they've handled, including employees with 
--              zero orders.
-- ----------------------------------------------------------------------------
SELECT 
    E.employeeID,
    E.employeeName,
    COUNT(O.orderID) AS orders_assisted,
    COALESCE(SUM(O.totalPrice), 0.00) AS total_revenue_handled
FROM employees E
LEFT JOIN orders O ON E.employeeID = O.employeeID
GROUP BY E.employeeID, E.employeeName
ORDER BY total_revenue_handled DESC;

-- ----------------------------------------------------------------------------
-- Statement 19: Catalog Items Above Average Cost
-- Explanation: This statement finds all products with a retail price higher 
--              than the total average retail price across the store's entire 
--              catalog.
-- ----------------------------------------------------------------------------
SELECT 
    P.productID,
    P.productName,
    P.productType,
    P.productPrice
FROM products P
WHERE P.productPrice > (
    SELECT AVG(productPrice)
    FROM products
)
ORDER BY P.productPrice DESC;

-- ----------------------------------------------------------------------------
-- Statement 20: Wholesale Cost Adjustment for Appliances
-- Explanation: This statement applies a 5% wholesale cost increase in the 
--              supply table for all store products that are classified under 
--              the 'Appliance' product type.
-- ----------------------------------------------------------------------------
UPDATE supply
SET wholesaleCost = ROUND(wholesaleCost * 1.05, 2)
WHERE productID IN (
    SELECT productID
    FROM products
    WHERE productType = 'Appliance'
);

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
-- Statement 22: Customers going to store but not making any purchases in 2020
-- Explanation: Find customers using EXISTS, NOT EXISTS, and Subqueries to 
--      find customers receiving help but have not yet placed an order in 2026.  
-- ----------------------------------------------------------------------------
SELECT c.custID AS [Customer ID], c.custName AS [Customer Name], c.custEmail AS [Customer Email]
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM helps h 
    WHERE h.custID = c.custID 
        AND h.interactionDate >= '2020-01-01'
    ) --date larger than 2026
    AND NOT EXISTS
    (SELECT 1 FROM orders o 
        WHERE o.custID = c.custID 
            AND o.orderDate >= '2020-01-01')
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
-- Statement 26: Low Stock Vendor Alert
-- Explanation: This statement searches for vendors that supply a product with 3 or fewer units 
-- currently in stock at any store. It also retrieves each vendor's ID, name, and email in alphabetical order.
-- ----------------------------------------------------------------------------
SELECT V.vendorID, V.vendorName, V.vendorEmail
FROM vendors V
WHERE EXISTS (
    SELECT 1
    FROM supply S
    JOIN inventorystock I ON S.productID = I.productID
    WHERE S.vendorID = V.vendorID
      AND I.quantityOnHand <= 3
)
ORDER BY V.vendorName ASC;

-- ----------------------------------------------------------------------------
-- Statement 27: Store Location Shared Stock Finder
-- Explanation: This statement will find the product IDs and names of items stocked 
-- at both store location 1 and store location 23 to keep only overlapping products. 
-- The results are also ordered by product ID.
-- ----------------------------------------------------------------------------
SELECT P.productID, P.productName
FROM products P
JOIN inventorystock I ON P.productID = I.productID
WHERE I.locationID = 1
INTERSECT
SELECT P.productID, P.productName
FROM products P
JOIN inventorystock I ON P.productID = I.productID
WHERE I.locationID = 23
ORDER BY P.productID ASC;

-- ----------------------------------------------------------------------------
-- Statement 28: Store & Vendor Contact Directory
-- Explanation: This statement combines all store employees and vendors into a contact directory. 
-- Each contact's name, email, and role affiliation are included and ordered alphabetically.
-- ----------------------------------------------------------------------------
SELECT 
    employeeName AS contact_name,
    employeeEmail AS contact_email,
    'INTERNAL EMPLOYEE' AS affiliation
FROM employees
UNION ALL
SELECT 
    vendorName AS contact_name,
    vendorEmail AS contact_email,
    'EXTERNAL VENDOR' AS affiliation
FROM vendors
ORDER BY contact_name ASC;

-- ----------------------------------------------------------------------------
-- Statement 29: Category Best-Sellers Ranking
-- Explanation: This statement calculates the total units sold and total 
-- revenue for each product, which are ranked from highest to lowest revenue for each product category.
-- ----------------------------------------------------------------------------
WITH ProductSales AS (
    SELECT 
        P.productID,
        P.productName,
        P.productType,
        SUM(OI.quantity) AS total_units_sold,
        SUM(OI.quantity * P.productPrice) AS total_revenue
    FROM products P
    JOIN orderitems OI ON P.productID = OI.productID
    GROUP BY P.productID, P.productName, P.productType
)
SELECT 
    productType,
    productID,
    productName,
    total_units_sold,
    total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY productType 
        ORDER BY total_revenue DESC
    ) AS rank_in_category
FROM ProductSales
ORDER BY productType ASC, rank_in_category ASC;

-- ----------------------------------------------------------------------------
-- Statement 30: Category Inventory Status Breakdown
-- Explanation: This statement displays every product category across the store, 
-- and displays items out of stock, low stock, or well stocked. Total number of stocking 
-- records per category is included aswell.
-- ----------------------------------------------------------------------------
SELECT 
    P.productType,
    COUNT(CASE WHEN I.quantityOnHand = 0 THEN 1 END) AS out_of_stock_locations,
    COUNT(CASE WHEN I.quantityOnHand BETWEEN 1 AND 5 THEN 1 END) AS low_stock_locations,
    COUNT(CASE WHEN I.quantityOnHand > 5 THEN 1 END) AS well_stocked_locations,
    COUNT(*) AS total_stock_records
FROM products P
JOIN inventorystock I ON P.productID = I.productID
GROUP BY P.productType
ORDER BY total_stock_records DESC;
