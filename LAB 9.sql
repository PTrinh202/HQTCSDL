CREATE TABLE LOP(
	MALOP CHAR(5) PRIMARY KEY,
	TENLOP NVARCHAR(20),
	SISO INT,
);
CREATE TABLE SINHVIEN(
	MASV CHAR(5) PRIMARY KEY,
	HOTEN NVARCHAR(50),
	NGSINH DATE,
	MALOP CHAR(5) CONSTRAINT KF_MALOP REFERENCES LOP(MALOP),
);
CREATE TABLE MONHOC(
	MAMH CHAR(5) PRIMARY KEY,
	TENMH NVARCHAR(20)
);
CREATE TABLE KETQUA(
	MASV INT,
	MAMH CHAR(5),
	DIEMTHI FLOAT,
	CONSTRAINT FK_MASV FOREIGN KEY(MASV) REFERENCES SINHVIEN(MASV),
	CONSTRAINT FK_MAMH FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH),
	CONSTRAINT FK_MASV_MAMH PRIMARY KEY (MASV, MAMH),
);
INSERT LOP VALUES
	('A', 'LỚP 1', 12),
	('B', 'LỚP 2', 24),
	('C', 'LỚP 3', 48)
INSERT SINHVIEN VALUES
	('0950080111', 'ĐINH TOÀN', '1999-10-22', 'A'),
	('0950080122', 'NGUYÊN LÊ', '1999-12-12', 'A'),
	('0950080123', 'LÊ MINH', '2000-4-5', 'B')
INSERT MONHOC VALUES
	('CSDL', 'CSDL NÂNG CAO'),
	('MTT', 'MẠNG MÁY TÍNH'),
	('TCC', 'TOÁN CAO CẤP'),
	('LTW', 'LẬP TRÌNH WEB')
INSERT KETQUA VALUES
	('0950080111', 'MTT', 8),
	('0950080111', 'LTW', 5),
	('0950080123', 'TCC', 4.5),
	('0950080122', 'MTT', 8.5),
	('0950080123', 'MTT', 7.5)

--CÂU 1: Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ--
GO 
CREATE FUNCTION DIEMTB (@MASV CHAR(5))
RETURNS FLOAT
AS 
	BEGIN
		DECLARE @TB FLOAT
		SET @TB = (SELECT AVG(DIEMTHI) FROM KETQUA WHERE MASV = @MASV)
		RETURN @TB
	END
/*CÂU 2: Viết hàm bằng 2 cách (table – value fuction và multistatement value function) tính điểm trung
bình của cả lớp, thông tin gồm MaSV, Hoten, ĐiemTB, sử dụng hàm diemtb ở câu 1*/
GO
CREATE FUNCTION TRBINHLOP (@MALOP CHAR(5))
RETURNS TABLE
AS
	RETURN
		SELECT S.MASV, HOTEN, TRUNGBINH = DBO.DIEMTB(S.MASV)
		FROM SINHVIEN S JOIN KETQUA K ON S.MASV = K.MASV
		WHERE MALOP = @MALOP
		GROUP BY S.MASV, HOTEN
/*CÂU 3: Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV, (VD sinh viên
có MaSV=01 thi 3 môn) kết quả trả về chuỗi thông báo “Sinh viên 01 thi 3 môn” hoặc “Sinh
viên 01 không thi môn nào”*/
GO
CREATE PROC KTRA @MSV CHAR(5)
AS
	BEGIN
		DECLARE @N INT
		SET @N = (SELECT COUNT (*) FROM KETQUA WHERE MASV = @MSV)
		IF @N = 0
			PRINT 'SINH VIÊN' + @MSV + 'KHÔNG THI MÔN NÀO'
		ELSE
			PRINT 'SINH VIÊN' + @MSV + 'THI' + CAST(@N AS CHAR(2)) + 'MON'
	END
GO 
EXEC KTRA '0950080111'
/*CÂU 4: Viết một trigger kiểm tra sỉ số lớp khi thêm một sinh viên mới vào danh sách sinh viên thì hệ
thống cập nhật lại siso của lớp, mỗi lớp tối đa 10SV, nếu thêm vào &gt;10 thì thông báo lớp đầy
và hủy giao dịch*/
GO 
CREATE TRIGGER UPDATESSLOP
ON SINHVIEN
FOR INSERT
AS
	BEGIN
		DECLARE @SS INT
		SET @SS = (SELECT COUNT(*) FROM SINHVIEN S 
			WHERE MALOP IN (SELECT MALOP FROM inserted))
		IF @SS > 10
			BEGIN
				PRINT 'LỚP ĐẦY'
				ROLLBACK TRAN
			END
		ELSE 
			BEGIN
				UPDATE LOP
				SET SISO = @SS
				WHERE MALOP IN (SELECT MALOP FROM inserted)
			END
	END
/*CÂU 5: Tạo 2 login user1 và user2 đăng nhập vào sql, tạo 2 user tên user1 và user2 trên CSDL Quản lý
Sinh viên tương ứng với 2 login vừa tạo.*/
--TẠO login
create login user1 with password = '123'
create login user2 with password = '456'
--TẠO user
create user user1 for login user1
create user user2 for login user2
/*CÂU 6: Gán quyền cho user 1 các quyền Insert, Update, trên bảng sinhvien, gán quyền select cho
user2 trên bảng sinhvien*/
GRANT INSERT, UPDATE ON SINHVIEN TO USER1
GRANT SELECT ON SINHVIEN TO USER2
--CÂU 7
go
use QLSV --Chọn cơ sở dữ liệu
go
Create role Quanly
Grant select, insert, update to Quanly
exec Sp_AddRoleMember 'Quanly', 'user1'
exec Sp_AddRoleMember 'Quanly', 'user2'

--CÂU 8
BACKUP DATABASE QLSV
TO DISK = 'C:\BACKUP\QLSV.Bak'
WITH NOINIT, NAME = 'Full Backup of QLSV'
--THÊM SINHVIEN
INSERT SINHVIEN VALUES
('0950080145', 'MINH TÔN', '1999-3-2', 'B')

--CÂU 9
BACKUP DATABASE QLSV
TO DISK = 'C:\BACKUP\QLSV_DIFF.Bak'
WITH DIFFERENTIAL

--CÂU 10
DROP DATABASE QLSV
RESTORE DATABASE QLSV
FROM DISK = 'C:\BACKUP\QLSV.Bak'
SELECT*FROM SINHVIEN