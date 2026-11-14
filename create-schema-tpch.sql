-- Nue Lopez
-- Relational Schemas
-- 26 September 2026


-- Dropping tables if they exist before rerunning/repopulating data into DB. 
DROP TABLE IF EXISTS helps;
DROP TABLE IF EXISTS supply;
DROP TABLE IF EXISTS inventoryStock;
DROP TABLE IF EXISTS orderItems;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS locationsInStore;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS products;


--  Create Base Entity tables; no foreign keys. 
CREATE TABLE products(
	productID INTEGER PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    productType VARCHAR(20) NOT NULL,
    productPrice DECIMAL(8, 2) NOT NULL,
    productDescription TEXT
);

CREATE TABLE vendors(
    vendorID INTEGER PRIMARY KEY,
    vendorName VARCHAR(50) NOT NULL,
    vendorPhone VARCHAR(20),
    vendorEmail VARCHAR(100),
    vendorAddress VARCHAR(255) 
);

CREATE TABLE locationsInStore(
    locationID INTEGER PRIMARY KEY,
    aisleNumber INTEGER,
    sectionName VARCHAR(50),
    shelfNumber INTEGER
);

CREATE TABLE customers (
    custID INTEGER PRIMARY KEY,
    custName VARCHAR(50) NOT NULL,
    custEmail VARCHAR(100) NOT NULL UNIQUE,
    custAddr VARCHAR(100),
    custBalance DECIMAL(7, 2) NOT NULL DEFAULT 0.00
);


--	1:N Relationship Entity Tables using Foreign Keys
-- WorksIn: locationsInStore (1) <- employees (N)
CREATE TABLE employees (
    employeeID INTEGER PRIMARY KEY,
    employeeName VARCHAR(50) NOT NULL,
    employeeEmail VARCHAR(100) NOT NULL UNIQUE,
    locationID INTEGER,
    FOREIGN KEY (locationID) REFERENCES locationsInStore(locationID) ON DELETE SET NULL
);
--potentailly insert if a person is a manager or not... BOOL statement denoting. 


--Places & Assist 1:N
CREATE TABLE orders (
    orderID INTEGER PRIMARY KEY,
    orderPriority INTEGER DEFAULT 1,
    shipAddr VARCHAR(100) NOT NULL,
    totalPrice DECIMAL(8, 2) NOT NULL CHECK (totalPrice >= 0.00),
    orderDate DATE NOT NULL,
    orderDescription TEXT,
    custID INTEGER NOT NULL,
    employeeID INTEGER,
    FOREIGN KEY (custID) REFERENCES customers(custID) ON DELETE CASCADE,
    FOREIGN KEY (employeeID) REFERENCES employees(employeeID) ON DELETE SET NULL
);

--	M:N Relationship Tables 

--	products-orders. 
CREATE TABLE orderItems (
    orderID INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (orderID, productID),
    FOREIGN KEY (orderID) REFERENCES orders(orderID) ON DELETE CASCADE,
    FOREIGN KEY (productID) REFERENCES products(productID)
);

--	products-locationsInStore
CREATE TABLE inventoryStock (
    productID INTEGER NOT NULL,
    locationID INTEGER NOT NULL,
    quantityOnHand INTEGER NOT NULL DEFAULT 0 CHECK (quantityOnHand >= 0),
    PRIMARY KEY (productID, locationID),
    FOREIGN KEY (productID) REFERENCES products(productID),
    FOREIGN KEY (locationID) REFERENCES locationsInStore(locationID)
);

--	products-vendors
CREATE TABLE supply (
    vendorID INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    wholesaleCost DECIMAL(8, 2) NOT NULL CHECK (wholesaleCost >= 0.00),
    PRIMARY KEY (vendorID, productID),
    FOREIGN KEY (vendorID) REFERENCES vendors(vendorID),
    FOREIGN KEY (productID) REFERENCES products(productID)
);

CREATE TABLE helps (
    employeeID INTEGER NOT NULL,
    custID INTEGER NOT NULL,
    interactionDate DATE NOT NULL,
    PRIMARY KEY (employeeID, custID, interactionDate),
    FOREIGN KEY (employeeID) REFERENCES employees(employeeID) ON DELETE CASCADE,
    FOREIGN KEY (custID) REFERENCES customers(custID) ON DELETE CASCADE
);
