import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const PhoneShopApp());
}

class PhoneShopApp extends StatelessWidget {
  const PhoneShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cửa hàng điện thoại',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF0A500),
          primary: const Color(0xFFF0A500),
          secondary: const Color(0xFF00B4D8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF0A500),
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      // Bắt đầu từ màn hình giới thiệu theo đúng yêu cầu bài tập 03
      home: const WelcomeScreen(),
    );
  }
}
