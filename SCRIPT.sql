CREATE DATABASE DATLICHKHAM1;
GO

USE DATLICHKHAM1;
GO

-- 1. VAI_TRO
CREATE TABLE VAI_TRO (
    ma_vai_tro VARCHAR(20) PRIMARY KEY,
    ten_vai_tro NVARCHAR(100) NOT NULL
);
GO

-- 2. NGUOI_DUNG
CREATE TABLE NGUOI_DUNG (
    ma_nguoi_dung VARCHAR(20) PRIMARY KEY,
    mat_khau VARCHAR(255) NOT NULL,
    ho_ten NVARCHAR(100) NOT NULL,
    so_dien_thoai VARCHAR(15),
    email VARCHAR(100),
    trang_thai BIT NOT NULL DEFAULT 1,
    ma_vai_tro VARCHAR(20) NOT NULL,
    CONSTRAINT fk_nguoi_dung_vai_tro
        FOREIGN KEY (ma_vai_tro) REFERENCES VAI_TRO(ma_vai_tro)
);
GO

-- 3. KHOA
CREATE TABLE KHOA (
    ma_khoa VARCHAR(20) PRIMARY KEY,
    ten_khoa NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(MAX)
);
GO

-- 4. BAC_SI
CREATE TABLE BAC_SI (
    ma_bac_si VARCHAR(20) PRIMARY KEY,
    ho_ten_bac_si NVARCHAR(100) NOT NULL,
    chuyen_mon NVARCHAR(100),
    trang_thai_lam_viec BIT NOT NULL DEFAULT 1,
    ma_khoa VARCHAR(20) NOT NULL,
    CONSTRAINT fk_bac_si_khoa
        FOREIGN KEY (ma_khoa) REFERENCES KHOA(ma_khoa)
);
GO

-- 5. LICH_LAM_VIEC
CREATE TABLE LICH_LAM_VIEC (
    ma_lich VARCHAR(20) PRIMARY KEY,
    thu_trong_tuan INT NOT NULL CHECK (thu_trong_tuan BETWEEN 2 AND 8), -- 2 = Th? 2 ... 8 = Ch? nh?t
    gio_bat_dau TIME NOT NULL,
    gio_ket_thuc TIME NOT NULL,
    ma_bac_si VARCHAR(20) NOT NULL,
    CONSTRAINT ck_lich_lam_viec_gio
        CHECK (gio_bat_dau < gio_ket_thuc),
    CONSTRAINT fk_lich_lam_viec_bac_si
        FOREIGN KEY (ma_bac_si) REFERENCES BAC_SI(ma_bac_si)
);
GO

-- 6. KHUNG_GIO_KHAM
CREATE TABLE KHUNG_GIO_KHAM (
    ma_khung_gio VARCHAR(20) PRIMARY KEY,
    ngay_kham DATE NOT NULL,
    con_trong BIT NOT NULL DEFAULT 1,
    ma_lich VARCHAR(20) NOT NULL,
    CONSTRAINT fk_khung_gio_lich
        FOREIGN KEY (ma_lich) REFERENCES LICH_LAM_VIEC(ma_lich)
);
GO

-- 7. TRANG_THAI_DAT_LICH
CREATE TABLE TRANG_THAI_DAT_LICH (
    ma_trang_thai VARCHAR(20) PRIMARY KEY,
    ten_trang_thai NVARCHAR(50) NOT NULL
);
GO

-- 8. LICH_HEN
CREATE TABLE LICH_HEN (
    ma_lich_hen VARCHAR(20) PRIMARY KEY,
    ngay_dat_lich DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ghi_chu NVARCHAR(MAX),

    ma_nguoi_dung VARCHAR(20) NOT NULL,
    ma_khung_gio VARCHAR(20) NOT NULL,
    ma_bac_si VARCHAR(20) NOT NULL,
    ma_khoa VARCHAR(20) NOT NULL,
    ma_trang_thai VARCHAR(20) NOT NULL,

    CONSTRAINT fk_lich_hen_nguoi_dung
        FOREIGN KEY (ma_nguoi_dung) REFERENCES NGUOI_DUNG(ma_nguoi_dung),

    CONSTRAINT fk_lich_hen_khung_gio
        FOREIGN KEY (ma_khung_gio) REFERENCES KHUNG_GIO_KHAM(ma_khung_gio),

    CONSTRAINT fk_lich_hen_bac_si
        FOREIGN KEY (ma_bac_si) REFERENCES BAC_SI(ma_bac_si),

    CONSTRAINT fk_lich_hen_khoa
        FOREIGN KEY (ma_khoa) REFERENCES KHOA(ma_khoa),

    CONSTRAINT fk_lich_hen_trang_thai
        FOREIGN KEY (ma_trang_thai) REFERENCES TRANG_THAI_DAT_LICH(ma_trang_thai)
);
GO

