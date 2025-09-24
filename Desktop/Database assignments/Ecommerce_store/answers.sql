-- Create database and switch to it
CREATE DATABASE IF NOT EXISTS ecommerceDB
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
USE ecommerceDB;

-- STEP 1: Drop old tables
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS ProductCategories;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Users;

SET FOREIGN_KEY_CHECKS = 1;

-- STEP 2: Create Tables
-- Users
CREATE TABLE Users (
    UserID INT NOT NULL AUTO_INCREMENT,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100),
    Phone VARCHAR(30),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID)
) ENGINE=InnoDB;

-- Suppliers
CREATE TABLE Suppliers (
    SupplierID INT NOT NULL AUTO_INCREMENT,
    SupplierName VARCHAR(150) NOT NULL,
    ContactName VARCHAR(120),
    Phone VARCHAR(30),
    Email VARCHAR(255),
    Address TEXT,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (SupplierID)
) ENGINE=InnoDB;

-- Categories
CREATE TABLE Categories (
    CategoryID INT NOT NULL AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    PRIMARY KEY (CategoryID)
) ENGINE=InnoDB;

-- Products
CREATE TABLE Products (
    ProductID INT NOT NULL AUTO_INCREMENT,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    Name VARCHAR(255) NOT NULL,
    ShortDescription VARCHAR(512),
    LongDescription TEXT,
    Price DECIMAL(12,2) NOT NULL CHECK (Price >= 0),
    SupplierID INT,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Inventory
CREATE TABLE Inventory (
    InventoryID INT NOT NULL AUTO_INCREMENT,
    ProductID INT NOT NULL,
    WarehouseLocation VARCHAR(120),
    Quantity INT NOT NULL DEFAULT 0,
    ReorderLevel INT NOT NULL DEFAULT 10,
    LastUpdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (InventoryID),
    UNIQUE KEY uq_inventory_product (ProductID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ProductCategories 
CREATE TABLE ProductCategories (
    ProductID INT NOT NULL,
    CategoryID INT NOT NULL,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Addresses
CREATE TABLE Addresses (
    AddressID INT NOT NULL AUTO_INCREMENT,
    UserID INT NOT NULL,
    Label VARCHAR(60),
    Line1 VARCHAR(255) NOT NULL,
    Line2 VARCHAR(255),
    City VARCHAR(100) NOT NULL,
    Region VARCHAR(100),
    PostalCode VARCHAR(30),
    Country VARCHAR(100) NOT NULL,
    IsDefault TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (AddressID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Orders
CREATE TABLE Orders (
    OrderID INT NOT NULL AUTO_INCREMENT,
    UserID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ShipAddressID INT,
    BillingAddressID INT,
    Status ENUM('Pending','Processing','Shipped','Delivered','Cancelled','Returned') NOT NULL DEFAULT 'Pending',
    Subtotal DECIMAL(12,2) NOT NULL CHECK (Subtotal >= 0),
    Shipping DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (Shipping >= 0),
    Tax DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (Tax >= 0),
    Total DECIMAL(14,2) NOT NULL CHECK (Total >= 0),
    PRIMARY KEY (OrderID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (ShipAddressID) REFERENCES Addresses(AddressID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (BillingAddressID) REFERENCES Addresses(AddressID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- OrderItems
CREATE TABLE OrderItems (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(12,2) NOT NULL CHECK (UnitPrice >= 0),
    Discount DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (Discount >= 0),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Payments
CREATE TABLE Payments (
    PaymentID INT NOT NULL AUTO_INCREMENT,
    OrderID INT NOT NULL,
    PaidAmount DECIMAL(14,2) NOT NULL CHECK (PaidAmount >= 0),
    PaymentMethod ENUM('CreditCard','DebitCard','PayPal','BankTransfer','CashOnDelivery') NOT NULL,
    PaymentStatus ENUM('Pending','Completed','Failed','Refunded') NOT NULL DEFAULT 'Pending',
    TransactionRef VARCHAR(255),
    PaidAt DATETIME,
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Reviews 
CREATE TABLE Reviews (
    ReviewID INT NOT NULL AUTO_INCREMENT,
    ProductID INT NOT NULL,
    UserID INT,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Title VARCHAR(255),
    Body TEXT,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ReviewID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- STEP 3: Helpful Indexes

CREATE INDEX idx_products_name ON Products(Name);
CREATE INDEX idx_orders_user ON Orders(UserID);
CREATE INDEX idx_inventory_quantity ON Inventory(Quantity);

-- STEP 4: Sample Data 

INSERT INTO Users (Email, PasswordHash, FirstName, LastName, Phone) VALUES
('noela@example.com','hash_here','Noela','Kipchumba','+254700000000'),
('brian@example.com','hash_here','Brian','Mutai','+254711111111'),
('emily@example.com','hash_here','Emily','Clark','+254722222222');

INSERT INTO Suppliers (SupplierName) VALUES ('Acme Supplies');

INSERT INTO Categories (CategoryName) VALUES 
('Laptops'), ('Accessories'), ('Phones');

INSERT INTO Products (SKU, Name, Price, SupplierID) VALUES
('LAP-001','Super Laptop', 1500.00, 1),
('MOU-001','Wireless Mouse', 25.50, 1),
('PHN-001','Smart Phone', 450.00, 1);

INSERT INTO Inventory (ProductID, Quantity) VALUES 
(1, 10), (2, 50), (3, 20);

INSERT INTO ProductCategories (ProductID, CategoryID) VALUES 
(1,1), (2,2), (3,3);

-- Orders & OrderItems
INSERT INTO Orders (UserID, Subtotal, Shipping, Tax, Total) VALUES
(1, 1500.00, 50.00, 150.00, 1700.00),
(2, 51.00, 10.00, 6.10, 67.10),
(3, 450.00, 25.00, 45.00, 520.00);

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
(1, 1, 1, 1500.00, 0.00),
(2, 2, 2, 25.50, 0.00),
(3, 3, 1, 450.00, 0.00);

