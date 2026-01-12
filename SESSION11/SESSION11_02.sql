USE social_network_pro;
DROP PROCEDURE IF EXISTS CalculatePostLikes;

DELIMITER $$
CREATE PROCEDURE CalculatePostLikes(IN p_post_id INT, OUT total_likes INT)
BEGIN
    SELECT COUNT(*) INTO total_likes 
    FROM likes 
    WHERE post_id = p_post_id;
END $$
DELIMITER ;

CALL CalculatePostLikes(3, @tong_like);
SELECT @tong_like;

-- 4. Xóa thủ tục
DROP PROCEDURE IF EXISTS CalculatePostLikes;