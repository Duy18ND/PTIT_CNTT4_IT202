USE social_network_pro;

-- 2) tao chi muc phuc hop (composite index)
-- kiem tra ke hoach thuc thi truoc khi tao index
explain select post_id, content, created_at from posts where user_id = 1 and year(created_at) = 2026;
-- tao chi muc phuc hop idx_created_at_user_id tren bang posts
create index idx_created_at_user_id on posts(created_at, user_id);
-- kiem tra lai ke hoach thuc thi sau khi tao index
explain select post_id, content, created_at from posts where user_id = 1 and year(created_at) = 2026;

-- 3) tao chi muc duy nhat (unique index)
-- kiem tra ke hoach thuc thi truoc khi tao index
explain select user_id, username, email from users where email = 'an@gmail.com';
-- tao chi muc duy nhat idx_email tren cot email
create unique index idx_email on users(email);
-- kiem tra lai ke hoach thuc thi sau khi tao index
explain select user_id, username, email from users where email = 'an@gmail.com';


-- 4) xoa chi muc
-- xoa chi muc idx_created_at_user_id khoi bang posts
drop index idx_created_at_user_id on posts;
-- xoa chi muc idx_email khoi bang users
drop index idx_email on users;