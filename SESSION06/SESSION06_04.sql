DROP DATABASE IF EXISTS Session06_04;
CREATE DATABASE Session06_04;
USE Session06_04;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    
    CONSTRAINT fk_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

INSERT INTO products VALUES
(1, 'Laptop Dell', 15000000), 
(2, 'Iphone 15', 20000000),    
(3, 'Chuột Logi', 500000),      
(4, 'Ban phim Co', 1000000),   
(5, 'Tai nghe Sony', 2000000);  

INSERT INTO order_items VALUES
(101, 1, 1),  
(102, 3, 10), 
(103, 4, 2),
(104, 2, 2), 
(105, 3, 5); 

SELECT p.product_id, p.product_name, SUM(o.quantity) AS "Tổng số lượng bán"
FROM products p
JOIN order_items o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_id, p.product_name, SUM(o.quantity * p.price) AS "Tổng doanh thu" 
FROM products p
JOIN order_items o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

SELECT p.product_id, p.product_name, SUM(o.quantity * p.price) AS "Tổng doanh thu"
FROM products p
JOIN order_items o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(o.quantity * p.price) > 5000000;