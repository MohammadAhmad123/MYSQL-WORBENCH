-- Create a new database named eCommerceDB
CREATE DATABASE eCommerceDB;

-- Use the eCommerceDB database for all subsequent operations
USE eCommerceDB;


-- Create the Products table to store product information
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,   -- Primary Key: unique identifier for each product
    name VARCHAR(255) NOT NULL,                  -- Product name (required)
    description TEXT,                            -- Description of the product (optional)
    price DECIMAL(10, 2) NOT NULL,               -- Price of the product with two decimal points (required)
    stock_quantity INT NOT NULL                  -- Quantity of product available in stock (required)
);


-- Create the Customers table to store customer information
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,  -- Primary Key: unique identifier for each customer
    first_name VARCHAR(255) NOT NULL,            -- First name of the customer (required)
    last_name VARCHAR(255) NOT NULL,             -- Last name of the customer (required)
    email VARCHAR(255) NOT NULL UNIQUE,          -- Email address (unique and required)
    phone_number VARCHAR(15),                    -- Phone number of the customer (optional)
    address TEXT                                 -- Address of the customer (optional)
);

-- Create the Orders table to track customer orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,    -- Primary Key: unique identifier for each order
    customer_id INT,                            -- Foreign Key linking to the Customers table (who placed the order)
    order_date DATE NOT NULL,                   -- Date the order was placed (required)
    status VARCHAR(50) NOT NULL,                -- Status of the order (e.g., 'Pending', 'Shipped', 'Completed')
    
    -- Foreign Key constraint to ensure each order is linked to a valid customer
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
    ON DELETE SET NULL                          -- Set to NULL if the referenced customer is deleted
);


-- Create the OrderItems table to store details of products within each order
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT, -- Primary Key: unique identifier for each order item
    order_id INT,                                 -- Foreign Key linking to Orders table (which order this item belongs to)
    product_id INT,                               -- Foreign Key linking to Products table (which product is ordered)
    quantity INT NOT NULL,                        -- Quantity of the product in this order item (required)
    price DECIMAL(10, 2) NOT NULL,                -- Price of the product at the time of order (required)
    
    -- Foreign Key constraints to ensure each order item links to valid order and product records
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
    ON DELETE CASCADE,                            -- Deletes OrderItems if the related Order is deleted
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


-- Insert sample data into Products table
-- Adding initial products with details like name, description, price, and stock quantity
INSERT INTO Products (name, description, price, stock_quantity) VALUES
('Laptop', 'ROG Strix G17 G713', 1500.00, 50), -- Product: Laptop, priced at $1500, with 50 units in stock
('Smartphone', 'Pixel 9 Pro', 900.00, 150), -- Product: Smartphone, priced at $900, with 150 units in stock
('Headphones', 'Sennheiser HD 490 PRO', 350.00, 200); -- Product: Headphones, priced at $350, with 200 units in stock


-- Insert sample data into Customers table
-- Adding customers with personal details like name, email, phone, and address
INSERT INTO Customers (first_name, last_name, email, phone_number, address) VALUES
('Rock', 'Johnson', 'rocky.j@example.com', '123-456-7890', '123 Maple St'),  -- Customer: Rock Johnson with contact and address information
('Alamin', 'Ahmad', 'alamin.ah@example.com', '987-654-3210', '456 Oak Ave');  -- Customer: Alamin Ahmad with contact and address information



-- Insert sample data into Orders table
-- Adding orders with references to customer IDs, order dates, and order status
INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-11-01', 'Completed'), -- Order by Customer ID 1 (Rock Johnson) on November 1, 2024, marked as 'Completed'
(2, '2024-11-02', 'Pending'); -- Order by Customer ID 2 (Alamin Ahmad) on November 2, 2024, marked as 'Pending'

-- Insert sample data into OrderItems table
-- Adding items for each order, including references to order IDs, product IDs, quantity, and price at the time of order
INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1500.00),        -- Order #1 contains 1 laptop at $1500.00
(1, 3, 2, 350.00),         -- Order #1 contains 2 headphones at $350.00 each
(2, 2, 1, 900.00);         -- Order #2 contains 1 smartphone at $900.00


-- Selects all records from the Products table to display each product's details
SELECT * FROM Products;

-- Selects all records from the Customers table to display each customer's information
SELECT * FROM Customers;

-- Selects all records from the Orders table to display each customer's information
SELECT * FROM Orders;


-- Selects all records from the OrderItems table to display each customer's information
SELECT * FROM OrderItems;



-- Retrieves order details along with customer information by joining Orders and Customers tables
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.status
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;  -- Join on customer_id to link orders with customers


-- Updates stock quantity of a specific product by reducing it by the ordered quantity
UPDATE Products
SET stock_quantity = stock_quantity - 5   -- Decrement stock by the ordered quantity
WHERE product_id = 2;                                      -- Specify the product to update


-- Calculates total sales for each product by summing the revenue from each order item
SELECT p.name, SUM(oi.quantity * oi.price) AS total_sales
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id          -- Join with Products to get product names
GROUP BY p.name                                          -- Group by product name to calculate sales per product
ORDER BY total_sales DESC;                               -- Order results by total sales in descending order


-- Counts the total number of orders for each customer by joining Orders and Customers tables
SELECT c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id            -- Join to associate orders with the corresponding customer
GROUP BY c.customer_id                                    -- Group by customer to count total orders per customer
ORDER BY total_orders DESC;                               -- Order by total orders in descending order to show top customers



