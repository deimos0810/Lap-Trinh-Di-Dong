import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../models/daily_task.dart';
import '../services/daily_task_file_service.dart';
import 'screen_add_daily_task.dart';

class ScreenDailyTasks extends StatefulWidget {
  const ScreenDailyTasks({super.key});

  @override
  State<ScreenDailyTasks> createState() => _ScreenDailyTasksState();
}

class _ScreenDailyTasksState extends State<ScreenDailyTasks> {
  final DailyTaskFileService fileService = DailyTaskFileService();
  final NotificationService notiService = NotificationService();

  List<DailyTask> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    setState(() {
      isLoading = true;
    });
    tasks = await fileService.loadTasks();
    setState(() {
      isLoading = false;
    });
  }

  // ================= BẤM CHECKBOX: HỘP THOẠI XÁC NHẬN VÀ BẮN THÔNG BÁO SỐ LƯỢNG =================
  void onTaskCheckChanged(DailyTask task, bool? newValue) async {
    if (newValue == true && !task.isCompleted) {
      // Hiển thị hộp thoại hỏi người dùng (như yêu cầu PDF trang 25)
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Xác nhận hoàn thành"),
            content: Text(
              "Bạn có xác nhận nhiệm vụ \"${task.title}\" này đã hoàn thành?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Xác nhận"),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        task.isCompleted = true;
        await fileService.updateTask(task);

        // Đếm số lượng nhiệm vụ đã hoàn thành
        final completedCount = tasks.where((t) => t.isCompleted).length;

        // "Nếu có sẽ thông báo trên khay thông báo của hệ thống số lượng nhiệm vụ đã hoàn thành." (PDF trang 25)
        await notiService.showSimpleNotification(
          id: 4000,
          title: "Nhiệm vụ mỗi ngày",
          body: "Bạn đã hoàn thành $completedCount nhiệm vụ!",
          channelId: 'task_completion_channel',
          channelName: 'Tiến độ nhiệm vụ',
          channelDescription: 'Thông báo tiến độ nhiệm vụ hoàn thành trong ngày',
        );

        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Chúc mừng! Đã hoàn thành: ${task.title}"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } else {
      // Bỏ tick nếu muốn
      task.isCompleted = false;
      await fileService.updateTask(task);
      setState(() {});
    }
  }

  // "Chọn biểu tượng notification để thiết lập thời gian thông báo." (PDF trang 24)
  void setReminderForTask(DailyTask task) async {
    final now = TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: now,
      helpText: "Thiết lập thời gian thông báo",
    );

    if (pickedTime != null) {
      final hour = pickedTime.hour.toString().padLeft(2, '0');
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      final reminderString = "$hour:$minute";

      task.reminderTime = reminderString;
      await fileService.updateTask(task);

      final current = DateTime.now();
      var scheduledDate = DateTime(
        current.year,
        current.month,
        current.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (scheduledDate.isBefore(current)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await notiService.scheduleNotificationAt(
        id: task.id,
        scheduledTime: scheduledDate,
        channelId: 'daily_task_reminders',
        channelName: 'Nhắc nhở nhiệm vụ hàng ngày',
        channelDescription: 'Thông báo nhắc nhở nhiệm vụ theo giờ đã đặt',
        title: "📌 Nhắc việc: ${task.title}",
        body: "Đến giờ thực hiện: ${task.title} (Nhắc lúc $reminderString)",
      );

      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đã đặt nhắc nhở cho '${task.title}' lúc $reminderString"),
            backgroundColor: Colors.blue.shade700,
          ),
        );
      }
    }
  }

  void deleteTask(DailyTask task) async {
    await notiService.cancelNotification(task.id);
    await fileService.deleteTask(task.id);
    loadTasks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xóa nhiệm vụ '${task.title}'")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nhiệm vụ mỗi ngày",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist_rtl, size: 70, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        "Chưa có nhiệm vụ nào",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Nhấn dấu (+) bên dưới để thêm nhiệm vụ mới",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            // Checkbox (như hình mẫu trang 25)
                            Transform.scale(
                              scale: 1.1,
                              child: Checkbox(
                                value: task.isCompleted,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: Colors.blue.shade600,
                                onChanged: (val) => onTaskCheckChanged(task, val),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Tiêu đề & Giờ nhắc
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: task.isCompleted
                                          ? Colors.grey.shade400
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.reminderTime.isNotEmpty
                                        ? "Nhắc lúc ${task.reminderTime}"
                                        : "Chưa đặt giờ nhắc",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // "Chọn biểu tượng notification để thiết lập thời gian thông báo." (PDF trang 24)
                            IconButton(
                              icon: const Icon(Icons.notifications_active_outlined),
                              color: task.reminderTime.isNotEmpty
                                  ? Colors.blue.shade600
                                  : Colors.grey.shade400,
                              tooltip: "Thiết lập thời gian thông báo",
                              onPressed: () => setReminderForTask(task),
                            ),

                            // Nút xóa nhiệm vụ
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: Colors.red.shade300,
                              tooltip: "Xóa nhiệm vụ",
                              onPressed: () => deleteTask(task),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      // FAB (+) mở màn hình Thêm nhiệm vụ mới (như hình trang 25)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade900,
        elevation: 1,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScreenAddDailyTask()),
          );
          if (result == true) {
            loadTasks();
          }
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
