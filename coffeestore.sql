create database coffeestore ;
USE coffeestore;
CREATE TABLE products (
id INT auto_increment primary KEY,
name VARCHAR(40),
price DECIMAL(4,2)
);

CREATE TABLE customers
(
	id INT auto_increment PRIMARY KEY,
	first_name VARCHAR(40),
	last_name VARCHAR(40),
	gender ENUM('M','F'),
	phone_number VARCHAR(12)
);

CREATE TABLE orders (
	id INT auto_increment PRIMARY KEY,
    product_id INT,
    customer_id INT,
    order_time DATETIME,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

ALTER TABLE products ADD COLUMN coffeeorigin VARCHAR(255);
select * from products;

-- Drop the customers table
DROP TABLE orders;

-- Insert Values in customers table
INSERT INTO customers (first_name, last_name, gender, phone_number) VALUES
('John', 'Doe', 'M', '1234567890'),
('Jane', 'Smith', 'F', '0987654321'),
('Alice', 'Brown', 'F', '1122334455'),
('Bob', 'Johnson', 'M', '5566778899');

select * from customers;

-- Remove all records from the products table
TRUNCATE TABLE customers;
