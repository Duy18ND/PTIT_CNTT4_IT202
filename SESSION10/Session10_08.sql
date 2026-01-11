USE social_network_pro;

-- 2) Tạo index idx_user_gender
CREATE INDEX idx_user_gender ON users(gender);

-- 3) Tạo View view_popular_posts
-- Cần dùng LEFT JOIN để lấy cả những bài chưa có like hoặc comment nào
CREATE OR REPLACE VIEW view_popular_posts AS
SELECT 
    p.post_id,
    u.username,
    p.content,
    -- Đếm số user đã like (dùng DISTINCT để không bị trùng lặp do join nhiều bảng)
    COUNT(DISTINCT l.user_id) AS like_count,
    -- Đếm số comment
    COUNT(DISTINCT c.comment_id) AS comment_count
FROM posts p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, u.username, p.content;

-- 4) Truy vấn xem dữ liệu trong View
SELECT * FROM view_popular_posts;

-- 5) Truy vấn các bài viết có tổng tương tác (like + comment) > 10
-- Sắp xếp giảm dần theo tổng tương tác
SELECT 
    post_id, 
    username, 
    content, 
    like_count, 
    comment_count,
    (like_count + comment_count) AS total_interaction
FROM view_popular_posts
WHERE (like_count + comment_count) > 10
ORDER BY total_interaction DESC;