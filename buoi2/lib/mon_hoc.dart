abstract class MonHoc {
  String maMon;
  String tenMon;
  int soTinChi;

  MonHoc({required this.maMon, required this.tenMon, required this.soTinChi});

  double tinhDiemTrungBinh();

  String quyDoiDiemHe4() {
    final diem = tinhDiemTrungBinh();

    if (diem >= 8.5) return 'A';
    if (diem >= 7.0) return 'B';
    if (diem >= 5.5) return 'C';
    if (diem >= 4.0) return 'D';
    return 'F';
  }

  String loaiMonHoc();

  String dinhDangDiem(double diem) {
    return diem.toStringAsFixed(2);
  }

  @override
  String toString() {
    return '${loaiMonHoc()} | Mã: $maMon | Tên: $tenMon | '
        'Tín chỉ: $soTinChi | ĐTB: '
        '${dinhDangDiem(tinhDiemTrungBinh())} | '
        'Điểm chữ: ${quyDoiDiemHe4()}';
  }
}

class LyThuyet extends MonHoc {
  double diemTieuLuan;
  double diemCuoiKy;

  LyThuyet({
    required super.maMon,
    required super.tenMon,
    required super.soTinChi,
    required this.diemTieuLuan,
    required this.diemCuoiKy,
  });

  @override
  double tinhDiemTrungBinh() {
    return diemTieuLuan * 0.3 + diemCuoiKy * 0.7;
  }

  @override
  String loaiMonHoc() => 'Lý thuyết';
}

class ThucHanh extends MonHoc {
  List<double> diemKiemTra;

  ThucHanh({
    required super.maMon,
    required super.tenMon,
    required super.soTinChi,
    required this.diemKiemTra,
  });

  @override
  double tinhDiemTrungBinh() {
    if (diemKiemTra.isEmpty) return 0;

    final tong = diemKiemTra.reduce((a, b) => a + b);
    return tong / diemKiemTra.length;
  }

  @override
  String loaiMonHoc() => 'Thực hành';
}

class DoAn extends MonHoc {
  double diemGVHD;
  double diemGVPB;

  DoAn({
    required super.maMon,
    required super.tenMon,
    required super.soTinChi,
    required this.diemGVHD,
    required this.diemGVPB,
  });

  @override
  double tinhDiemTrungBinh() {
    return (diemGVHD + diemGVPB) / 2;
  }

  @override
  String loaiMonHoc() => 'Đồ án';
}
