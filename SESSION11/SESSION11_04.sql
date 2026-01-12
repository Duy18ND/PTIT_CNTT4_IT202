use social_network_pro;

-- 2) Viết procedure tên CreatePostWithValidation nhận IN p_user_id (INT), IN p_content (TEXT). Nếu độ dài content < 5 ký tự thì không thêm bài viết và SET một biến thông báo lỗi (có thể dùng OUT result_message VARCHAR(255) để trả về thông báo “Nội dung quá ngắn” hoặc “Thêm bài viết thành công”).
delimiter $$
create procedure CreatePostWithValidation
(
IN p_user_id int,
IN p_content text,
OUT result_message varchar(255)
)
begin 
	if char_length(p_content) < 5 then
		set result_message = "Nội dung quá ngắn";
	else 
		insert into posts(user_id, content) values (p_user_id, p_content);
        SET result_message = 'Thành công: Đã thêm bài viết mới';
	end if;
end $$
delimiter ;
-- 3) Gọi thủ tục và thử insert các trường hợp 
CALL CreatePostWithValidation(1, "HI", @result_mes_1);
select @result_mes;

CALL CreatePostWithValidation(2, 'Hôm nay trời đẹp quá', @result_mes_2);
SELECT @result_mes_2;
-- 4) Kiểm tra các kết quả
SELECT * FROM posts WHERE user_id = 1 ORDER BY created_at DESC;
SELECT * FROM posts WHERE user_id = 2 ORDER BY created_at DESC;
-- 5) Xóa thủ tục vừa khởi tạo trên
drop procedure if exists CreatePostWithValidation;