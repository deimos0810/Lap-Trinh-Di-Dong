import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../models/daily_task.dart';
import '../services/daily_task_file_service.dart';

class ScreenAddDailyTask extends StatefulWidget {
  const ScreenAddDailyTask({super.key});

  @override
  State<ScreenAddDailyTask> createState() => _ScreenAddDailyTaskState();
}

class _ScreenAddDailyTaskState extends State<ScreenAddDailyTask> {
  final TextEditingController titleController = TextEditingController();
  final DailyTaskFileService fileService = DailyTaskFileService();
  final NotificationService notiService = NotificationService();

  TimeOfDay? selectedTime;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void saveTask() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tên nhiệm vụ")),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String reminderString = '';
    if (selectedTime != null) {
      final hour = selectedTime!.hour.toString().padLeft(2, '0');
      final minute = selectedTime!.minute.toString().padLeft(2, '0');
      reminderString = "$hour:$minute";

      // Lên lịch notification vào giờ đã chọn
      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      try {
        await notiService.scheduleNotificationAt(
          id: id,
          scheduledTime: scheduledDate,
          channelId: 'daily_task_reminders',
          channelName: 'Nhắc nhở nhiệm vụ hàng ngày',
          channelDescription: 'Thông báo nhắc nhở hoàn thành nhiệm vụ theo giờ đã đặt',
          title: "📌 Nhắc nhở nhiệm vụ: $title",
          body: "Đến giờ thực hiện nhiệm vụ: $title ($reminderString)",
        );
      } catch (e) {
        debugPrint("Lỗi lên lịch notification: $e");
      }
    }

    final task = DailyTask(
      id: id,
      title: title,
      reminderTime: reminderString,
      isCompleted: false,
    );

    // Lưu nhiệm vụ đó vào file và trở về màn hình chính (theo yêu cầu PDF trang 25)
    try {
      await fileService.addTask(task);
    } catch (e) {
      debugPrint("Lỗi lưu task: $e");
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = selectedTime != null
        ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
        : "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm nhiệm vụ mới"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // Ô Tên nhiệm vụ
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Tên nhiệm vụ",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ô Giờ nhắc
            InkWell(
              onTap: pickTime,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formattedTime.isEmpty ? "Giờ nhắc" : "Nhắc lúc $formattedTime",
                        style: TextStyle(
                          fontSize: 15,
                          color: formattedTime.isEmpty ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Nút Lưu nhiệm vụ (như hình mẫu trang 25)
            ElevatedButton(
              onPressed: saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey.shade700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Lưu nhiệm vụ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
