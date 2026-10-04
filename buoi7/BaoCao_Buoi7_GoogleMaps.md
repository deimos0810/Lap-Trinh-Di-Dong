# BÁO CÁO THỰC HÀNH
# BÀI 07: MULTIMEDIA (tt) – GOOGLE MAPS & LOCATION SERVICES

---

| | |
|:---|:---|
| **Họ và tên** | Lương Viễn Đông |
| **MSSV** | 2001230180 |
| **Môn học** | Lập Trình Di Động |
| **Giảng viên hướng dẫn** | *(Tên giảng viên)* |
| **Thư mục bài làm** | `buoi7/` |
| **Link GitHub** | https://github.com/deimos0810/Lap-Trinh-Di-Dong.git |
| **Ngày nộp** | 04/10/2026 |

---

## I. GIỚI THIỆU TỔNG QUAN

Báo cáo này trình bày kết quả thực hành **Bài 07 – Multimedia (tt): Google Maps & Location Services** trong môn học Lập Trình Di Động. Nội dung bài thực hành xoay quanh việc tích hợp dịch vụ bản đồ và định vị địa lý vào ứng dụng di động xây dựng bằng **Flutter**, từ hiển thị bản đồ cơ bản, tìm đường đi, đến lưu trữ dữ liệu cục bộ bằng SQLite.

Toàn bộ ứng dụng được phát triển trong một dự án Flutter duy nhất (`buoi7/`), với kiến trúc mã nguồn được tổ chức theo các module rõ ràng:

```
buoi7/
├── lib/
│   ├── main.dart                      # Điểm khởi đầu ứng dụng
│   ├── models/
│   │   └── favorite_route.dart        # Model dữ liệu tuyến đường yêu thích
│   ├── services/
│   │   ├── directions_service.dart    # Gọi Google Directions API & Geocoding
│   │   └── sqlite_service.dart        # Quản lý CSDL SQLite cục bộ
│   └── screens/
│       ├── bai1_map_screen.dart       # Bài 1: Hiển thị bản đồ & vị trí GPS
│       ├── bai2_route_screen.dart     # Bài 2: Tìm tuyến đường theo tọa độ
│       ├── bai4_inclass_screen.dart   # Bài 4: Bài tập tại lớp (POI, Tap, Distance)
│       └── homework_map_screen.dart   # Bài tập về nhà: Geocoding & SQLite
└── android/
    └── app/src/main/AndroidManifest.xml  # Khai báo API Key & quyền truy cập
```

### 1.1. Công nghệ và thư viện sử dụng

| Thư viện | Phiên bản | Chức năng |
|:---|:---:|:---|
| `google_maps_flutter` | ^2.5.3 | Hiển thị bản đồ tương tác Google Maps trên Android/iOS |
| `geolocator` | ^11.0.0 | Truy vấn vị trí GPS hiện tại của thiết bị |
| `geocoding` | ^3.0.0 | Chuyển đổi địa chỉ văn bản ↔ tọa độ `LatLng` |
| `http` | ^1.2.0 | Gửi yêu cầu HTTP tới Google Directions API |
| `sqflite` | ^2.3.2 | Quản lý CSDL SQLite trên thiết bị (Android/iOS) |
| `sqflite_common_ffi` | ^2.3.2 | Hỗ trợ SQLite trên môi trường Desktop (Windows/Linux/macOS) |
| `path` | ^1.9.0 | Xác định đường dẫn lưu trữ file CSDL |

---

## II. NỘI DUNG THỰC HIỆN

### Bài 1: Hiển thị bản đồ Google Maps và đánh dấu vị trí hiện tại

**File thực hiện:** `lib/screens/bai1_map_screen.dart`

#### Mục tiêu

Nhúng widget Google Maps vào giao diện ứng dụng Flutter, đồng thời lấy tọa độ GPS của thiết bị và hiển thị Marker tại vị trí đó.

#### Các bước thực hiện

**Bước 1 – Xin quyền truy cập vị trí:**
Sử dụng `Geolocator.checkPermission()` kết hợp `Geolocator.requestPermission()` để kiểm tra và yêu cầu quyền `ACCESS_FINE_LOCATION`. Ứng dụng xử lý đầy đủ ba trạng thái: *được cấp*, *bị từ chối* và *bị từ chối vĩnh viễn*.

**Bước 2 – Lấy vị trí GPS:**
Gọi `Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)` để lấy tọa độ thực tế. Trong trường hợp máy ảo chưa được cấu hình GPS, chương trình tự động sử dụng tọa độ mặc định của TP. Hồ Chí Minh (10.7769, 106.7009).

