import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'bai3/views/screen_bai3_todo.dart';
import 'bai4/views/screen_vocab_main.dart';
import 'btvn/views/screen_daily_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo NotificationService (Timezone, settings, permissions)
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buổi 8 - Notification & File',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainDashboardScreen(),
    );
  }
}

class MainDashboardScreen extends StatelessWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text(
          "Buổi 08: Notification & File",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner thông tin sinh viên
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Lập Trình Thiết Bị Di Động",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "MSSV: 2001230180",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Nội dung: Bài tập tại lớp (Bài 3, Bài 4) & Bài tập về nhà",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "DANH SÁCH BÀI TẬP",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),

            // Card 1: Bài tập 3 (Tại lớp)
            _buildExerciseCard(
              context: context,
              number: "BÀI TẬP 3 (TẠI LỚP)",
              title: "Ứng dụng Nhắc việc (Todo & Lịch)",
              description:
                  "• Lưu công việc vào file todo.txt\n• Gửi thông báo tức thì khi lưu\n• Đặt lịch hẹn thông báo (zonedSchedule) theo ngày giờ đã chọn",
              icon: Icons.notifications_active,
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenBai3Todo()),
                );
              },
            ),
            const SizedBox(height: 16),

            // Card 2: Bài tập 4 (Tại lớp)
            _buildExerciseCard(
              context: context,
              number: "BÀI TẬP 4 (TẠI LỚP)",
              title: "Ứng dụng Học Từ Vựng (Vocabulary)",
              description:
                  "• Menu Drawer: Trang chính, Học từ, Kiểm tra từ, Lịch nhắc\n• Lưu từ vào file vocabularies.txt & hẹn giờ 10 phút\n• Học từ: cảnh báo notification khi sai bội số của 3\n• Trắc nghiệm đúng/sai & xem danh sách lịch nhắc",
              icon: Icons.menu_book,
              color: Colors.blue.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenVocabMain()),
                );
              },
            ),
            const SizedBox(height: 16),

            // Card 3: Bài tập về nhà
            _buildExerciseCard(
              context: context,
              number: "BÀI TẬP VỀ NHÀ",
              title: "Nhiệm Vụ Mỗi Ngày (Daily Todo List)",
              description:
                  "• Giao diện như hình mẫu, lưu file daily_tasks.txt\n• Biểu tượng notification để cài đặt giờ nhắc\n• Checkbox xác nhận hoàn thành nhiệm vụ\n• Thông báo trên khay hệ thống số lượng đã hoàn thành",
              icon: Icons.checklist,
              color: Colors.indigo.shade600,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenDailyTasks()),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required BuildContext context,
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            number,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
