use social_network_pro;

-- 2) tao view view_user_activity_status
create or replace view view_user_activity_status as
select 
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    case 
        when exists(select 1 from posts p where p.user_id = u.user_id) 
             or exists(select 1 from comments c where c.user_id = u.user_id)
        then 'Active'
        else 'Inactive'
    end as status
from users u;

-- 3) truy van kiem tra ket qua tu view
select * from view_user_activity_status;

-- 4) thong ke so luong user theo trang thai (active/inactive)
select 
    status as 'ten trang thai',
    count(user_id) as user_count
from view_user_activity_status
group by status
order by user_count desc;