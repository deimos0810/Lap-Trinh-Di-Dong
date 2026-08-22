abstract class Phong {
  String maPhong;
  int soNguoi;
  double soDien;
  double soNuoc;

  Phong(this.maPhong, this.soNguoi, this.soDien, this.soNuoc);

  double tinhTienPhong();

  String loaiPhong();

  @override
  String toString() {
    return '${loaiPhong()} | Mã: $maPhong | Người thuê: $soNguoi | '
        'Điện: $soDien | Nước: $soNuoc | Tiền: ${tinhTienPhong()}';
  }
}

class PhongA extends Phong {
  int soNguoiThan;

  PhongA(
    super.maPhong,
    super.soNguoi,
    super.soDien,
    super.soNuoc,
    this.soNguoiThan,
  );

  @override
  double tinhTienPhong() {
    return 1400 + 2 * soDien + 8 * soNuoc + 50 * soNguoiThan;
  }

  @override
  String loaiPhong() => 'Phòng A';
}

class PhongB extends Phong {
  int giatui;
  int somay;

  PhongB(
    super.maPhong,
    super.soNguoi,
    super.soDien,
    super.soNuoc,
    this.giatui,
    this.somay,
  );

  @override
  double tinhTienPhong() {
    return 2000 + 2 * soDien + 8 * soNuoc + 5 * giatui + 100 * somay;
  }

  @override
  String loaiPhong() => 'Phòng B';
}
