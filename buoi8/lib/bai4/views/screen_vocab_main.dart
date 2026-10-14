import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../models/vocab_item.dart';
import '../services/vocab_file_service.dart';
import 'screen_vocab_quiz.dart';
import 'screen_vocab_reminders.dart';
import 'screen_vocab_study.dart';

class ScreenVocabMain extends StatefulWidget {
  const ScreenVocabMain({super.key});

  @override
  State<ScreenVocabMain> createState() => _ScreenVocabMainState();
}

class _ScreenVocabMainState extends State<ScreenVocabMain> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();
  final VocabFileService fileService = VocabFileService();
  final NotificationService notiService = NotificationService();

  @override
  void dispose() {
    wordController.dispose();
    meaningController.dispose();
    super.dispose();
  }

  // ================= LƯU VÀ NHẮC HỌC SAU 10 PHÚT (HOẶC TEST NHANH) =================
  void saveAndScheduleReminder({Duration delay = const Duration(minutes: 10)}) async {
    final word = wordController.text.trim();
    final meaning = meaningController.text.trim();

    if (word.isEmpty || meaning.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập cả Từ và Nghĩa"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final item = VocabItem(
      id: id,
      word: word,
      meaning: meaning,
      createdAt: DateTime.now(),
    );

    wordController.clear();
    meaningController.clear();

    try {
      // 1. Lưu vào file vocabularies.txt
      await fileService.addVocabulary(item);

      // 2. Bắn notification tức thì báo đã lưu
      await notiService.showSimpleNotification(
        id: id % 100000,
        title: "Ứng dụng học từ vựng",
        body: "Đã lưu từ: '$word' ($meaning). Hãy ôn tập sau ${delay.inMinutes > 0 ? '${delay.inMinutes} phút' : '${delay.inSeconds} giây'}!",
        channelId: 'vocab_instant_channel',
        channelName: 'Thông báo từ vựng',
        channelDescription: 'Thông báo khi thêm từ vựng mới',
      );

      // 3. Đặt lịch nhắc học (sau 10 phút)
      await notiService.scheduleNotificationAfter(
        id: id,
        delay: delay,
        channelId: 'vocab_reminder_channel',
        channelName: 'Nhắc nhở ôn từ vựng',
        channelDescription: 'Thông báo nhắc nhở học từ mới đã lưu',
        title: "Ôn tập từ mới",
        body: "$word: $meaning",
      );
    } catch (e) {
      debugPrint("Lỗi khi lưu từ vựng hoặc notification: $e");
    }

    if (mounted) {
      // 4. SnackBar như yêu cầu trong PDF (trang 22)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            delay.inMinutes == 10
                ? "Đã lưu và lên lịch nhắc học từ sau 10 phút"
                : "Đã lưu và lên lịch nhắc học sau ${delay.inSeconds} giây",
          ),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ứng dụng học từ vựng"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header (như trang 22)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade500,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 45, color: Colors.blue),
              ),
              accountName: const Text(
                "Trợ lý học từ vựng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text("Học từ vựng thông minh mỗi ngày"),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text("Trang chính", style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.blue),
              title: const Text("Học từ"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenVocabStudy()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: Colors.blue),
              title: const Text("Kiểm tra từ"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenVocabQuiz()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.blue),
              title: const Text("Lịch nhắc"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenVocabReminders()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tiêu đề & Hướng dẫn
            Text(
              "Thêm từ mới",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Nhập từ vựng tiếng Anh và nghĩa tiếng Việt để lưu và lên lịch ôn tập.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 28),

            // Ô Từ
            TextField(
              controller: wordController,
              decoration: InputDecoration(
                labelText: "Từ",
                hintText: "Ví dụ: vocabulary, student...",
                prefixIcon: const Icon(Icons.translate, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Ô Nghĩa
            TextField(
              controller: meaningController,
              decoration: InputDecoration(
                labelText: "Nghĩa",
                hintText: "Ví dụ: từ vựng, sinh viên...",
                prefixIcon: const Icon(Icons.description_outlined, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Nút "Lưu & Nhắc học sau 10 phút" (như hình trang 22)
            ElevatedButton(
              onPressed: () => saveAndScheduleReminder(delay: const Duration(minutes: 10)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey.shade800,
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Lưu & Nhắc học sau 10 phút",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Nút test nhanh (sau 10 giây để kiểm tra ngay lập tức mà không phải chờ 10 phút)
            OutlinedButton.icon(
              onPressed: () => saveAndScheduleReminder(delay: const Duration(seconds: 10)),
              icon: const Icon(Icons.timer_outlined, size: 18, color: Colors.blue),
              label: const Text(
                "Lưu & Test chuông sau 10 giây (Dành cho test nhanh)",
                style: TextStyle(fontSize: 13, color: Colors.blue),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue.shade200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
