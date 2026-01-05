drop database if exists session06_06;
create database session06_06;
use session06_06;

create table products (
    product_id int primary key,
    product_name varchar(255),
    price decimal(15, 2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int,
    primary key (order_id, product_id),
    constraint fk_product_final 
        foreign key (product_id) 
        references products(product_id)
);

insert into products values
(1, 'Laptop Gaming', 25000000),
(2, 'Iphone 15 Pro', 30000000),
(3, 'Chuot Fuhlen', 200000),   
(4, 'Ban phim Co', 1500000),    
(5, 'Man hinh 4K', 10000000), 
(6, 'Tai nghe Sony', 3000000),   
(7, 'Lot chuot', 50000);

insert into order_items values
(101, 1, 12), 
(102, 2, 5),  
(103, 3, 100),
(104, 4, 20), 
(105, 5, 10),
(106, 6, 15), 
(107, 7, 50);

select  
	p.product_name as "Tên sản phẩm", 
    sum(o.quantity) as "Tổng số lượng bán", 
    sum(o.quantity * p.price) as "Tổng doanh thu",
    sum(o.quantity * p.price) / sum(o.quantity) as "Giá bán trung bình"
from products p
join order_items o on p.product_id = o.product_id
group by p.product_id, p.product_name
having sum(o.quantity) >= 10 
order by sum(o.quantity * p.price) desc 
limit 5;