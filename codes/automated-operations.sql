-- for automatic occurence
SET GLOBAL EventScheduler = ON;

CREATE TABLE IF NOT EXISTS LowStockReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    Title VARCHAR(255),
    StockLevel INT,
    ReportTime DATETIME
);

CREATE EVENT IF NOT EXISTS DailyLowStockReport
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
  INSERT INTO LowStockReport (BookID, Title, StockLevel, ReportTime)
  SELECT BookID, Title, Stock, NOW()
  FROM Book
  WHERE Stock < 5;

CREATE TABLE IF NOT EXISTS MonthlySummaryReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    `Month` VARCHAR(7),
    TotalRevenue DECIMAL(10,2),
    GeneratedAt DATETIME
);

CREATE EVENT IF NOT EXISTS MonthlySalesSummary -- can be send to email
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-05-01 00:00:00' -- will start on 1st May 2025
DO
  INSERT INTO MonthlySummaryReport (`Month`, TotalRevenue, GeneratedAt)
  SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m'),
         SUM(Amount), NOW()
  FROM Payment
  WHERE `Status` = 'Completed'
    AND PaymentDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

CREATE TABLE IF NOT EXISTS PendingOrderAlert (
    AlertID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    CustomerID INT,
    OrderDate DATETIME,
    AlertTime DATETIME
);

CREATE EVENT IF NOT EXISTS CheckStalePendingOrders
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP + INTERVAL 1 DAY
DO
  INSERT INTO PendingOrderAlert (OrderID, CustomerID, OrderDate, AlertTime)
  SELECT OrderID, CustomerID, OrderDate, NOW()
  FROM Orders
  WHERE `Status` = 'Pending'
    AND OrderDate < NOW() - INTERVAL 48 HOUR;

-- Testing automata opr8rs for non-scheduled insert for manual run

INSERT INTO LowStockReport (BookID, Title, StockLevel, ReportTime)
SELECT BookID, Title, Stock, NOW()
FROM Book
WHERE Stock < 20;

SELECT * FROM LowStockReport;

INSERT INTO MonthlySummaryReport (`Month`, TotalRevenue, GeneratedAt)
SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m'),
       SUM(Amount), NOW()
FROM Payment
WHERE `Status` = 'Completed'
  AND PaymentDate >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

SELECT * FROM MonthlySummaryReport;

INSERT INTO PendingOrderAlert (OrderID, CustomerID, OrderDate, AlertTime)
SELECT OrderID, CustomerID, OrderDate, NOW()
FROM Orders
WHERE `Status` = 'Pending'
  AND OrderDate < NOW() - INTERVAL 48 HOUR;

SELECT * FROM PendingOrderAlert;

