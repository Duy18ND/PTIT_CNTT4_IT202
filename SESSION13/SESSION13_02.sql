USE SESSION13_01;
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

UPDATE posts p
SET like_count = (
    SELECT COUNT(*) 
    FROM likes l 
    WHERE l.post_id = p.post_id
);

DELIMITER $$
DROP TRIGGER IF EXISTS tg_likes_insert $$
CREATE TRIGGER tg_likes_insert
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts 
    SET like_count = like_count + 1 
    WHERE post_id = NEW.post_id;
END $$

-- Trigger 2: Khi ai đó unlike -> Giảm like_count bảng posts
DROP TRIGGER IF EXISTS tg_likes_delete $$
CREATE TRIGGER tg_likes_delete
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts 
    SET like_count = like_count - 1 
    WHERE post_id = OLD.post_id;
END $$

DELIMITER ;

CREATE OR REPLACE VIEW user_statistics AS
SELECT 
    u.user_id,
    u.username,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 4, NOW());
SELECT * FROM posts WHERE post_id = 4;

SELECT * FROM user_statistics WHERE user_id = 3;

DELETE FROM likes WHERE user_id = 2 AND post_id = 4;
SELECT * FROM user_statistics WHERE user_id = 3;