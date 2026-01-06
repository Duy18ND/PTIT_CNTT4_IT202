drop database if exists Session07_03;
create database Session07_03;
use Session07_03;

create table products (
	id int primary key,
    name varchar(255),
    price decimal(10,2)
);

create table order_items (
	order_id int primary key,
    product_id int,
    quantity int,
    constraint fk_product foreign key (product_id) references products(id)
);

insert into products values
(1, 'Laptop Gaming Asus', 25000000),
(2, 'Chuot Logitech G102', 450000),
(3, 'Ban phim Keychron', 1800000),
(4, 'Man hinh Dell Ultrasharp', 9500000),
(5, 'Tai nghe Sony WH-1000XM5', 6500000),
(6, 'Ghe Cong Thai Hoc', 3500000),
(7, 'Lot Chuot Size XXL', 150000);

insert into order_items values
(101, 1, 1),  
(102, 2, 2), 
(103, 1, 1), 
(104, 5, 1),  
(105, 3, 5),  
(106, 7, 10), 
(107, 4, 2);

-- Lấy danh sách đơn hàng có giá trị lớn hơn giá trị trung bình của tất cả đơn hàng
select 
    o.order_id, 
    o.product_id, 
    o.quantity,
    (o.quantity * (select price from products where id = o.product_id)) as total_value
from order_items o
where 
    (o.quantity * (select price from products where id = o.product_id)) 
    > 
    (select avg(price) from products);