import 'dart:io';

import '../lib/mon_hoc.dart';

class QuanLyMonHoc {
  final List<MonHoc> danhSach = [];

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

  int nhapSoNguyen(String thongBao, {int min = 1}) {
    while (true) {
      final giaTri = nhapChuoi(thongBao);
      final ketQua = int.tryParse(giaTri);

      if (ketQua != null && ketQua >= min) {
        return ketQua;
      }

      print('Vui lòng nhập số nguyên >= $min.');
    }
  }

  double nhapDiem(String thongBao) {
    while (true) {
      final giaTri = nhapChuoi(thongBao).replaceAll(',', '.');
      final diem = double.tryParse(giaTri);

      if (diem != null && diem >= 0 && diem <= 10) {
        return diem;
      }

      print('Điểm phải nằm trong khoảng từ 0 đến 10.');
    }
  }

  void nhapDanhSachTuBanPhim() {
    danhSach.clear();
    final soLuong = nhapSoNguyen('Nhập số lượng môn học: ');

    for (int i = 0; i < soLuong; i++) {
      print('\n--- Nhập môn học thứ ${i + 1} ---');
      nhapMotMonHoc();
    }
  }

  void nhapMotMonHoc() {
    final loai = nhapChuoi('Loại môn [LT/TH/DA]: ').toUpperCase();
    final ma = nhapChuoi('Mã môn: ');
    final ten = nhapChuoi('Tên môn: ');
    final tinChi = nhapSoNguyen('Số tín chỉ: ');

    switch (loai) {
      case 'LT':
        final tieuLuan = nhapDiem('Điểm tiểu luận: ');
        final cuoiKy = nhapDiem('Điểm cuối kỳ: ');

        danhSach.add(
          LyThuyet(
            maMon: ma,
            tenMon: ten,
            soTinChi: tinChi,
            diemTieuLuan: tieuLuan,
            diemCuoiKy: cuoiKy,
          ),
        );
        break;

      case 'TH':
        final diem = <double>[];
        for (int i = 0; i < 3; i++) {
          diem.add(nhapDiem('Điểm kiểm tra lần ${i + 1}: '));
        }

        danhSach.add(
          ThucHanh(maMon: ma, tenMon: ten, soTinChi: tinChi, diemKiemTra: diem),
        );
        break;

      case 'DA':
        final gvhd = nhapDiem('Điểm GVHD: ');
        final gvpb = nhapDiem('Điểm GVPB: ');

        danhSach.add(
          DoAn(
            maMon: ma,
            tenMon: ten,
            soTinChi: tinChi,
            diemGVHD: gvhd,
            diemGVPB: gvpb,
          ),
        );
        break;

      default:
        print('Loại môn không hợp lệ.');
    }
  }

  void inTieuDe(String tieuDe) {
    print('\n===== $tieuDe =====');
  }

  void xuatDanhSach([List<MonHoc>? danhSachCanXuat]) {
    final danhSachXuat = danhSachCanXuat ?? danhSach;

    if (danhSachXuat.isEmpty) {
      print('Danh sách môn học đang rỗng.');
      return;
    }

    for (int i = 0; i < danhSachXuat.length; i++) {
      print('${i + 1}. ${danhSachXuat[i]}');
    }
  }

  void sapXepTheoTen() {
    danhSach.sort(
      (a, b) => a.tenMon.toLowerCase().compareTo(b.tenMon.toLowerCase()),
    );
  }

  void sapXepTheoTinChi() {
    danhSach.sort((a, b) => a.soTinChi.compareTo(b.soTinChi));
  }

  void timMonNhieuTinChiNhat() {
    if (danhSach.isEmpty) {
      print('Danh sách môn học đang rỗng.');
      return;
    }

    final maxTinChi = danhSach
        .map((mon) => mon.soTinChi)
        .reduce((a, b) => a > b ? a : b);

    final ketQua = danhSach.where((mon) => mon.soTinChi == maxTinChi).toList();

    xuatDanhSach(ketQua);
  }

  void timMonTheoMa() {
    final maCanTim = nhapChuoi('Nhập mã môn cần tìm: ');
    final ketQua = danhSach
        .where((mon) => mon.maMon.toLowerCase() == maCanTim.toLowerCase())
        .toList();

    if (ketQua.isEmpty) {
      print('Không tìm thấy môn học có mã $maCanTim.');

      final them = nhapChuoi(
        'Bạn có muốn thêm môn này không? [Y/N]: ',
      ).toUpperCase();
      if (them == 'Y') {
        nhapMotMonHoc();
      }
    } else {
      xuatDanhSach(ketQua);
    }
  }

