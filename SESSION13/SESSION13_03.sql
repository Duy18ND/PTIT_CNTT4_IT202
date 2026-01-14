drop database if exists session13_03;
create database session13_03;
use session13_03;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int, 
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table likes (
    like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

insert into posts (user_id, content, created_at) values
(1, 'Post 1 cua Alice', '2025-01-10 10:00:00'),
(1, 'Post 2 cua Alice', '2025-01-10 10:30:00'),
(2, 'Post 3 cua Bob', '2025-01-11 09:00:00'),
(3, 'Post 4 cua Charlie', '2025-01-12 15:00:00');

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

DELIMITER //

CREATE TRIGGER trg_before_insert_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    SELECT user_id
    INTO post_owner
    FROM posts
    WHERE post_id = NEW.post_id;

    IF NEW.user_id = post_owner THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không được phép like bài viết của chính mình';
    END IF;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_after_insert_like
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_after_delete_like
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_after_update_like
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    -- Nếu đổi sang bài khác
    IF OLD.post_id <> NEW.post_id THEN
        UPDATE posts
        SET like_count = like_count - 1
        WHERE post_id = OLD.post_id;

        UPDATE posts
        SET like_count = like_count + 1
        WHERE post_id = NEW.post_id;
    END IF;
END //
DELIMITER ;

--  Test like bài của chính mình (phải lỗi)
-- Alice (user_id = 1) like post_id = 1 (của Alice)
INSERT INTO likes (user_id, post_id)
VALUES (1, 1);

-- Like hợp lệ
INSERT INTO likes (user_id, post_id)
VALUES (2, 4);

-- Kiểm tra like_count
SELECT * FROM posts WHERE post_id = 4;

-- UPDATE like sang post khác
-- Ví dụ đổi like_id = 2 sang post_id = 3
UPDATE likes
SET post_id = 3
WHERE like_id = 2;

-- Kiểm tra cả 2 post
SELECT * FROM posts WHERE post_id IN (3,4);

-- XÓA LIKE
DELETE FROM likes WHERE like_id = 2;

SELECT * FROM posts;
SELECT * FROM user_statistics;