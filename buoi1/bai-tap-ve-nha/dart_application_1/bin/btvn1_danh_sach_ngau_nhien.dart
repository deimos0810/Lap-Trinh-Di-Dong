import 'dart:math';
import 'dart:io';

List<int> taoDanhSachNgauNhien(int soLuong) {
  final random = Random();
  return List.generate(soLuong, (_) => 5 + random.nextInt(96));
}

void inDanhSach(List<int> danhSach) {
  print('[${danhSach.join(', ')}]');
}

bool laDanhSachDoiXung(List<int> danhSach) {
  for (int i = 0; i < danhSach.length ~/ 2; i++) {
    if (danhSach[i] != danhSach[danhSach.length - 1 - i]) {
      return false;
    }
  }

  return true;
}

bool tangDan(List<int> danhSach) {
  for (int i = 0; i < danhSach.length - 1; i++) {
    if (danhSach[i] > danhSach[i + 1]) return false;
  }

  return true;
}

int nhapSoNguyen(String thongBao) {
  while (true) {
    stdout.write(thongBao);
    final n = int.tryParse(stdin.readLineSync()!.trim());
    if (n != null) return n;
    print('Vui lòng nhập số nguyên.');
  }
}

void main() {
  final soLuong = nhapSoNguyen('Nhập số lượng phần tử: ');
  final danhSach = taoDanhSachNgauNhien(soLuong);

  print('\nDanh sách ngẫu nhiên:');
  inDanhSach(danhSach);

  final soLe = danhSach.where((x) => x.isOdd).toList();
  if (soLe.isEmpty) {
    print('Danh sách không có số lẻ.');
  } else {
    final tong = soLe.fold<int>(0, (tong, x) => tong + x);
    print('Các số lẻ: ${soLe.join(', ')}');
    print('Trung bình cộng số lẻ: ${(tong / soLe.length).toStringAsFixed(2)}');
  }

  print(
    laDanhSachDoiXung(danhSach)
        ? 'Danh sách đối xứng.'
        : 'Danh sách không đối xứng.',
  );

  print(
    tangDan(danhSach)
        ? 'Danh sách đã được sắp tăng dần.'
        : 'Danh sách chưa được sắp tăng dần.',
  );

  final lonNhat = danhSach.reduce(max);
  print('Phần tử lớn nhất: $lonNhat');

  final soChan = danhSach.where((x) => x.isEven).toList();
  if (soChan.isEmpty) {
    print('Danh sách không có số chẵn.');
  } else {
    final lonNhatChan = soChan.reduce(max);
    print('Phần tử là số chẵn lớn nhất: $lonNhatChan');
  }

  final x = nhapSoNguyen('Nhập giá trị cần xóa: ');
  if (!danhSach.contains(x)) {
    print('Không tìm thấy.');
  } else {
    danhSach.removeWhere((phantu) => phantu == x);
    print('Đã xóa các phần tử có giá trị $x.');
  }

  print('Danh sách sau khi xử lý:');
  inDanhSach(danhSach);
}
