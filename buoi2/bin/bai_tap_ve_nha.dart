import 'dart:io';

import '../lib/hoa_don.dart';

class QuanLyHoaDon {
  final List<HoaDon> danhSach = [];

  String nhapChuoi(String thongBao, {bool choRong = false}) {
    while (true) {
      stdout.write(thongBao);
      final giaTri = stdin.readLineSync()?.trim() ?? '';

      if (choRong || giaTri.isNotEmpty) {
        return giaTri;
      }

      print('Dữ liệu không được để trống.');
    }
  }

  String nhapMaKhachHang() {
    while (true) {
      final ma = nhapChuoi('Mã khách hàng (KHxxxx): ').toUpperCase();

      if (HoaDon.kiemTraMaKhachHang(ma)) {
        return ma;
      }

      print('Mã không hợp lệ. Ví dụ mã đúng: KH0002.');
    }
  }

  int nhapSoNguyen(String thongBao, {int min = 0}) {
    while (true) {
      final ketQua = int.tryParse(nhapChuoi(thongBao));

      if (ketQua != null && ketQua >= min) {
        return ketQua;
      }

      print('Vui lòng nhập số nguyên >= $min.');
    }
  }

  double nhapSoThuc(String thongBao, {double min = 0}) {
    while (true) {
      final chuoi = nhapChuoi(thongBao).replaceAll(',', '.');
      final ketQua = double.tryParse(chuoi);

      if (ketQua != null && ketQua >= min) {
        return ketQua;
      }

      print('Vui lòng nhập số >= $min.');
    }
  }

  HoaDon? taoHoaDonTuBanPhim() {
    final loai = nhapChuoi('Loại khách hàng [CN/DL/CT]: ').toUpperCase();
    final ma = nhapMaKhachHang();
    final ten = nhapChuoi('Tên khách hàng: ');
    final soLuong = nhapSoNguyen('Số lượng: ', min: 1);
    final giaBan = nhapSoThuc('Giá bán: ', min: 1);

    try {
      switch (loai) {
        case 'CN':
          final khoangCach = nhapSoThuc('Khoảng cách giao hàng (km): ');
          return KhachHangCaNhan(
            maKhachHang: ma,
            tenKhachHang: ten,
            soLuong: soLuong,
            giaBan: giaBan,
            khoangCachGiaoHang: khoangCach,
          );
        case 'DL':
          final hopTac = nhapSoNguyen('Thời gian hợp tác (năm): ');
          return DaiLyCap1(
            maKhachHang: ma,
            tenKhachHang: ten,
            soLuong: soLuong,
            giaBan: giaBan,
            thoiGianHopTac: hopTac,
          );
        case 'CT':
          final nhanVien = nhapSoNguyen('Số lượng nhân viên: ');
          return KhachHangCongTy(
            maKhachHang: ma,
            tenKhachHang: ten,
            soLuong: soLuong,
            giaBan: giaBan,
            soLuongNhanVien: nhanVien,
          );
        default:
          print('Loại khách hàng không hợp lệ. Chỉ nhận CN, DL hoặc CT.');
          return null;
      }
    } on ArgumentError catch (e) {
      print('Lỗi dữ liệu: ${e.message}');
      return null;
    }
  }

  void nhapDanhSach() {
    danhSach.clear();
    final soHoaDon = nhapSoNguyen('Nhập số lượng hóa đơn: ', min: 1);

    for (int i = 0; i < soHoaDon; i++) {
      print('\n--- Hóa đơn thứ ${i + 1} ---');
      final hoaDon = taoHoaDonTuBanPhim();

      if (hoaDon != null) {
        danhSach.add(hoaDon);
      } else {
        print('Nhập lại hóa đơn này.');
        i--;
      }
    }
  }

  void inTieuDe(String tieuDe) {
    print('\n========== $tieuDe ==========');
  }

  void xuatDanhSach([List<HoaDon>? dsCanXuat]) {
    final ds = dsCanXuat ?? danhSach;

    if (ds.isEmpty) {
      print('Danh sách hóa đơn đang rỗng.');
      return;
    }

    for (int i = 0; i < ds.length; i++) {
      print('${i + 1}. ${ds[i]}');
    }
  }

  void tinhTongThanhTien() {
    final tong = danhSach.fold<double>(
      0,
      (ketQua, hoaDon) => ketQua + hoaDon.thanhTien(),
    );
    print('Tổng thành tiền tất cả hóa đơn: ${tong.toStringAsFixed(0)} VNĐ');
  }

  void tinhTongTroGia() {
    final tong = danhSach.fold<double>(
      0,
      (ketQua, hoaDon) => ketQua + hoaDon.tinhTroGia(),
    );
    print(
      'Tổng tiền trợ giá công ty đã hỗ trợ: ${tong.toStringAsFixed(0)} VNĐ',
    );
  }

  void khachHangMuaNhieuNhat() {
    if (danhSach.isEmpty) {
      print('Danh sách hóa đơn đang rỗng.');
      return;
    }

    final maxSoLuong = danhSach
        .map((hoaDon) => hoaDon.soLuong)
        .reduce((a, b) => a > b ? a : b);

    final ketQua = danhSach
        .where((hoaDon) => hoaDon.soLuong == maxSoLuong)
        .toList();

    print('Số lượng mua nhiều nhất: $maxSoLuong');
    xuatDanhSach(ketQua);
  }

