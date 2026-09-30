import 'package:flutter/material.dart';
import 'screens/bai4_screen.dart';
import 'screens/bai5_contacts_screen.dart';
import 'screens/bai6_music_screen.dart';
import 'screens/bai7_sms_analyzer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bài Tập Flutter (4 - 7)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {'title': 'Bài 4: Video Recorder & Playback', 'screen': const Bai4Screen(), 'icon': Icons.videocam},
      {'title': 'Bài 5: Quản lý Danh bạ', 'screen': const Bai5ContactsScreen(), 'icon': Icons.contacts},
      {'title': 'Bài 6: Music Player UI', 'screen': const Bai6MusicScreen(), 'icon': Icons.music_note},
      {'title': 'Bài 7: SMS Analyzer App', 'screen': const Bai7SmsAnalyzerScreen(), 'icon': Icons.analytics},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Bài Tập (4 - 7)'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = exercises[index];
          return Card(
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(item['icon'], color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item['screen']),
                );
              },
            ),
          );
        },
      ),
    );
  }
}