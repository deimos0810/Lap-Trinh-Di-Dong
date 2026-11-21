import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'bai1_auth/auth_screen.dart';
import 'bai2_upload/upload_manager_screen.dart';
import 'bai3_product/product_list_screen.dart';
import 'baitap_venha_wallet/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init note: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thực Hành LTDD - Buổi 11 (Firebase)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C35DE)),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Chương 7: Flutter & Firebase", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF4C35DE),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "DANH SÁCH BÀI TẬP THỰC HÀNH",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              title: "Bài tập tại lớp 1",
              subtitle: "Firebase Authentication (Email/Password & Google Sign-in)",
              icon: Icons.vpn_key_outlined,
              color: const Color(0xFFFD366E),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen())),
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              context,
              title: "Bài tập tại lớp 2",
              subtitle: "Firebase Storage: Upload file, Quản lý tiến trình %, Pause/Resume/Cancel",
              icon: Icons.cloud_upload_outlined,
              color: const Color(0xFF38B6FF),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadManagerScreen())),
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              context,
              title: "Bài tập tại lớp 3",
              subtitle: "Firestore & Storage: Quản lý danh sách sản phẩm, thêm kèm ảnh, xóa",
              icon: Icons.storefront_outlined,
              color: const Color(0xFF6B46C1),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductListScreen())),
            ),
            const SizedBox(height: 12),
            _buildMenuCard(
              context,
              title: "Bài tập về nhà: Ví ZhipPay",
              subtitle: "E-Wallet hoàn chỉnh: Onboarding, Dashboard, Send Money, Nạp/Rút/Chuyển & Thống kê",
              icon: Icons.account_balance_wallet_outlined,
              color: const Color(0xFF4C35DE),
              isHighlight: true,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return Card(
      elevation: isHighlight ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isHighlight ? BorderSide(color: color, width: 1.5) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
