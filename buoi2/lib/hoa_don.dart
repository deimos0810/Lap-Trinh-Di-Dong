abstract class HoaDon {
  String maKhachHang;
  String tenKhachHang;
  int soLuong;
  double giaBan;

  HoaDon({
    required this.maKhachHang,
    required this.tenKhachHang,
    required this.soLuong,
    required this.giaBan,
  }) {
    if (!kiemTraMaKhachHang(maKhachHang)) {
      throw ArgumentError(
        'Mã khách hàng phải gồm 6 ký tự: KH + 4 chữ số. Ví dụ: KH0002.',
      );
    }

    if (tenKhachHang.trim().isEmpty) {
      throw ArgumentError('Tên khách hàng không được để trống.');
    }

    if (soLuong <= 0) {
      throw ArgumentError('Số lượng phải lớn hơn 0.');
    }

    if (giaBan <= 0) {
      throw ArgumentError('Giá bán phải lớn hơn 0.');
    }
  }

  static bool kiemTraMaKhachHang(String ma) {
    return RegExp(r'^KH\d{4}$').hasMatch(ma.trim());
  }

  double thanhTienGoc() => soLuong * giaBan;

  double vat() => thanhTienGoc() * 0.10;

  double tinhChietKhau();

  double tinhTroGia();

  double thanhTien() {
    return thanhTienGoc() + vat() - tinhChietKhau() - tinhTroGia();
  }

  String loaiKhachHang();

  String dinhDangTien(double tien) {
    return tien.toStringAsFixed(0);
  }

  @override
  String toString() {
    return '${loaiKhachHang()} | Mã: $maKhachHang | Tên: $tenKhachHang | '
        'SL: $soLuong | Giá bán: ${dinhDangTien(giaBan)} | '
        'Gốc: ${dinhDangTien(thanhTienGoc())} | '
        'VAT: ${dinhDangTien(vat())} | '
        'Chiết khấu: ${dinhDangTien(tinhChietKhau())} | '
        'Trợ giá: ${dinhDangTien(tinhTroGia())} | '
        'Thành tiền: ${dinhDangTien(thanhTien())}';
  }
}

class KhachHangCaNhan extends HoaDon {
  double khoangCachGiaoHang;

  KhachHangCaNhan({
    required super.maKhachHang,
    required super.tenKhachHang,
    required super.soLuong,
    required super.giaBan,
    required this.khoangCachGiaoHang,
  }) {
    if (khoangCachGiaoHang < 0) {
      throw ArgumentError('Khoảng cách giao hàng không được âm.');
    }
  }

  @override
  double tinhChietKhau() {
    final chietKhauTheoSoLuong = soLuong >= 3 ? thanhTienGoc() * 0.05 : 0;

    final chietKhauTheoKhoangCach = khoangCachGiaoHang < 10
        ? 50000.0 * soLuong
        : 0.0;

    return chietKhauTheoSoLuong + chietKhauTheoKhoangCach;
  }

  @override
  double tinhTroGia() {
    double troGia = giaBan * soLuong * 0.02;

    if (soLuong > 3) {
      troGia += 100000;
    }

    return troGia;
  }

  @override
  String loaiKhachHang() => 'Khách hàng cá nhân';
}

class DaiLyCap1 extends HoaDon {
  int thoiGianHopTac;

  DaiLyCap1({
    required super.maKhachHang,
    required super.tenKhachHang,
    required super.soLuong,
    required super.giaBan,
    required this.thoiGianHopTac,
  }) {
    if (thoiGianHopTac < 0) {
      throw ArgumentError('Thời gian hợp tác không được âm.');
    }
  }

  @override
  double tinhChietKhau() {
    double tyLeChietKhau = 0.30;

    if (thoiGianHopTac > 5) {
      tyLeChietKhau += (thoiGianHopTac - 5) * 0.01;
    }

    if (tyLeChietKhau > 0.35) {
      tyLeChietKhau = 0.35;
    }

    return thanhTienGoc() * tyLeChietKhau;
  }

  @override
  double tinhTroGia() => 0;

  @override
  String loaiKhachHang() => 'Đại lý cấp 1';
}

class KhachHangCongTy extends HoaDon {
  int soLuongNhanVien;

  KhachHangCongTy({
    required super.maKhachHang,
    required super.tenKhachHang,
    required super.soLuong,
    required super.giaBan,
    required this.soLuongNhanVien,
  }) {
    if (soLuongNhanVien < 0) {
      throw ArgumentError('Số lượng nhân viên không được âm.');
    }
  }

  @override
  double tinhChietKhau() {
    if (soLuongNhanVien > 5000) {
      return thanhTienGoc() * 0.07;
    }

    if (soLuongNhanVien > 1000) {
      return thanhTienGoc() * 0.05;
    }

    return 0;
  }

  @override
  double tinhTroGia() => 120000.0 * soLuong;

  @override
  String loaiKhachHang() => 'Khách hàng công ty';
}
