import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../models/vocab_item.dart';
import '../services/vocab_file_service.dart';

class ScreenVocabStudy extends StatefulWidget {
  const ScreenVocabStudy({super.key});

  @override
  State<ScreenVocabStudy> createState() => _ScreenVocabStudyState();
}

class _ScreenVocabStudyState extends State<ScreenVocabStudy> {
  final TextEditingController answerController = TextEditingController();
  final VocabFileService fileService = VocabFileService();
  final NotificationService notiService = NotificationService();

  List<VocabItem> vocabularies = [];
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void loadData() async {
    vocabularies = await fileService.loadVocabularies();
    vocabularies.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  void checkAnswer() async {
    if (vocabularies.isEmpty) return;

    final currentItem = vocabularies[currentIndex];
    final userAnswer = answerController.text.trim().toLowerCase();

    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập nghĩa của từ")),
      );
      return;
    }

    final correctAnswer = currentItem.meaning.trim().toLowerCase();
    final bool isCorrect = userAnswer == correctAnswer ||
        correctAnswer.contains(userAnswer) ||
        userAnswer.contains(correctAnswer);

    if (isCorrect) {
      setState(() {
        correctCount++;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Chính xác! '$userAnswer' đúng với nghĩa '${currentItem.meaning}'"),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } else {
      setState(() {
        wrongCount++;
      });

      // ================= ĐẶC BIỆT TỪ PDF (Trang 23): =================
      // Nếu số từ sai là bội số của 3 sẽ hiển thị một notification!
      if (wrongCount % 3 == 0) {
        await notiService.showSimpleNotification(
          id: 3000 + wrongCount,
          title: "⚠️ Cảnh báo ôn tập từ mới",
          body: "Bạn đã trả lời sai $wrongCount từ! Hãy dành thời gian xem lại danh sách từ vựng nhé.",
          channelId: 'vocab_alert_channel',
          channelName: 'Cảnh báo học tập',
          channelDescription: 'Thông báo khi người dùng trả lời sai bội số của 3 lần',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sai rồi! Nghĩa đúng của '${currentItem.word}' là: '${currentItem.meaning}'"),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    answerController.clear();
    // Chuyển sang từ tiếp theo
    setState(() {
      currentIndex = (currentIndex + 1) % vocabularies.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vocabularies.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Ôn tập từ mới")),
        body: const Center(
          child: Text("Chưa có từ vựng nào. Hãy thêm từ vựng ở Trang chính!"),
        ),
      );
    }

    final currentWord = vocabularies[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ôn tập từ mới"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // 2 ô đếm Đúng / Sai phía trên (như trang 23)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "✓ $correctCount từ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "✗ $wrongCount từ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Card hiển thị từ tiếng Anh (như trang 23)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              alignment: Alignment.center,
              child: Text(
                currentWord.word,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Ô nhập nghĩa tiếng Việt
            TextField(
              controller: answerController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Nhập nghĩa tiếng Việt",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              onSubmitted: (_) => checkAnswer(),
            ),
            const SizedBox(height: 20),

            // Nút "Check" (màu xanh dương như hình trang 23)
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Check",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Gợi ý: Cứ mỗi 3 lần trả lời sai, hệ thống sẽ gửi một Notification cảnh báo!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
