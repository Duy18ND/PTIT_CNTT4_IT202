USE social_network_pro;
DROP PROCEDURE IF EXISTS CalculateBonusPoints;
DELIMITER $$
CREATE PROCEDURE CalculateBonusPoints(
    IN p_user_id INT,         
    INOUT p_bonus_points INT   
)
BEGIN
    DECLARE v_post_count INT;
    SELECT COUNT(*) INTO v_post_count 
    FROM posts 
    WHERE user_id = p_user_id;

    IF v_post_count >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF v_post_count >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    END IF;
END $$

DELIMITER ;
SET @diem_thuong = 100;
CALL CalculateBonusPoints(2, @diem_cua_toi);

SELECT @diem_cua_toi AS 'Diem_Sau_Khi_Cong';

DROP PROCEDURE IF EXISTS CalculateBonusPoints;