  void tinhTinChiTrungBinh() {
    if (danhSach.isEmpty) {
      print('Danh sách môn học đang rỗng.');
      return;
    }

    final tongTinChi = danhSach.fold<int>(
      0,
      (tong, mon) => tong + mon.soTinChi,
    );

    final trungBinh = tongTinChi / danhSach.length;
    print('Số tín chỉ trung bình: ${trungBinh.toStringAsFixed(2)}');
  }

  MonHoc? taoMonTuDong(String dong) {
    final parts = dong.split('#');
    if (parts.length < 5) return null;

    try {
      final loai = parts[0].toUpperCase();
      final ma = parts[1];
      final ten = parts[2];
      final tinChi = int.parse(parts[3]);
      final diem = parts
          .sublist(4)
          .map((x) => double.parse(x.replaceAll(',', '.')))
          .toList();

      if (loai == 'LT' && diem.length == 2) {
        return LyThuyet(
          maMon: ma,
          tenMon: ten,
          soTinChi: tinChi,
          diemTieuLuan: diem[0],
          diemCuoiKy: diem[1],
        );
      }

      if (loai == 'TH' && diem.length == 3) {
        return ThucHanh(
          maMon: ma,
          tenMon: ten,
          soTinChi: tinChi,
          diemKiemTra: diem,
        );
      }

      if (loai == 'DA' && diem.length == 2) {
        return DoAn(
          maMon: ma,
          tenMon: ten,
          soTinChi: tinChi,
          diemGVHD: diem[0],
          diemGVPB: diem[1],
        );
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  void docFile(String tenFile) {
    final file = File(tenFile);

    if (!file.existsSync()) {
      print('Không tìm thấy file $tenFile');
      return;
    }

    danhSach.clear();
    int soDongLoi = 0;

    for (final dong in file.readAsLinesSync()) {
      if (dong.trim().isEmpty) continue;

      final mon = taoMonTuDong(dong);
      if (mon == null) {
        soDongLoi++;
      } else {
        danhSach.add(mon);
      }
    }

    print('Đã đọc ${danhSach.length} môn học từ file.');
    if (soDongLoi > 0) {
      print('Có $soDongLoi dòng không hợp lệ.');
    }
  }

  void menu() {
    while (true) {
      print('''

========== MENU QUẢN LÝ MÔN HỌC ==========
1. Nhập danh sách môn học từ bàn phím
2. Xuất danh sách môn học
3. Kiểm tra danh sách đã sắp xếp theo tên chưa
4. Sắp xếp tăng dần theo tên môn học
5. Sắp xếp tăng dần theo số tín chỉ
6. Cho biết môn học có số tín chỉ cao nhất
7. Tìm môn theo mã, không có thì thêm vào cuối danh sách
8. Đọc danh sách môn học từ file
9. Tính số tín chỉ trung bình
0. Thoát
===========================================
''');

      final luaChon = nhapChuoi('Chọn chức năng: ');

      switch (luaChon) {
        case '1':
          nhapDanhSachTuBanPhim();
          break;
        case '2':
          inTieuDe('DANH SÁCH MÔN HỌC');
          xuatDanhSach();
          break;
        case '3':
          final daSapXep = true;
          for (int i = 0; i < danhSach.length - 1; i++) {
            if (danhSach[i].tenMon.toLowerCase().compareTo(
                  danhSach[i + 1].tenMon.toLowerCase(),
                ) >
                0) {
              print('Danh sách chưa được sắp xếp theo tên.');
              return;
            }
          }
          print(
            daSapXep
                ? 'Danh sách đang tăng dần theo tên.'
                : 'Danh sách chưa sắp xếp.',
          );
          break;
        case '4':
          sapXepTheoTen();
          print('Đã sắp xếp tăng dần theo tên.');
          break;
        case '5':
          sapXepTheoTinChi();
          print('Đã sắp xếp tăng dần theo số tín chỉ.');
          break;
        case '6':
          inTieuDe('MÔN CÓ NHIỀU TÍN CHỈ NHẤT');
          timMonNhieuTinChiNhat();
          break;
        case '7':
          timMonTheoMa();
          break;
        case '8':
          docFile('data/monhoc.txt');
          break;
        case '9':
          tinhTinChiTrungBinh();
          break;
        case '0':
          print('Kết thúc chương trình.');
          return;
        default:
          print('Lựa chọn không hợp lệ.');
      }
    }
  }
}

void main() {
  final quanLy = QuanLyMonHoc();
  quanLy.menu();
}
