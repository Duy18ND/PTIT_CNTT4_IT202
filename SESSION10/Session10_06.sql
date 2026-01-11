USE social_network_pro;
-- 2) Tạo một view tên view_users_summary để thống kê số lượng bài viết của từng người dùng.user_id (Mã người dùng), username (Tên người dùng), 
-- total_posts (Tổng số lượng bài viết của người dùng)
create view view_users_summary as
select u.user_id, u.username, count(p.post_id) as total_posts
from users u 
left join posts p on u.user_id = p.user_id
group by u.user_id, p.user_id;
-- 3) Truy vấn từ view_users_summary để hiển thị các thông tin về user_id, username và total_posts của các người dùng có total_posts lớn hơn 5.
select * from view_users_summary where total_posts > 5;