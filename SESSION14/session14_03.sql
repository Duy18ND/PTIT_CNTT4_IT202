drop database if exists session14_03;
create database session14_03;
use session14_03;

-- bảng nhân viên
create table employees (
    emp_id int primary key auto_increment,
    emp_name varchar(50),
    salary decimal(10,2)
);

-- bảng quỹ công ty
create table company_funds (
    fund_id int primary key auto_increment,
    balance decimal(15,2)
);

-- bảng trả lương
create table payroll (
    payroll_id int primary key auto_increment,
    emp_id int,
    salary decimal(10,2),
    pay_date date,
    foreign key (emp_id) references employees(emp_id)
);

-- thêm dữ liệu mẫu
insert into employees (emp_name, salary) values 
('nguyen van a', 5000.00),
('tran thi b', 200000.00); -- lương cao để test trường hợp thiếu quỹ

insert into company_funds (balance) values (50000.00);


delimiter $$

drop procedure if exists transfer_salary $$

create procedure transfer_salary(
    in p_emp_id int
)
begin
    -- khai báo biến lưu lương nhân viên và số dư quỹ
    declare v_salary decimal(10,2);
    declare v_fund_balance decimal(15,2);
    declare v_sys_error int default 0; -- giả lập trạng thái lỗi ngân hàng (0: ok, 1: lỗi)

    -- xử lý lỗi sql: gặp lỗi thì rollback ngay
    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'lỗi hệ thống: đã rollback';
    end;

    start transaction;

    -- lấy lương nhân viên theo id
    select salary into v_salary 
    from employees 
    where emp_id = p_emp_id;

    -- lấy số dư quỹ công ty (khóa dòng để tránh xung đột)
    select balance into v_fund_balance 
    from company_funds 
    where fund_id = 1 
    for update;

    -- kiểm tra số dư quỹ: nếu thiếu tiền thì hủy
    if v_fund_balance < v_salary then
        rollback;
        signal sqlstate '45000' set message_text = 'quỹ không đủ tiền trả lương';
    else
        -- trừ tiền quỹ công ty
        update company_funds 
        set balance = balance - v_salary 
        where fund_id = 1;

        -- ghi lịch sử trả lương
        insert into payroll (emp_id, salary, pay_date) 
        values (p_emp_id, v_salary, curdate());

        -- giả lập kiểm tra hệ thống ngân hàng
        -- (trong thực tế sẽ gọi api, ở đây mình đặt điều kiện giả định)
        if v_sys_error = 1 then
            rollback;
            signal sqlstate '45000' set message_text = 'lỗi hệ thống ngân hàng';
        else
            -- mọi thứ ok thì lưu lại
            commit;
        end if;
    end if;

end $$
delimiter ;