DELIMITER $$

-- Trigger to update book stock after an order is placed
CREATE TRIGGER UpdateStockAfterOrder
AFTER INSERT ON OrderItem
FOR EACH ROW
BEGIN
    -- Update the stock in the Book table based on the newly inserted OrderItem
    UPDATE Book
    SET Stock = Stock - NEW.Quantity
    WHERE BookID = NEW.BookID;
END$$

DELIMITER ;

DELIMITER $$

-- Trigger to prevent order insertion if stock is insufficient
CREATE TRIGGER PreventNegativeStock
BEFORE INSERT ON OrderItem
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    -- Get the available stock for the book being ordered
    SELECT Stock INTO available_stock
    FROM Book
    WHERE BookID = NEW.BookID;

    -- If the available stock is less than the quantity ordered, raise an error
    IF available_stock < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this book';
    END IF;
END$$

DELIMITER ;
