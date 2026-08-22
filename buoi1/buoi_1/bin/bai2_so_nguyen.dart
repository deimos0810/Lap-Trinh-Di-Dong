import 'dart:io';

int nhapSoNguyenDuongLonHon10() {
  while (true) {
    stdout.write('Nhập số nguyên dương lớn hơn 10: ');
    final n = int.tryParse(stdin.readLineSync()!.trim());

    if (n != null && n > 10) {
      return n;
    }

    print('Dữ liệu không hợp lệ.');
  }
}

List<int> tachChuSo(int n) {
  return n.toString().split('').map(int.parse).toList();
}

bool laSoLe(int n) => n % 2 != 0;

void main() {
  final n = nhapSoNguyenDuongLonHon10();
  final chuSo = tachChuSo(n);

  print('Các chữ số: ${chuSo.join(' ')}');
  print('Số chữ số: ${chuSo.length}');
  print('Tổng các chữ số: ${chuSo.reduce((a, b) => a + b)}');

  final coChuSoLe = chuSo.any(laSoLe);
  print(
    coChuSoLe
        ? 'Số đã nhập có chứa chữ số lẻ.'
        : 'Số đã nhập không chứa chữ số lẻ.',
  );
}
