drop database if exists Session07_04;
create database Session07_04;
use Session07_04;
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
    
    constraint fk_customers foreign key (customer_id) references customers(id)
);

 insert into customers values
(1, 'Nguyen Van A', 'ana@test.com'),
(2, 'Tran Thi B', 'btran@test.com'),
(3, 'Le Van C', 'cle@test.com'),
(4, 'Pham Thi D', 'dpham@test.com'),
(5, 'Hoang Van E', 'ehoang@test.com'),
(6, 'Doan Manh Duy', 'duy@test.com'),
(7, 'Vu Thi F', 'fvu@test.com');

insert into orders values
(101, 1, '2024-01-01', 500000), 
(102, 2, '2024-01-02', 1200000),  
(103, 1, '2024-01-05', 250000),  
(104, 6, '2024-01-10', 5000000),  
(105, 3, '2024-01-12', 150000),   
(106, 7, '2024-01-15', 3000000),
(107, 2, '2024-01-20', 800000);

-- Hiển thị tên khách hàng
select c.id, c.name
from customers c;
-- Hiển thị số lượng đơn hàng của từng khách
select c.id, c.name, (select count(*) from orders o where o.customer_id = c.id) as "so_luong_don"
from customers c;