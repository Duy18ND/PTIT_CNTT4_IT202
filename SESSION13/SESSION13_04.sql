use session13_03;

drop table if exists post_history;
create table post_history (
    history_id int primary key auto_increment,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) 
        on delete cascade
);

drop trigger if exists trg_before_update_post;
drop trigger if exists trg_after_delete_post_history;

delimiter //

create trigger trg_before_update_post
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        )
        values (
            old.post_id,
            old.content,
            new.content,
            now(),
            old.user_id   
        );
    end if;
end //
delimiter ;

delimiter //

create trigger trg_after_delete_post_history
after delete on posts
for each row
begin
end //
delimiter ;

-- cập nhật nội dung bài viết số 1
update posts
set content = 'Alice updated her first post!'
where post_id = 1;

-- cập nhật nội dung bài viết số 3
update posts
set content = 'Bob updated his first post!'
where post_id = 3;

select * from post_history;

select post_id, content, like_count
from posts;

select * from user_statistics;