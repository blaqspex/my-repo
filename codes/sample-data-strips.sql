-- Categories
INSERT INTO Category (Name) 
VALUES 
('Fiction'),
('Science & Technology'),
('History'),
('Self-Help'),
('Biographies');

-- Authors
INSERT INTO Author (Name, Bio)
VALUES
('Matt Haig', 'Matt Haig is an English author of fiction, non-fiction, and children\'s books.'),
('Yuval Noah Harari', 'Yuval Noah Harari is an Israeli historian and professor.'),
('Stephen Hawking', 'Stephen Hawking was an English theoretical physicist and cosmologist.'),
('Malala Yousafzai', 'Malala Yousafzai is a Pakistani activist for female education.'),
('Dale Carnegie', 'Dale Carnegie was an American writer and lecturer.');

-- Books
INSERT INTO Book (Title, ISBN, Price, Stock, CategoryID)
VALUES
('The Midnight Library', '9781786892737', 499.99, 50, 1),  -- Fiction
('Sapiens: A Brief History of Humankind', '9780062316110', 899.99, 30, 2),  -- Science & Technology
('Homo Deus: A Brief History of Tomorrow', '9780062464316', 799.99, 25, 2),  -- Science & Technology
('Educated: A Memoir', '9780399590504', 599.99, 20, 5),  -- Biographies
('How to Win Friends and Influence People', '9780671027032', 349.99, 15, 4);  -- Self-Help

-- Customers
INSERT INTO Customer (Name, Email, Phone, Address)
VALUES
('John Doe', 'john.doe@example.com', '8976543210', '123 Main St, Springfield'),
('Jane Smith', 'jane.smith@example.com', '7123456789', '456 Oak St, Rivertown'),
('Sarah Lee', 'sarah.lee@example.com', '9345678901', '789 Pine St, Laketown'),
('David Brown', 'david.brown@example.com', '6786543210', '101 Maple St, Greenfield'),
('David Green', 'davidg@example.com', '9437853691', '135 Willow St, Springfield'),
('Sophia Lee', 'sophial@example.com', '8423651470', '246 Redwood St, Springfield'),
('Michael Harris', 'michaelh@example.com', '7816552580', '579 Ash St, Springfield'),
('Pro Debsarma', 'prodebsarma@gmail.com', '9163007716', '406 Sarat Bose Rd, Subhash Nagar'),
('Olivia Martinez', 'oliviam@example.com', '8756553698', '864 Birchwood Ave, Springfield'),
('Emily Clark', 'emily.clark@example.com', '6109876543', '202 Cedar St, Oakwood');

-- Orders
INSERT INTO Orders (CustomerID, OrderDate, Status, EstimatedDelivery)
VALUES
(1, CURDATE() - INTERVAL 10 DAY, 'Shipped', CURDATE() + INTERVAL 50 DAY),
(2, CURDATE() - INTERVAL 20 DAY, 'Pending', CURDATE() + INTERVAL 40 DAY),
(3, CURDATE() - INTERVAL 30 DAY, 'Shipped', CURDATE() + INTERVAL 30 DAY),
(4, CURDATE() - INTERVAL 40 DAY, 'Pending', CURDATE() + INTERVAL 20 DAY),
(5, CURDATE() - INTERVAL 50 DAY, 'Shipped', CURDATE() + INTERVAL 10 DAY);

-- Order Items
INSERT INTO OrderItem (OrderID, BookID, Quantity, UnitPrice)
VALUES
(1, 1, 2, 499.99),  -- The Midnight Library
(2, 2, 1, 899.99),  -- Sapiens: A Brief History of Humankind
(3, 3, 3, 799.99),  -- Homo Deus: A Brief History of Tomorrow
(4, 4, 1, 599.99),  -- Educated: A Memoir
(5, 5, 5, 349.99);  -- How to Win Friends and Influence People

