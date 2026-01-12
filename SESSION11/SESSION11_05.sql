USE social_network_pro;
DROP PROCEDURE IF EXISTS CalculateUserActivityScore;

DELIMITER $$

CREATE PROCEDURE CalculateUserActivityScore(
    IN p_user_id INT, 
    OUT activity_score INT, 
    OUT activity_level VARCHAR(50) 
)
BEGIN
    DECLARE v_post_count INT DEFAULT 0;
    DECLARE v_comment_count INT DEFAULT 0;
    DECLARE v_likes_received INT DEFAULT 0;

    SELECT COUNT(*) INTO v_post_count 
    FROM posts 
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO v_comment_count 
    FROM comments 
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO v_likes_received
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    SET activity_score = (v_post_count * 10) + (v_comment_count * 5) + (v_likes_received * 3);

    CASE 
        WHEN activity_score > 500 THEN 
            SET activity_level = 'Rất tích cực';
        WHEN activity_score >= 200 THEN 
            SET activity_level = 'Tích cực';
        ELSE 
            SET activity_level = 'Bình thường';
    END CASE;

END $$

DELIMITER ;

CALL CalculateUserActivityScore(1, @diem_so, @xep_loai);

SELECT 
    @diem_so AS 'Tổng Điểm', 
    @xep_loai AS 'Xếp Loại Hoạt Động';

DROP PROCEDURE IF EXISTS CalculateUserActivityScore;