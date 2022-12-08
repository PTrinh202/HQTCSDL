/*BÀI 1A*/
CREATE PROC sp_Bai1a @ten NVARCHAR(50)
AS
BEGIN
	PRINT 'Xin chào ' + CAST(@ten AS NVARCHAR);
END	
GO
EXEC sp_Bai1a 'Thao Quyen';
/*BÀI 1B*/
CREATE OR ALTER PROCEDURE sp_Sum @So1 INT = 5, @So2 INT = 4
AS
BEGIN
	DECLARE @tong INT;
	SET @tong = @So1 + @So2;
	PRINT 'Tổng là: ' + cast(@tong AS NVARCHAR);
END
GO
EXEC sp_Sum /* nếu không truyền đối số vào thì chương trình sẽ lấy giá trị đã khởi tạo của trong chương trình để thực hiện phép tính*/
EXEC sp_Sum 7,8;
/*BÀI 1C*/
CREATE PROCEDURE sp_TongChan @n INT
AS
BEGIN
	DECLARE @tong INT = 0, @i INT = 1;
	WHILE (@i <= @n)
	BEGIN
		IF(@i % 2= 0)
		BEGIN
			SET @tong = @tong + @i
		END
		SET @i= @i +1
	END
	select @tong AS 'Tong chan'
END
GO
/*BÀI 1D*/
CREATE PROC sp_UCLN @s3 INT,@s4 INT
AS
BEGIN
	DECLARE @temp INT;
	WHILE (@s4 % @s3 != 0)
	BEGIN
		IF (@s4 > @s3)
		SET @s4 = @s4-@s3
		ELSE
		SET @s3 = @s3-@s4
	END
	PRINT N'Ước chung lớn nhất là ' + CAST(@s3 AS VARCHAR(10))
END
GO
/*BÀI 2A*/
go
create procedure ThongtinNV2 @MANV nvarchar(9)
as 
begin 
select * from NHANVIEN where MANV=@MANV
end
go
exec ThongtinNV2 '005'
/*BÀI 2B*/
go
create procedure soluong1234 @MADA nvarchar(9)
as 
begin 
select MADA,COUNT(*) AS SOLUONG
from DEAN ,NHANVIEN
where MADA=@MADA and PHG=PHONG 
GROUP BY MADA
end
go
exec soluong1234 '20'
/*BÀI 2C*/
CREATE PROCEDURE sp_Cau2c @MaDa INT, @Ddiem_DA NVARCHAR(15)
AS
BEGIN
	SELECT PHANCONG.MADA, COUNT(*) AS 'SL'
	FROM DEAN, PHANCONG
	WHERE DEAN.MADA = PHANCONG.MADA and
		  DDIEM_DA = @Ddiem_DA	and
		  DEAN.MADA = @MaDa	
	GROUP BY PHANCONG.MADA
END
GO
/*BÀI 2D*/
GO
create procedure nhanvien12345 @trphg nvarchar(9)
as 
begin 
select TENNV
from NHANVIEN, PHONGBAN
WHERE @trphg=MANV AND PHG=MAPHG
END
GO
EXEC nhanvien12345 '006'
/*BÀI 2E*/
GO
create procedure nhanvien123456 @MANV nvarchar(9),@MAPB nvarchar(9)
as 
begin 
select TENNV
from NHANVIEN, PHONGBAN
WHERE @MANV=MANV AND PHG=MAPHG
END
GO
EXEC nhanvien123456'001','4'
/* BÀI 3A*/
CREATE PROC sp_ThemPhongBan @TenPHG NVARCHAR(15),
	@MaPHG INT, @TRPHG NVARCHAR(9), @NG_NHANCHUC date
AS
BEGIN
	IF EXISTS(SELECT * FROM PHONGBAN WHERE MAPHG = @MaPHG)
		PRINT 'Da ton tai, khong them vao duoc';
	ELSE
		INSERT INTO PHONGBAN
		VALUES(@TenPHG, @MaPHG,@TRPHG,@NG_NHANCHUC)
END
GO
EXEC sp_ThemPhongBan 'CNTT',6,'008','1985-01-01'
/*BÀI 3B*/
CREATE PROCEDURE sp_PhongBanDoiTen @tenphg NVARCHAR(30)
AS
BEGIN
	update phongban SET tenphg = @tenphg
	WHERE tenphg = N'Công Nghệ Thông Tin'
END
Exec sp_PhongBanDoiTen 'IT'
GO
EXEC sp_PhongBanDoiTen 'IT'
/*BÀI 3C*/
CREATE PROCEDURE sp_ThemNhanVien
@honv NVARCHAR(15),@tenlotnv NVARCHAR(15), @tennv NVARCHAR(15),@manv NVARCHAR(9),
@ngsinh date,@dchi NVARCHAR(30), @phai NVARCHAR(3),@luong float, @ma_nql NVARCHAR(9), @phg INT
AS
BEGIN
	IF (@phg = (SELECT maphg FROM phongban WHERE tenphg ='IT'))
	BEGIN
		IF(@luong < 25000)
		BEGIN
			SET @ma_nql = '009'
			insert into nhanvien
			values(@honv,@tenlotnv,@tennv,@manv,@ngsinh,@dchi,@phai,@luong,@ma_nql,@phg)
		END
		ELSE
		BEGIN
			SET @ma_nql = '005'
			insert into nhanvien
			values(@honv,@tenlotnv,@tennv,@manv,@ngsinh,@dchi,@phai,@luong,@ma_nql,@phg)
		END
		IF (@phai = 'Nam')
		BEGIN
			IF(datedIFf(yy,@ngsinh,getdate()) between 18 and 65)
			BEGIN
				insert into nhanvien
				values(@honv,@tenlotnv,@tennv,@manv,@ngsinh,@dchi,@phai,@luong,@ma_nql,@phg)
			END
			ELSE
			PRINT N'Không thỏa'
		END
		ELSE
		BEGIN
			IF(datedIFf(yy,@ngsinh,getdate()) between 18 and 60)
			BEGIN
				insert into nhanvien
				values(@honv,@tenlotnv,@tennv,@manv,@ngsinh,@dchi,@phai,@luong,@ma_nql,@phg)
			END
			ELSE
			PRINT N'Không Thỏa'
		END
	END
	ELSE
	PRINT N'NHAN VIEN PHONG IT MOI THEM DUOC'
END
GO