-- Reviews
INSERT INTO Review (BookID, CustomerID, Rating, Comment)
VALUES
(1, 1, 5, 'Amazing story, couldn’t stop reading.'),
(2, 2, 4, 'Solid writing and good characters.'),
(3, 3, 3, 'Interesting, but a bit slow.'),
(1, 2, 4, 'Enjoyable and well-paced.'),
(4, 5, 2, 'Not really my type.'),
(1, 3, 5, 'Loved it start to finish!'),
(5, 7, 3, 'Good one-time read.'),
(2, 8, 5, 'Fantastic! Would recommend.'),
(1, 4, 4, 'Great character development.'),
(4, 10, 3, 'Decent, but predictable.'),
(3, 1, 4, 'Unique plot, pretty cool.'),
(1, 5, 5, 'One of my favorites.'),
(2, 3, 3, 'Mediocre pacing.'),
(1, 6, 4, 'Impressive worldbuilding.'),
(1, 7, 2, 'Didn’t meet my expectations.'),
(1, 9, 5, 'Super fun read!'),
(2, 7, 4, 'I liked the ending a lot.'),
(4, 8, 4, 'Surprisingly good.'),
(1, 10, 5, 'Top-tier writing.'),
(2, 10, 3, 'It was okay, not bad.'),
(1, 8, 4, 'Quite up to the mark.');

-- Author-Book Relationship
INSERT INTO BookAuthor (BookID, AuthorID) 
VALUES 
(1, 1),  -- The Midnight Library by Matt Haig
(2, 2),  -- Sapiens by Yuval Noah Harari
(3, 2),  -- Homo Deus by Yuval Noah Harari
(4, 4),  -- Educated by Malala Yousafzai
(5, 5);  -- How to Win Friends by Dale Carnegie

-- Payment
INSERT INTO Payment (OrderID, CustomerID, PaymentMethod, Amount, PaymentDate, `Status`) VALUES
(1, 1, 'UPI', 999.98, CURDATE() - INTERVAL 50 DAY, 'Completed'),
(2, 2, 'Credit Card', 899.00, CURDATE() - INTERVAL 40 DAY, 'Completed'),
(3, 3, 'CoD',  2399.97, CURDATE() - INTERVAL 30 DAY, 'Pending'),  -- won't count coz 'll be paid on delivery
(4, 4, 'UPI', 599.99, CURDATE() - INTERVAL 20 DAY, 'Completed'),
(5, 5, 'Credit Card', 1749.95, CURDATE() - INTERVAL 10 DAY, 'Completed');

INSERT INTO Payment (OrderID, CustomerID, PaymentMethod, Amount, PaymentDate, `Status`) VALUES
(6, 2, 'UPI', 499.00, CURDATE() - INTERVAL 20 DAY, 'Completed'),
(7, 5, 'CoD', '349.99', CURDATE() - INTERVAL 25 DAY, 'Pending');








-- For testing triggers
INSERT INTO Orders (CustomerID, OrderDate, Status, EstimatedDelivery)
VALUES (1, CURDATE() - INTERVAL 10 DAY, 'Pending', CURDATE() + INTERVAL 30 DAY);

INSERT INTO OrderItem (OrderID, BookID, Quantity, UnitPrice)
VALUES (6, 1, 2, 499.99);
-- will automatically update

INSERT INTO Orders (CustomerID, OrderDate, Status, EstimatedDelivery)
VALUES (2, CURDATE() - INTERVAL 10 DAY, 'Pending', CURDATE() + INTERVAL 20 DAY);

INSERT INTO OrderItem (OrderID, BookID, Quantity, UnitPrice)
VALUES (7, 5, 12, 349.99); -- will not throw error coz order qty not exceeding existing stock amt
-- but now the stock amt reduced to 3 automatically thanks to previous trigger. so,...
INSERT INTO OrderItem (OrderID, BookID, Quantity, UnitPrice)
VALUES (8, 5, 20, 349.99); -- will throw error coz order qty exceeding existing stock amt

select * from orderitem;

INSERT INTO OrderItem (OrderID, BookID, Quantity, UnitPrice)
VALUES (5, 4, 20, 349.99); -- will throw error coz order qty exceeding existing stock amt