CREATE UNIQUE INDEX idx_unique_khung_gio
ON LICH_HEN(ma_khung_gio);
GO

INSERT INTO KHOA (ma_khoa, ten_khoa, mo_ta) VALUES
('K01', N'Nội', N'Khoa nội'),
('K02', N'Ngoại', N'Khoa ngoại'),
('K03', N'Nhi', N'Khoa nhi'),
('K04', N'Tim mạch', N'Khoa tim mạch'),
('K05', N'Tiêu hóa', N'Khoa tiêu hóa'),
('K06', N'Da liễu', N'Khoa da liễu'),
('K07', N'Hô hấp', N'Khoa hô hấp'),
('K08', N'Tai mũi họng', N'Khoa tai mũi họng'),
('K09', N'Sản', N'Khoa sản'),
('K10', N'Răng hàm mặt', N'Khoa răng hàm mặt'),
('K11', N'Thần kinh', N'Khoa thần kinh'),
('K12', N'Tiết niệu', N'Khoa tiết niệu'),
('K13', N'Nam khoa', N'Khoa nam khoa'),
('K14', N'Ung bướu', N'Khoa ung bướu'),
('K15', N'Chấn thương chỉnh hình', N'Khoa chấn thương chỉnh hình'),
('K16', N'Hồi sức cấp cứu', N'Khoa hồi sức cấp cứu'),
('K17', N'Chẩn đoán hình ảnh', N'X-quang, CT, MRI'),
('K18', N'Dinh dưỡng', N'Khoa dinh dưỡng'),
('K19', N'Vật lý trị liệu', N'Khoa vật lý trị liệu');
GO

INSERT INTO VAI_TRO VALUES
('VT01', N'Admin'),
('VT02', N'Bệnh nhân');
GO

INSERT INTO BAC_SI VALUES
('BS01', N'Nguyễn Văn Minh', N'Nội khoa', 1, 'K01'),
('BS02', N'Trần Thị Lan', N'Ngoại khoa', 1, 'K02'),
('BS03', N'Lê Văn Hùng', N'Nhi khoa', 1, 'K03'),
('BS04', N'Phạm Thị Mai', N'Tim mạch', 1, 'K04'),
('BS05', N'Hoàng Văn Nam', N'Tiêu hóa', 1, 'K05'),
('BS06', N'Đỗ Thị Hoa', N'Da liễu', 1, 'K06'),
('BS07', N'Ngô Văn Tuấn', N'Hô hấp', 1, 'K07'),
('BS08', N'Bùi Thị Hạnh', N'Tai mũi họng', 1, 'K08'),
('BS09', N'Phan Văn Đức', N'Sản khoa', 1, 'K09'),
('BS10', N'Nguyễn Thị Yến', N'Răng hàm mặt', 1, 'K10');
GO

INSERT INTO LICH_LAM_VIEC VALUES
('L01', 2, '08:00', '12:00', 'BS01'),
('L02', 3, '13:00', '17:00', 'BS01'),
('L03', 2, '08:00', '12:00', 'BS02'),
('L04', 4, '13:00', '17:00', 'BS03'),
('L05', 5, '08:00', '12:00', 'BS04'),
('L06', 6, '13:00', '17:00', 'BS05'),
('L07', 2, '08:00', '12:00', 'BS06'),
('L08', 3, '13:00', '17:00', 'BS07'),
('L09', 4, '08:00', '12:00', 'BS08'),
('L10', 5, '13:00', '17:00', 'BS09');
GO

INSERT INTO KHUNG_GIO_KHAM VALUES
('KG01', '2026-03-20', 1, 'L01'),
('KG02', '2026-03-20', 1, 'L02'),
('KG03', '2026-03-21', 1, 'L03'),
('KG04', '2026-03-21', 1, 'L04'),
('KG05', '2026-03-22', 1, 'L05'),
('KG06', '2026-03-22', 1, 'L06'),
('KG07', '2026-03-23', 1, 'L07'),
('KG08', '2026-03-23', 1, 'L08'),
('KG09', '2026-03-24', 1, 'L09'),
('KG10', '2026-03-24', 1, 'L10');
GO

INSERT INTO TRANG_THAI_DAT_LICH VALUES
('TT01', N'Đã đặt'),
('TT02', N'Đã khám'),
('TT03', N'Đã hủy');
GO

SELECT * FROM BAC_SI;
SELECT * FROM LICH_LAM_VIEC;
SELECT * FROM KHUNG_GIO_KHAM;