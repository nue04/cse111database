-- Nue Lopez
-- Relational Schemas
-- 26 September 2026


-- Dropping tables if they exist before rerunning/repopulating data into DB. 
DROP TABLE IF EXISTS Helps;
DROP TABLE IF EXISTS Supply;
DROP TABLE IF EXISTS InventoryStock;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS LocationsInStore;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Products;


--  Create Base Entity tables; no foreign keys. 
CREATE TABLE Products(
	productID INTEGER PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productType VARCHAR(20) NOT NULL,
    productPrice DECIMAL(8, 2) NOT NULL,
    productDescription TEXT
);

CREATE TABLE Vendors(
    vendorID INTEGER PRIMARY KEY,
    vendorName VARCHAR(50) NOT NULL,
    vendorPhone VARCHAR(20),
    vendorEmail VARCHAR(100),
    vendorAddress VARCHAR(255) 
);

CREATE TABLE LocationsInStore(
    locationID INTEGER PRIMARY KEY,
    aisleNumber INTEGER,
    sectionName VARCHAR(50),
    shelfNumber INTEGER
);

CREATE TABLE Customers (
    custID INTEGER PRIMARY KEY,
    custName VARCHAR(50) NOT NULL,
    custEmail VARCHAR(100) NOT NULL UNIQUE,
    custAddr VARCHAR(100),
    custBalance DECIMAL(7, 2) NOT NULL DEFAULT 0.00
);


--	1:N Relationship Entity Tables using Foreign Keys
-- WorksIn: LocationsInStore (1) <- Employees (N)
CREATE TABLE Employees (
    employeeID INTEGER PRIMARY KEY,
    employeeName VARCHAR(50) NOT NULL,
    employeeEmail VARCHAR(100) NOT NULL UNIQUE,
    locationID INTEGER,
    FOREIGN KEY (locationID) REFERENCES LocationsInStore(locationID) ON DELETE SET NULL
);
--potentailly insert if a person is a manager or not... BOOL statement denoting. 


--Places & Assist 1:N
CREATE TABLE Orders (
    orderID INTEGER PRIMARY KEY,
    orderPriority INTEGER DEFAULT 1,
    shipAddr VARCHAR(100) NOT NULL,
    totalPrice DECIMAL(8, 2) NOT NULL CHECK (totalPrice >= 0.00),
    orderDate DATE NOT NULL,
    orderDescription TEXT,
    custID INTEGER NOT NULL,
    employeeID INTEGER,
    FOREIGN KEY (custID) REFERENCES Customers(custID) ON DELETE CASCADE,
    FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE SET NULL
);

--	M:N Relationship Tables 

--	Products-Orders. 
CREATE TABLE OrderItems (
    orderID INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID) ON DELETE CASCADE,
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

--	Products-LocationsInStore
CREATE TABLE InventoryStock (
    productID INTEGER NOT NULL,
    locationID INTEGER NOT NULL,
    quantityOnHand INTEGER NOT NULL DEFAULT 0 CHECK (quantityOnHand >= 0),
    PRIMARY KEY (productID, locationID),
    FOREIGN KEY (productID) REFERENCES Products(productID),
    FOREIGN KEY (locationID) REFERENCES LocationsInStore(locationID)
);

