-- Các trường hợp sử lý transaction:
-- 1. Xử lý trong thực thi chuyển khoản
-- - Trừ tiền trong tài khoản người gửi
-- - Cộng tiền vào tài khoản nhận
-- Các tình huống có thể xảy ra nếu xử lý độc lập các hành động:
-- Tiền bị trừ trong tài khoản gửi nhưng không được cộng vào tài khoản do: Sự cố
-- + Mất điện, bảo trì, mất kết nối.

-- VD: Rút tiền từ ATM
-- Có thể xảy ra:
-- - Máy ATM đang đếm số tiền để trả thì mất điện, mất kết nối với server
-- -> hành động có thể liên quan với nhau có thể xử lý trong 1 giao dịch gọi là transaction

drop database if exists DEMO14;
create database DEMO14;
use DEMO14;

create table books (
	isbn int auto_increment primary key,
    book_name varchar(100) not null,
    author varchar(50) not null,
    publisher varchar(100) not null,
    year_publish int check (year_publish >= 1900),
    price decimal(10,2) check (price >= 0)
);
-- Cài đặt thủ công có sửu dụng giao dịch
delimiter $$
create procedure insert_book()
begin 
	declare continue handler for sqlexception
    begin
		signal sqlstate  "Thực thi thất bại";
        rollback;
    end;
	start transaction;
	insert into books(book_name, author, publisher, year_publish, price) values
    ("Lap Trinh Java", "Doan Manh Duy","NXB Kim dong", 2023, 150000);
	insert into books(book_name, author, publisher, year_publish, price) values
    ("Lap Trinh Java", "Doan Manh Duy","NXB Kim dong", 2023, 29000);
	insert into books(book_name, author, publisher, year_publish, price) values
    ("Lap Trinh Java", "Doan Manh Duy","NXB Kim dong", 2023, -150000);
	insert into books(book_name, author, publisher, year_publish, price) values
    ("Lap Trinh Java", "Doan Manh Duy","NXB Kim dong", 2023, 20000);
    commit;
end $$
delimiter ;

call insert_book();
select * from books;

-- DEMO2
create table accounts (
	account_number int auto_increment primary key,
    account_name varchar(50),
    balence decimal (10,2)
);

insert into accounts(account_name, balance) values
("Nguyen Van A", 100000),
("Nguyen Van B", 500000),
("Nguyen Van C", 200000);

-- Thủ tục chuyển tiền
DELIMITER $$
CREATE PROCEDURE transfer_money (
    IN p_from_account INT, -- Tài khoản gửi
    IN p_to_account INT,   -- Tài khoản nhận
    IN p_money DECIMAL(10,2) -- Số tiền chuyển
)
BEGIN
    -- Khai báo biến lưu số dư người gửi
    DECLARE v_sender_balance DECIMAL(10,2);
    
    -- 1. KHAI BÁO XỬ LÝ LỖI (HANDLER)
    -- Nếu có bất kỳ lỗi SQL nào xảy ra trong quá trình chạy -> Rollback ngay lập tức
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi giao dịch: Đã Rollback toàn bộ!';
    END;

    -- 2. KIỂM TRA LOGIC ĐẦU VÀO (Theo yêu cầu của bạn)
    -- Nếu số tiền âm hoặc bằng 0 -> Báo lỗi ngay
    IF p_money <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Số tiền chuyển phải lớn hơn 0';
    END IF;

    -- 3. BẮT ĐẦU GIAO DỊCH
    START TRANSACTION;

    -- Kiểm tra tài khoản người gửi có tồn tại không và khóa dòng đó lại (FOR UPDATE)
    -- để tránh người khác rút tiền cùng lúc gây sai lệch.
    SELECT balance INTO v_sender_balance 
    FROM accounts 
    WHERE account_number = p_from_account 
    FOR UPDATE;

    -- Kiểm tra logic số dư
    IF v_sender_balance IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tài khoản người gửi không tồn tại';
    ELSEIF v_sender_balance < p_money THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số dư không đủ để thực hiện giao dịch';
    ELSE
        -- Nếu mọi thứ OK -> Thực hiện trừ và cộng tiền
        
        -- Trừ tiền người gửi
        UPDATE accounts 
        SET balance = balance - p_money 
        WHERE account_number = p_from_account;
        
        -- Cộng tiền người nhận
        UPDATE accounts 
        SET balance = balance + p_money 
        WHERE account_number = p_to_account;
        
        -- Kiểm tra xem người nhận có tồn tại không (dựa vào số dòng update)
        IF ROW_COUNT() = 0 THEN
            ROLLBACK; -- Không tìm thấy người nhận -> Hoàn tác việc trừ tiền
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tài khoản người nhận không tồn tại';
        ELSE
            -- Mọi thứ thành công -> Chốt giao dịch
            COMMIT;
        END IF;
    END IF;

END $$
DELIMITER ;

CALL transfer_money(1, 2, -50000);
CALL transfer_money(1, 2, 5000000);

SELECT * FROM accounts;