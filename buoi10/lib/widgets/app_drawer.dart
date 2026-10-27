import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/store_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_history_screen.dart';
import '../services/cart_manager.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, this.currentRoute = 'store'});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header người dùng theo hình minh họa slide 21
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF0A500), // Màu cam vàng đặc trưng trong bài
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 45,
                color: Color(0xFFF0A500),
              ),
            ),
            accountName: const Text(
              'Lương Viễn Đông',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            accountEmail: const Text(
              '2001230180@huit.edu.vn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),

          // Menu Cửa hàng
          ListTile(
            leading: const Icon(Icons.store, color: Colors.blueGrey),
            title: const Text('Cửa hàng', style: TextStyle(fontSize: 16)),
            selected: currentRoute == 'store',
            selectedTileColor: Colors.amber.withValues(alpha: 0.15),
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != 'store') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StoreScreen()),
                );
              }
            },
          ),

          // Menu Giỏ hàng
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.blueGrey),
            title: const Text('Giỏ hàng', style: TextStyle(fontSize: 16)),
            trailing: AnimatedBuilder(
              animation: CartManager.instance,
              builder: (context, _) {
                final count = CartManager.instance.itemCount;
                if (count == 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            selected: currentRoute == 'cart',
            selectedTileColor: Colors.amber.withValues(alpha: 0.15),
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != 'cart') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              }
            },
          ),

          // Menu Lịch sử hóa đơn
          ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.blueGrey),
            title: const Text('Lịch sử hóa đơn (SQL Server)', style: TextStyle(fontSize: 16)),
            selected: currentRoute == 'history',
            selectedTileColor: Colors.amber.withValues(alpha: 0.15),
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                );
              }
            },
          ),

          const Divider(),

          const Spacer(),

          // Menu Thoát -> Về màn hình giới thiệu
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: const Text('Thoát', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
