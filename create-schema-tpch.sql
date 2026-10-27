-- Nue Lopez
-- Relational Schemas
-- 26 September 2026

--	Base Entity tables; no foreign keys. 
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


--	1:N Relationship Entity Tables
CREATE TABLE Employees (
    employeeID INTEGER PRIMARY KEY,
    employeeName VARCHAR(50) NOT NULL,
    employeeEmail VARCHAR(100) NOT NULL,
    locationID INTEGER,
    FOREIGN KEY (locationID) REFERENCES LocationsInStore(locationID) ON DELETE SET NULL
);

CREATE TABLE Orders (
    orderID INTEGER PRIMARY KEY,
    orderPriority INTEGER DEFAULT 1,
    shipAddr VARCHAR(100) NOT NULL,
    totalPrice DECIMAL(8, 2) NOT NULL,
    orderDate DATE NOT NULL,
    orderDescription TEXT,
    custID INTEGER NOT NULL,
    employeeID INTEGER,
    FOREIGN KEY (custID) REFERENCES Customers(custID) ON DELETE CASCADE,
    FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE SET NULL
);

--	M:N Relationship Tables (Many-many). 

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
