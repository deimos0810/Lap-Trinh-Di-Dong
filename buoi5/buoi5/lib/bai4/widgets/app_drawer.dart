import 'package:flutter/material.dart';

import 'huit_logo_widget.dart';

class PhoneStoreDrawer extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onNavigateToStore;
  final VoidCallback onNavigateToCart;
  final VoidCallback onNavigateToIntro;

  const PhoneStoreDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigateToStore,
    required this.onNavigateToCart,
    required this.onNavigateToIntro,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 48,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Image (assets/images/avatar.png)
                SizedBox(
                  width: 64,
                  height: 64,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const HuitLogoWidget(size: 64);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sơn Tùng MTP',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'sontungmtp@huit.edu.vn',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // Drawer Options
          Expanded(
            child: Container(
              color: const Color(
                0xFF1E88E5,
              ), // Blue section matching assignment drawer
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.storefront, color: Colors.white),
                    title: const Text(
                      'Cửa hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    selected: currentRoute == 'store',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToStore();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Giỏ hàng',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    selected: currentRoute == 'cart',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToCart();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text(
                      'Thoát',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onNavigateToIntro();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
