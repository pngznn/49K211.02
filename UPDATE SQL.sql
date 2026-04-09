CREATE DATABASE CLINICARE_GROUP2;
GO

USE CLINICARE_GROUP2;
GO

/* =========================================================
   1. BẢNG DANH MỤC
   ========================================================= */

CREATE TABLE Vai_tro (
    ma_vai_tro VARCHAR(10) PRIMARY KEY,
    ten_vai_tro NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Trang_thai (
    ma_trang_thai VARCHAR(10) PRIMARY KEY,
    ten_trang_thai NVARCHAR(50) NOT NULL
);
GO

/* =========================================================
   2. BẢNG KHOA
   ========================================================= */

CREATE TABLE Khoa (
    ma_khoa VARCHAR(10) PRIMARY KEY,
    ten_khoa NVARCHAR(100) NOT NULL,
    ma_bac_si VARCHAR(10) NULL
);
GO

/* =========================================================
   3. TÀI KHOẢN VÀ THÔNG TIN NGƯỜI DÙNG
   ========================================================= */

CREATE TABLE Tai_khoan (
    ma_tai_khoan VARCHAR(10) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    ma_vai_tro VARCHAR(10) NOT NULL,
    FOREIGN KEY (ma_vai_tro) REFERENCES Vai_tro(ma_vai_tro)
);
GO

CREATE TABLE Thong_tin_nguoi_dung (
    ma_nguoi_dung VARCHAR(10) PRIMARY KEY,
    ho_ten NVARCHAR(100) NOT NULL,
    so_dien_thoai VARCHAR(15) NULL,
    gioi_tinh NVARCHAR(10) NULL,
    ngay_sinh DATE NULL,
    dia_chi NVARCHAR(MAX) NULL,
    cccd VARCHAR(20) NULL,
    chieu_cao FLOAT NULL,
    can_nang FLOAT NULL,
    nhom_mau VARCHAR(5) NULL,
    tien_su_benh NVARCHAR(MAX) NULL,
    di_ung NVARCHAR(MAX) NULL,
    ghi_chu NVARCHAR(MAX) NULL,
    ma_tai_khoan VARCHAR(10) NOT NULL,
    FOREIGN KEY (ma_tai_khoan) REFERENCES Tai_khoan(ma_tai_khoan)
);
GO

/* =========================================================
   4. BÁC SĨ
   ========================================================= */

CREATE TABLE Bac_si (
    ma_bac_si VARCHAR(10) PRIMARY KEY,
    ho_ten_bac_si NVARCHAR(100) NOT NULL,
    gioi_tinh NVARCHAR(10) NULL,
    ngay_sinh DATE NULL,
    so_dien_thoai VARCHAR(15) NULL,
    email VARCHAR(100) NULL,
    chuc_danh NVARCHAR(100) NOT NULL,
    chuyen_khoa NVARCHAR(100) NULL,
    so_nam_kinh_nghiem INT NULL,
    dia_chi NVARCHAR(MAX) NULL,
    mo_ta_kinh_nghiem NVARCHAR(MAX) NULL,
    ma_khoa VARCHAR(10) NOT NULL,
    FOREIGN KEY (ma_khoa) REFERENCES Khoa(ma_khoa)
);
GO

ALTER TABLE Khoa
ADD CONSTRAINT FK_Khoa_BacSi
FOREIGN KEY (ma_bac_si) REFERENCES Bac_si(ma_bac_si);
GO

/* =========================================================
   5. PHÒNG KHÁM
   ========================================================= */

CREATE TABLE Phong_kham (
    ma_phong VARCHAR(10) PRIMARY KEY,
    ten_phong NVARCHAR(100) NOT NULL,
    ma_khoa VARCHAR(10) NOT NULL,
    FOREIGN KEY (ma_khoa) REFERENCES Khoa(ma_khoa)
);
GO

/* =========================================================
   6. CẤU HÌNH GIỜ LÀM BÁC SĨ
   ========================================================= */

CREATE TABLE Cau_hinh_gio_lam_bac_si (
    ma_cau_hinh VARCHAR(10) PRIMARY KEY,
    ma_bac_si VARCHAR(10) NOT NULL,
    ngay_hieu_luc DATE NOT NULL,
    gio_sang_bat_dau TIME NOT NULL,
    gio_sang_ket_thuc TIME NOT NULL,
    gio_chieu_bat_dau TIME NOT NULL,
    gio_chieu_ket_thuc TIME NOT NULL,
    trang_thai NVARCHAR(20) NOT NULL DEFAULT N'Đang áp dụng',
    ngay_tao DATETIME NOT NULL DEFAULT GETDATE(),
    ngay_cap_nhat DATETIME NULL,
    ghi_chu NVARCHAR(255) NULL,

    CONSTRAINT FK_CauHinh_BacSi
        FOREIGN KEY (ma_bac_si) REFERENCES Bac_si(ma_bac_si),

    CONSTRAINT CHK_CauHinh_GioSang
        CHECK (gio_sang_ket_thuc > gio_sang_bat_dau),

    CONSTRAINT CHK_CauHinh_GioChieu
        CHECK (gio_chieu_ket_thuc > gio_chieu_bat_dau),

    CONSTRAINT CHK_CauHinh_TrangThai
        CHECK (trang_thai IN (N'Đang áp dụng', N'Hết hiệu lực'))
);
GO

CREATE UNIQUE INDEX UIX_CauHinh_BacSi_NgayHieuLuc
ON Cau_hinh_gio_lam_bac_si(ma_bac_si, ngay_hieu_luc);
GO

/* =========================================================
   7. KHUNG GIỜ KHÁM
   ========================================================= */

CREATE TABLE Khung_gio_kham (
    ma_khung_gio VARCHAR(10) PRIMARY KEY,
    thoi_luong_phut INT NOT NULL CONSTRAINT DF_KhungGio_ThoiLuong DEFAULT 30,
    ma_bac_si VARCHAR(10) NOT NULL,
    FOREIGN KEY (ma_bac_si) REFERENCES Bac_si(ma_bac_si),
    CONSTRAINT CHK_KhungGio_ThoiLuong CHECK (thoi_luong_phut > 0)
);
GO

/* =========================================================
   8. LỊCH LÀM VIỆC
   ========================================================= */

CREATE TABLE Lich_lam_viec (
    ma_lich_lam INT IDENTITY(1,1) PRIMARY KEY,
    ngay_lam_viec DATE NOT NULL,
    gio_bat_dau TIME NOT NULL,
    gio_ket_thuc TIME NOT NULL,
    ca_lam NVARCHAR(20) NOT NULL,
    ma_bac_si VARCHAR(10) NOT NULL,
    ma_phong VARCHAR(10) NOT NULL,

    CONSTRAINT FK_LLV_BacSi
        FOREIGN KEY (ma_bac_si) REFERENCES Bac_si(ma_bac_si),

    CONSTRAINT FK_LLV_Phong
        FOREIGN KEY (ma_phong) REFERENCES Phong_kham(ma_phong),

    CONSTRAINT CHK_LLV_GioHopLe
        CHECK (gio_ket_thuc > gio_bat_dau),

    CONSTRAINT CHK_LLV_CaLam
        CHECK (ca_lam IN (N'Ca sáng', N'Ca chiều'))
);
GO

CREATE UNIQUE INDEX UIX_LLV_BacSi_Ngay_Ca
ON Lich_lam_viec(ma_bac_si, ngay_lam_viec, ca_lam);
GO

CREATE UNIQUE INDEX UIX_LLV_Phong_Ngay_Ca
ON Lich_lam_viec(ma_phong, ngay_lam_viec, ca_lam);
GO

/* =========================================================
   9. LỊCH HẸN
   ========================================================= */

CREATE TABLE Lich_hen (
    ma_lich_hen VARCHAR(10) PRIMARY KEY,
    ngay_kham DATE NOT NULL,
    mo_ta_trieu_chung NVARCHAR(MAX) NULL,
    ma_tai_khoan VARCHAR(10) NOT NULL,
    ma_khung_gio VARCHAR(10) NOT NULL,
    ma_bac_si VARCHAR(10) NOT NULL,
    ma_trang_thai VARCHAR(10) NOT NULL,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat DATETIME NULL,
    gio_bat_dau_kham TIME NOT NULL,
    gio_ket_thuc_kham TIME NOT NULL,

    FOREIGN KEY (ma_tai_khoan) REFERENCES Tai_khoan(ma_tai_khoan),
    FOREIGN KEY (ma_khung_gio) REFERENCES Khung_gio_kham(ma_khung_gio),
    FOREIGN KEY (ma_bac_si) REFERENCES Bac_si(ma_bac_si),
    FOREIGN KEY (ma_trang_thai) REFERENCES Trang_thai(ma_trang_thai),

    CONSTRAINT CHK_LichHen_GioHopLe
        CHECK (gio_ket_thuc_kham > gio_bat_dau_kham)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UIX_LichHen_KhongTrung
ON Lich_hen (ma_bac_si, ma_khung_gio, ngay_kham)
WHERE ma_trang_thai = 'TT01';
GO

/* =========================================================
   10. DỮ LIỆU CƠ BẢN
   ========================================================= */

INSERT INTO Vai_tro (ma_vai_tro, ten_vai_tro) VALUES
('VT01', N'Quản trị viên'),
('VT02', N'Bệnh nhân');
GO

INSERT INTO Trang_thai (ma_trang_thai, ten_trang_thai) VALUES
('TT01', N'Đã xác nhận'),
('TT02', N'Đã hủy'),
('TT03', N'Đã khám xong'),
('TT04', N'Chờ xác nhận');
GO

INSERT INTO Tai_khoan (ma_tai_khoan, email, mat_khau, ma_vai_tro) VALUES
('TK001', 'admin@gmail.com', '123', 'VT01');
GO

INSERT INTO Thong_tin_nguoi_dung (
    ma_nguoi_dung, ho_ten, so_dien_thoai, ma_tai_khoan
) VALUES
('ND001', N'Quản trị viên', '0900000000', 'TK001');
GO

/* =========================================================
   11. PROCEDURE: TỰ ĐỘNG CẬP NHẬT LỊCH HẸN ĐÃ KHÁM XONG
   ========================================================= */

DROP PROCEDURE IF EXISTS dbo.sp_AutoUpdateCompletedAppointments;
GO

CREATE PROCEDURE dbo.sp_AutoUpdateCompletedAppointments
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Lich_hen
    SET ma_trang_thai = 'TT03',
        ngay_cap_nhat = GETDATE()
    WHERE ma_trang_thai = 'TT01'
      AND (
            ngay_kham < CAST(GETDATE() AS DATE)
            OR (
                ngay_kham = CAST(GETDATE() AS DATE)
                AND gio_ket_thuc_kham < CAST(GETDATE() AS TIME)
            )
          );
END;
GO

/* =========================================================
   12. PROCEDURE: TẠO LỊCH MẶC ĐỊNH CHO 1 BÁC SĨ
   Chỉ tạo từ THỨ 2 đến THỨ 6
   Gán phòng đúng theo khoa và thứ tự trong khoa
   ========================================================= */

DROP PROCEDURE IF EXISTS dbo.sp_TaoLichMacDinhChoBacSi;
GO

CREATE PROCEDURE dbo.sp_TaoLichMacDinhChoBacSi
    @ma_bac_si VARCHAR(10),
    @tu_ngay DATE,
    @so_ngay INT = 30
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFIRST 1;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Bac_si
        WHERE ma_bac_si = @ma_bac_si
    )
    BEGIN
        RAISERROR (N'Bác sĩ không tồn tại.', 16, 1);
        RETURN;
    END

    DECLARE @ma_phong VARCHAR(10);

    ;WITH BacSiTheoKhoa AS (
        SELECT 
            ma_bac_si,
            ma_khoa,
            ROW_NUMBER() OVER (PARTITION BY ma_khoa ORDER BY ma_bac_si) AS stt_bac_si
        FROM dbo.Bac_si
    ),
    PhongTheoKhoa AS (
        SELECT 
            ma_phong,
            ma_khoa,
            ROW_NUMBER() OVER (PARTITION BY ma_khoa ORDER BY ma_phong) AS stt_phong
        FROM dbo.Phong_kham
    )
    SELECT @ma_phong = p.ma_phong
    FROM BacSiTheoKhoa b
    INNER JOIN PhongTheoKhoa p
        ON b.ma_khoa = p.ma_khoa
       AND b.stt_bac_si = p.stt_phong
    WHERE b.ma_bac_si = @ma_bac_si;

    IF @ma_phong IS NULL
    BEGIN
        RAISERROR (N'Không tìm thấy phòng phù hợp cho bác sĩ trong khoa.', 16, 1);
        RETURN;
    END

    ;WITH NgayLam AS (
        SELECT @tu_ngay AS ngay_lam_viec
        UNION ALL
        SELECT DATEADD(DAY, 1, ngay_lam_viec)
        FROM NgayLam
        WHERE ngay_lam_viec < DATEADD(DAY, @so_ngay - 1, @tu_ngay)
    )
    INSERT INTO dbo.Lich_lam_viec (
        ngay_lam_viec,
        gio_bat_dau,
        gio_ket_thuc,
        ca_lam,
        ma_bac_si,
        ma_phong
    )
    SELECT
        ngay_lam_viec,
        '07:00:00',
        '11:00:00',
        N'Ca sáng',
        @ma_bac_si,
        @ma_phong
    FROM NgayLam
    WHERE DATEPART(WEEKDAY, ngay_lam_viec) BETWEEN 1 AND 5
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.Lich_lam_viec llv
          WHERE llv.ma_bac_si = @ma_bac_si
            AND llv.ngay_lam_viec = NgayLam.ngay_lam_viec
            AND llv.ca_lam = N'Ca sáng'
      )

    UNION ALL

    SELECT
        ngay_lam_viec,
        '13:30:00',
        '16:30:00',
        N'Ca chiều',
        @ma_bac_si,
        @ma_phong
    FROM NgayLam
    WHERE DATEPART(WEEKDAY, ngay_lam_viec) BETWEEN 1 AND 5
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.Lich_lam_viec llv
          WHERE llv.ma_bac_si = @ma_bac_si
            AND llv.ngay_lam_viec = NgayLam.ngay_lam_viec
            AND llv.ca_lam = N'Ca chiều'
      )
    OPTION (MAXRECURSION 1000);
