/*Bài 1: Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì
xuất thông báo “luong phải >15000’*/
CREATE TRIGGER CheckLuong_NV ON NHANVIEN 
FOR INSERT 
AS
BEGIN
IF (select LUONG from inserted) < 15000
BEGIN
PRINT N'Luong phai > 15000'
ROLLBACK TRANSACTION
END
END
GO
INSERT INTO NHANVIEN
VALUES ('PHAI', 'VIEN', 'THI', '115', '1907-02-01 00:00:00_000', 'HCM', 'NAM', 4000, '005', 4)
/*BÀI 1.2: Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.*/
CREATE TRIGGER KiemTraTuoi ON NHANVIEN 
FOR INSERT 
AS
BEGIN
DECLARE @age INT
SET @age = (SELECT YEAR(GETDATE()) - YEAR(NGSINH) FROM INSERTED)
IF ( @age NOT BETWEEN 18 AND 65)
BEGIN
PRINT 'Tuoi trong khoang 18 - 65'
ROLLBACK TRANSACTION
END
END
GO
/*BÀI 1.3: Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM*/
CREATE TRIGGER KiemTra_DiaChi_HCM ON NHANVIEN 
FOR UPDATE
AS
BEGIN
IF (SELECT DCHI FROM inserted) LIKE '%HCM%'
BEGIN
PRINT 'Khong duoc cap nhat dia chi HCM'
ROLLBACK TRANSACTION
END
END
GO
SELECT * FROM NHANVIEN
GO
UPDATE NHANVIEN SET	LUONG = 30001 WHERE MANV = 001
GO
/*BÀI 2: Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
thêm mới nhân viên.*/
CREATE TRIGGER Dem_NamNu ON NHANVIEN 
AFTER INSERT
AS
BEGIN
DECLARE @a INT;
SELECT @a = COUNT(*) 
FROM NHANVIEN 
WHERE PHAI = 'Nam'
GROUP BY PHAI
PRINT 'So nhan vien NAM hien tai la: ' + CAST(@a AS CHAR(5));
DECLARE @b INT;
SELECT @b = COUNT (*) 
FROM NHANVIEN 
WHERE PHAI = N'Nữ'
GROUP BY PHAI
PRINT 'So nhan vien NU hien tai la: ' + CONVERT(CHAR(5), @b);
END
GO
/*BÀI 2.2: Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động
cập nhật phần giới tính nhân viên*/
CREATE TRIGGER Dem_NamNu_CapNhat ON NHANVIEN 
AFTER UPDATE
AS
BEGIN
DECLARE @a INT;
SELECT @a = COUNT(*) 
FROM NHANVIEN 
WHERE PHAI = 'Nam'
GROUP BY PHAI
PRINT 'So nhan vien NAM hien tai la: ' + CAST(@a AS CHAR(5));
DECLARE @b INT;
SELECT @b = COUNT (*) 
FROM NHANVIEN 
WHERE PHAI = N'Nữ'
GROUP BY PHAI
PRINT 'So nhan vien NU hien tai la: ' + CONVERT(CHAR(5), @b);
END
GO
/*BÀI 2.3: Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng
DEAN*/
CREATE TRIGGER DemSoLuongDeAn_Xoa ON DEAN 
AFTER DELETE 
AS
BEGIN
SELECT PHANCONG.MA_NVIEN, COUNT (*) 
FROM DEAN
INNER JOIN CONGVIEC ON DEAN.MADA = CONGVIEC.MADA
INNER JOIN PHANCONG ON CONGVIEC.MADA = PHANCONG.MADA AND CONGVIEC.STT = PHANCONG.STT
GROUP BY PHANCONG.MA_NVIEN
END
GO
DELETE FROM DEAN WHERE PHONG = 1;
GO
/*BÀI 3: Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân
viên trong bảng nhân viên.*/
CREATE TRIGGER DELETE_NhanVien_ThanNhan ON NHANVIEN
INSTEAD OF DELETE
AS
BEGIN
DELETE FROM THANNHAN WHERE MA_NVIEN IN (SELECT MA_NVIEN FROM deleted)
DELETE FROM NHANVIEN WHERE MANV IN (SELECT MANV FROM deleted)
END
GO
DELETE FROM NHANVIEN WHERE MANV ='022'
/*BÀI 3.2: Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADA
là 1.*/
CREATE TRIGGER TuDong_PhanCong ON NHANVIEN 
AFTER INSERT AS
BEGIN
INSERT INTO PHANCONG VALUES ((SELECT MANV FROM inserted),1 ,1 ,30)
END
GO