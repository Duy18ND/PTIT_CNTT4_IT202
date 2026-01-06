drop database if exists Session07_01;
create database Session07_01;
use Session07_01;

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
(1, 'Nguyen Van A', 'nguyenvana@example.com'),
(2, 'Tran Thi B', 'tranthib@example.com'),
(3, 'Le Van C', 'levanc@example.com'),
(4, 'Pham Thi D', 'phamthid@example.com'),
(5, 'Hoang Van E', 'hoangvane@example.com'),
(6, 'Doan Manh Duy', 'duymanh@example.com'),
(7, 'Vu Thi F', 'vuthif@example.com'),
(8, 'Dang Van G', 'dangvang@example.com'),
(9, 'Bui Thi H', 'buithih@example.com'),
(10, 'Ngo Van I', 'ngovani@example.com');

insert into orders values
(101, 1, '2024-01-01', 500000),  
(102, 2, '2024-01-02', 1200000), 
(103, 1, '2024-01-03', 250000),   
(104, 3, '2024-01-05', 3000000),
(105, 4, '2024-01-07', 150000),   
(106, 5, '2024-01-10', 5000000),  
(107, 6, '2024-01-12', 450000),  
(108, 2, '2024-01-15', 800000), 
(109, 8, '2024-01-20', 2000000),  
(110, 10, '2024-01-25', 100000);

-- Lấy danh sách khách hàng đã từng đặt đơn hàng
select c.*, (select count(*) from orders o where o) as "Số đơn đặt" from customers c where id in (select c.customer_id from orders o);