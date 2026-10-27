import 'package:flutter/material.dart';
import '../models/dien_thoai.dart';
import '../models/item_gio_hang.dart';

class CartManager extends ChangeNotifier {
  // Singleton instance
  static final CartManager instance = CartManager._internal();
  CartManager._internal();

  final List<ItemGioHang> _items = [];

  List<ItemGioHang> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.soLuong);

  double get tongTien => _items.fold(0.0, (sum, i) => sum + i.thanhTien);

  bool get isEmpty => _items.isEmpty;

  void addItem(DienThoai dt) {
    final index = _items.indexWhere((item) => item.dienThoai.maDT == dt.maDT);
    if (index >= 0) {
      _items[index].soLuong++;
    } else {
      _items.add(ItemGioHang(dienThoai: dt, soLuong: 1));
    }
    notifyListeners();
  }

  void removeItem(String maDT) {
    _items.removeWhere((item) => item.dienThoai.maDT == maDT);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
