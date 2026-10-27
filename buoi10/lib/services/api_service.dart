import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/dien_thoai.dart';
import '../models/hoa_don.dart';
import '../models/item_gio_hang.dart';

class ApiService {
  // Lấy URL phù hợp tùy nền tảng (Android Emulator dùng 10.0.2.2, Windows/Web dùng localhost)
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5183';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:5183';
    } catch (_) {}
    return 'http://localhost:5183';
  }

  // Danh sách dữ liệu mẫu dự phòng khi chưa bật Web API
  static final List<DienThoai> fallbackDienThoais = [
    DienThoai(
      maDT: 'DT01',
      tenDT: 'Điện thoại 01',
      hangSX: 'Samsung',
      gia: 1200.0,
      moTa: 'Điện thoại mới của hãng Samsung với công nghệ hiện đại',
      hinhAnh: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
      noiBat: false,
    ),
    DienThoai(
      maDT: 'DT02',
      tenDT: 'Điện thoại 02',
      hangSX: 'Apple',
      gia: 200.0,
      moTa: 'Điện thoại thiết kế nhỏ gọn, cấu hình mượt mà tiện dụng',
      hinhAnh: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
      noiBat: false,
    ),
    DienThoai(
      maDT: 'DT03',
      tenDT: 'Điện thoại 03',
      hangSX: 'Xiaomi',
      gia: 850.0,
      moTa: 'Hiệu năng cao, màn hình tần số quét lớn hiển thị đẹp',
      hinhAnh: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400',
      noiBat: false,
    ),
    DienThoai(
      maDT: 'DT04',
      tenDT: 'Điện thoại 04',
      hangSX: 'Oppo',
      gia: 600.2,
      moTa: 'Thiết kế sang trọng, chuyên gia chân dung chụp hình cực nét',
      hinhAnh: 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400',
      noiBat: true,
    ),
    DienThoai(
      maDT: 'DT05',
      tenDT: 'Điện thoại 05',
      hangSX: 'Samsung',
      gia: 1500.0,
      moTa: 'Màn hình Dynamic AMOLED đỉnh cao, hỗ trợ sạc nhanh',
      hinhAnh: 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400',
      noiBat: false,
    ),
    DienThoai(
      maDT: 'DT07',
      tenDT: 'Điện thoại 07',
      hangSX: 'Apple',
      gia: 2000.0,
      moTa: 'Khung viền titan sang trọng, hiệu năng vượt bậc mạnh mẽ',
      hinhAnh: 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=400',
      noiBat: true,
    ),
    DienThoai(
      maDT: 'DT08',
      tenDT: 'iPhone 15 Pro Max',
      hangSX: 'Apple',
      gia: 18000000.0,
      moTa: 'Phone 15 Pro Max là một chiếc điện thoại thông minh cao cấp được mong đợi nhất năm 2023. Với nhiều tính năng mới và cải tiến, iPhone 15 Pro Max chắc chắn sẽ là một lựa chọn tuyệt vời cho những người dùng đang tìm kiếm một chiếc điện thoại có hiệu năng mạnh mẽ, camera chất lượng và thiết kế sang trọng. Sản phẩm chính hãng, đảm bảo chất lượng: Thế Giới Di Động là nhà bán lẻ điện thoại di động lớn nhất Việt Nam, cam kết cung cấp sản phẩm chính hãng, đảm bảo chất lượng.',
      hinhAnh: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400',
      noiBat: true,
    ),
    DienThoai(
      maDT: 'DT10',
      tenDT: 'Oppo Reno 10 Pro+',
      hangSX: 'Oppo',
      gia: 13000000.0,
      moTa: 'Hàng chính hãng, thiết kế sang trọng, camera chụp đêm siêu nét',
      hinhAnh: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=400',
      noiBat: true,
    ),
    DienThoai(
      maDT: 'DT12',
      tenDT: 'Galaxy S24 Plus',
      hangSX: 'Samsung',
      gia: 16500000.0,
      moTa: 'Hàng chính hãng, tích hợp Galaxy AI thông minh thế hệ mới',
      hinhAnh: 'https://images.unsplash.com/photo-1533228876829-65c94e7b5025?w=400',
      noiBat: true,
    ),
  ];

  // 1. Lấy tất cả điện thoại từ API
  static Future<List<DienThoai>> getDienThoais() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/DienThoai'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => DienThoai.fromJson(e)).toList();
      }
    } catch (_) {}
    return fallbackDienThoais;
  }

  // 2. Lấy danh sách sản phẩm được chọn nhiều nhất (nổi bật)
  static Future<List<DienThoai>> getDienThoaiNoiBat() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/DienThoai/noibat'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        if (data.isNotEmpty) {
          return data.map((e) => DienThoai.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return fallbackDienThoais.where((x) => x.noiBat).toList();
  }

  // 3. Gửi hóa đơn thanh toán lên API để lưu vào CSDL SQL Server
  static Future<Map<String, dynamic>> thanhToanGioHang({
    required String maKH,
    required List<ItemGioHang> items,
  }) async {
    final payload = {
      'maKH': maKH,
      'chiTiet': items.map((i) => i.toJson()).toList(),
    };

    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/HoaDon'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 6));

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(res.body),
          'message': 'Đã lưu hóa đơn thành công vào SQL Server!',
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi máy chủ (${res.statusCode}): ${res.body}',
        };
      }
    } catch (e) {
      return {
        'success': true, // Giả lập thanh toán offline nếu backend chưa mở
        'isOffline': true,
        'message': 'Đã hoàn tất thanh toán (chế độ demo ngoại tuyến)',
      };
    }
  }

  // 4. Lấy lịch sử hóa đơn từ CSDL SQL Server
  static Future<List<HoaDon>> getLichSuHoaDon() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/HoaDon'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => HoaDon.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }
}
