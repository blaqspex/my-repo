USE Online_Bookstore_Database;

-- Retrieve Books in "Fiction" Category That Are In Stock -- showing results
SELECT b.Title, b.ISBN, b.Price, b.Stock
FROM Book b
JOIN Category c ON b.CategoryID = c.CategoryID
WHERE c.Name = 'Fiction' AND b.Stock > 0;

-- List Customers Who Bought At Least 5 Books in Last 3 Months -- not showing results
SELECT cu.Name, cu.Email, COUNT(oi.BookID) AS TotalBooksBought
FROM Customer cu
JOIN Orders o ON cu.CustomerID = o.CustomerID
JOIN OrderItem oi ON o.OrderID = oi.OrderID
WHERE o.OrderDate >= CURDATE() - INTERVAL 3 MONTH
GROUP BY cu.CustomerID
HAVING TotalBooksBought >= 5;

-- Top 5 Best-Selling Books of the Year -- showing results
SELECT b.Title, SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM OrderItem oi
JOIN Book b ON oi.BookID = b.BookID
WHERE YEAR(oi.OrderDate) = YEAR(CURDATE())
GROUP BY b.BookID
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Books with No Purchases -- not showing results
SELECT b.Title, b.ISBN, b.Stock
FROM Book b
LEFT JOIN OrderItem oi ON b.BookID = oi.BookID
WHERE oi.BookID IS NULL;

-- Total Revenue per Book Category -- showing results
SELECT c.Name AS CategoryName, SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM OrderItem oi
JOIN Book b ON oi.BookID = b.BookID
JOIN Category c ON b.CategoryID = c.CategoryID
GROUP BY c.Name;

-- Customers with 5+ purchases in the last 3 months -- not showing results
SELECT c.CustomerID, c.name, COUNT(o.OrderID) AS total_orders
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= CURDATE() - INTERVAL 3 MONTH
GROUP BY c.CustomerID, c.name
HAVING COUNT(o.OrderID) >= 5;

-- Average rating of books with at least 10 reviews -- not showing results
SELECT b.BookID, b.Title, ROUND(AVG(r.Rating), 2) AS AverageRating, COUNT(r.ReviewID) AS TotalReviews
FROM Book b
JOIN Review r ON b.BookID = r.BookID
GROUP BY b.BookID, b.Title
HAVING COUNT(r.ReviewID) >= 10;

-- Pending orders with customer contact -- showing results
SELECT o.OrderID, o.OrderDate, c.name, c.Email, c.Phone
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE o.Status = 'Pending';

-- Orders that include at least one book from the 'Science & Technology' category -- showing results
SELECT DISTINCT o.OrderID, o.OrderDate, c.name AS CustomerName
FROM Orders o
JOIN OrderItem oi ON o.OrderID = oi.OrderID
JOIN Book b ON oi.BookID = b.BookID
JOIN Category cat ON b.CategoryID = cat.CategoryID
JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE cat.name = 'Science & Technology';