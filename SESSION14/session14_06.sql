drop database if exists session14_06;
create database session14_06;
use session14_06;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    likes_count int default 0,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

create table likes (
    like_id int primary key auto_increment,
    user_id int not null,
    post_id int not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id),
    unique key unique_like (post_id, user_id)
);

insert into users (username) values ('nguyen van a'), ('tran thi b');
insert into posts (user_id, content) values (1, 'hello world status');

delimiter $$

drop procedure if exists proc_add_like $$

create procedure proc_add_like(
    in p_user_id int,
    in p_post_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'lỗi: đã like bài viết này rồi hoặc id không tồn tại';
    end;

    start transaction;

    insert into likes (user_id, post_id) 
    values (p_user_id, p_post_id);

    update posts 
    set likes_count = likes_count + 1 
    where post_id = p_post_id;

    commit;

end $$
delimiter ;

call proc_add_like(2, 1);

select * from posts;
select * from likes;