END;
GO

/* =========================================================
   13. PROCEDURE: TẠO LỊCH MẶC ĐỊNH CHO TẤT CẢ BÁC SĨ
   ========================================================= */

DROP PROCEDURE IF EXISTS dbo.sp_TaoLichMacDinhChoTatCaBacSi;
GO

CREATE PROCEDURE dbo.sp_TaoLichMacDinhChoTatCaBacSi
    @tu_ngay DATE,
    @so_ngay INT = 30
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ma_bac_si VARCHAR(10);

    DECLARE cur CURSOR FOR
        SELECT ma_bac_si
        FROM dbo.Bac_si
        ORDER BY ma_bac_si;

    OPEN cur;
    FETCH NEXT FROM cur INTO @ma_bac_si;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.sp_TaoLichMacDinhChoBacSi
            @ma_bac_si = @ma_bac_si,
            @tu_ngay = @tu_ngay,
            @so_ngay = @so_ngay;

        FETCH NEXT FROM cur INTO @ma_bac_si;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;
GO

/* =========================================================
   14. PROCEDURE: ĐỔI GIỜ LÀM BÁC SĨ THEO NGÀY HIỆU LỰC
   Chỉ tạo từ THỨ 2 đến THỨ 6
   Gán phòng đúng theo khoa và thứ tự trong khoa
   ========================================================= */

DROP PROCEDURE IF EXISTS dbo.sp_DoiGioLamBacSi;
GO

