CREATE VIEW TotalRevenueByCategory AS
SELECT 
    c.Name AS CategoryName,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM 
    OrderItem oi
JOIN 
    Book b ON oi.BookID = b.BookID
JOIN 
    Category c ON b.CategoryID = c.CategoryID
GROUP BY 
    c.Name;

CREATE VIEW CustomerOrderSummary AS
SELECT 
    cu.Name AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpent
FROM 
    Customer cu
JOIN 
    Orders o ON cu.CustomerID = o.CustomerID
JOIN 
    OrderItem oi ON o.OrderID = oi.OrderID
GROUP BY 
    cu.Name;

CREATE VIEW LowStockBooks AS
SELECT 
    b.Title AS BookTitle,
    b.Stock AS StockLevel,
    c.Name AS CategoryName
FROM 
    Book b
JOIN 
    Category c ON b.CategoryID = c.CategoryID
WHERE 
    b.Stock < 5;

-- For viewing the views
SELECT * FROM view_name;
