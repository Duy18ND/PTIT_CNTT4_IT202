drop database if exists session14_08;
create database session14_08;
use session14_08;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    comments_count int default 0,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

create table comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

insert into users (username) values ('nguyen van a');
insert into posts (user_id, content) values (1, 'bai viet so 1');

delimiter $$

drop procedure if exists sp_post_comment $$

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare exit handler for sqlexception
    begin
        rollback to savepoint after_insert;
        commit;
    end;

    start transaction;

    insert into comments (post_id, user_id, content) 
    values (p_post_id, p_user_id, p_content);

    savepoint after_insert;

    if p_content = 'loi' then
        signal sqlstate '45000' set message_text = 'gia lap loi update';
    else
        update posts 
        set comments_count = comments_count + 1 
        where post_id = p_post_id;
    end if;

    commit;

end $$
delimiter ;

call sp_post_comment(1, 1, 'binh luan nay se thanh cong');

call sp_post_comment(1, 1, 'loi');

select * from comments;
select * from posts;