# BÀI TẬP VỀ NHÀ (BÀI TẬP 03) - BÀI 10: XÂY DỰNG VÀ SỬ DỤNG API

> **Môn:** Lập trình di động  
> **Khoa:** Công nghệ Thông tin - Trường Đại học Công Thương TP.HCM (HUIT)  
> **Sinh viên thực hiện:** Lương Viên Đông (MSSV: 2001230180)  

---

## 📱 YÊU CẦU ĐỀ BÀI (THEO FILE PDF BÀI 10, TRANG 20 - 22)

1. **Thiết kế cơ sở dữ liệu trên SQL Server** (`CuaHangDienThoaiDB`):
   - Bảng `DienThoai`: Lưu danh mục các sản phẩm điện thoại.
   - Bảng `KhachHang`: Thông tin khách hàng đặt mua.
   - Bảng `HoaDon`: Lưu hóa đơn mua sắm của khách sau khi thanh toán.
   - Bảng `ChiTietHoaDon`: Chi tiết từng dòng sản phẩm, số lượng, đơn giá, thành tiền trong hóa đơn.

2. **Xây dựng Web API bằng ASP.NET Core 9.0 (.NET Core) & Entity Framework Core**:
   - `GET /api/DienThoai`: Lấy danh sách toàn bộ sản phẩm.
   - `GET /api/DienThoai/noibat`: Lấy danh sách sản phẩm nổi bật ("Sản phẩm được lựa chọn nhiều nhất").
   - `GET /api/DienThoai/{id}`: Lấy chi tiết một sản phẩm.
   - `POST /api/HoaDon`: Nhận dữ liệu giỏ hàng khi người dùng bấm **Thanh toán**, tự động sinh mã hóa đơn và lưu chi tiết vào SQL Server.
   - `GET /api/HoaDon`: Lấy danh sách các hóa đơn đã lưu trong CSDL SQL Server để kiểm tra / báo cáo.

3. **Xây dựng ứng dụng Flutter hoàn chỉnh theo đúng giao diện trong PDF**:
   - **Màn hình giới thiệu (WelcomeScreen):** Logo HUIT tròn, tiêu đề *"Cửa hàng điện thoại"*, địa chỉ *"140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh"*, nút mũi tên tròn (`->`) để vào ứng dụng.
   - **Màn hình Cửa hàng (StoreScreen):**
     + AppBar màu cam vàng, nút mở Drawer bên trái, icon Giỏ hàng có badge đếm số lượng bên phải.
     + Mục 1: *"Chọn sản phẩm bạn muốn sử dụng"* (danh sách cuộn ngang các card điện thoại).
     + Mục 2: *"Sản phẩm được lựa chọn nhiều nhất"* (danh sách cuộn ngang các điện thoại bán chạy).
     + Nút tròn màu xanh ngọc với dấu `+` ở mỗi card: khi bấm hiện hộp thoại xác nhận:
       > **Xác nhận**  
       > Bạn vừa thêm sản phẩm vào Giỏ hàng  
       > [Không] [Đồng ý]
   - **Drawer điều hướng:**
     + `UserAccountsDrawerHeader`: Avatar tròn, tên *"Lương Viễn Đông"*, email *"2001230180@huit.edu.vn"*.
     + Menu *"Cửa hàng"*: Chuyển về trang sản phẩm.
     + Menu *"Giỏ hàng"*: Chuyển sang màn hình giỏ hàng (kèm badge đếm số lượng).
     + Menu *"Lịch sử hóa đơn (SQL Server)"*: Xem các hóa đơn đã thanh toán lưu trong CSDL.
     + Menu *"Thoát"*: Quay về màn hình giới thiệu.
   - **Màn hình Giỏ hàng (CartScreen):**
     + Tiêu đề *"Giỏ hàng của bạn"*.
     + Khi giỏ hàng trống: Hiện thông báo *"Bạn chưa có sản phẩm nào trong giỏ hàng!!!"*.
     + Khi có sản phẩm: Danh sách các điện thoại đã chọn kèm giá và icon thùng rác xóa.
     + Khi bấm thùng rác: Hiện hộp thoại xác nhận:
       > **Xác nhận**  
       > Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng  
       > [Không] [Đồng ý]
     + Nút **Thanh toán** bo tròn: Khi bấm sẽ gọi API lưu hóa đơn vào SQL Server và hiện thông báo:
       > **Thanh toán**  
       > Bạn đã thanh toán xong giỏ hàng  
       > [Đóng]