--	Products-Vendors
CREATE TABLE Supply (
    vendorID INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    wholesaleCost DECIMAL(8, 2) NOT NULL CHECK (wholesaleCost >= 0.00),
    PRIMARY KEY (vendorID, productID),
    FOREIGN KEY (vendorID) REFERENCES Vendors(vendorID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

CREATE TABLE Helps (
    employeeID INTEGER NOT NULL,
    custID INTEGER NOT NULL,
    interactionDate DATE NOT NULL,
    PRIMARY KEY (employeeID, custID, interactionDate),
    FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE CASCADE,
    FOREIGN KEY (custID) REFERENCES Customers(custID) ON DELETE CASCADE
);


--                      Adding data to DB.

-- Adding 15 items to Products. 
INSERT INTO Products VALUES (101, 'Mid-Century Velvet Sofa', 'Furniture', 899.99, '3-seater deep navy velvet sofa with tapered wooden legs');
INSERT INTO Products VALUES (102, 'Rustic Oak Dining Table', 'Furniture', 649.50, 'Solid reclaimed oak dining table, seats up to 8');
INSERT INTO Products VALUES (103, 'Ergonomic Executive Chair', 'Furniture', 249.00, 'High-back mesh ergonomic office chair with lumbar support');
INSERT INTO Products VALUES (104, 'King Platform Bed Frame', 'Furniture', 520.00, 'Minimalist walnut finish king platform bed with wooden slats');
INSERT INTO Products VALUES (105, 'Modern Glass Coffee Table', 'Furniture', 189.99, 'Tempered round glass top coffee table with black steel base');
INSERT INTO Products VALUES (106, 'Reclining Leather Armchair', 'Furniture', 450.00, 'Top-grain brown leather push-back recliner with footrest');
INSERT INTO Products VALUES (107, 'Industrial 5-Tier Bookshelf', 'Furniture', 135.00, 'Open metal frame bookshelf with rustic pine wood shelves');
INSERT INTO Products VALUES (108, 'French Door Refrigerator', 'Appliance', 1499.00, '26 cu. ft. smart stainless steel French door refrigerator');
INSERT INTO Products VALUES (109, 'Countertop Microwave 1100W', 'Appliance', 129.99, '1.2 cu. ft. stainless steel microwave with sensor cooking');
INSERT INTO Products VALUES (110, 'Front-Load Washing Machine', 'Appliance', 799.00, '4.5 cu. ft. high-efficiency front-load washer with steam cycle');
INSERT INTO Products VALUES (111, 'Electric Dryer with Steam', 'Appliance', 749.00, '7.4 cu. ft. front-load electric dryer with wrinkle guard');
INSERT INTO Products VALUES (112, 'Built-In Dishwasher 24-inch', 'Appliance', 599.95, 'Quiet 44 dBA stainless steel dishwasher with third rack');
INSERT INTO Products VALUES (113, 'Convection Air Fryer Oven', 'Appliance', 179.50, '10-in-1 digital countertop air fryer toaster oven');
INSERT INTO Products VALUES (114, 'Freestanding Gas Range Stove', 'Appliance', 899.00, '5-burner stainless steel gas convection oven range');
INSERT INTO Products VALUES (115, 'Pro Stand Mixer 5-Quart', 'Appliance', 299.99, 'Tilt-head electric food stand mixer with dough hook and whisk');


-- Inserting data into Vendors, having 8 Suppliers
INSERT INTO Vendors VALUES (1, 'Northwest Timber Crafts', '503-555-0144', 'sales@nwtimbercrafts.com', '1240 Industrial Way, Portland, OR 97201');
INSERT INTO Vendors VALUES (2, 'Apex Home Appliances Corp', '312-555-8821', 'orders@apexappliances.com', '800 Michigan Ave, Chicago, IL 60611');
INSERT INTO Vendors VALUES (3, 'Sierra Comfort Furniture', '559-555-3211', 'support@sierracomfort.com', '450 Fresno Blvd, Fresno, CA 93721');
INSERT INTO Vendors VALUES (4, 'Whirlpool Logistics Supply', '269-555-9000', 'b2b@whirlpoolsupply.com', '2000 N M-63, Benton Harbor, MI 49022');
INSERT INTO Vendors VALUES (5, 'Steelcase Ergonomics Hub', '616-555-4300', 'contract@steelcasehub.com', '901 44th St SE, Grand Rapids, MI 49508');
INSERT INTO Vendors VALUES (6, 'Golden State Mattress & Bedding', '916-555-7765', 'accounts@goldenstatebed.com', '3100 Capital Ave, Sacramento, CA 95814');
INSERT INTO Vendors VALUES (7, 'KitchenPro Culinary Tech', '408-555-1289', 'distribution@kitchenprotech.com', '150 Tech Way, San Jose, CA 95110');
INSERT INTO Vendors VALUES (8, 'Pacific Coast Living Designs', '206-555-6677', 'inquiries@pacificliving.com', '720 1st Ave S, Seattle, WA 98104');

-- Inserting data into LocationsInStore, having 10 Store asiles; 10 sections. 
-- --------------------------------------------------------
INSERT INTO LocationsInStore VALUES (1, 1, 'Living Room Showcase', 101);
INSERT INTO LocationsInStore VALUES (2, 1, 'Living Room Showcase', 102);
INSERT INTO LocationsInStore VALUES (3, 2, 'Dining & Kitchen Furniture', 201);
INSERT INTO LocationsInStore VALUES (4, 3, 'Bedroom & Mattresses', 301);
INSERT INTO LocationsInStore VALUES (5, 4, 'Home Office & Storage', 401);
INSERT INTO LocationsInStore VALUES (6, 5, 'Major Kitchen Appliances', 501);
INSERT INTO LocationsInStore VALUES (7, 5, 'Major Kitchen Appliances', 502);
INSERT INTO LocationsInStore VALUES (8, 6, 'Laundry Suites', 601);
INSERT INTO LocationsInStore VALUES (9, 7, 'Small Countertop Appliances', 701);
INSERT INTO LocationsInStore VALUES (10, 8, 'Clearance & Outlet Corner', 801);

-- Inserting data into Customers, total is 12 Customers in alpha-order by first name. 
INSERT INTO Customers VALUES (1, 'Alice Johnson', 'alice.j@gmail.com', '742 Evergreen Terr, Merced, CA 95340', 0.00);
INSERT INTO Customers VALUES (2, 'Bob Martinez', 'bob.martinez@yahoo.com', '1280 Olive Ave, Turlock, CA 95380', 149.50);
INSERT INTO Customers VALUES (3, 'Catherine Lee', 'clee99@ucmerced.edu', '5200 Lake Rd, Merced, CA 95343', 0.00);
INSERT INTO Customers VALUES (4, 'David Smith', 'david.smith44@outlook.com', '315 G St, Modesto, CA 95354', 899.99);
INSERT INTO Customers VALUES (5, 'Elena Rostova', 'elena.rostova@gmail.com', '888 Yosemite Pkwy, Merced, CA 95341', 0.00);
INSERT INTO Customers VALUES (6, 'Franklin Chen', 'fchen@techcorp.io', '2100 Canal St, Atwater, CA 95301', 320.00);
INSERT INTO Customers VALUES (7, 'Grace Hopper', 'grace.h@navy.mil', '1945 Computation Rd, Fresno, CA 93720', 0.00);
INSERT INTO Customers VALUES (8, 'Henry Cavill', 'hcavill@cinema.co.uk', '450 Royal Oaks Dr, Merced, CA 95348', 50.00);
INSERT INTO Customers VALUES (9, 'Irene Adler', 'irene.a@investigations.org', '221 Baker Way, Modesto, CA 95350', 0.00);
INSERT INTO Customers VALUES (10, 'James Wilson', 'jwilson@mercedhealth.org', '110 Bellevue Rd, Merced, CA 95348', 0.00);
INSERT INTO Customers VALUES (11, 'Karen Patel', 'karen.patel@ucdavis.edu', '650 Davis Blvd, Davis, CA 95616', 450.00);
INSERT INTO Customers VALUES (12, 'Lucas Scott', 'lscott@treehill.net', '300 River Rd, Chowchilla, CA 93610', 0.00);

-- Inserting data into Employees: 8 Associates & updating Managers next push. 
INSERT INTO Employees VALUES (1, 'Captain Garret Clark', 'garretclark@captainclarks.com', 1);
INSERT INTO Employees VALUES (2, 'Nue Lopez', 'nuelopez@captainclarks.com', 6);
INSERT INTO Employees VALUES (3, 'Samantha Miller', 'smiller@captainclarks.com', 3);
INSERT INTO Employees VALUES (4, 'Marcus Rivera', 'mrivera@captainclarks.com', 4);
INSERT INTO Employees VALUES (5, 'Chloe Zhao', 'czhao@captainclarks.com', 5);
INSERT INTO Employees VALUES (6, 'Tyler Vance', 'tvance@captainclarks.com', 8);
INSERT INTO Employees VALUES (7, 'Brianna Hayes', 'bhayes@captainclarks.com', 9);
INSERT INTO Employees VALUES (8, 'Jordan Bennett', 'jbennett@captainclarks.com', 10);


-- created Orders (12 Transactions) and uploading more later. 
INSERT INTO Orders VALUES (1001, 1, '742 Evergreen Terr, Merced, CA 95340', 899.99, '2026-10-02', 'Living room sofa purchase with in-store pickup', 1, 1);
INSERT INTO Orders VALUES (1002, 2, '1280 Olive Ave, Turlock, CA 95380', 799.49, '2026-10-05', 'Reclaimed oak table and glass coffee table order', 2, 3);
INSERT INTO Orders VALUES (1003, 1, '5200 Lake Rd, Merced, CA 95343', 249.00, '2026-10-08', 'Ergonomic office chair for student workspace', 3, 5);
INSERT INTO Orders VALUES (1004, 3, '315 G St, Modesto, CA 95354', 1499.00, '2026-10-12', 'French door refrigerator delivery with priority shipping', 4, 2);
INSERT INTO Orders VALUES (1005, 1, '888 Yosemite Pkwy, Merced, CA 95341', 1548.00, '2026-10-15', 'Full laundry suite: front-load washer and electric dryer', 5, 6);
INSERT INTO Orders VALUES (1006, 2, '2100 Canal St, Atwater, CA 95301', 520.00, '2026-10-19', 'King platform bed frame with curbside pickup', 6, 4);
INSERT INTO Orders VALUES (1007, 1, '1945 Computation Rd, Fresno, CA 95340', 309.98, '2026-10-22', 'Microwave 1100W and air fryer convection oven', 7, 7);
INSERT INTO Orders VALUES (1008, 1, '450 Royal Oaks Dr, Merced, CA 95348', 450.00, '2026-10-26', 'Top-grain leather reclining armchair', 8, 1);
INSERT INTO Orders VALUES (1009, 2, '221 Baker Way, Modesto, CA 95350', 899.00, '2026-10-29', 'Gas range stove appliance upgrade', 9, 2);
INSERT INTO Orders VALUES (1010, 1, '110 Bellevue Rd, Merced, CA 95348', 299.99, '2026-11-02', 'Pro stand food mixer culinary holiday gift', 10, 7);
INSERT INTO Orders VALUES (1011, 2, '650 Davis Blvd, Davis, CA 95616', 1034.95, '2026-11-04', 'Built-in dishwasher and leather armchair bundle', 11, 2);
INSERT INTO Orders VALUES (1012, 1, '300 River Rd, Chowchilla, CA 93610', 784.00, '2026-11-07', 'Oak dining table and bookshelf set', 12, 3);

-- Inserting data into OrderItems: Line Items for Each Order
INSERT INTO OrderItems VALUES (1001, 101, 1);
INSERT INTO OrderItems VALUES (1002, 102, 1);
INSERT INTO OrderItems VALUES (1002, 105, 1);
INSERT INTO OrderItems VALUES (1003, 103, 1);
INSERT INTO OrderItems VALUES (1004, 108, 1);
INSERT INTO OrderItems VALUES (1005, 110, 1);
INSERT INTO OrderItems VALUES (1005, 111, 1);
INSERT INTO OrderItems VALUES (1006, 104, 1);
INSERT INTO OrderItems VALUES (1007, 109, 1);
INSERT INTO OrderItems VALUES (1007, 113, 1);
INSERT INTO OrderItems VALUES (1008, 106, 1);
INSERT INTO OrderItems VALUES (1009, 114, 1);
INSERT INTO OrderItems VALUES (1010, 115, 1);
INSERT INTO OrderItems VALUES (1011, 112, 1);
INSERT INTO OrderItems VALUES (1011, 106, 1);
INSERT INTO OrderItems VALUES (1012, 102, 1);
INSERT INTO OrderItems VALUES (1012, 107, 1);

---- Inserting data into InventoryStock (Stocking Levels Across Aisles)
INSERT INTO InventoryStock VALUES (101, 1, 8);
INSERT INTO InventoryStock VALUES (101, 10, 2);
INSERT INTO InventoryStock VALUES (102, 3, 5);
INSERT INTO InventoryStock VALUES (103, 5, 14);
INSERT INTO InventoryStock VALUES (104, 4, 6);
INSERT INTO InventoryStock VALUES (105, 1, 11);
INSERT INTO InventoryStock VALUES (105, 2, 4);
INSERT INTO InventoryStock VALUES (106, 2, 7);
INSERT INTO InventoryStock VALUES (107, 5, 12);
INSERT INTO InventoryStock VALUES (108, 6, 4);
INSERT INTO InventoryStock VALUES (109, 9, 20);
INSERT INTO InventoryStock VALUES (110, 8, 6);
INSERT INTO InventoryStock VALUES (111, 8, 5);
INSERT INTO InventoryStock VALUES (112, 7, 8);
INSERT INTO InventoryStock VALUES (113, 9, 15);
INSERT INTO InventoryStock VALUES (114, 6, 5);
INSERT INTO InventoryStock VALUES (115, 9, 18);


-- Inserting data into Supply. 
INSERT INTO Supply VALUES (1, 102, 380.00);
INSERT INTO Supply VALUES (1, 107, 75.00);
INSERT INTO Supply VALUES (2, 108, 950.00);
INSERT INTO Supply VALUES (2, 109, 70.00);
INSERT INTO Supply VALUES (3, 101, 520.00);
INSERT INTO Supply VALUES (3, 106, 260.00);
INSERT INTO Supply VALUES (4, 110, 480.00);
INSERT INTO Supply VALUES (4, 111, 440.00);
INSERT INTO Supply VALUES (4, 112, 370.00);
INSERT INTO Supply VALUES (5, 103, 130.00);
INSERT INTO Supply VALUES (6, 104, 300.00);
INSERT INTO Supply VALUES (7, 113, 95.00);
INSERT INTO Supply VALUES (7, 114, 550.00);
INSERT INTO Supply VALUES (7, 115, 175.00);
INSERT INTO Supply VALUES (8, 101, 540.00);
INSERT INTO Supply VALUES (8, 105, 90.00);

-- Inserting data into Helps; Employee Assistance Interactions with Customers and inserting dates. 
INSERT INTO Helps VALUES (1, 1, '2026-10-02');
INSERT INTO Helps VALUES (3, 2, '2026-10-05');
INSERT INTO Helps VALUES (5, 3, '2026-10-08');
INSERT INTO Helps VALUES (2, 4, '2026-10-12');
INSERT INTO Helps VALUES (6, 5, '2026-10-15');
INSERT INTO Helps VALUES (4, 6, '2026-10-19');
INSERT INTO Helps VALUES (7, 7, '2026-10-22');
INSERT INTO Helps VALUES (1, 8, '2026-10-26');
INSERT INTO Helps VALUES (2, 9, '2026-10-29');
INSERT INTO Helps VALUES (7, 10, '2026-11-02');
INSERT INTO Helps VALUES (2, 11, '2026-11-04');
INSERT INTO Helps VALUES (3, 12, '2026-11-07');
INSERT INTO Helps VALUES (1, 3, '2026-11-08');
INSERT INTO Helps VALUES (5, 1, '2026-11-09');
