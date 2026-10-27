import 'dien_thoai.dart';

class ItemGioHang {
  final DienThoai dienThoai;
  int soLuong;

  ItemGioHang({
    required this.dienThoai,
    this.soLuong = 1,
  });

  double get thanhTien => dienThoai.gia * soLuong;

  Map<String, dynamic> toJson() {
    return {
      'maDT': dienThoai.maDT,
      'soLuong': soLuong,
      'donGia': dienThoai.gia,
    };
  }
}