**Bước 3 – Hiển thị bản đồ và Marker:**
Widget `GoogleMap` được khởi tạo với `initialCameraPosition` trỏ về TP. Hồ Chí Minh. Sau khi lấy được vị trí, `GoogleMapController.animateCamera()` được gọi để di chuyển camera tới đúng vị trí hiện tại. Một `Marker` với `InfoWindow` hiển thị tọa độ chi tiết được cắm tại đó.

```dart
Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);
final pos = LatLng(position.latitude, position.longitude);
_markers.add(Marker(
  markerId: const MarkerId("Vị trí của bạn"),
  position: pos,
  infoWindow: InfoWindow(
    title: "Vị trí của bạn",
    snippet: 'Vĩ độ: ${pos.latitude.toStringAsFixed(4)}, '
             'Kinh độ: ${pos.longitude.toStringAsFixed(4)}',
  ),
));
```

> **[Chèn ảnh: Màn hình Bài 1 – Hiển thị bản đồ Google Maps và Marker tại vị trí hiện tại TP.HCM]**

---

### Bài 2: Tìm tuyến đường theo tọa độ (Route Finder)

**File thực hiện:** `lib/screens/bai2_route_screen.dart`

#### Mục tiêu

Cho phép người dùng nhập tọa độ điểm xuất phát và điểm đích, sau đó gọi **Google Directions API** để lấy và vẽ tuyến đường dạng Polyline lên bản đồ.

#### Các bước thực hiện

**Bước 1 – Nhập tọa độ:**
Hai ô `TextField` cho phép nhập dưới dạng `latitude, longitude`. Khi khởi động, điểm xuất phát được tự động điền bằng GPS hiện tại; điểm đích mặc định là **Trường Đại học Công Thương TP.HCM – HUIT** (10.8065, 106.6289).

**Bước 2 – Gọi Google Directions API:**
Hàm `DirectionsService.getDirections()` gửi yêu cầu HTTP GET đến:
```
https://maps.googleapis.com/maps/api/directions/json
  ?origin={lat},{lng}
  &destination={lat},{lng}
  &mode=driving
  &key={API_KEY}
```

**Bước 3 – Giải mã Polyline và vẽ tuyến đường:**
Chuỗi `overview_polyline.points` trong phản hồi JSON được giải mã bằng thuật toán Polyline Encoding của Google, cho ra danh sách `List<LatLng>`. Danh sách này được truyền vào đối tượng `Polyline` (màu xanh dương, độ rộng 5px) và hiển thị trên bản đồ.

**Bước 4 – Hiển thị kết quả:**
Sau khi tìm đường thành công, `SnackBar` thông báo khoảng cách (`distance.text`) và thời gian di chuyển (`duration.text`) lấy từ phản hồi API.

> **[Chèn ảnh: Màn hình Bài 2 – Tuyến đường Polyline từ vị trí hiện tại đến ĐH Công Thương TP.HCM]**

---

### Bài 3 (Tại lớp – Bài 4): Mở rộng tính năng định vị và lọc POI

**File thực hiện:** `lib/screens/bai4_inclass_screen.dart`

#### Mục tiêu

Mở rộng bài 2 với các tính năng nâng cao: nút nhanh lấy vị trí hiện tại, hiển thị khoảng cách và thời gian di chuyển, cho phép chọn điểm bằng thao tác chạm lên bản đồ, và lọc các địa điểm quan tâm (POI) theo danh mục.

#### Các tính năng đã thực hiện

**a) Điểm mặc định tự động:**
Khi màn hình khởi động, ứng dụng tự động xác định vị trí GPS làm điểm xuất phát và đặt sẵn **ĐH Công Thương TP.HCM (HUIT)** (10.8065, 106.6289) làm điểm đích.

**b) Chọn điểm bằng Tap bản đồ:**
Sự kiện `onTap` của widget `GoogleMap` được lắng nghe. Tùy theo chế độ (`ChoiceChip`) đang được chọn, thao tác chạm sẽ cập nhật điểm xuất phát hoặc điểm đích tương ứng.

```dart
void _onMapTapped(LatLng position) {
  if (_mapClickTarget == 'start') {
    _startLatLng = position;
    _startController.text = '${position.latitude.toStringAsFixed(4)}, ...';
  } else {
    _endLatLng = position;
    _endController.text = '${position.latitude.toStringAsFixed(4)}, ...';
  }
  _updateMarkers();
}
```

