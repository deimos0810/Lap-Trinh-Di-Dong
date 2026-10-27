-- ====================================================================
-- Script tao co so du lieu: CuaHangDienThoaiDB
-- Mon: Lap trinh di dong - Bai 10: Xay dung va su dung API
-- Bai tap 03: Ung dung mua ban dien thoai di dong co gio hang & luu hoa don
-- ====================================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'CuaHangDienThoaiDB')
BEGIN
    ALTER DATABASE CuaHangDienThoaiDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CuaHangDienThoaiDB;
END
GO

CREATE DATABASE CuaHangDienThoaiDB;
GO

USE CuaHangDienThoaiDB;
GO

-- 1. Bang DienThoai (San pham)
CREATE TABLE DienThoai (
    MaDT NVARCHAR(20) PRIMARY KEY,
    TenDT NVARCHAR(100) NOT NULL,
    HangSX NVARCHAR(50) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    MoTa NVARCHAR(MAX) NULL,
    HinhAnh NVARCHAR(500) NULL,
    NoiBat BIT NOT NULL DEFAULT 0
);
GO

-- 2. Bang KhachHang (Khach hang)
CREATE TABLE KhachHang (
    MaKH NVARCHAR(20) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NULL,
    SoDienThoai NVARCHAR(20) NULL
);
GO

