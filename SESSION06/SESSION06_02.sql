DROP DATABASE IF EXISTS Session06_02;
CREATE DATABASE Session06_02;
USE Session06_02;

CREATE TABLE customers(
    customer_id int primary key,
    full_name varchar(255),
    city varchar(255)
);

CREATE TABLE orders(
    order_id int primary key, 
    customer_id int,
    order_date date,
    status ENUM('pending', 'completed', 'cancelled'),
    total_amount DECIMAL(10,2)
);

INSERT INTO customers VALUES
(1, 'Doan Manh Duy', 'Nam Dinh'), 
(2, 'Do Van A', 'Ha Noi'),
(3, 'Nguyen Thi Bich', 'Da Nang'),
(4, 'Tran Van Cuong', 'Ho Chi Minh'),
(5, 'Le Thi Duyen', 'Can Tho');

INSERT INTO orders VALUES
(101, 1, '2024-03-01', 'completed', '1000000'),
(102, 2, '2024-03-02', 'pending', '210000'),   
(103, 1, '2024-03-05', 'cancelled', '360000'), 
(104, 3, '2024-03-10', 'completed', '12000000'), 
(105, 5, '2024-03-12', 'pending', '3400000'); 

-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
select c.customer_id, c.full_name, sum(o.total_amount) as "Tổng số tiền"
from orders o
join customers c on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

-- Hiển thị giá trị đơn hàng cao nhất của từng khách
select c.customer_id, c.full_name, max(o.total_amount) as "Đơn hàng cao nhất"
from orders o
join customers c on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
select c.customer_id, c.full_name, o.total_amount as "Tổng tiền giảm dần"
from orders o
join customers c on c.customer_id = o.customer_id
order by o.total_amount desc;
