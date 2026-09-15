import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'healthcare_screen.dart';
import 'music_screen.dart';

class HomeworkHomeScreen extends StatelessWidget {
  const HomeworkHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập về nhà')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(context, 'Bài 04', 'Ví điện tử', Icons.account_balance_wallet, const WalletScreen()),
          _item(context, 'Bài 05', 'Đăng ký khám chữa bệnh', Icons.local_hospital, const HealthcareScreen()),
          _item(context, 'Bài 06', 'Ứng dụng nghe nhạc', Icons.music_note, const MusicScreen()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String number, String title, IconData icon, Widget page) => Card(child: ListTile(leading: CircleAvatar(child: Icon(icon)), title: Text(number, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(title), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page))));
}