CREATE PROCEDURE dbo.sp_DoiGioLamBacSi
    @ma_cau_hinh VARCHAR(10),
    @ma_bac_si VARCHAR(10),
    @ngay_hieu_luc DATE,
    @gio_sang_bat_dau TIME,
    @gio_sang_ket_thuc TIME,
    @gio_chieu_bat_dau TIME,
    @gio_chieu_ket_thuc TIME,
    @so_ngay_tao_lich INT = 30,
    @ghi_chu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFIRST 1;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Bac_si
        WHERE ma_bac_si = @ma_bac_si
    )
    BEGIN
        RAISERROR (N'Bác sĩ không tồn tại.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.Cau_hinh_gio_lam_bac_si
        WHERE ma_cau_hinh = @ma_cau_hinh
    )
    BEGIN
        RAISERROR (N'Mã cấu hình đã tồn tại.', 16, 1);
        RETURN;
    END

    IF @ngay_hieu_luc < CAST(GETDATE() AS DATE)
    BEGIN
        RAISERROR (N'Ngày hiệu lực không được ở quá khứ.', 16, 1);
        RETURN;
    END

    IF @gio_sang_ket_thuc <= @gio_sang_bat_dau
    BEGIN
        RAISERROR (N'Giờ ca sáng không hợp lệ.', 16, 1);
        RETURN;
    END

    IF @gio_chieu_ket_thuc <= @gio_chieu_bat_dau
    BEGIN
        RAISERROR (N'Giờ ca chiều không hợp lệ.', 16, 1);
        RETURN;
    END

    IF @gio_sang_ket_thuc > @gio_chieu_bat_dau
    BEGIN
        RAISERROR (N'Ca sáng và ca chiều bị chồng giờ.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.Lich_hen
        WHERE ma_bac_si = @ma_bac_si
          AND ma_trang_thai = 'TT01'
          AND ngay_kham >= @ngay_hieu_luc
          AND NOT (
                (gio_bat_dau_kham >= @gio_sang_bat_dau AND gio_ket_thuc_kham <= @gio_sang_ket_thuc)
                OR
                (gio_bat_dau_kham >= @gio_chieu_bat_dau AND gio_ket_thuc_kham <= @gio_chieu_ket_thuc)
          )
    )
    BEGIN
        RAISERROR (N'Có lịch hẹn đã xác nhận không còn phù hợp với giờ làm mới.', 16, 1);
        RETURN;
    END

    UPDATE dbo.Cau_hinh_gio_lam_bac_si
    SET trang_thai = N'Hết hiệu lực',
        ngay_cap_nhat = GETDATE()
    WHERE ma_bac_si = @ma_bac_si
      AND trang_thai = N'Đang áp dụng';

    INSERT INTO dbo.Cau_hinh_gio_lam_bac_si (
        ma_cau_hinh,
        ma_bac_si,
        ngay_hieu_luc,
        gio_sang_bat_dau,
        gio_sang_ket_thuc,
        gio_chieu_bat_dau,
        gio_chieu_ket_thuc,
        trang_thai,
        ngay_tao,
        ghi_chu
    )
    VALUES (
        @ma_cau_hinh,
        @ma_bac_si,
        @ngay_hieu_luc,
        @gio_sang_bat_dau,
        @gio_sang_ket_thuc,
        @gio_chieu_bat_dau,
        @gio_chieu_ket_thuc,
        N'Đang áp dụng',
        GETDATE(),
        @ghi_chu
    );

    DECLARE @ma_phong VARCHAR(10);

    ;WITH BacSiTheoKhoa AS (
        SELECT 
            ma_bac_si,
            ma_khoa,
            ROW_NUMBER() OVER (PARTITION BY ma_khoa ORDER BY ma_bac_si) AS stt_bac_si
        FROM dbo.Bac_si
    ),
    PhongTheoKhoa AS (
        SELECT 
            ma_phong,
            ma_khoa,
            ROW_NUMBER() OVER (PARTITION BY ma_khoa ORDER BY ma_phong) AS stt_phong
        FROM dbo.Phong_kham
    )
    SELECT @ma_phong = p.ma_phong
    FROM BacSiTheoKhoa b
    INNER JOIN PhongTheoKhoa p
        ON b.ma_khoa = p.ma_khoa
       AND b.stt_bac_si = p.stt_phong
    WHERE b.ma_bac_si = @ma_bac_si;

    IF @ma_phong IS NULL
    BEGIN
        RAISERROR (N'Không tìm thấy phòng phù hợp cho bác sĩ trong khoa.', 16, 1);
        RETURN;
    END

    DELETE FROM dbo.Lich_lam_viec
    WHERE ma_bac_si = @ma_bac_si
      AND ngay_lam_viec >= @ngay_hieu_luc;

    ;WITH NgayLam AS (
        SELECT @ngay_hieu_luc AS ngay_lam_viec
        UNION ALL
        SELECT DATEADD(DAY, 1, ngay_lam_viec)
        FROM NgayLam
        WHERE ngay_lam_viec < DATEADD(DAY, @so_ngay_tao_lich - 1, @ngay_hieu_luc)
    )
    INSERT INTO dbo.Lich_lam_viec (
        ngay_lam_viec,
        gio_bat_dau,
        gio_ket_thuc,
        ca_lam,
        ma_bac_si,
        ma_phong
    )
    SELECT
        ngay_lam_viec,
        @gio_sang_bat_dau,
        @gio_sang_ket_thuc,
        N'Ca sáng',
        @ma_bac_si,
        @ma_phong
    FROM NgayLam
    WHERE DATEPART(WEEKDAY, ngay_lam_viec) BETWEEN 1 AND 5

    UNION ALL

    SELECT
        ngay_lam_viec,
        @gio_chieu_bat_dau,
        @gio_chieu_ket_thuc,
        N'Ca chiều',
        @ma_bac_si,
        @ma_phong
    FROM NgayLam
    WHERE DATEPART(WEEKDAY, ngay_lam_viec) BETWEEN 1 AND 5
    OPTION (MAXRECURSION 1000);
END;
GO

EXEC dbo.sp_TaoLichMacDinhChoTatCaBacSi
    @tu_ngay = '2026-04-08',
    @so_ngay = 30;
GO

SELECT COUNT(*) AS tong_lich
FROM dbo.Lich_lam_viec;
GO

SELECT TOP 50 *
FROM dbo.Lich_lam_viec
ORDER BY ma_bac_si, ngay_lam_viec, ca_lam;
GO
USE CLINICARE_GROUP2;
GO
INSERT INTO Khoa (ma_khoa, ten_khoa) VALUES
('K01', N'Khoa Nội'),
('K02', N'Khoa Ngoại'),
('K03', N'Khoa Nhi'),
('K04', N'Khoa Tim mạch'),
('K05', N'Khoa Tiêu hóa'),
('K06', N'Khoa Da liễu'),
('K07', N'Khoa Hô hấp'),
('K08', N'Khoa Tai Mũi Họng'),
('K09', N'Khoa Sản'),
('K10', N'Khoa Răng Hàm Mặt'),
('K11', N'Khoa Thần kinh'),
('K12', N'Khoa Tiết niệu'),
('K13', N'Khoa Nam khoa'),
('K14', N'Khoa Ung bướu'),
('K15', N'Khoa Chấn thương chỉnh hình'),
('K16', N'Khoa Hồi sức cấp cứu'),
('K17', N'Khoa Chẩn đoán hình ảnh'),
('K18', N'Khoa Dinh dưỡng'),
('K19', N'Khoa Vật lý trị liệu');
GO

/* =========================
   2. INSERT 95 BÁC SĨ
   ========================= */
INSERT INTO Bac_si (
    ma_bac_si,
    ho_ten_bac_si,
    gioi_tinh,
    ngay_sinh,
    so_dien_thoai,
    email,
    chuc_danh,
    chuyen_khoa,
    so_nam_kinh_nghiem,
    dia_chi,
    mo_ta_kinh_nghiem,
    ma_khoa
) VALUES
-- K01 - Khoa Nội
('BS01', N'Nguyễn Văn An', N'Nam', CONVERT(DATE,'12/03/1978',103), '0901000001', 'bs01@clinicare.vn', N'Trưởng khoa', N'Nội tổng quát', 18, N'Hà Nội', N'Bác sĩ có nhiều năm kinh nghiệm trong điều trị bệnh lý nội khoa tổng quát.', 'K01'),
('BS02', N'Trần Thị Bình', N'Nữ', CONVERT(DATE,'21/07/1985',103), '0901000002', 'bs02@clinicare.vn', N'Bác sĩ', N'Nội tổng quát', 11, N'Hà Nội', N'Chuyên khám và theo dõi các bệnh lý nội khoa thường gặp.', 'K01'),
('BS03', N'Lê Văn Cường', N'Nam', CONVERT(DATE,'05/11/1987',103), '0901000003', 'bs03@clinicare.vn', N'Bác sĩ', N'Nội tổng quát', 9, N'Hà Nội', N'Có kinh nghiệm trong tư vấn và điều trị bệnh nội khoa cho người lớn tuổi.', 'K01'),
('BS04', N'Phạm Thị Dung', N'Nữ', CONVERT(DATE,'15/01/1990',103), '0901000004', 'bs04@clinicare.vn', N'Bác sĩ', N'Nội tổng quát', 7, N'Hà Nội', N'Tận tâm trong chăm sóc và điều trị bệnh nhân nội trú và ngoại trú.', 'K01'),
('BS05', N'Hoàng Minh Đức', N'Nam', CONVERT(DATE,'09/09/1988',103), '0901000005', 'bs05@clinicare.vn', N'Bác sĩ', N'Nội tổng quát', 10, N'Hà Nội', N'Chuyên theo dõi, đánh giá và lập phác đồ điều trị nội khoa.', 'K01'),

-- K02 - Khoa Ngoại
('BS06', N'Vũ Quốc Hùng', N'Nam', CONVERT(DATE,'18/02/1977',103), '0901000006', 'bs06@clinicare.vn', N'Trưởng khoa', N'Ngoại tổng quát', 19, N'Hồ Chí Minh', N'Có kinh nghiệm phẫu thuật và điều trị các bệnh lý ngoại khoa tổng quát.', 'K02'),
('BS07', N'Ngô Thị Lan', N'Nữ', CONVERT(DATE,'25/05/1986',103), '0901000007', 'bs07@clinicare.vn', N'Bác sĩ', N'Ngoại tổng quát', 11, N'Hồ Chí Minh', N'Chuyên khám tiền phẫu và hậu phẫu cho bệnh nhân ngoại khoa.', 'K02'),
('BS08', N'Đặng Văn Khoa', N'Nam', CONVERT(DATE,'14/08/1984',103), '0901000008', 'bs08@clinicare.vn', N'Bác sĩ', N'Ngoại tổng quát', 12, N'Hồ Chí Minh', N'Có kinh nghiệm trong xử trí các ca phẫu thuật ngoại khoa phổ biến.', 'K02'),
('BS09', N'Bùi Thị Mai', N'Nữ', CONVERT(DATE,'03/12/1989',103), '0901000009', 'bs09@clinicare.vn', N'Bác sĩ', N'Ngoại tổng quát', 8, N'Hồ Chí Minh', N'Thực hiện khám, tư vấn và theo dõi sau điều trị ngoại khoa.', 'K02'),
('BS10', N'Phan Văn Nam', N'Nam', CONVERT(DATE,'27/04/1991',103), '0901000010', 'bs10@clinicare.vn', N'Bác sĩ', N'Ngoại tổng quát', 6, N'Hồ Chí Minh', N'Phụ trách khám và hỗ trợ điều trị bệnh lý ngoại khoa.', 'K02'),

