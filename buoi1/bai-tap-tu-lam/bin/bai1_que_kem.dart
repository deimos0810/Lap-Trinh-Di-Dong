import 'dart:io';

double nhapSo(String thongBao) {
  while (true) {
    stdout.write(thongBao);
    final giaTri = double.tryParse(stdin.readLineSync()!.trim());

    if (giaTri != null && giaTri > 0) {
      return giaTri;
    }

    print('Vui lòng nhập một số lớn hơn 0.');
  }
}

void main() {
  final soLuong = nhapSo('Nhập số que kem cần mua: ').toInt();
  final giaMotQue = nhapSo('Nhập giá tiền một que kem: ');

  final tienGoc = soLuong * giaMotQue;
  double phanTramGiam = 0;

  if (soLuong > 10) {
    phanTramGiam = 0.10;
  } else if (soLuong >= 5 && soLuong <= 10) {
    phanTramGiam = 0.05;
  }

  final tienGiam = tienGoc * phanTramGiam;
  final tienPhaiTra = tienGoc - tienGiam;

  print('\n===== KẾT QUẢ =====');
  print('Số lượng: $soLuong que');
  print('Giá một que: ${giaMotQue.toStringAsFixed(0)}');
  print('Tiền gốc: ${tienGoc.toStringAsFixed(0)}');
  print('Giảm: ${(phanTramGiam * 100).toStringAsFixed(0)}%');
  print('Tiền giảm: ${tienGiam.toStringAsFixed(0)}');
  print('Tiền phải trả: ${tienPhaiTra.toStringAsFixed(0)}');
}
