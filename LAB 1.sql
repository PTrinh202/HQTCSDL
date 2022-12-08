GO
  /** Câu 1 **/
  SELECT [HONV] as 'Họ NV',[TENLOT] as 'Tên Lót',[TENNV] as 'Tên NV',[PHG]
  FROM [QLDA].[dbo].[NHANVIEN]
  WHERE [PHG] = 4
GO
  /** Câu 2 **/
  SELECT [HONV] as 'Họ NV',[TENLOT] as 'Tên Lót',[TENNV] as 'Tên NV',[LUONG] as 'Lương'
  FROM [QLDA].[dbo].NHANVIEN
  where [LUONG]>30000
  GO
  /** Câu 3 **/
  SELECT [HONV] as 'Họ NV',[TENLOT] as 'Tên Lót',[TENNV] as 'Tên NV',[LUONG] as 'Lương',[PHG]
  FROM [QLDA].[dbo].NHANVIEN
  where ([LUONG]>30000 AND [PHG]=5) OR ([LUONG]>25000 AND [PHG]=4)
  GO
  /** Câu 4 **/
   SELECT [HONV] as 'Họ NV',[TENLOT] as 'Tên Lót',[TENNV] as 'Tên NV',[DCHI] as 'Địa Chỉ'
  FROM [QLDA].[dbo].NHANVIEN
  where [DCHI] like '%TP HCM%'
  GO
  /** Câu 5 **/
  SELECT [HONV] as 'Họ NV',[TENLOT] as 'Tên Lót',[TENNV] as 'Tên NV'
  FROM [QLDA].[dbo].NHANVIEN
  where [HONV] like 'N%'
  GO
  /** Câu 6 **/
  SELECT  [NGSINH] as 'Ngày Sinh',[DCHI] as 'Địa Chỉ'
  FROM [QLDA].[dbo].[NHANVIEN]
  where ([TENLOT]= 'Bá') AND ([TENNV] = 'Tiên')