-- K03 - Khoa Nhi
('BS11', N'Nguyễn Thị Hạnh', N'Nữ', CONVERT(DATE,'10/06/1979',103), '0901000011', 'bs11@clinicare.vn', N'Trưởng khoa', N'Nhi khoa', 17, N'Đà Nẵng', N'Có nhiều kinh nghiệm trong điều trị bệnh lý trẻ em và tư vấn dinh dưỡng.', 'K03'),
('BS12', N'Trương Văn Phúc', N'Nam', CONVERT(DATE,'20/10/1988',103), '0901000012', 'bs12@clinicare.vn', N'Bác sĩ', N'Nhi khoa', 9, N'Đà Nẵng', N'Chuyên khám và điều trị các bệnh nhiễm khuẩn hô hấp ở trẻ.', 'K03'),
('BS13', N'Đỗ Thị Quỳnh', N'Nữ', CONVERT(DATE,'30/03/1990',103), '0901000013', 'bs13@clinicare.vn', N'Bác sĩ', N'Nhi khoa', 7, N'Đà Nẵng', N'Bác sĩ tận tâm trong chăm sóc sức khỏe trẻ sơ sinh và trẻ nhỏ.', 'K03'),
('BS14', N'Lý Văn Sơn', N'Nam', CONVERT(DATE,'07/07/1987',103), '0901000014', 'bs14@clinicare.vn', N'Bác sĩ', N'Nhi khoa', 10, N'Đà Nẵng', N'Có kinh nghiệm trong theo dõi tăng trưởng và phát triển của trẻ.', 'K03'),
('BS15', N'Phạm Ngọc Ánh', N'Nữ', CONVERT(DATE,'11/11/1992',103), '0901000015', 'bs15@clinicare.vn', N'Bác sĩ', N'Nhi khoa', 5, N'Đà Nẵng', N'Chuyên khám sức khỏe tổng quát và tiêm chủng cho trẻ em.', 'K03'),

-- K04 - Khoa Tim mạch
('BS16', N'Đinh Văn Long', N'Nam', CONVERT(DATE,'22/01/1976',103), '0901000016', 'bs16@clinicare.vn', N'Trưởng khoa', N'Tim mạch', 20, N'Cần Thơ', N'Chuyên sâu trong chẩn đoán và điều trị các bệnh lý tim mạch.', 'K04'),
('BS17', N'Tạ Thị Yến', N'Nữ', CONVERT(DATE,'18/09/1985',103), '0901000017', 'bs17@clinicare.vn', N'Bác sĩ', N'Tim mạch', 11, N'Cần Thơ', N'Có kinh nghiệm điều trị tăng huyết áp và rối loạn nhịp tim.', 'K04'),
('BS18', N'Mai Quốc Bảo', N'Nam', CONVERT(DATE,'29/12/1988',103), '0901000018', 'bs18@clinicare.vn', N'Bác sĩ', N'Tim mạch', 8, N'Cần Thơ', N'Chuyên khám lâm sàng và cận lâm sàng bệnh tim mạch.', 'K04'),
('BS19', N'Nguyễn Thị Thu', N'Nữ', CONVERT(DATE,'13/02/1991',103), '0901000019', 'bs19@clinicare.vn', N'Bác sĩ', N'Tim mạch', 6, N'Cần Thơ', N'Bác sĩ theo dõi và quản lý điều trị tim mạch mãn tính.', 'K04'),
('BS20', N'Võ Minh Tâm', N'Nam', CONVERT(DATE,'06/06/1989',103), '0901000020', 'bs20@clinicare.vn', N'Bác sĩ', N'Tim mạch', 9, N'Cần Thơ', N'Có kinh nghiệm trong siêu âm tim và tư vấn điều trị bệnh mạch vành.', 'K04'),

-- K05 - Khoa Tiêu hóa
('BS21', N'Lê Thị Hoa', N'Nữ', CONVERT(DATE,'04/04/1978',103), '0901000021', 'bs21@clinicare.vn', N'Trưởng khoa', N'Tiêu hóa', 18, N'Hải Phòng', N'Chuyên sâu về bệnh lý tiêu hóa, gan mật và nội soi chẩn đoán.', 'K05'),
('BS22', N'Phạm Văn Hiếu', N'Nam', CONVERT(DATE,'16/08/1986',103), '0901000022', 'bs22@clinicare.vn', N'Bác sĩ', N'Tiêu hóa', 11, N'Hải Phòng', N'Khám và điều trị các bệnh lý dạ dày, tá tràng, đại tràng.', 'K05'),
('BS23', N'Ngô Thị Huyền', N'Nữ', CONVERT(DATE,'08/01/1989',103), '0901000023', 'bs23@clinicare.vn', N'Bác sĩ', N'Tiêu hóa', 8, N'Hải Phòng', N'Có kinh nghiệm trong tư vấn chế độ ăn và điều trị bệnh lý tiêu hóa.', 'K05'),
('BS24', N'Trần Đức Khánh', N'Nam', CONVERT(DATE,'10/10/1990',103), '0901000024', 'bs24@clinicare.vn', N'Bác sĩ', N'Tiêu hóa', 7, N'Hải Phòng', N'Phụ trách khám nội tiêu hóa và theo dõi điều trị nội trú.', 'K05'),
('BS25', N'Bùi Thị Nhung', N'Nữ', CONVERT(DATE,'19/05/1992',103), '0901000025', 'bs25@clinicare.vn', N'Bác sĩ', N'Tiêu hóa', 5, N'Hải Phòng', N'Chuyên khám các triệu chứng rối loạn tiêu hóa và tư vấn điều trị.', 'K05'),

-- K06 - Khoa Da liễu
('BS26', N'Nguyễn Quốc Việt', N'Nam', CONVERT(DATE,'14/07/1980',103), '0901000026', 'bs26@clinicare.vn', N'Trưởng khoa', N'Da liễu', 16, N'Nghệ An', N'Có kinh nghiệm điều trị bệnh da liễu, dị ứng và các vấn đề về da mạn tính.', 'K06'),
('BS27', N'Trần Thị Ngọc', N'Nữ', CONVERT(DATE,'03/03/1987',103), '0901000027', 'bs27@clinicare.vn', N'Bác sĩ', N'Da liễu', 10, N'Nghệ An', N'Chuyên khám và điều trị mụn, viêm da, dị ứng da.', 'K06'),
('BS28', N'Lê Văn Phong', N'Nam', CONVERT(DATE,'24/11/1988',103), '0901000028', 'bs28@clinicare.vn', N'Bác sĩ', N'Da liễu', 9, N'Nghệ An', N'Có kinh nghiệm trong tư vấn chăm sóc và điều trị bệnh da thường gặp.', 'K06'),
('BS29', N'Phạm Thị Sen', N'Nữ', CONVERT(DATE,'01/09/1991',103), '0901000029', 'bs29@clinicare.vn', N'Bác sĩ', N'Da liễu', 6, N'Nghệ An', N'Chuyên theo dõi điều trị bệnh lý da liễu ở trẻ em và người lớn.', 'K06'),
('BS30', N'Đỗ Minh Tuấn', N'Nam', CONVERT(DATE,'12/12/1990',103), '0901000030', 'bs30@clinicare.vn', N'Bác sĩ', N'Da liễu', 7, N'Nghệ An', N'Phụ trách khám da, nấm da và các bệnh da liễu theo mùa.', 'K06'),

-- K07 - Khoa Hô hấp
('BS31', N'Vũ Thị Hà', N'Nữ', CONVERT(DATE,'08/08/1979',103), '0901000031', 'bs31@clinicare.vn', N'Trưởng khoa', N'Hô hấp', 17, N'Thanh Hóa', N'Chuyên điều trị hen suyễn, COPD và các bệnh lý hô hấp mãn tính.', 'K07'),
('BS32', N'Nguyễn Văn Hòa', N'Nam', CONVERT(DATE,'28/06/1986',103), '0901000032', 'bs32@clinicare.vn', N'Bác sĩ', N'Hô hấp', 11, N'Thanh Hóa', N'Có kinh nghiệm trong khám và điều trị bệnh hô hấp cấp tính.', 'K07'),
('BS33', N'Hoàng Thị Liên', N'Nữ', CONVERT(DATE,'17/02/1989',103), '0901000033', 'bs33@clinicare.vn', N'Bác sĩ', N'Hô hấp', 8, N'Thanh Hóa', N'Chuyên tư vấn và quản lý điều trị các bệnh phổi mạn tính.', 'K07'),
('BS34', N'Phan Văn Lực', N'Nam', CONVERT(DATE,'09/04/1990',103), '0901000034', 'bs34@clinicare.vn', N'Bác sĩ', N'Hô hấp', 7, N'Thanh Hóa', N'Phụ trách khám, đọc kết quả cận lâm sàng và hỗ trợ chẩn đoán hô hấp.', 'K07'),
('BS35', N'Trịnh Thị Oanh', N'Nữ', CONVERT(DATE,'23/10/1992',103), '0901000035', 'bs35@clinicare.vn', N'Bác sĩ', N'Hô hấp', 5, N'Thanh Hóa', N'Có kinh nghiệm điều trị các bệnh nhiễm khuẩn đường hô hấp.', 'K07'),

