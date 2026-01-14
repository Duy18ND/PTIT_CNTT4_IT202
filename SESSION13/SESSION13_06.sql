use session13_03;

drop table if exists friendships;
create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

drop trigger if exists trg_after_insert_friendship;
delimiter //
create trigger trg_after_insert_friendship
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end //
delimiter ;

drop trigger if exists trg_after_delete_friendship;
delimiter //
create trigger trg_after_delete_friendship
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end //
delimiter ;

drop procedure if exists follow_user;
delimiter //
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    -- kiểm tra tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'không được tự follow chính mình';
    end if;

    -- kiểm tra trùng lặp
    if exists (
        select 1 from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'đã tồn tại quan hệ follow';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end //
delimiter ;

create or replace view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(us.total_likes, 0) as total_likes,
    group_concat(p.content order by p.created_at desc separator ' | ') as recent_posts
from users u
left join user_statistics us on u.user_id = us.user_id
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count, us.total_likes;

-- bước 1: follow hợp lệ
call follow_user(2, 1, 'accepted'); -- bob follow alice
call follow_user(3, 1, 'accepted'); -- charlie follow alice

-- kiểm tra sau khi thêm
select user_id, username, follower_count from users;
select * from user_profile;

-- bước 2: unfollow (xóa bob follow alice)
delete from friendships
where follower_id = 2 and followee_id = 1;

-- kiểm tra sau khi xóa (follower của alice phải giảm)
select user_id, username, follower_count from users;

-- bước 3: test các case đặc biệt

-- a) tự follow (đã comment lại để không dừng script)
-- call follow_user(1, 1, 'accepted'); 

-- b) re-follow (bob follow lại alice) -> lệnh này phải chạy được vì ở bước 2 đã xóa rồi
call follow_user(2, 1, 'accepted');

-- kiểm tra cuối cùng (alice phải tăng follower lại)
select * from user_profile;