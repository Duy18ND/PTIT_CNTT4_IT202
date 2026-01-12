drop database if exists DEMO;
create database DEMO;
use DEMO;
create table doi_bong(
	ma_doi_bong char(15) not null primary key,
    	ten_doi_bong varchar(100) not null unique
);

create table tt_thi_dau(
	ma_tran_dau int not null,
    	ngay_thi_dau date,
    	ma_doi_bong char(15) not null,
    	so_ban_thang int check(so_ban_thang>=0),
   	 so_ban_thua int check(so_ban_thua>=0),
    	diem int check(diem>=0 and diem<=3),
	primary key(ma_tran_dau,ma_doi_bong)
);

insert into doi_bong(ma_doi_bong,ten_doi_bong) values
('MU','Manchester United'),
('ARS','Arsenal'),
('LIV','Liverpool');

insert into tt_thi_dau(ma_tran_dau,ngay_thi_dau,ma_doi_bong,so_ban_thang,so_ban_thua) values
(1,'2025-10-22','MU',3,1),
(1,'2025-10-22','ARS',1,3),
(2,'2025-10-30','MU',2,2),
(2,'2025-10-30','LIV',2,2),
(3,'2025-11-10','ARS',0,2),
(3,'2025-11-10','LIV',2,0);

-- Tạo các thủ tục sau:
-- 1.	Thủ tục thêm 1 đội bóng mới
DELIMITER $$
CREATE PROCEDURE insertDoi_Bong(
    IN p_ma_doi_bong CHAR(15),      
    IN p_ten_doi_bong VARCHAR(100)
)
BEGIN
    -- Thêm logic INSERT vào đây
    INSERT INTO doi_bong(ma_doi_bong, ten_doi_bong) 
    VALUES (p_ma_doi_bong, p_ten_doi_bong);
END$$
DELIMITER ;

CALL insertDoi_Bong('TNL', 'Team Nguoi La');
SELECT * FROM doi_bong;
-- 2.	Thủ tục cập nhật thông tin 1 đội bóng
delimiter $$
create procedure p_updateDoi_Bong (IN p_ma_doi_bong char(15), IN p_ten_doi_bong varchar(100))
begin
update doi_bong set ten_doi_bong = p_ten_doi_bong where ma_doi_bong = p_ma_doi_bong;
end $$
delimiter ;

CALL p_updateDoi_Bong("TNL", "Het Cuu!");
SELECT * FROM doi_bong;
-- 3.	Thủ tục xoá thông tin đội bóng
delimiter $$
create procedure p_deleteDoi_Bong(IN p_ma_doi_bong char(15))
begin
	delete from doi_bong where ma_doi_bong = p_ma_doi_bong;
end $$
delimiter ;
CALL p_deleteDoi_Bong('TNL');
SELECT * FROM doi_bong;
-- 4.	Thủ tục lấy dữ liệu đội bóng, có phân trang
delimiter $$
create procedure p_pageDoi_bong (IN p_page_number int, IN p_page_size int)
begin 
declare v_offset int;
set v_offset = (p_page_number - 1) * p_page_size;

select * from doi_bong 
order by ma_doi_bong asc
limit p_page_number offset v_offset; 
end $$
delimiter ;

CALL p_pageDoi_bong(1, 2);
-- 5.	Thủ tục thêm mới thông tin thi đấu
-- 6.	Thủ tục cập nhật dữ liệu điểm (thắng – 3 điểm, hoà – 1 điểm, thua – 0 điểm)
-- 7.	Thủ tục lấy dữ liệu thông tin thi đấu theo mã trận đấu
-- 8.	Thủ tục thống kê số trận đấu, số trận thắng, số trận thua, hệ số bàn thắng, điểm
