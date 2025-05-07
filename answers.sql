-- Question 1

-- Transform ProductDetail table into 1NF
-- Each row should represent a single product for an order
CREATE TABLE ProductDetail_1NF AS
SELECT 
    OrderID, 
    CustomerName, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (
    -- Helper table to split comma-separated values (up to 4 products)
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
) numbers ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;

-- Question 2

-- Transform OrderDetails table into 2NF
-- Step 1: Create a table for orders with customer information
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Insert unique OrderID and CustomerName into Orders_2NF
INSERT INTO Orders_2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create a table for order details without CustomerName
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID)
);

-- Step 4: Insert OrderID, Product, and Quantity into OrderDetails_2NF
INSERT INTO OrderDetails_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
