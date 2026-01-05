drop database if exists session06_05;
create database session06_05;
use session06_05;

create table customers (
    customer_id int primary key,
    full_name varchar(255),
    phone varchar(20)
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(15, 2),
    
    constraint fk_customer 
        foreign key (customer_id) 
        references customers(customer_id)
);

insert into customers values
(1, 'Nguyen Van VIP', '0901234567'),
(2, 'Tran Van Giau',  '0909999999'),
(3, 'Le Thi Binh',    '0908888888'), 
(4, 'Pham Gia Bao',   '0907777777'); 

insert into orders values
(101, 1, '2024-03-01', 5000000),
(102, 1, '2024-03-05', 4000000),
(103, 1, '2024-03-10', 2000000),
(104, 2, '2024-03-12', 50000000), 
(105, 3, '2024-03-01', 500000),
(106, 3, '2024-03-02', 500000),
(107, 3, '2024-03-03', 500000),
(108, 3, '2024-03-04', 500000),
(109, 4, '2024-03-15', 80000000),
(110, 4, '2024-03-16', 50000000),
(111, 4, '2024-03-17', 50000000);

select 
    c.customer_id, 
    c.full_name, 
    count(o.order_id) as "Tong_so_don", 
    sum(o.total_amount) as "Tong_tien_da_chi", 
    round(avg(o.total_amount), 2) as "Trung_binh_don"
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
having count(o.order_id) >= 3 and sum(o.total_amount) > 10000000 
order by sum(o.total_amount) desc;