-- K08 - Khoa Tai Mũi Họng
('BS36', N'Nguyễn Thanh Phú', N'Nam', CONVERT(DATE,'30/01/1977',103), '0901000036', 'bs36@clinicare.vn', N'Trưởng khoa', N'Tai Mũi Họng', 19, N'Bình Dương', N'Chuyên sâu về bệnh lý tai mũi họng và can thiệp thủ thuật chuyên khoa.', 'K08'),
('BS37', N'Lê Thị Thảo', N'Nữ', CONVERT(DATE,'12/09/1986',103), '0901000037', 'bs37@clinicare.vn', N'Bác sĩ', N'Tai Mũi Họng', 11, N'Bình Dương', N'Khám và điều trị viêm họng, viêm mũi xoang, viêm tai giữa.', 'K08'),
('BS38', N'Trần Quốc Thịnh', N'Nam', CONVERT(DATE,'01/07/1988',103), '0901000038', 'bs38@clinicare.vn', N'Bác sĩ', N'Tai Mũi Họng', 9, N'Bình Dương', N'Có kinh nghiệm trong nội soi tai mũi họng và điều trị bệnh lý mũi xoang.', 'K08'),
('BS39', N'Ngô Thị Vân', N'Nữ', CONVERT(DATE,'18/03/1991',103), '0901000039', 'bs39@clinicare.vn', N'Bác sĩ', N'Tai Mũi Họng', 6, N'Bình Dương', N'Phụ trách khám các bệnh lý đường hô hấp trên và tai mũi họng.', 'K08'),
('BS40', N'Đặng Minh Hoàng', N'Nam', CONVERT(DATE,'29/11/1990',103), '0901000040', 'bs40@clinicare.vn', N'Bác sĩ', N'Tai Mũi Họng', 7, N'Bình Dương', N'Chuyên điều trị các bệnh lý viêm nhiễm tai mũi họng thường gặp.', 'K08'),

-- K09 - Khoa Sản
('BS41', N'Phạm Thị Hương', N'Nữ', CONVERT(DATE,'05/12/1978',103), '0901000041', 'bs41@clinicare.vn', N'Trưởng khoa', N'Sản phụ khoa', 18, N'Đồng Nai', N'Có kinh nghiệm lâu năm trong chăm sóc thai kỳ và điều trị sản phụ khoa.', 'K09'),
('BS42', N'Nguyễn Văn Khôi', N'Nam', CONVERT(DATE,'20/04/1985',103), '0901000042', 'bs42@clinicare.vn', N'Bác sĩ', N'Sản phụ khoa', 12, N'Đồng Nai', N'Chuyên khám thai, siêu âm sản khoa và theo dõi sức khỏe thai phụ.', 'K09'),
('BS43', N'Lê Thị Mỹ', N'Nữ', CONVERT(DATE,'15/06/1989',103), '0901000043', 'bs43@clinicare.vn', N'Bác sĩ', N'Sản phụ khoa', 8, N'Đồng Nai', N'Phụ trách khám phụ khoa định kỳ và tư vấn sức khỏe sinh sản.', 'K09'),
('BS44', N'Bùi Văn Quang', N'Nam', CONVERT(DATE,'22/08/1990',103), '0901000044', 'bs44@clinicare.vn', N'Bác sĩ', N'Sản phụ khoa', 7, N'Đồng Nai', N'Có kinh nghiệm trong theo dõi thai kỳ và xử trí tình huống sản khoa.', 'K09'),
('BS45', N'Trần Thị Yến Nhi', N'Nữ', CONVERT(DATE,'09/02/1992',103), '0901000045', 'bs45@clinicare.vn', N'Bác sĩ', N'Sản phụ khoa', 5, N'Đồng Nai', N'Chuyên tư vấn tiền sản, hậu sản và chăm sóc sức khỏe phụ nữ.', 'K09'),

-- K10 - Khoa Răng Hàm Mặt
('BS46', N'Đỗ Văn Thành', N'Nam', CONVERT(DATE,'27/03/1979',103), '0901000046', 'bs46@clinicare.vn', N'Trưởng khoa', N'Răng Hàm Mặt', 17, N'Khánh Hòa', N'Có kinh nghiệm trong điều trị nha khoa tổng quát và phục hình răng.', 'K10'),
('BS47', N'Nguyễn Thị Kim', N'Nữ', CONVERT(DATE,'14/05/1987',103), '0901000047', 'bs47@clinicare.vn', N'Bác sĩ', N'Răng Hàm Mặt', 10, N'Khánh Hòa', N'Chuyên khám răng định kỳ, tư vấn và điều trị sâu răng.', 'K10'),
('BS48', N'Lê Minh Tân', N'Nam', CONVERT(DATE,'26/09/1988',103), '0901000048', 'bs48@clinicare.vn', N'Bác sĩ', N'Răng Hàm Mặt', 9, N'Khánh Hòa', N'Có kinh nghiệm trong nhổ răng, điều trị tủy và chăm sóc nha chu.', 'K10'),
('BS49', N'Phạm Thị Trang', N'Nữ', CONVERT(DATE,'06/01/1991',103), '0901000049', 'bs49@clinicare.vn', N'Bác sĩ', N'Răng Hàm Mặt', 6, N'Khánh Hòa', N'Chuyên điều trị các bệnh lý răng miệng phổ biến.', 'K10'),
('BS50', N'Võ Quốc Duy', N'Nam', CONVERT(DATE,'17/10/1990',103), '0901000050', 'bs50@clinicare.vn', N'Bác sĩ', N'Răng Hàm Mặt', 7, N'Khánh Hòa', N'Phụ trách tư vấn, khám và lập kế hoạch điều trị nha khoa.', 'K10'),

-- K11 - Khoa Thần kinh
('BS51', N'Trần Văn Bách', N'Nam', CONVERT(DATE,'19/07/1977',103), '0901000051', 'bs51@clinicare.vn', N'Trưởng khoa', N'Thần kinh', 19, N'Quảng Ninh', N'Chuyên sâu trong điều trị bệnh lý thần kinh trung ương và ngoại biên.', 'K11'),
('BS52', N'Nguyễn Thị Giang', N'Nữ', CONVERT(DATE,'08/12/1986',103), '0901000052', 'bs52@clinicare.vn', N'Bác sĩ', N'Thần kinh', 11, N'Quảng Ninh', N'Có kinh nghiệm trong khám đau đầu, rối loạn giấc ngủ và chóng mặt.', 'K11'),
('BS53', N'Phan Văn Hưng', N'Nam', CONVERT(DATE,'02/03/1988',103), '0901000053', 'bs53@clinicare.vn', N'Bác sĩ', N'Thần kinh', 9, N'Quảng Ninh', N'Chuyên theo dõi và điều trị bệnh lý thần kinh mãn tính.', 'K11'),
('BS54', N'Bùi Thị Hồng', N'Nữ', CONVERT(DATE,'13/09/1991',103), '0901000054', 'bs54@clinicare.vn', N'Bác sĩ', N'Thần kinh', 6, N'Quảng Ninh', N'Phụ trách khám thần kinh lâm sàng và đánh giá triệu chứng thần kinh.', 'K11'),
('BS55', N'Đặng Quốc Khải', N'Nam', CONVERT(DATE,'21/11/1990',103), '0901000055', 'bs55@clinicare.vn', N'Bác sĩ', N'Thần kinh', 7, N'Quảng Ninh', N'Có kinh nghiệm trong tư vấn điều trị bệnh lý thần kinh thường gặp.', 'K11'),

-- K12 - Khoa Tiết niệu
('BS56', N'Ngô Văn Lâm', N'Nam', CONVERT(DATE,'11/05/1978',103), '0901000056', 'bs56@clinicare.vn', N'Trưởng khoa', N'Tiết niệu', 18, N'Bắc Ninh', N'Chuyên điều trị bệnh lý thận tiết niệu và các rối loạn đường tiểu.', 'K12'),
('BS57', N'Lê Thị Loan', N'Nữ', CONVERT(DATE,'28/08/1987',103), '0901000057', 'bs57@clinicare.vn', N'Bác sĩ', N'Tiết niệu', 10, N'Bắc Ninh', N'Khám và điều trị các bệnh lý nhiễm khuẩn đường tiết niệu.', 'K12'),
('BS58', N'Nguyễn Minh Phát', N'Nam', CONVERT(DATE,'30/10/1988',103), '0901000058', 'bs58@clinicare.vn', N'Bác sĩ', N'Tiết niệu', 9, N'Bắc Ninh', N'Có kinh nghiệm trong khám sỏi tiết niệu và rối loạn tiểu tiện.', 'K12'),
('BS59', N'Phạm Thị Tuyết', N'Nữ', CONVERT(DATE,'04/06/1991',103), '0901000059', 'bs59@clinicare.vn', N'Bác sĩ', N'Tiết niệu', 6, N'Bắc Ninh', N'Phụ trách khám và tư vấn chăm sóc tiết niệu cho người bệnh.', 'K12'),
('BS60', N'Vũ Đức Mạnh', N'Nam', CONVERT(DATE,'14/02/1990',103), '0901000060', 'bs60@clinicare.vn', N'Bác sĩ', N'Tiết niệu', 7, N'Bắc Ninh', N'Chuyên hỗ trợ chẩn đoán và điều trị các bệnh lý tiết niệu.', 'K12'),

