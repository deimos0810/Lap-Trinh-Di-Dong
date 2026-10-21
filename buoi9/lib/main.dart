import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'views/expense_screen.dart';
import 'views/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo FFI cho Windows/Linux nếu chạy desktop
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const Buoi9App());
}

class Buoi9App extends StatelessWidget {
  const Buoi9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài 09 - Bài Tập Về Nhà (SQLite)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
        ),
      ),
      home: const HomeworkNavigationScreen(),
    );
  }
}

class HomeworkNavigationScreen extends StatefulWidget {
  const HomeworkNavigationScreen({super.key});

  @override
  State<HomeworkNavigationScreen> createState() => _HomeworkNavigationScreenState();
}

class _HomeworkNavigationScreenState extends State<HomeworkNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ExpenseScreen(),
      AuthScreen(
        onLoginSuccess: () {
          setState(() {
            _currentIndex = 0; // Chuyển sang màn hình Quản lý chi tiêu khi đăng nhập thành công
          });
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Bài 1: Quản Lý Chi Tiêu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_person_outlined),
            activeIcon: Icon(Icons.lock_person),
            label: 'Bài 2: Đăng Nhập & Đăng Ký',
          ),
        ],
      ),
    );
  }
}
