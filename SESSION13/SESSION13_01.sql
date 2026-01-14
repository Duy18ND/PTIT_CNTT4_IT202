DROP DATABASE IF EXISTS SESSION13_01;
CREATE DATABASE SESSION13_01;
USE SESSION13_01;

create table users (
	user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
	post_id int primary key auto_increment,
    user_id int, 
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- 2) Thêm dữ liệu mẫu dưới đây
INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03'); 
-- 3) Tạo 2 trigger:
-- Trigger AFTER INSERT trên posts: Khi thêm bài đăng mới, tăng post_count của người dùng tương ứng lên 1.
delimiter $$
create trigger tg_update_post 
after insert on posts
for each row 
begin 
	update users set post_count = post_count + 1
    where user_id = new.user_id;
end $$
delimiter ; 

-- Trigger AFTER DELETE trên posts: Khi xóa bài đăng, giảm post_count của người dùng tương ứng đi 1.
delimiter $$
 create trigger tg_delete_post
 after delete on posts
 for each row
 begin 
	update users set post_count = post_count - 1
    WHERE user_id = old.user_id;
 end $$
 delimiter ;

-- 4) Thực hiện insert các bài đăng sau và hiển thị bảng users để kiểm chứng:
INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');
SELECT * FROM users;

-- 5) Xóa một bài đăng bất kỳ (ví dụ post_id = 2) rồi hiển thị lại bảng users để kiểm tra.
delete from users where user_id = 1;
select * from users;