---

## 🚀 HƯỚNG DẪN CHẠY DỰ ÁN TỪNG BƯỚC (RẤT TIỆN LỢI)

Thư mục đã được tích hợp sẵn 4 file batch `.bat` chạy tự động:

### Bước 1: Khởi tạo CSDL SQL Server
Nhấp đúp chuột chạy file:
```cmd
1_KhoiTao_CSDL.bat
```
*(Hoặc chạy lệnh: `sqlcmd -S "(localdb)\MSSQLLocalDB" -f 65001 -i setup_CuaHangDienThoaiDB.sql`)*

### Bước 2: Chạy Backend Web API
Nhấp đúp chuột chạy file:
```cmd
2_Chay_Backend_API.bat
```
- Web API lắng nghe tại: `http://localhost:5183`
- Swagger UI tự động mở tại: `http://localhost:5183/swagger`

### Bước 3: Chạy ứng dụng Flutter
- **Cách 1: Chạy trên Windows Desktop (Cực nhanh để test ngay):**
  Nhấp đúp chuột chạy:
  ```cmd
  3_Chay_Flutter_Windows.bat
  ```
- **Cách 2: Chạy trên máy ảo Android (Pixel / Android Emulator):**
  Nhấp đúp chuột chạy:
  ```cmd
  4_Chay_Flutter_Android.bat
  ```

---

## 🗂️ CẤU TRÚC DỰ ÁN

```
buoi10/
├── 1_KhoiTao_CSDL.bat              # Script khởi tạo CSDL CuaHangDienThoaiDB
├── 2_Chay_Backend_API.bat           # Script khởi động ASP.NET Core API cổng 5183
├── 3_Chay_Flutter_Windows.bat       # Script chạy Flutter trên Windows
├── 4_Chay_Flutter_Android.bat       # Script chạy Flutter trên máy ảo Android
├── setup_CuaHangDienThoaiDB.sql     # Script SQL tạo 4 bảng và dữ liệu mẫu chuẩn theo slide
├── DoAnAPI/                         # Thư mục Backend ASP.NET Core 9.0
│   ├── Controllers/
│   │   ├── DienThoaiController.cs  # CRUD điện thoại + lọc nổi bật
│   │   ├── HoaDonController.cs    # Lưu hóa đơn thanh toán vào CSDL & xem lịch sử
│   │   └── KhachHangController.cs  # Quản lý khách hàng
│   ├── Models/
│   │   ├── DienThoai.cs
│   │   ├── KhachHang.cs
│   │   ├── HoaDon.cs
│   │   ├── ChiTietHoaDon.cs
│   │   ├── TaoHoaDonDto.cs
│   │   └── CuaHangDbContext.cs
│   ├── Program.cs
│   └── appsettings.json
└── lib/                             # Thư mục Frontend Flutter
    ├── models/
    │   ├── dien_thoai.dart          # Model Điện thoại
    │   ├── item_gio_hang.dart       # Model Mục giỏ hàng
    │   └── hoa_don.dart             # Model Hóa đơn & chi tiết
    ├── services/
    │   ├── api_service.dart         # Kết nối API .NET + fallback dữ liệu
    │   └── cart_manager.dart        # Quản lý state giỏ hàng (ChangeNotifier)
    ├── widgets/
    │   └── app_drawer.dart          # Drawer menu có avatar Lương Viễn Đông
    ├── screens/
    │   ├── welcome_screen.dart      # Màn hình giới thiệu HUIT
    │   ├── store_screen.dart        # Màn hình Cửa hàng (2 danh mục)
    │   ├── cart_screen.dart         # Màn hình Giỏ hàng & Thanh toán
    │   ├── product_detail_screen.dart # Chi tiết sản phẩm
    │   └── order_history_screen.dart  # Lịch sử hóa đơn từ SQL Server
    └── main.dart                    # Entry point của ứng dụng
```
