import 'dart:math';
import 'package:flutter/material.dart';
import '../models/vocab_item.dart';
import '../services/vocab_file_service.dart';

class QuizQuestion {
  final String word;
  final String displayedMeaning;
  final bool isActuallyCorrect;

  QuizQuestion({
    required this.word,
    required this.displayedMeaning,
    required this.isActuallyCorrect,
  });
}

class ScreenVocabQuiz extends StatefulWidget {
  const ScreenVocabQuiz({super.key});

  @override
  State<ScreenVocabQuiz> createState() => _ScreenVocabQuizState();
}

class _ScreenVocabQuizState extends State<ScreenVocabQuiz> {
  final VocabFileService fileService = VocabFileService();

  List<VocabItem> allWords = [];
  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  bool isLoading = true;

  final int totalQuestions = 5;

  @override
  void initState() {
    super.initState();
    initQuiz();
  }

  void initQuiz() async {
    allWords = await fileService.loadVocabularies();
    if (allWords.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final random = Random();
    questions = [];

    // Tạo danh sách câu hỏi
    final shuffledList = List<VocabItem>.from(allWords)..shuffle();
    final count = min(totalQuestions, shuffledList.length);

    for (int i = 0; i < count; i++) {
      final item = shuffledList[i];
      final bool shouldBeCorrect = random.nextBool();

      if (shouldBeCorrect || allWords.length < 2) {
        questions.add(
          QuizQuestion(
            word: item.word,
            displayedMeaning: item.meaning,
            isActuallyCorrect: true,
          ),
        );
      } else {
        // Lấy nghĩa của từ khác
        final otherItems = allWords.where((w) => w.word != item.word).toList();
        final randomOther = otherItems[random.nextInt(otherItems.length)];
        questions.add(
          QuizQuestion(
            word: item.word,
            displayedMeaning: randomOther.meaning,
            isActuallyCorrect: false,
          ),
        );
      }
    }

    setState(() {
      currentQuestionIndex = 0;
      correctAnswers = 0;
      wrongAnswers = 0;
      isLoading = false;
    });
  }

  void handleAnswer(bool userThinksCorrect) {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) return;

    final question = questions[currentQuestionIndex];
    final bool isUserRight = (userThinksCorrect == question.isActuallyCorrect);

    if (isUserRight) {
      correctAnswers++;
    } else {
      wrongAnswers++;
    }

    if (currentQuestionIndex + 1 < questions.length) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      setState(() {
        currentQuestionIndex++;
      });
      showResultDialog();
    }
  }

  void showResultDialog() {
    final total = correctAnswers + wrongAnswers;
    final double percentage = total > 0 ? (correctAnswers / total) * 100 : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Kết thúc bài kiểm tra",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tổng số câu: $total", style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 8),
              Text(
                "✓ Đúng: $correctAnswers",
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                "✗ Sai: $wrongAnswers",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                "Tỉ lệ chính xác: ${percentage.toStringAsFixed(1)}%",
                style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
                initQuiz();
              },
              child: const Text("Làm lại"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Thoát"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Trắc nghiệm Đúng / Sai")),
        body: const Center(
          child: Text("Cần ít nhất 2 từ vựng để bắt đầu trắc nghiệm!"),
        ),
      );
    }

    final question = currentQuestionIndex < questions.length
        ? questions[currentQuestionIndex]
        : questions.last;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trắc nghiệm Đúng / Sai"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Ô đếm Đúng / Sai phía trên (như hình trang 24)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Đúng: $correctAnswers",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Sai: $wrongAnswers",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Từ tiếng Anh
            Text(
              question.word,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Nghĩa tiếng Việt
            Text(
              question.displayedMeaning,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),

            // 2 nút chọn Đúng / Sai (như hình trang 24)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => handleAnswer(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "✓ Đúng",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => handleAnswer(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "✗ Sai",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