**c) Hiển thị khoảng cách và thời gian di chuyển:**
Sau khi tính toán tuyến đường, các giá trị `distance.text` và `duration.text` được trích xuất từ phản hồi API và hiển thị trực quan trên thẻ thông tin.

**d) Lọc địa điểm POI (Points of Interest):**
Bốn `FilterChip` tương ứng bốn danh mục địa điểm, mỗi loại được thể hiện bằng màu Marker riêng biệt, sử dụng dữ liệu các địa điểm thực tế tại TP. Hồ Chí Minh:

| Danh mục | Màu Marker | Ví dụ địa điểm thực tế |
|:---|:---:|:---|
| Quán ăn | 🟠 Cam | Bún bò Huế 72 Tân Phú, Phở Hùng Tân Phú |
| Khách sạn | 🟣 Tím | Khách sạn Kim Anh, Mường Thanh Sài Gòn |
| Bệnh viện | 🌸 Hồng | Bệnh viện Chợ Rẫy, BV Nhi Đồng 1, BV Quận Tân Phú |
| Trường học | 🔵 Xanh lam | ĐH Công Thương TP.HCM, ĐH Bách Khoa, ĐH Sư phạm |

> **[Chèn ảnh: Màn hình Bài 4 – Tuyến đường và Marker POI phân màu sắc theo danh mục trên bản đồ]**

> **[Chèn ảnh: Thẻ thông tin hiển thị Khoảng cách và Thời gian di chuyển]**

---

### Bài 4 (Về nhà): Geocoding, Phương tiện di chuyển & Lưu trữ SQLite

**File thực hiện:** `lib/screens/homework_map_screen.dart`

#### Mục tiêu

Nâng cấp trải nghiệm người dùng bằng cách cho phép nhập **địa chỉ dạng văn bản** thay vì tọa độ số, lựa chọn **phương tiện di chuyển**, và **lưu trữ tuyến đường yêu thích** vào cơ sở dữ liệu SQLite nội bộ.

#### Các tính năng đã thực hiện

**a) Geocoding – Chuyển đổi địa chỉ thành tọa độ:**
Người dùng nhập địa chỉ dạng văn bản (ví dụ: *"227 Nguyễn Văn Cừ, Quận 5, TP.HCM"*). Hàm `DirectionsService.getCoordinatesFromAddress()` sử dụng thư viện `geocoding` làm nguồn chính, kết hợp OpenStreetMap Nominatim API làm nguồn dự phòng.

**b) Lựa chọn phương tiện di chuyển:**
`SegmentedButton` cho phép chuyển đổi giữa bốn chế độ di chuyển. Mỗi chế độ hiển thị Polyline với màu sắc phân biệt rõ ràng:

| Phương tiện | Tham số API | Màu Polyline |
|:---|:---:|:---:|
| Ô tô | `driving` | 🔵 Xanh lam |
| Xe máy | `bicycling` | 🟠 Cam |
| Đi bộ | `walking` | 🟢 Xanh lá |
| Xe buýt | `transit` | 🟣 Tím |

**c) Lưu trữ tuyến đường yêu thích bằng SQLite:**
Lớp `SqliteService` quản lý bảng `favorite_routes`. Sau khi tìm được tuyến đường, người dùng nhấn nút **"Lưu SQLite"** để lưu toàn bộ thông tin, bao gồm địa chỉ, tọa độ, phương tiện, khoảng cách, thời gian và thời điểm tạo.

```sql
CREATE TABLE favorite_routes (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  title        TEXT    NOT NULL,
  startAddress TEXT    NOT NULL,
  startLat     REAL    NOT NULL,
  startLng     REAL    NOT NULL,
  endAddress   TEXT    NOT NULL,
  endLat       REAL    NOT NULL,
  endLng       REAL    NOT NULL,
  travelMode   TEXT    NOT NULL,
  distanceText TEXT    NOT NULL,
  durationText TEXT    NOT NULL,
  createdAt    TEXT    NOT NULL
)
```

**d) Xem lại và quản lý tuyến đường đã lưu:**
Nút **⭐** trên AppBar mở `ModalBottomSheet` liệt kê toàn bộ tuyến đường đã lưu. Người dùng có thể nhấn vào một mục để khôi phục và hiển thị lại tuyến đường trên bản đồ, hoặc nhấn biểu tượng thùng rác để xóa khỏi CSDL.

> **[Chèn ảnh: Màn hình Bài tập về nhà – Giao diện nhập địa chỉ và chọn phương tiện di chuyển]**

