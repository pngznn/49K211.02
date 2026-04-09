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

-- M?i khung gi? ch? ???c ??t t?i ?a 1 l?ch h?n
CREATE UNIQUE INDEX idx_unique_khung_gio
ON LICH_HEN(ma_khung_gio);
GO