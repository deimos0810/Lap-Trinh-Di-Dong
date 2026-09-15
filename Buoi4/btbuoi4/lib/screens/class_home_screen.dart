import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'facilities_screen.dart';
import 'mood_screen.dart';

class ClassHomeScreen extends StatelessWidget {
  const ClassHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập trên lớp')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(context, 'Bài 01', 'Calculator', Icons.calculate, const CalculatorScreen()),
          _item(context, 'Bài 02', 'Cơ sở vật chất trường', Icons.school, const FacilitiesScreen()),
          _item(context, 'Bài 03', 'Tình trạng trong ngày', Icons.mood, const MoodScreen()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String number, String title, IconData icon, Widget page) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}