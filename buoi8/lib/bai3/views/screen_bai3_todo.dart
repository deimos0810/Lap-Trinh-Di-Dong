import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/notification_service.dart';
import '../models/todo_reminder.dart';
import '../services/todo_file_service.dart';

class ScreenBai3Todo extends StatefulWidget {
  const ScreenBai3Todo({super.key});

  @override
  State<ScreenBai3Todo> createState() => _ScreenBai3TodoState();
}

class _ScreenBai3TodoState extends State<ScreenBai3Todo> {
  final TextEditingController controller = TextEditingController();
  final TodoFileService fileService = TodoFileService();
  final NotificationService notiService = NotificationService();

  List<TodoReminder> todos = [];
  DateTime? selectedTime;

  final List<Color> colors = [
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void loadData() async {
    todos = await fileService.loadTodos();
    setState(() {});
  }

  String formatTime(DateTime time) {
    return DateFormat("dd/MM/yyyy HH:mm").format(time);
  }

  Color getTextColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }

  // CHỌN NGÀY + GIỜ
  void pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(2100),
      initialDate: selectedTime ?? now,
    );
    if (!mounted) return;
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: selectedTime != null
            ? TimeOfDay(hour: selectedTime!.hour, minute: selectedTime!.minute)
            : TimeOfDay.now(),
      );
      if (!mounted) return;
      if (time != null) {
        setState(() {
          selectedTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  // THÊM TODO (BÀI TẬP 3: LƯU FILE + BẮN THÔNG BÁO TỨC THÌ + HẸN GIỜ THÔNG BÁO)
  void addTodo() async {
    final title = controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tên công việc")),
      );
      return;
    }
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ngày và giờ")),
      );
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final todo = TodoReminder(id: id, title: title, time: selectedTime!);

    setState(() {
      todos.add(todo);
      selectedTime = null;
    });
    controller.clear();

    try {
      await fileService.saveTodos(todos);

      // ================= BÀI TẬP 3: XỬ LÝ NOTIFICATION =================
      // 1. Hiển thị notification tức thì: Đã thêm lịch cho công việc
      await notiService.showSimpleNotification(
        id: id % 100000,
        title: "Đã thêm lịch công việc",
        body: "Công việc '$title' đã được lưu và lên lịch lúc ${formatTime(todo.time)}",
        channelId: 'todo_channel_instant',
        channelName: 'Thông báo nhắc việc',
        channelDescription: 'Thông báo xác nhận thêm việc mới',
      );

      // 2. Thiết lập lịch cho công việc theo thời gian đã chọn
      if (todo.time.isAfter(DateTime.now())) {
        await notiService.scheduleNotificationAt(
          id: id,
          scheduledTime: todo.time,
          channelId: 'todo_scheduled_channel',
          channelName: 'Lịch nhắc công việc',
          channelDescription: 'Nhắc nhở công việc đến thời hạn thực hiện',
          title: "⏰ Đến giờ làm việc: $title",
          body: "Đã đến thời gian thực hiện công việc được lên lịch: $title",
        );
      }
    } catch (e) {
      debugPrint("Lỗi khi lưu hoặc lên lịch notification: $e");
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã lưu và lên lịch nhắc cho: $title"),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  void deleteTodo(int index) async {
    final removed = todos[index];
    setState(() {
      todos.removeAt(index);
    });

    try {
      await notiService.cancelNotification(removed.id);
      await fileService.saveTodos(todos);
    } catch (e) {
      debugPrint("Lỗi khi xóa todo: $e");
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xóa công việc '${removed.title}'")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bài 3: Nhắc việc (Notification + File)"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ô nhập công việc
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Tên công việc",
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Dòng chọn thời gian
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime == null
                        ? "Chưa chọn thời gian"
                        : formatTime(selectedTime!),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: selectedTime != null ? FontWeight.w600 : FontWeight.normal,
                      color: selectedTime != null ? Colors.blue.shade900 : Colors.grey.shade700,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: pickDateTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue, width: 1.5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Chọn thời gian",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Nút Lưu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addTodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blue, width: 1.5),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Lưu",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danh sách Todo đã lưu trong file
            Expanded(
              child: todos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_outlined, size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            "Chưa có công việc nào trong file todo.txt",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final t = todos[index];
                        final Color bgColor = colors[index % colors.length];
                        final Color textColor = getTextColor(bgColor);

                        return Card(
                          color: bgColor,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.task_alt,
                              color: textColor,
                            ),
                            title: Text(
                              t.title,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              formatTime(t.time),
                              style: TextStyle(
                                color: textColor.withValues(alpha: 0.75),
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline, color: textColor.withValues(alpha: 0.8)),
                              tooltip: "Xóa công việc",
                              onPressed: () => deleteTodo(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