-- K13 - Khoa Nam khoa
('BS61', N'Nguyễn Thành Trung', N'Nam', CONVERT(DATE,'09/01/1979',103), '0901000061', 'bs61@clinicare.vn', N'Trưởng khoa', N'Nam khoa', 17, N'Hưng Yên', N'Có kinh nghiệm trong khám và điều trị các bệnh lý nam khoa.', 'K13'),
('BS62', N'Trần Quốc Vinh', N'Nam', CONVERT(DATE,'17/03/1986',103), '0901000062', 'bs62@clinicare.vn', N'Bác sĩ', N'Nam khoa', 11, N'Hưng Yên', N'Chuyên tư vấn sức khỏe sinh sản nam giới và điều trị nam khoa.', 'K13'),
('BS63', N'Phạm Minh Nhật', N'Nam', CONVERT(DATE,'25/07/1988',103), '0901000063', 'bs63@clinicare.vn', N'Bác sĩ', N'Nam khoa', 9, N'Hưng Yên', N'Có kinh nghiệm điều trị rối loạn chức năng sinh lý nam.', 'K13'),
('BS64', N'Lê Văn Tùng', N'Nam', CONVERT(DATE,'12/10/1991',103), '0901000064', 'bs64@clinicare.vn', N'Bác sĩ', N'Nam khoa', 6, N'Hưng Yên', N'Khám và theo dõi điều trị các bệnh lý nam khoa thường gặp.', 'K13'),
('BS65', N'Đặng Quốc Nam', N'Nam', CONVERT(DATE,'07/05/1990',103), '0901000065', 'bs65@clinicare.vn', N'Bác sĩ', N'Nam khoa', 7, N'Hưng Yên', N'Chuyên tư vấn, khám và đánh giá sức khỏe sinh sản nam giới.', 'K13'),

-- K14 - Khoa Ung bướu
('BS66', N'Phạm Thị Thanh', N'Nữ', CONVERT(DATE,'29/09/1977',103), '0901000066', 'bs66@clinicare.vn', N'Trưởng khoa', N'Ung bướu', 19, N'Nam Định', N'Chuyên sâu trong phát hiện sớm, chẩn đoán và điều trị ung bướu.', 'K14'),
('BS67', N'Nguyễn Văn Quyết', N'Nam', CONVERT(DATE,'16/11/1985',103), '0901000067', 'bs67@clinicare.vn', N'Bác sĩ', N'Ung bướu', 12, N'Nam Định', N'Có kinh nghiệm trong theo dõi và chăm sóc bệnh nhân ung bướu.', 'K14'),
('BS68', N'Lê Thị Nga', N'Nữ', CONVERT(DATE,'21/06/1988',103), '0901000068', 'bs68@clinicare.vn', N'Bác sĩ', N'Ung bướu', 9, N'Nam Định', N'Phụ trách khám tư vấn và hỗ trợ điều trị bệnh lý ung bướu.', 'K14'),
('BS69', N'Trần Minh Quân', N'Nam', CONVERT(DATE,'03/04/1990',103), '0901000069', 'bs69@clinicare.vn', N'Bác sĩ', N'Ung bướu', 7, N'Nam Định', N'Chuyên theo dõi diễn tiến điều trị và đánh giá đáp ứng của người bệnh.', 'K14'),
('BS70', N'Bùi Thị Xuân', N'Nữ', CONVERT(DATE,'15/12/1992',103), '0901000070', 'bs70@clinicare.vn', N'Bác sĩ', N'Ung bướu', 5, N'Nam Định', N'Có kinh nghiệm trong chăm sóc hỗ trợ và tư vấn bệnh nhân ung bướu.', 'K14'),

-- K15 - Khoa Chấn thương chỉnh hình
('BS71', N'Nguyễn Quốc Cường', N'Nam', CONVERT(DATE,'26/02/1978',103), '0901000071', 'bs71@clinicare.vn', N'Trưởng khoa', N'Chấn thương chỉnh hình', 18, N'Thừa Thiên Huế', N'Có nhiều năm kinh nghiệm trong điều trị chấn thương và chỉnh hình.', 'K15'),
('BS72', N'Trần Thị Hảo', N'Nữ', CONVERT(DATE,'13/07/1986',103), '0901000072', 'bs72@clinicare.vn', N'Bác sĩ', N'Chấn thương chỉnh hình', 11, N'Thừa Thiên Huế', N'Chuyên khám các bệnh lý xương khớp và chấn thương vận động.', 'K15'),
('BS73', N'Phạm Văn Phú', N'Nam', CONVERT(DATE,'05/09/1988',103), '0901000073', 'bs73@clinicare.vn', N'Bác sĩ', N'Chấn thương chỉnh hình', 9, N'Thừa Thiên Huế', N'Có kinh nghiệm trong xử trí gãy xương và theo dõi sau điều trị.', 'K15'),
('BS74', N'Lê Thị Bích', N'Nữ', CONVERT(DATE,'24/01/1991',103), '0901000074', 'bs74@clinicare.vn', N'Bác sĩ', N'Chấn thương chỉnh hình', 6, N'Thừa Thiên Huế', N'Phụ trách tư vấn phục hồi vận động sau chấn thương.', 'K15'),
('BS75', N'Võ Minh Quý', N'Nam', CONVERT(DATE,'31/08/1990',103), '0901000075', 'bs75@clinicare.vn', N'Bác sĩ', N'Chấn thương chỉnh hình', 7, N'Thừa Thiên Huế', N'Chuyên khám và điều trị các vấn đề cơ xương khớp phổ biến.', 'K15'),

-- K16 - Khoa Hồi sức cấp cứu
('BS76', N'Nguyễn Văn Đạt', N'Nam', CONVERT(DATE,'10/10/1977',103), '0901000076', 'bs76@clinicare.vn', N'Trưởng khoa', N'Hồi sức cấp cứu', 19, N'Bà Rịa - Vũng Tàu', N'Chuyên sâu trong hồi sức, cấp cứu và xử trí các tình huống nguy kịch.', 'K16'),
('BS77', N'Phạm Thị Lý', N'Nữ', CONVERT(DATE,'12/02/1985',103), '0901000077', 'bs77@clinicare.vn', N'Bác sĩ', N'Hồi sức cấp cứu', 12, N'Bà Rịa - Vũng Tàu', N'Có kinh nghiệm tiếp nhận và xử trí cấp cứu ban đầu.', 'K16'),
('BS78', N'Lê Minh Châu', N'Nam', CONVERT(DATE,'18/04/1988',103), '0901000078', 'bs78@clinicare.vn', N'Bác sĩ', N'Hồi sức cấp cứu', 9, N'Bà Rịa - Vũng Tàu', N'Phụ trách hồi sức nội khoa và theo dõi bệnh nhân nặng.', 'K16'),
('BS79', N'Trần Thị Tâm', N'Nữ', CONVERT(DATE,'09/06/1990',103), '0901000079', 'bs79@clinicare.vn', N'Bác sĩ', N'Hồi sức cấp cứu', 7, N'Bà Rịa - Vũng Tàu', N'Chuyên hỗ trợ cấp cứu, theo dõi dấu hiệu sinh tồn và xử trí khẩn cấp.', 'K16'),
('BS80', N'Ngô Quốc Bình', N'Nam', CONVERT(DATE,'27/11/1991',103), '0901000080', 'bs80@clinicare.vn', N'Bác sĩ', N'Hồi sức cấp cứu', 6, N'Bà Rịa - Vũng Tàu', N'Có kinh nghiệm trong cấp cứu đa chấn thương và hồi sức tích cực.', 'K16'),

-- K17 - Khoa Chẩn đoán hình ảnh
('BS81', N'Đặng Thị Hồng', N'Nữ', CONVERT(DATE,'06/04/1979',103), '0901000081', 'bs81@clinicare.vn', N'Trưởng khoa', N'Chẩn đoán hình ảnh', 17, N'Vĩnh Phúc', N'Chuyên sâu trong đọc kết quả X-quang, siêu âm và chẩn đoán hình ảnh.', 'K17'),
('BS82', N'Nguyễn Văn Sang', N'Nam', CONVERT(DATE,'20/09/1986',103), '0901000082', 'bs82@clinicare.vn', N'Bác sĩ', N'Chẩn đoán hình ảnh', 11, N'Vĩnh Phúc', N'Có kinh nghiệm trong thực hiện và phân tích các kỹ thuật chẩn đoán hình ảnh.', 'K17'),
('BS83', N'Lê Thị Hòa', N'Nữ', CONVERT(DATE,'01/12/1988',103), '0901000083', 'bs83@clinicare.vn', N'Bác sĩ', N'Chẩn đoán hình ảnh', 9, N'Vĩnh Phúc', N'Chuyên siêu âm tổng quát và hỗ trợ chẩn đoán bệnh lý nội ngoại khoa.', 'K17'),
('BS84', N'Phạm Minh Khang', N'Nam', CONVERT(DATE,'16/07/1991',103), '0901000084', 'bs84@clinicare.vn', N'Bác sĩ', N'Chẩn đoán hình ảnh', 6, N'Vĩnh Phúc', N'Phụ trách đọc kết quả hình ảnh và phối hợp chẩn đoán với các khoa lâm sàng.', 'K17'),
('BS85', N'Bùi Thị Phương', N'Nữ', CONVERT(DATE,'22/05/1990',103), '0901000085', 'bs85@clinicare.vn', N'Bác sĩ', N'Chẩn đoán hình ảnh', 7, N'Vĩnh Phúc', N'Có kinh nghiệm trong chẩn đoán hình ảnh thường quy và tư vấn chuyên môn.', 'K17'),

