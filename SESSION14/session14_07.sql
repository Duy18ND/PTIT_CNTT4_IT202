drop database if exists session14_07;
create database session14_07;
use session14_07;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    following_count int default 0,
    followers_count int default 0
);

create table followers (
    follower_id int not null,
    followed_id int not null,
    created_at datetime default current_timestamp,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

insert into users (username) values ('nguyen van a'), ('tran thi b'), ('le van c');

delimiter $$

drop procedure if exists sp_follow_user $$

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare v_check_exist int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'lỗi: không thể follow (người dùng không tồn tại hoặc đã follow rồi)';
    end;

    start transaction;

    if p_follower_id = p_followed_id then
        signal sqlstate '45000' set message_text = 'lỗi: không thể tự follow chính mình';
    end if;

    select count(*) into v_check_exist 
    from users 
    where user_id in (p_follower_id, p_followed_id);

    if v_check_exist < 2 then
        signal sqlstate '45000' set message_text = 'lỗi: người dùng không tồn tại';
    end if;

    if exists (select 1 from followers where follower_id = p_follower_id and followed_id = p_followed_id) then
        signal sqlstate '45000' set message_text = 'lỗi: bạn đã follow người này rồi';
    end if;

    insert into followers (follower_id, followed_id) 
    values (p_follower_id, p_followed_id);

    update users 
    set following_count = following_count + 1 
    where user_id = p_follower_id;

    update users 
    set followers_count = followers_count + 1 
    where user_id = p_followed_id;

    commit;

end $$
delimiter ;

call sp_follow_user(1, 2);

call sp_follow_user(1, 1);

call sp_follow_user(1, 2);

call sp_follow_user(1, 99);

select * from users;
select * from followers;