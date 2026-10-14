import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../services/notification_service.dart';

class ScreenVocabReminders extends StatefulWidget {
  const ScreenVocabReminders({super.key});

  @override
  State<ScreenVocabReminders> createState() => _ScreenVocabRemindersState();
}

class _ScreenVocabRemindersState extends State<ScreenVocabReminders> {
  final NotificationService notiService = NotificationService();
  List<PendingNotificationRequest> pendingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPendingReminders();
  }

  void loadPendingReminders() async {
    setState(() {
      isLoading = true;
    });
    final list = await notiService.getPendingNotifications();
    setState(() {
      pendingList = list;
      isLoading = false;
    });
  }

  void cancelReminder(int id) async {
    await notiService.cancelNotification(id);
    loadPendingReminders();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã hủy lịch nhắc thành công"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch nhắc"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Làm mới",
            onPressed: loadPendingReminders,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 70, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        "Không có lịch nhắc nào đang chờ hiển thị",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Hãy thêm từ vựng mới để đặt lịch nhắc ôn tập!",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: pendingList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = pendingList[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.alarm, color: Colors.blue),
                      ),
                      title: Text(
                        item.title ?? "Lịch nhắc ôn tập",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        item.body ?? "Nội dung ôn từ vựng",
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: "Hủy lịch nhắc",
                        onPressed: () => cancelReminder(item.id),
                      ),
                    );
                  },
                ),
    );
  }
}