-- K18 - Khoa Dinh dưỡng
('BS86', N'Nguyễn Thị Mai', N'Nữ', CONVERT(DATE,'17/01/1980',103), '0901000086', 'bs86@clinicare.vn', N'Trưởng khoa', N'Dinh dưỡng', 16, N'Bến Tre', N'Chuyên xây dựng chế độ dinh dưỡng điều trị và tư vấn sức khỏe dinh dưỡng.', 'K18'),
('BS87', N'Trần Văn Lộc', N'Nam', CONVERT(DATE,'29/03/1987',103), '0901000087', 'bs87@clinicare.vn', N'Bác sĩ', N'Dinh dưỡng', 10, N'Bến Tre', N'Có kinh nghiệm tư vấn dinh dưỡng cho người bệnh nội khoa và trẻ em.', 'K18'),
('BS88', N'Lê Thị Thanh Tâm', N'Nữ', CONVERT(DATE,'11/08/1989',103), '0901000088', 'bs88@clinicare.vn', N'Bác sĩ', N'Dinh dưỡng', 8, N'Bến Tre', N'Phụ trách đánh giá tình trạng dinh dưỡng và hướng dẫn chế độ ăn phù hợp.', 'K18'),
('BS89', N'Phạm Quốc Bảo', N'Nam', CONVERT(DATE,'02/10/1991',103), '0901000089', 'bs89@clinicare.vn', N'Bác sĩ', N'Dinh dưỡng', 6, N'Bến Tre', N'Chuyên tư vấn dinh dưỡng cho người trưởng thành và người cao tuổi.', 'K18'),
('BS90', N'Võ Thị Ngân', N'Nữ', CONVERT(DATE,'14/06/1992',103), '0901000090', 'bs90@clinicare.vn', N'Bác sĩ', N'Dinh dưỡng', 5, N'Bến Tre', N'Có kinh nghiệm tư vấn thực đơn hỗ trợ điều trị và hồi phục sức khỏe.', 'K18'),

-- K19 - Khoa Vật lý trị liệu
('BS91', N'Nguyễn Văn Tài', N'Nam', CONVERT(DATE,'08/11/1978',103), '0901000091', 'bs91@clinicare.vn', N'Trưởng khoa', N'Vật lý trị liệu', 18, N'Long An', N'Chuyên sâu trong phục hồi chức năng và vật lý trị liệu vận động.', 'K19'),
('BS92', N'Trần Thị Cẩm', N'Nữ', CONVERT(DATE,'06/05/1986',103), '0901000092', 'bs92@clinicare.vn', N'Bác sĩ', N'Vật lý trị liệu', 11, N'Long An', N'Có kinh nghiệm trong phục hồi chức năng sau chấn thương và tai biến.', 'K19'),
('BS93', N'Lê Minh Hiền', N'Nam', CONVERT(DATE,'27/07/1988',103), '0901000093', 'bs93@clinicare.vn', N'Bác sĩ', N'Vật lý trị liệu', 9, N'Long An', N'Phụ trách đánh giá vận động và xây dựng liệu trình phục hồi chức năng.', 'K19'),
('BS94', N'Phạm Thị Kiều', N'Nữ', CONVERT(DATE,'19/09/1991',103), '0901000094', 'bs94@clinicare.vn', N'Bác sĩ', N'Vật lý trị liệu', 6, N'Long An', N'Chuyên hướng dẫn tập luyện phục hồi và hỗ trợ giảm đau vận động.', 'K19'),
('BS95', N'Võ Quốc Thắng', N'Nam', CONVERT(DATE,'25/12/1990',103), '0901000095', 'bs95@clinicare.vn', N'Bác sĩ', N'Vật lý trị liệu', 7, N'Long An', N'Có kinh nghiệm trong điều trị phục hồi chức năng cơ xương khớp.', 'K19');
GO

/* =========================
   3. UPDATE TRƯỞNG KHOA
   ========================= */
UPDATE Khoa SET ma_bac_si = 'BS01' WHERE ma_khoa = 'K01';
UPDATE Khoa SET ma_bac_si = 'BS06' WHERE ma_khoa = 'K02';
UPDATE Khoa SET ma_bac_si = 'BS11' WHERE ma_khoa = 'K03';
UPDATE Khoa SET ma_bac_si = 'BS16' WHERE ma_khoa = 'K04';
UPDATE Khoa SET ma_bac_si = 'BS21' WHERE ma_khoa = 'K05';
UPDATE Khoa SET ma_bac_si = 'BS26' WHERE ma_khoa = 'K06';
UPDATE Khoa SET ma_bac_si = 'BS31' WHERE ma_khoa = 'K07';
UPDATE Khoa SET ma_bac_si = 'BS36' WHERE ma_khoa = 'K08';
UPDATE Khoa SET ma_bac_si = 'BS41' WHERE ma_khoa = 'K09';
UPDATE Khoa SET ma_bac_si = 'BS46' WHERE ma_khoa = 'K10';
UPDATE Khoa SET ma_bac_si = 'BS51' WHERE ma_khoa = 'K11';
UPDATE Khoa SET ma_bac_si = 'BS56' WHERE ma_khoa = 'K12';
UPDATE Khoa SET ma_bac_si = 'BS61' WHERE ma_khoa = 'K13';
UPDATE Khoa SET ma_bac_si = 'BS66' WHERE ma_khoa = 'K14';
UPDATE Khoa SET ma_bac_si = 'BS71' WHERE ma_khoa = 'K15';
UPDATE Khoa SET ma_bac_si = 'BS76' WHERE ma_khoa = 'K16';
UPDATE Khoa SET ma_bac_si = 'BS81' WHERE ma_khoa = 'K17';
UPDATE Khoa SET ma_bac_si = 'BS86' WHERE ma_khoa = 'K18';
UPDATE Khoa SET ma_bac_si = 'BS91' WHERE ma_khoa = 'K19';
GO

INSERT INTO Phong_kham (ma_phong, ten_phong, ma_khoa) VALUES
-- K01 - Khoa Nội
('P001', N'Phòng khám Nội 1', 'K01'),
('P002', N'Phòng khám Nội 2', 'K01'),
('P003', N'Phòng khám Nội 3', 'K01'),
('P004', N'Phòng khám Nội 4', 'K01'),
('P005', N'Phòng khám Nội 5', 'K01'),

-- K02 - Khoa Ngoại
('P006', N'Phòng khám Ngoại 1', 'K02'),
('P007', N'Phòng khám Ngoại 2', 'K02'),
('P008', N'Phòng khám Ngoại 3', 'K02'),
('P009', N'Phòng khám Ngoại 4', 'K02'),
('P010', N'Phòng khám Ngoại 5', 'K02'),

-- K03 - Khoa Nhi
('P011', N'Phòng khám Nhi 1', 'K03'),
('P012', N'Phòng khám Nhi 2', 'K03'),
('P013', N'Phòng khám Nhi 3', 'K03'),
('P014', N'Phòng khám Nhi 4', 'K03'),
('P015', N'Phòng khám Nhi 5', 'K03'),

-- K04 - Khoa Tim mạch
('P016', N'Phòng khám Tim mạch 1', 'K04'),
('P017', N'Phòng khám Tim mạch 2', 'K04'),
('P018', N'Phòng khám Tim mạch 3', 'K04'),
('P019', N'Phòng khám Tim mạch 4', 'K04'),
('P020', N'Phòng khám Tim mạch 5', 'K04'),

-- K05 - Khoa Tiêu hóa
('P021', N'Phòng khám Tiêu hóa 1', 'K05'),
('P022', N'Phòng khám Tiêu hóa 2', 'K05'),
('P023', N'Phòng khám Tiêu hóa 3', 'K05'),
('P024', N'Phòng khám Tiêu hóa 4', 'K05'),
('P025', N'Phòng khám Tiêu hóa 5', 'K05'),

-- K06 - Khoa Da liễu
('P026', N'Phòng khám Da liễu 1', 'K06'),
('P027', N'Phòng khám Da liễu 2', 'K06'),
('P028', N'Phòng khám Da liễu 3', 'K06'),
('P029', N'Phòng khám Da liễu 4', 'K06'),
('P030', N'Phòng khám Da liễu 5', 'K06'),

-- K07 - Khoa Hô hấp
('P031', N'Phòng khám Hô hấp 1', 'K07'),
('P032', N'Phòng khám Hô hấp 2', 'K07'),
('P033', N'Phòng khám Hô hấp 3', 'K07'),
('P034', N'Phòng khám Hô hấp 4', 'K07'),
('P035', N'Phòng khám Hô hấp 5', 'K07'),

-- K08 - Khoa Tai Mũi Họng
('P036', N'Phòng khám Tai Mũi Họng 1', 'K08'),
('P037', N'Phòng khám Tai Mũi Họng 2', 'K08'),
('P038', N'Phòng khám Tai Mũi Họng 3', 'K08'),
('P039', N'Phòng khám Tai Mũi Họng 4', 'K08'),
('P040', N'Phòng khám Tai Mũi Họng 5', 'K08'),

-- K09 - Khoa Sản
('P041', N'Phòng khám Sản 1', 'K09'),
('P042', N'Phòng khám Sản 2', 'K09'),
('P043', N'Phòng khám Sản 3', 'K09'),
('P044', N'Phòng khám Sản 4', 'K09'),
('P045', N'Phòng khám Sản 5', 'K09'),

-- K10 - Khoa Răng Hàm Mặt
('P046', N'Phòng khám Răng Hàm Mặt 1', 'K10'),
('P047', N'Phòng khám Răng Hàm Mặt 2', 'K10'),
('P048', N'Phòng khám Răng Hàm Mặt 3', 'K10'),
('P049', N'Phòng khám Răng Hàm Mặt 4', 'K10'),
('P050', N'Phòng khám Răng Hàm Mặt 5', 'K10'),

