USE social_network_pro;

-- 1. Xóa thủ tục cũ để tạo lại bản mới đầy đủ hơn
DROP PROCEDURE IF EXISTS insertUsers;

-- 2. Tạo thủ tục với đầy đủ tham số đầu vào
DELIMITER $$
CREATE PROCEDURE insertUsers(
    IN p_username VARCHAR(50), 
    IN p_fullname VARCHAR(100),
    IN p_gender ENUM('Nam', 'Nữ'),  
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(100),
    IN p_birthdate DATE,             
    IN p_hometown VARCHAR(100)      
)
BEGIN
    INSERT INTO users(
        username, 
        full_name, 
        gender, 
        email, 
        password, 
        birthdate, 
        hometown
        -- Không cần created_at vì nó tự lấy thời gian hiện tại
        -- Không cần user_id vì nó tự tăng
    )
    VALUES(
        p_username, 
        p_fullname, 
        p_gender, 
        p_email, 
        p_password, 
        p_birthdate, 
        p_hometown
    );
END $$
DELIMITER ;

-- =============================================
-- 3. GỌI THỦ TỤC (TEST THỬ)
-- =============================================
-- Bây giờ bạn phải truyền đủ 7 tham số theo đúng thứ tự:
CALL insertUsers(
    'duy_pro_2026',        -- username
    'Phạm Quốc Duy',       -- full_name
    'Nam',                 -- gender
    'duy.pro@gmail.com',   -- email
    'matkhauSieumanh',     -- password
    '1995-05-20',          -- birthdate (Năm-Tháng-Ngày)
    'Hải Phòng'            -- hometown
);

-- Kiểm tra kết quả
SELECT * FROM users WHERE username = 'duy_pro_2026';