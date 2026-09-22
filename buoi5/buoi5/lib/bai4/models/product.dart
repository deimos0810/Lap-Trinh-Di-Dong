import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final Color cardColor;
  final IconData icon;
  final String imagePath;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    this.cardColor = const Color(0xFF1E293B),
    this.icon = Icons.phone_android,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int delta) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

final sampleProducts = [
  const Product(
    id: 'p1',
    name: 'Điện thoại 01',
    description: 'điện thoại mới của hãng SamGung với công nghệ hiện đại',
    price: 1200.0,
    cardColor: Color(0xFF0F172A),
    icon: Icons.phone_iphone,
    imagePath: 'assets/images/dt1.png',
  ),
  const Product(
    id: 'p2',
    name: 'Điện thoại 02',
    description: 'điện thoại mới của hãng SamGung với công nghệ hiện đại',
    price: 200.0,
    cardColor: Color(0xFF0D9488),
    icon: Icons.phone_android,
    imagePath: 'assets/images/dt2.png',
  ),
  const Product(
    id: 'p3',
    name: 'Điện thoại 03',
    description: 'Màn hình OLED 120Hz, camera 108MP siêu nét',
    price: 850.0,
    cardColor: Color(0xFF6366F1),
    icon: Icons.smartphone,
    imagePath: 'assets/images/dt3.png',
  ),
  const Product(
    id: 'p4',
    name: 'Điện thoại 04',
    description: 'Thiết kế sang trọng mỏng nhẹ, pin trâu 5000mAh',
    price: 990.0,
    cardColor: Color(0xFFD97706),
    icon: Icons.phone_android,
    imagePath: 'assets/images/dt4.png',
  ),
];