  void tongChietKhauKhachHangCongTy() {
    final tong = danhSach.whereType<KhachHangCongTy>().fold<double>(
      0,
      (ketQua, hoaDon) => ketQua + hoaDon.tinhChietKhau(),
    );

    print(
      'Tổng tiền chiết khấu cho khách hàng công ty: '
      '${tong.toStringAsFixed(0)} VNĐ',
    );
  }

  void sapXepTheoSoLuongVaThanhTien() {
    danhSach.sort((a, b) {
      final soSanhSoLuong = a.soLuong.compareTo(b.soLuong);

      if (soSanhSoLuong != 0) {
        return soSanhSoLuong;
      }

      return a.thanhTien().compareTo(b.thanhTien());
    });

    print('Đã sắp xếp tăng dần theo số lượng; nếu bằng nhau, theo thành tiền.');
  }

  void timHoaDonTheoMaKhachHang() {
    final ma = nhapMaKhachHang();
    final ketQua = danhSach
        .where((hoaDon) => hoaDon.maKhachHang.toUpperCase() == ma)
        .toList();

    if (ketQua.isEmpty) {
      print('Khách hàng lạ');
    } else {
      xuatDanhSach(ketQua);
    }
  }

  HoaDon? taoHoaDonTuDong(String dong) {
    final p = dong.split('#');

    if (p.length != 6) {
      return null;
    }

    try {
      final loai = p[0].trim().toUpperCase();
      final ma = p[1].trim().toUpperCase();
      final ten = p[2].trim();
      final soLuong = int.parse(p[3].trim());
      final giaBan = double.parse(p[4].trim().replaceAll(',', '.'));
      final thongTinThem = p[5].trim();

      switch (loai) {
        case 'CN':
          return KhachHangCaNhan(
            maKhachHang: ma,
            tenKhachHang: ten,
            soLuong: soLuong,
            giaBan: giaBan,
            khoangCachGiaoHang: double.parse(thongTinThem.replaceAll(',', '.')),
          );
        case 'DL':
          return DaiLyCap1(
            maKhachHang: ma,
            tenKhachHang: ten,
            soLuong: soLuong,
            giaBan: giaBan,
            thoiGianHopTac: int.parse(thongTinThem),
          );
        case 'CT':
          return KhachHangCongTy(
            maKhachHang: ma,
            tenKhachHang: ten,
            soLuong: soLuong,
            giaBan: giaBan,
            soLuongNhanVien: int.parse(thongTinThem),
          );
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  void docFile(String tenFile) {
    final file = File(tenFile);

    if (!file.existsSync()) {
      print('Không tìm thấy file: $tenFile');
      return;
    }

    danhSach.clear();
    int dongLoi = 0;

    for (final dong in file.readAsLinesSync()) {
      if (dong.trim().isEmpty) continue;

      final hoaDon = taoHoaDonTuDong(dong);
      if (hoaDon == null) {
        dongLoi++;
      } else {
        danhSach.add(hoaDon);
      }
    }

    print('Đã đọc ${danhSach.length} hóa đơn từ file.');
    if (dongLoi > 0) {
      print('Có $dongLoi dòng dữ liệu không hợp lệ.');
    }
  }

  void menu() {
    while (true) {
      print('''

============== QUẢN LÝ HÓA ĐƠN ==============
1. Nhập danh sách hóa đơn từ bàn phím
2. Đọc danh sách hóa đơn từ file
3. Xuất danh sách hóa đơn
4. Tính tổng thành tiền tất cả hóa đơn
5. Tính tổng tiền trợ giá công ty đã hỗ trợ
6. Cho biết khách hàng có số lượng mua nhiều nhất
7. Tính tổng chiết khấu đối với khách hàng công ty
8. Sắp xếp tăng dần theo số lượng, rồi thành tiền
9. Xuất hóa đơn của khách hàng theo mã
0. Thoát
================================================
''');

      final luaChon = nhapChuoi('Chọn chức năng: ');

      switch (luaChon) {
        case '1':
          nhapDanhSach();
          break;
        case '2':
          docFile('data/hoadon.txt');
          break;
        case '3':
          inTieuDe('DANH SÁCH HÓA ĐƠN');
          xuatDanhSach();
          break;
        case '4':
          tinhTongThanhTien();
          break;
        case '5':
          tinhTongTroGia();
          break;
        case '6':
          inTieuDe('KHÁCH HÀNG MUA NHIỀU NHẤT');
          khachHangMuaNhieuNhat();
          break;
        case '7':
          tongChietKhauKhachHangCongTy();
          break;
        case '8':
          sapXepTheoSoLuongVaThanhTien();
          break;
        case '9':
          timHoaDonTheoMaKhachHang();
          break;
        case '0':
          print('Đã kết thúc chương trình.');
          return;
        default:
          print('Lựa chọn không hợp lệ.');
      }
    }
  }
}

void main() {
  final quanLy = QuanLyHoaDon();
  quanLy.menu();
}
