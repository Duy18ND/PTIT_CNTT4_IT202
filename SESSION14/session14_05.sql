drop database if exists session14_05;
create database session14_05;
use session14_05;

-- 1. tạo bảng users (người dùng)
create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0 -- số lượng bài viết (mặc định là 0)
);

-- 2. tạo bảng posts (bài viết)
create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

-- 3. thêm 1 user mẫu để test
insert into users (username) values ('nguyen van a');
-- user này sẽ có id = 1, posts_count = 0

delimiter $$

drop procedure if exists add_new_post $$

create procedure add_new_post(
    in p_user_id int,   
    in p_content text
)
begin
    declare exit handler for sqlexception
    begin
        rollback; -- hủy toàn bộ thao tác
        signal sqlstate '45000' set message_text = 'lỗi: không thể đăng bài (user không tồn tại hoặc lỗi hệ thống)';
    end;

    start transaction;
    
    insert into posts (user_id, content) 
    values (p_user_id, p_content);

    update users 
    set posts_count = posts_count + 1 
    where user_id = p_user_id;
    
    commit;

end $$
delimiter ;