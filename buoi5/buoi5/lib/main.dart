import 'package:flutter/material.dart';
import 'bai1/bai1_screen.dart';
import 'bai2/bai2_screen.dart';
import 'bai3/bai3_screen.dart';
import 'bai4/bai4_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buổi 5 - LTDD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0088CC)),
        useMaterial3: true,
      ),
      home: const MainExerciseLauncher(),
    );
  }
}

class MainExerciseLauncher extends StatefulWidget {
  const MainExerciseLauncher({super.key});

  @override
  State<MainExerciseLauncher> createState() => _MainExerciseLauncherState();
}

class _MainExerciseLauncherState extends State<MainExerciseLauncher> {
  int _selectedIndex = 0;

  final List<Widget> _exercises = [
    const Bai1Screen(),
    const Bai2Screen(),
    const Bai3Screen(),
    const Bai4App(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _exercises[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0088CC),
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Bài 1 (ListView)',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Bài 2 (MoMo Home)',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Bài 3 (Voucher)',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_android),
              label: 'Bài 4 (Phone Store)',
            ),
          ],
        ),
      ),
    );
  }
}
