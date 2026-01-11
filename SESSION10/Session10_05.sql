USE social_network_pro;
drop index idx_hometown on users;

--     2) Thực hiện truy vấn với các yêu cầu sau:=
-- Viết một câu truy vấn để tìm tất cả các người dùng (users) có hometown là "Hà Nội"
explain select u.*, p.post_id, p.content from users u
join posts p on u.user_id = p.user_id
where u.hometown = "Hà Nội"
order by u.username desc
limit 10;

--     3) Tạo chỉ mục có tên idx_hometown trên cột hometown của bảng users
create index idx_hometown on users(hometown);

--      4) Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi trước và sau khi có chỉ mục.
explain select u.*, p.post_id, p.content from users u
join posts p on u.user_id = p.user_id
where u.hometown = "Hà Nội"
order by u.username desc
limit 10;