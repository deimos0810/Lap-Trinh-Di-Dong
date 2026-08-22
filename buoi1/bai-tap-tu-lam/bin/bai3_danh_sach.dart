import 'dart:io';

int nhapSoNguyen(String thongBao) {
  while (true) {
    stdout.write(thongBao);
    final n = int.tryParse(stdin.readLineSync()!.trim());

    if (n != null) return n;
    print('Vui lòng nhập số nguyên.');
  }
}

void inDanhSach(List<int> danhSach) {
  print('[${danhSach.join(', ')}]');
}

bool laSoNguyenTo(int n) {
  if (n < 2) return false;

  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }

  return true;
}

void main() {
  final danhSach = <int>[];
  final soLuong = nhapSoNguyen('Nhập số lượng phần tử: ');

  for (int i = 0; i < soLuong; i++) {
    danhSach.add(nhapSoNguyen('Nhập phần tử thứ ${i + 1}: '));
  }

  print('\nDanh sách vừa nhập:');
  inDanhSach(danhSach);

  final tong = danhSach.fold<int>(0, (tong, x) => tong + x);
  print('Tổng các phần tử: $tong');

  final soNguyenTo = danhSach.where(laSoNguyenTo).toList();
  print(
    'Các số nguyên tố: ${soNguyenTo.isEmpty ? 'Không có' : soNguyenTo.join(', ')}',
  );

  final x = nhapSoNguyen('Nhập giá trị cần tìm: ');
  final viTri = <int>[];

  for (int i = 0; i < danhSach.length; i++) {
    if (danhSach[i] == x) {
      viTri.add(i);
    }
  }

  if (viTri.isEmpty) {
    danhSach.insert(0, x);
    print('Không tìm thấy $x, đã thêm $x vào đầu danh sách.');
  } else {
    print('$x xuất hiện tại vị trí: ${viTri.join(', ')}');
  }

  print('Danh sách sau cùng:');
  inDanhSach(danhSach);
}