> **[Chèn ảnh: ModalBottomSheet hiển thị danh sách tuyến đường yêu thích đã lưu trong SQLite]**

---

## III. CẤU HÌNH VÀ TRIỂN KHAI

### 3.1. Cấu hình Google Maps API Key

File `android/app/src/main/AndroidManifest.xml` được khai báo đầy đủ quyền truy cập vị trí và API Key:

```xml
<!-- Quyền truy cập vị trí -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />

<!-- Google Maps API Key -->
<application ...>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="AIzaSyB_ALUqcqvAsERy26jsTnyzZLnrs0ySzls" />
</application>
```

### 3.2. Cấu hình Gradle (Android Build)

Do các thư viện `google_maps_flutter_android`, `geolocator_android` và `geocoding_android` yêu cầu Android SDK API tối thiểu là 36, hai file Gradle đã được điều chỉnh so với cấu hình mặc định:

- **`android/app/build.gradle.kts`:** Đặt `compileSdk = 36`, `minSdk = 21`, `targetSdk = 34`.
- **`android/build.gradle.kts`:** Ép tất cả subproject plugin biên dịch ở mức SDK 36.
- **`android/gradle.properties`:** Thêm `kotlin.incremental=false` để tránh lỗi khóa cache của trình biên dịch Kotlin 2.4.0 trên hệ điều hành Windows.

### 3.3. Các thư viện phụ thuộc (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_maps_flutter: ^2.5.3
  geolocator: ^11.0.0
  geocoding: ^3.0.0
  http: ^1.2.0
  sqflite: ^2.3.2
  path: ^1.9.0
  sqflite_common_ffi: ^2.3.2
```

### 3.4. Lệnh biên dịch và chạy ứng dụng

```bash
# Bước 1: Di chuyển vào thư mục dự án
cd buoi7

# Bước 2: Tải các gói phụ thuộc
flutter pub get

# Bước 3: Kiểm tra mã nguồn (phân tích tĩnh)
flutter analyze
# Kết quả: No issues found!

# Bước 4: Chạy ứng dụng trên máy ảo Android
flutter run -d emulator-5554
```

> **Lưu ý:** Package `google_maps_flutter` không hỗ trợ nền tảng Windows Desktop. Vui lòng sử dụng máy ảo Android Emulator hoặc thiết bị thật khi kiểm thử.

---

## IV. KẾT QUẢ VÀ NHẬN XÉT

### 4.1. Bảng tổng hợp kết quả

| STT | Nội dung yêu cầu | Kết quả |
|:---:|:---|:---:|
| 1 | Hiển thị bản đồ Google Maps, lấy vị trí GPS | ✅ Hoàn thành |
| 2 | Tìm tuyến đường theo tọa độ, vẽ Polyline | ✅ Hoàn thành |
| 3 | Tap bản đồ chọn điểm, hiển thị Distance & Duration | ✅ Hoàn thành |
| 4 | Lọc địa điểm POI (4 danh mục, Marker phân màu) | ✅ Hoàn thành |
| 5 | Nhập địa chỉ văn bản qua Geocoding API | ✅ Hoàn thành |
| 6 | Chọn phương tiện di chuyển, Polyline phân màu | ✅ Hoàn thành |
| 7 | Lưu, xem lại và xóa tuyến đường yêu thích (SQLite) | ✅ Hoàn thành |
| 8 | `flutter analyze` không phát hiện lỗi | ✅ *No issues found!* |

### 4.2. Nhận xét

Qua quá trình thực hành, bài tập đã cung cấp cái nhìn toàn diện về việc tích hợp các dịch vụ vị trí và bản đồ vào ứng dụng di động. Việc kết hợp giữa **Google Maps SDK**, **Directions API**, **Geocoding API** và **SQLite** phản ánh đúng quy trình phát triển một tính năng bản đồ hoàn chỉnh trong thực tế, từ khâu hiển thị giao diện, xử lý dữ liệu từ API cho đến lưu trữ cục bộ.

Một điểm đáng chú ý trong quá trình triển khai là môi trường máy ảo Android Emulator mặc định đặt vị trí GPS tại trụ sở Google ở California (Hoa Kỳ), đòi hỏi người lập trình phải chủ động cấu hình lại vị trí thông qua *Extended Controls* của Emulator, hoặc xử lý trường hợp GPS không khả dụng bằng giá trị dự phòng phù hợp với bối cảnh Việt Nam.

---

*Báo cáo được biên soạn bởi: **Lương Viễn Đông – MSSV: 2001230180***
*Ngày: 04/10/2026*
