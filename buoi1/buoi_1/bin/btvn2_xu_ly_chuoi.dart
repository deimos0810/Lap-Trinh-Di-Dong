import 'dart:io';

bool laNguyenAm(String kyTu) {
  const nguyenAm =
      'aeiouAEIOUáàảãạăắằẳẵặâấầẩẫậ'
      'éèẻẽẹêếềểễệóòỏõọôốồổỗộơớờởỡợ'
      'íìỉĩịúùủũụưứừửữựýỳỷỹỵ';
  return nguyenAm.contains(kyTu);
}

List<String> tachTu(String chuoi) {
  return chuoi.trim().split(RegExp(r'\s+'));
}

String daoNguocTu(String chuoi) {
  final tu = tachTu(chuoi);
  tu.reverse();
  return tu.join(' ');
}

extension ReverseList<T> on List<T> {
  void reverse() {
    int trai = 0;
    int phai = length - 1;

    while (trai < phai) {
      final tam = this[trai];
      this[trai] = this[phai];
      this[phai] = tam;
      trai++;
      phai--;
    }
  }
}

void main() {
  stdout.write('Nhập một chuỗi: ');
  final chuoi = stdin.readLineSync()?.trim() ?? '';

  final soKyTuNguyenAm = chuoi.split('').where(laNguyenAm).length;

  final tu = chuoi.isEmpty ? <String>[] : tachTu(chuoi);
  final coDoiXung = chuoi == chuoi.split('').reversed.join();

  print('Số ký tự là nguyên âm: $soKyTuNguyenAm');
  print('Số từ trong chuỗi: ${tu.length}');
  print(coDoiXung ? 'Chuỗi đối xứng.' : 'Chuỗi không đối xứng.');
  print('Đảo ngược từ: ${daoNguocTu(chuoi)}');
}
