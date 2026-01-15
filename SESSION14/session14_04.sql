drop database if exists session14_04;
create database session14_04;
use session14_04;

-- bảng sinh viên
create table students (
    student_id int primary key auto_increment,
    student_name varchar(50)
);

-- bảng khóa học
create table courses (
    course_id int primary key auto_increment,
    course_name varchar(100),
    available_seats int
);

-- bảng đăng ký
create table enrollments (
    enrollment_id int primary key auto_increment,
    student_id int,
    course_id int,
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id)
);

-- thêm dữ liệu mẫu
insert into students (student_name) values ('nguyen van a'), ('tran thi b');
insert into courses (course_name, available_seats) values 
('Co So Du Lieu', 1), 
('lap trinh c', 50);   

delimiter $$

drop procedure if exists register_course $$

create procedure register_course(
    in p_student_name varchar(50),  -- tên sinh viên
    in p_course_name varchar(100)   -- tên môn học
)
begin
    -- khai báo biến để lưu id và số chỗ trống tìm được
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;

    -- cấu hình xử lý lỗi
    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000' set message_text = 'lỗi hệ thống: đã rollback';
    end;

    start transaction;

    -- [bước 1]: tìm id sinh viên từ tên
    select student_id into v_student_id 
    from students 
    where student_name = p_student_name;

    -- [bước 2]: tìm id môn học và số chỗ trống từ tên môn (khóa dòng để giữ chỗ)
    select course_id, available_seats into v_course_id, v_available_seats
    from courses 
    where course_name = p_course_name 
    for update;

    -- [bước 3]: kiểm tra logic
    if v_student_id is null or v_course_id is null then
        -- trường hợp nhập sai tên
        rollback;
        signal sqlstate '45000' set message_text = 'sinh viên hoặc môn học không tồn tại';
        
    elseif v_available_seats > 0 then
        -- [trường hợp còn chỗ]: thực hiện đăng ký
        
        -- thêm vào bảng enrollments
        insert into enrollments (student_id, course_id) 
        values (v_student_id, v_course_id);

        -- giảm số chỗ trống đi 1
        update courses 
        set available_seats = available_seats - 1 
        where course_id = v_course_id;

        -- xác nhận thành công
        commit;
    else
        -- [trường hợp hết chỗ]: rollback
        rollback;
        signal sqlstate '45000' set message_text = 'môn học đã hết chỗ trống';
    end if;

end $$
delimiter ;