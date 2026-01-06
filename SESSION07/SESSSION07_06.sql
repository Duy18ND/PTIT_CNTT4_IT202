drop database if exists Session07_06;
create database Session07_06;
use Session07_06;

create table customers (
    id int primary key,
    name varchar(255),
    email varchar(255)
);

create table orders (
    id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    constraint fk_customer foreign key (customer_id) references customers(id)
);

insert into customers values
(1, 'Nguyen Van A', 'a@test.com'),
(2, 'Tran Thi B', 'b@test.com'),
(3, 'Le Van C', 'c@test.com'),
(4, 'Pham Thi D', 'd@test.com'),
(5, 'Hoang Van E', 'e@test.com');

insert into orders values
(101, 1, '2024-01-01', 1000000), 
(102, 1, '2024-01-02', 2000000), 
(103, 2, '2024-01-03', 150000),  
(104, 3, '2024-01-04', 5000000), 
(105, 4, '2024-01-05', 500000),  
(106, 5, '2024-01-06', 1200000), 
(107, 2, '2024-01-07', 50000);   

-- Lấy danh sách khách hàng (id) có tổng tiền mua > trung bình cộng đơn hàng
select customer_id, sum(total_amount) as "Tong tien mua"
from orders
group by customer_id
having sum(total_amount) > (select avg(total_amount) from orders);