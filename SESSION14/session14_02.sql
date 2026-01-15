drop database if exists session14_02;
create database session14_02;
use session14_02;

create table products (
    product_id int primary key auto_increment,
    product_name varchar(50),
    price decimal(10,2),
    stock int
);

create table orders (
    order_id int primary key auto_increment,
    product_id int,
    quantity int,
    total_price decimal(10,2),
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, price, stock) values 
('laptop dell', 15000000, 10), 
('iphone 15', 20000000, 2);    

delimiter $$
drop procedure if exists proc_place_orders $$
create procedure proc_place_orders(
    in p_product_id int,      
    in p_quantity int    
)
begin
    declare v_stock int;          
    declare v_price decimal(10,2);    
    declare v_total_price decimal(10,2); 

    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'lỗi hệ thống: đã rollback';
    end;

    start transaction;

    select stock, price into v_stock, v_price 
    from products 
    where product_id = p_product_id 
    for update;

    if v_stock is null or v_stock < p_quantity then
        rollback;
        signal sqlstate '45000' set message_text = 'sản phẩm không tồn tại hoặc hết hàng';
    else
    
        set v_total_price = p_quantity * v_price;
        update products 
        set stock = stock - p_quantity 
        where product_id = p_product_id;
        insert into orders (product_id, quantity, total_price) 
        values (p_product_id, p_quantity, v_total_price);

        commit;
    end if;

end $$
delimiter ;

call proc_place_orders(1, 2);
call proc_place_orders(2, 5);

select * from products;
select * from orders;