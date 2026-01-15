drop database if exists session14_01;
create database session14_01;
use session14_01;

create table accounts (
    account_number int primary key auto_increment,
    account_name varchar(50),
    balance decimal(10,2)
);

insert into accounts (account_name, balance) values 
('Nguyen Van An', 1000), 
('Tran Thi Bay', 500);

delimiter $$

drop procedure if exists chuyen_tien $$

create procedure chuyen_tien(
    in p_from_account int,      
    in p_to_account int,        
    in p_amount decimal(10,2)   
)
begin
    declare v_sender_balance decimal(10,2);
    
    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'lỗi hệ thống: đã rollback giao dịch!';
    end;

    if p_amount <= 0 then
        signal sqlstate '45000' set message_text = 'số tiền chuyển phải lớn hơn 0';
    end if;

    start transaction;

    select balance into v_sender_balance 
    from accounts 
    where account_number = p_from_account 
    for update;

    if v_sender_balance is null or v_sender_balance < p_amount then
        rollback;
        signal sqlstate '45000' set message_text = 'số dư không đủ hoặc tài khoản nguồn sai';
    else
        update accounts 
        set balance = balance - p_amount 
        where account_number = p_from_account;

        update accounts 
        set balance = balance + p_amount 
        where account_number = p_to_account;

        if row_count() = 0 then
            rollback;
            signal sqlstate '45000' set message_text = 'tài khoản nhận không tồn tại';
        else
            commit;
        end if;
    end if;

end $$
delimiter ;

call chuyen_tien(1, 2, 200);

select * from accounts;