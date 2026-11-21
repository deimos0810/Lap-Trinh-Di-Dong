# BÀI THỰC HÀNH BUỔI 11: FLUTTER & FIREBASE
**Sinh viên thực hiện**: Lương Viễn Đông  
**Mã số sinh viên**: 2001230180  
**Học phần**: Lập trình di động (LTDD)  

---

## 1. TỔNG QUAN NỘI DUNG THỰC HIỆN

Dự án được cấu trúc bài bản theo từng phần bài tập trong tài liệu chương 7:

```
buoi11/lib/
├── firebase_options.dart              # Cấu hình kết nối Firebase
├── main.dart                          # Dashboard điều hướng tất cả bài tập
├── bai1_auth/                         # BÀI TẬP 1: Firebase Authentication
│   └── auth_screen.dart               # Đăng ký, đăng nhập Email/Password, Google Sign-in & Guest
├── bai2_upload/                       # BÀI TẬP 2: Quản lý Upload File
│   ├── models/upload_item.dart        # Model quản lý file & tác vụ
│   └── upload_manager_screen.dart     # Giao diện tải file, tiến trình %, Pause/Resume/Cancel
├── bai3_product/                      # BÀI TẬP 3: Quản lý Sản phẩm (Store)
│   └── product_list_screen.dart       # Realtime Firestore, thêm sản phẩm kèm ảnh, xóa sản phẩm
└── baitap_venha_wallet/               # BÀI TẬP VỀ NHÀ: Ví điện tử ZhipPay
    ├── services/wallet_service.dart   # Nạp, rút, chuyển khoản ACID qua Firestore runTransaction
    └── screens/
        ├── onboarding_screen.dart     # Giao diện chào mừng & Welcome Card
        ├── dashboard_screen.dart      # Tổng số dư ví, điểm thưởng, tiện ích nhanh, lịch sử
        ├── send_money_screen.dart     # Chuyển tiền với bàn phím số (Numpad) custom
        ├── profile_screen.dart        # Quản lý hồ sơ cá nhân & đổi Avatar
        └── statistics_screen.dart     # Thống kê dòng tiền Thu/Chi theo 1 tháng, 1 quý, 1 năm
```

---

## 2. HƯỚNG DẪN CHẠY ỨNG DỤNG

### Bước 1: Cài đặt thư viện
```bash
flutter pub get
```

### Bước 2: Chạy ứng dụng trên thiết bị / máy ảo
```bash
flutter run
```

---

## 3. LỊCH SỬ COMMIT GIT CHUẨN MỰC
- `chore: khoi tao project buoi11 va cau hinh firebase core dependencies`
- `feat(bai1): hoan thien UI va chuc nang Firebase Auth email/pass va google`
- `feat(bai2): xay dung man hinh upload file voi uploadtask va eventlistener`
- `feat(bai3): quan ly danh sach san pham su dung firestore va firebase storage`
- `feat(wallet): xay dung he thong vi zhippay nap rut chuyen tien va thong ke`
- `feat: tich hop co che fallback upload mo phong va base64 firestore khong can the blaze`
