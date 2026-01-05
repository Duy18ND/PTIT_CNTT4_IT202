DROP DATABASE IF EXISTS Session06_01;
CREATE DATABASE Session06_01;
USE Session06_01;

CREATE TABLE customers(
    customer_id int primary key,
    full_name varchar(255),
    city varchar(255)
);

CREATE TABLE orders(
    order_id int primary key, 
    customer_id int,
    order_date date,
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO customers VALUES
(1, 'Doan Manh Duy', 'Nam Dinh'), 
(2, 'Do Van A', 'Ha Noi'),
(3, 'Nguyen Thi Bich', 'Da Nang'),
(4, 'Tran Van Cuong', 'Ho Chi Minh'),
(5, 'Le Thi Duyen', 'Can Tho');

INSERT INTO orders VALUES
(101, 1, '2024-03-01', 'completed'),
(102, 2, '2024-03-02', 'pending'),   
(103, 1, '2024-03-05', 'cancelled'), 
(104, 3, '2024-03-10', 'completed'), 
(105, 5, '2024-03-12', 'pending'); 

-- Hiển thị danh sách đơn hàng kèm tên khách hàng
SELECT o.order_id, o.order_date, o.status, c.full_name as "Tên khách hàng" 
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
order by o.customer_id; 

-- Hiển thị mỗi khách hàng đã đặt bao nhiêu đơn hàng
select c.customer_id, c.full_name, count(o.order_id) as 'Tổng đơn hàng'
from orders o
left join customers c on c.customer_id = o.customer_id
GROUP BY c.customer_id, o.customer_id;

-- Chỉ hiển thị các khách hàng có ít nhất 1 đơn hàng
select c.customer_id, c.full_name, count(o.order_id) as 'Tổng đơn hàng'
from orders o
join customers c on c.customer_id = o.customer_id
GROUP BY c.customer_id, o.customer_id;
