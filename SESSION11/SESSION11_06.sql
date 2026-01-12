USE social_network_pro;

DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;

DELIMITER $$

CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT, 
    IN p_content TEXT
)
BEGIN
    -- Biến để lưu tên người đăng
    DECLARE v_fullname VARCHAR(100);
    -- Biến để lưu nội dung thông báo
    DECLARE v_message VARCHAR(255);

    SELECT full_name INTO v_fullname 
    FROM users 
    WHERE user_id = p_user_id;

    INSERT INTO posts(user_id, content) 
    VALUES (p_user_id, p_content);

    SET v_message = CONCAT(v_fullname, ' đã đăng một bài viết mới');

    INSERT INTO notifications(user_id, content, type)
    SELECT 
        CASE 
            WHEN user_id_1 = p_user_id THEN user_id_2
            ELSE user_id_1                     
        END AS receiver_id,
        v_message,
        'new_post'
    FROM friends
    WHERE (user_id_1 = p_user_id OR user_id_2 = p_user_id) 
      AND status = 'accepted';                    

END $$

DELIMITER ;

CALL NotifyFriendsOnNewPost(1, 'Chào buổi sáng mọi người!');

SELECT * FROM notifications 
WHERE type = 'new_post' 
ORDER BY created_at DESC;
SELECT * FROM posts WHERE user_id = 1 ORDER BY created_at DESC;

DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;