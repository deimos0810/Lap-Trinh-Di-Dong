class HoaDon {
  final String maHD;
  final DateTime ngayLap;
  final String maKH;
  final double tongTien;
  final String trangThai;
  final List<ChiTietHoaDonModel> chiTiets;

  HoaDon({
    required this.maHD,
    required this.ngayLap,
    required this.maKH,
    required this.tongTien,
    required this.trangThai,
    this.chiTiets = const [],
  });

  factory HoaDon.fromJson(Map<String, dynamic> json) {
    var rawList = json['chiTietHoaDons'] ?? json['ChiTietHoaDons'] ?? [];
    List<ChiTietHoaDonModel> list = [];
    if (rawList is List) {
      list = rawList.map((x) => ChiTietHoaDonModel.fromJson(x)).toList();
    }

    return HoaDon(
      maHD: (json['maHD'] ?? json['MaHD'] ?? '').toString(),
      ngayLap: json['ngayLap'] != null
          ? DateTime.tryParse(json['ngayLap'].toString()) ?? DateTime.now()
          : DateTime.now(),
      maKH: (json['maKH'] ?? json['MaKH'] ?? '').toString(),
      tongTien: (json['tongTien'] ?? json['TongTien'] ?? 0.0) is num
          ? (json['tongTien'] ?? json['TongTien'] as num).toDouble()
          : double.tryParse((json['tongTien'] ?? json['TongTien']).toString()) ?? 0.0,
      trangThai: (json['trangThai'] ?? json['TrangThai'] ?? 'Đã thanh toán').toString(),
      chiTiets: list,
    );
  }
}

class ChiTietHoaDonModel {
  final int id;
  final String maHD;
  final String maDT;
  final String tenDT;
  final int soLuong;
  final double donGia;
  final double thanhTien;

  ChiTietHoaDonModel({
    required this.id,
    required this.maHD,
    required this.maDT,
    required this.tenDT,
    required this.soLuong,
    required this.donGia,
    required this.thanhTien,
  });

  factory ChiTietHoaDonModel.fromJson(Map<String, dynamic> json) {
    var dienThoaiObj = json['dienThoai'] ?? json['DienThoai'];
    String ten = '';
    if (dienThoaiObj != null && dienThoaiObj is Map) {
      ten = (dienThoaiObj['tenDT'] ?? dienThoaiObj['TenDT'] ?? '').toString();
    }

    return ChiTietHoaDonModel(
      id: json['id'] ?? json['Id'] ?? 0,
      maHD: (json['maHD'] ?? json['MaHD'] ?? '').toString(),
      maDT: (json['maDT'] ?? json['MaDT'] ?? '').toString(),
      tenDT: ten,
      soLuong: json['soLuong'] ?? json['SoLuong'] ?? 1,
      donGia: (json['donGia'] ?? json['DonGia'] ?? 0.0) is num
          ? (json['donGia'] ?? json['DonGia'] as num).toDouble()
          : double.tryParse((json['donGia'] ?? json['DonGia']).toString()) ?? 0.0,
      thanhTien: (json['thanhTien'] ?? json['ThanhTien'] ?? 0.0) is num
          ? (json['thanhTien'] ?? json['ThanhTien'] as num).toDouble()
          : double.tryParse((json['thanhTien'] ?? json['ThanhTien']).toString()) ?? 0.0,
    );
  }
}