-- 3. Bang HoaDon (Luu hoa don khi khach mua hang)
CREATE TABLE HoaDon (
    MaHD NVARCHAR(50) PRIMARY KEY,
    NgayLap DATETIME NOT NULL DEFAULT GETDATE(),
    MaKH NVARCHAR(20) NOT NULL,
    TongTien DECIMAL(18,2) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Đã thanh toán',
    CONSTRAINT FK_HoaDon_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
GO

-- 4. Bang ChiTietHoaDon (Chi tiet cac dien thoai trong hoa don)
CREATE TABLE ChiTietHoaDon (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MaHD NVARCHAR(50) NOT NULL,
    MaDT NVARCHAR(20) NOT NULL,
    SoLuong INT NOT NULL DEFAULT 1,
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_ChiTietHoaDon_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON DELETE CASCADE,
    CONSTRAINT FK_ChiTietHoaDon_DienThoai FOREIGN KEY (MaDT) REFERENCES DienThoai(MaDT)
);
GO

-- ====================================================================
-- CHÈN DỮ LIỆU MẪU CHUẨN XÁC THEO SLIDE BÀI 10 (TRANG 19, 21, 22)
-- ====================================================================

-- Chen KhachHang mau
INSERT INTO KhachHang (MaKH, TenKH, Email, SoDienThoai) VALUES
('KH01', N'Lương Viễn Đông', '2001230180@huit.edu.vn', '0901234567'),
('KH02', N'Trần Gia Khánh', 'nhom14@huit.edu.vn', '0912345678');
GO

-- Chen cac san pham dien thoai
INSERT INTO DienThoai (MaDT, TenDT, HangSX, Gia, MoTa, HinhAnh, NoiBat) VALUES
('DT01', N'Điện thoại 01', 'Samsung', 1200.0, N'Điện thoại mới của hãng Samsung với công nghệ hiện đại, màn hình sắc nét và camera thông minh.', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400', 0),
('DT02', N'Điện thoại 02', 'Apple', 200.0, N'Thiết kế nhỏ gọn, độ bền cao, hỗ trợ đầy đủ các kết nối 4G/Wifi hiện đại.', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400', 0),
('DT03', N'Điện thoại 03', 'Xiaomi', 850.0, N'Dung lượng pin 5000mAh, sạc nhanh 33W, màn hình 90Hz siêu mượt mà.', 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400', 0),
('DT04', N'Điện thoại 04', 'Oppo', 600.2, N'Thiết kế siêu mỏng nhẹ, camera selfie thông minh tích hợp công nghệ AI làm đẹp.', 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400', 1),
('DT05', N'Điện thoại 05', 'Samsung', 1500.0, N'Màn hình Dynamic AMOLED cao cấp, hỗ trợ bút cảm ứng phục vụ công việc văn phòng.', 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400', 0),
('DT06', N'Điện thoại 06', 'Vivo', 950.0, N'Chống rung OIS tiên tiến, hệ thống âm thanh vòm sống động chân thực.', 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=400', 0),
('DT07', N'Điện thoại 07', 'Apple', 2000.0, N'Khung viền Titan sang trọng, hiệu năng cực đỉnh với chip thế hệ mới nhất.', 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=400', 1),
('DT08', N'iPhone 15 Pro Max', 'Apple', 18000000.0, N'Phone 15 Pro Max là một chiếc điện thoại thông minh cao cấp được mong đợi nhất năm 2023. Với nhiều tính năng mới và cải tiến, iPhone 15 Pro Max chắc chắn sẽ là một lựa chọn tuyệt vời cho những người dùng đang tìm kiếm một chiếc điện thoại có hiệu năng mạnh mẽ, camera chất lượng và thiết kế sang trọng. Sản phẩm chính hãng, đảm bảo chất lượng: Thế Giới Di Động là nhà bán lẻ điện thoại di động lớn nhất Việt Nam, cam kết cung cấp sản phẩm chính hãng, đảm bảo chất lượng.', 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400', 1),
('DT09', N'iPhone 15', 'Apple', 14000000.0, N'Hàng chính hãng VN/A, Dynamic Island thời thượng, màn hình Super Retina XDR sáng rõ.', 'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=400', 0),
('DT10', N'Oppo Reno 10 Pro+', 'Oppo', 13000000.0, N'Hàng chính hãng, chuyên gia chân dung tele đỉnh cao, sạc siêu nhanh SuperVOOC 100W.', 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400', 1),
('DT11', N'Oppo Reno 11F', 'Oppo', 10000000.0, N'Hàng chính hãng, thiết kế vân kim sa lấp lánh, kháng nước bụi IP65 bền bỉ.', 'https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=400', 0),
('DT12', N'Galaxy S24 Plus', 'Samsung', 16500000.0, N'Hàng chính hãng, sức mạnh từ Galaxy AI đột phá, khung Armor Aluminum bền chắc.', 'https://images.unsplash.com/photo-1533228876829-65c94e7b5025?w=400', 1),
('DT13', N'Xiaomi 14', 'Xiaomi', 12000000.0, N'Hàng chính hãng, ống kính quang học Leica danh tiếng thế giới, Snapdragon 8 Gen 3.', 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=400', 1),
('DT14', N'Xiaomi-Redmi A3', 'Xiaomi', 3500000.0, N'Hàng chính hãng, phong cách thiết kế sang trọng cụm camera tròn, pin bền bỉ.', 'https://images.unsplash.com/photo-1584006682522-dc17d6c0d963?w=400', 0);
GO

-- Chen 1 HoaDon mau ban dau
INSERT INTO HoaDon (MaHD, NgayLap, MaKH, TongTien, TrangThai) VALUES
('HD20261027001', GETDATE(), 'KH01', 3200.0, N'Đã thanh toán');
GO

INSERT INTO ChiTietHoaDon (MaHD, MaDT, SoLuong, DonGia, ThanhTien) VALUES
('HD20261027001', 'DT01', 1, 1200.0, 1200.0),
('HD20261027001', 'DT07', 1, 2000.0, 2000.0);
GO

-- Kiem tra ket qua
SELECT 'DienThoai' AS Bang, COUNT(*) AS SoLuong FROM DienThoai
UNION ALL
SELECT 'KhachHang', COUNT(*) FROM KhachHang
UNION ALL
SELECT 'HoaDon', COUNT(*) FROM HoaDon
UNION ALL
SELECT 'ChiTietHoaDon', COUNT(*) FROM ChiTietHoaDon;
GO