-- K11 - Khoa Thần kinh
('P051', N'Phòng khám Thần kinh 1', 'K11'),
('P052', N'Phòng khám Thần kinh 2', 'K11'),
('P053', N'Phòng khám Thần kinh 3', 'K11'),
('P054', N'Phòng khám Thần kinh 4', 'K11'),
('P055', N'Phòng khám Thần kinh 5', 'K11'),

-- K12 - Khoa Tiết niệu
('P056', N'Phòng khám Tiết niệu 1', 'K12'),
('P057', N'Phòng khám Tiết niệu 2', 'K12'),
('P058', N'Phòng khám Tiết niệu 3', 'K12'),
('P059', N'Phòng khám Tiết niệu 4', 'K12'),
('P060', N'Phòng khám Tiết niệu 5', 'K12'),

-- K13 - Khoa Nam khoa
('P061', N'Phòng khám Nam khoa 1', 'K13'),
('P062', N'Phòng khám Nam khoa 2', 'K13'),
('P063', N'Phòng khám Nam khoa 3', 'K13'),
('P064', N'Phòng khám Nam khoa 4', 'K13'),
('P065', N'Phòng khám Nam khoa 5', 'K13'),

-- K14 - Khoa Ung bướu
('P066', N'Phòng khám Ung bướu 1', 'K14'),
('P067', N'Phòng khám Ung bướu 2', 'K14'),
('P068', N'Phòng khám Ung bướu 3', 'K14'),
('P069', N'Phòng khám Ung bướu 4', 'K14'),
('P070', N'Phòng khám Ung bướu 5', 'K14'),

-- K15 - Khoa Chấn thương chỉnh hình
('P071', N'Phòng khám Chấn thương chỉnh hình 1', 'K15'),
('P072', N'Phòng khám Chấn thương chỉnh hình 2', 'K15'),
('P073', N'Phòng khám Chấn thương chỉnh hình 3', 'K15'),
('P074', N'Phòng khám Chấn thương chỉnh hình 4', 'K15'),
('P075', N'Phòng khám Chấn thương chỉnh hình 5', 'K15'),

-- K16 - Khoa Hồi sức cấp cứu
('P076', N'Phòng khám Hồi sức cấp cứu 1', 'K16'),
('P077', N'Phòng khám Hồi sức cấp cứu 2', 'K16'),
('P078', N'Phòng khám Hồi sức cấp cứu 3', 'K16'),
('P079', N'Phòng khám Hồi sức cấp cứu 4', 'K16'),
('P080', N'Phòng khám Hồi sức cấp cứu 5', 'K16'),

-- K17 - Khoa Chẩn đoán hình ảnh
('P081', N'Phòng khám Chẩn đoán hình ảnh 1', 'K17'),
('P082', N'Phòng khám Chẩn đoán hình ảnh 2', 'K17'),
('P083', N'Phòng khám Chẩn đoán hình ảnh 3', 'K17'),
('P084', N'Phòng khám Chẩn đoán hình ảnh 4', 'K17'),
('P085', N'Phòng khám Chẩn đoán hình ảnh 5', 'K17'),

-- K18 - Khoa Dinh dưỡng
('P086', N'Phòng khám Dinh dưỡng 1', 'K18'),
('P087', N'Phòng khám Dinh dưỡng 2', 'K18'),
('P088', N'Phòng khám Dinh dưỡng 3', 'K18'),
('P089', N'Phòng khám Dinh dưỡng 4', 'K18'),
('P090', N'Phòng khám Dinh dưỡng 5', 'K18'),

-- K19 - Khoa Vật lý trị liệu
('P091', N'Phòng khám Vật lý trị liệu 1', 'K19'),
('P092', N'Phòng khám Vật lý trị liệu 2', 'K19'),
('P093', N'Phòng khám Vật lý trị liệu 3', 'K19'),
('P094', N'Phòng khám Vật lý trị liệu 4', 'K19'),
('P095', N'Phòng khám Vật lý trị liệu 5', 'K19');
GO


INSERT INTO Khung_gio_kham (ma_khung_gio, thoi_luong_phut, ma_bac_si) VALUES
('KG01', 30, 'BS01'),
('KG02', 30, 'BS02'),
('KG03', 30, 'BS03'),
('KG04', 30, 'BS04'),
('KG05', 30, 'BS05'),
('KG06', 30, 'BS06'),
('KG07', 30, 'BS07'),
('KG08', 30, 'BS08'),
('KG09', 30, 'BS09'),
('KG10', 30, 'BS10'),
('KG11', 30, 'BS11'),
('KG12', 30, 'BS12'),
('KG13', 30, 'BS13'),
('KG14', 30, 'BS14'),
('KG15', 30, 'BS15'),
('KG16', 30, 'BS16'),
('KG17', 30, 'BS17'),
('KG18', 30, 'BS18'),
('KG19', 30, 'BS19'),
('KG20', 30, 'BS20'),
('KG21', 30, 'BS21'),
('KG22', 30, 'BS22'),
('KG23', 30, 'BS23'),
('KG24', 30, 'BS24'),
('KG25', 30, 'BS25'),
('KG26', 30, 'BS26'),
('KG27', 30, 'BS27'),
('KG28', 30, 'BS28'),
('KG29', 30, 'BS29'),
('KG30', 30, 'BS30'),
('KG31', 30, 'BS31'),
('KG32', 30, 'BS32'),
('KG33', 30, 'BS33'),
('KG34', 30, 'BS34'),
('KG35', 30, 'BS35'),
('KG36', 30, 'BS36'),
('KG37', 30, 'BS37'),
('KG38', 30, 'BS38'),
('KG39', 30, 'BS39'),
('KG40', 30, 'BS40'),
('KG41', 30, 'BS41'),
('KG42', 30, 'BS42'),
('KG43', 30, 'BS43'),
('KG44', 30, 'BS44'),
('KG45', 30, 'BS45'),
('KG46', 30, 'BS46'),
('KG47', 30, 'BS47'),
('KG48', 30, 'BS48'),
('KG49', 30, 'BS49'),
('KG50', 30, 'BS50'),
('KG51', 30, 'BS51'),
('KG52', 30, 'BS52'),
('KG53', 30, 'BS53'),
('KG54', 30, 'BS54'),
('KG55', 30, 'BS55'),
('KG56', 30, 'BS56'),
('KG57', 30, 'BS57'),
('KG58', 30, 'BS58'),
('KG59', 30, 'BS59'),
('KG60', 30, 'BS60'),
('KG61', 30, 'BS61'),
('KG62', 30, 'BS62'),
('KG63', 30, 'BS63'),
('KG64', 30, 'BS64'),
('KG65', 30, 'BS65'),
('KG66', 30, 'BS66'),
('KG67', 30, 'BS67'),
('KG68', 30, 'BS68'),
('KG69', 30, 'BS69'),
('KG70', 30, 'BS70'),
('KG71', 30, 'BS71'),
('KG72', 30, 'BS72'),
('KG73', 30, 'BS73'),
('KG74', 30, 'BS74'),
('KG75', 30, 'BS75'),
('KG76', 30, 'BS76'),
('KG77', 30, 'BS77'),
('KG78', 30, 'BS78'),
('KG79', 30, 'BS79'),
('KG80', 30, 'BS80'),
('KG81', 30, 'BS81'),
('KG82', 30, 'BS82'),
('KG83', 30, 'BS83'),
('KG84', 30, 'BS84'),
('KG85', 30, 'BS85'),
('KG86', 30, 'BS86'),
('KG87', 30, 'BS87'),
('KG88', 30, 'BS88'),
('KG89', 30, 'BS89'),
('KG90', 30, 'BS90'),
('KG91', 30, 'BS91'),
('KG92', 30, 'BS92'),
('KG93', 30, 'BS93'),
('KG94', 30, 'BS94'),
('KG95', 30, 'BS95');
GO
USE [CLINICARE_GROUP2]
INSERT INTO Cau_hinh_gio_lam_bac_si (
    ma_cau_hinh,
    ma_bac_si,
    ngay_hieu_luc,
    gio_sang_bat_dau,
    gio_sang_ket_thuc,
    gio_chieu_bat_dau,
    gio_chieu_ket_thuc,
    trang_thai,
    ghi_chu
)
SELECT
    'CH' + RIGHT('000' + CAST(ROW_NUMBER() OVER (ORDER BY ma_bac_si) AS VARCHAR(3)), 3) AS ma_cau_hinh,
    ma_bac_si,
    CAST('2026-04-01' AS DATE) AS ngay_hieu_luc,
    CAST('07:00:00' AS TIME) AS gio_sang_bat_dau,
    CAST('11:00:00' AS TIME) AS gio_sang_ket_thuc,
    CAST('13:30:00' AS TIME) AS gio_chieu_bat_dau,
    CAST('16:30:00' AS TIME) AS gio_chieu_ket_thuc,
    N'Đang áp dụng' AS trang_thai,
    N'Làm việc từ thứ 2 đến thứ 6' AS ghi_chu
FROM Bac_si
ORDER BY ma_bac_si;
DELETE FROM dbo.Trang_thai
WHERE ma_trang_thai = 'TT04';
GO
