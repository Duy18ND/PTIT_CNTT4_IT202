use session13_03;

drop procedure if exists add_user;
delimiter //
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end //
delimiter ;

drop trigger if exists trg_before_insert_user;
delimiter //
create trigger trg_before_insert_user
before insert on users
for each row
begin
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'email không hợp lệ';
    end if;

    if new.username not regexp '^[A-Za-z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'username chỉ được chứa chữ cái, số và dấu gạch dưới';
    end if;
end //
delimiter ;

call add_user('valid_user_01', 'valid01@example.com', '2025-01-20');

call add_user('invaliduser', 'invalidemail', '2025-01-20');

call add_user('invalid-user!', 'user2@example.com', '2025-01-20');

select * from users;