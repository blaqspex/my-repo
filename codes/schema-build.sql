CREATE DATABASE Online_Bookstore_Database;
USE Online_Bookstore_Database;

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(100) NOT NULL
);

CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(255)
);

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(255) NOT NULL,
    Bio TEXT
);

CREATE TABLE Book (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) UNIQUE NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT DEFAULT 0,
    CategoryID INT,
    PublisherID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);

CREATE TABLE BookAuthor (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    RegistrationDate DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE DEFAULT (CURRENT_DATE),
    `Status` VARCHAR(50),
    EstimatedDelivery DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE OrderItem (
    OrderID INT,
    BookID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
	OrderDate DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    CustomerID INT NOT NULL,
    PaymentMethod VARCHAR(50),
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    `Status` VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Review (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    CustomerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    `Comment` TEXT,
    ReviewDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE CartItem (
    CustomerID INT,
    BookID INT,
    Quantity INT,
    PRIMARY KEY (CustomerID, BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

CREATE TABLE `Admin` (
    AdminID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(255),
    Email VARCHAR(255) UNIQUE
);

CREATE TABLE PriceChangeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATE DEFAULT (CURRENT_DATE),
    AdminID INT,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (AdminID) REFERENCES Admin(AdminID)
);

CREATE TABLE StockAlertLog (
    AlertID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    StockLevel INT,
    AlertDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

CREATE TABLE Promotion (
    PromoID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(255),
    DiscountPercent DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE BookPromotion (
    BookID INT,
    PromoID INT,
    PRIMARY KEY (BookID, PromoID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (PromoID) REFERENCES Promotion(PromoID)
);
