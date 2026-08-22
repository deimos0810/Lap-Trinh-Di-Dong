import 'dart:io';
import '../lib/phong.dart';

List<Phong> docFile(String tenFile) {
  final file = File(tenFile);
  final danhSach = <Phong>[];

  if (!file.existsSync()) {
    print('Không tìm thấy file: $tenFile');
    return danhSach;
  }

  for (final dong in file.readAsLinesSync()) {
    if (dong.trim().isEmpty) continue;

    final p = dong.split('#');
    try {
      final ma = p[0];
      final soNguoi = int.parse(p[1]);
      final soDien = double.parse(p[2]);
      final soNuoc = double.parse(p[3]);

      if (ma.startsWith('A')) {
        danhSach.add(PhongA(ma, soNguoi, soDien, soNuoc, int.parse(p[4])));
      } else if (ma.startsWith('B')) {
        danhSach.add(
          PhongB(ma, soNguoi, soDien, soNuoc, int.parse(p[4]), int.parse(p[5])),
        );
      }
    } catch (_) {
      print('Bỏ qua dòng không hợp lệ: $dong');
    }
  }

  return danhSach;
}

void inDanhSach(List<Phong> danhSach) {
  for (final phong in danhSach) {
    print(phong);
  }
}

void main() {
  final danhSach = docFile('data/phongthue.txt');

  print('=== DANH SÁCH PHÒNG ===');
  inDanhSach(danhSach);

  print('\n=== PHÒNG CÓ SỐ NGƯỜI THUÊ > 2 ===');
  inDanhSach(danhSach.where((p) => p.soNguoi > 2).toList());

  final tongTien = danhSach.fold<double>(
    0,
    (tong, phong) => tong + phong.tinhTienPhong(),
  );
  print('\nTổng tiền phòng: $tongTien');

  danhSach.sort((a, b) => b.tinhTienPhong().compareTo(a.tinhTienPhong()));
  print('\n=== SẮP XẾP GIẢM DẦN THEO TIỀN ===');
  inDanhSach(danhSach);

  print('\n=== DANH SÁCH PHÒNG A ===');
  inDanhSach(danhSach.whereType<PhongA>().toList());
}
