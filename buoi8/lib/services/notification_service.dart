import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Quản lý thông báo chờ và hẹn giờ giả lập trên nền tảng Web
  static final List<PendingNotificationRequest> _webPendingList = [];
  static final Map<int, Timer> _webTimers = {};

  // ================= INIT =================
  Future<void> init() async {
    if (_isInitialized) return;

    // 1. Khởi tạo timezone cho mọi nền tảng (cả Web lẫn Mobile)
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (e) {
      debugPrint('Error init timezone: $e');
    }

    if (kIsWeb) {
      debugPrint('NotificationService: Running on Web platform');
      _isInitialized = true;
      return;
    }

    try {
      // 2. Android & iOS settings
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings = InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      );

      // 3. Init plugin
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked with payload: ${response.payload}');
        },
      );

      // 4. Xin quyen notification
      await _requestPermission();
    } catch (e) {
      debugPrint('Error initializing notification plugin: $e');
    }

    _isInitialized = true;
  }

  // ================= REQUEST PERMISSION =================
  Future<void> _requestPermission() async {
    if (kIsWeb) return;

    try {
      if (Platform.isAndroid) {
        // Xin quyền notification trên Android 13+
        final status = await Permission.notification.status;
        if (status.isDenied) {
          await Permission.notification.request();
        }

        // Xin quyền SCHEDULE_EXACT_ALARM trên Android 12+
        final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
        if (exactAlarmStatus.isDenied) {
          await Permission.scheduleExactAlarm.request();
        }
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }

  // Helper tạo AndroidNotificationDetails
  static AndroidNotificationDetails _createAndroidDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      visibility: NotificationVisibility.public,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );
  }

  // ================= GỬI THÔNG BÁO TỨC THÌ =================
  Future<void> showSimpleNotification({
    int id = 0,
    String title = 'Nhắc học từ vựng',
    String body = 'Bạn đã học 5 từ mới hôm nay chưa?',
    String channelId = 'learn_english_channel',
    String channelName = 'Học Anh Văn',
    String? channelDescription,
    String? payload,
  }) async {
    if (kIsWeb) {
      // Phát âm thanh thông báo trên Web
      SystemSound.play(SystemSoundType.alert);
      debugPrint('🔔 [WEB NOTIFICATION TỨC THÌ] $title: $body');
      return;
    }

    try {
      final details = _createAndroidDetails(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
      );

      final notificationDetails = NotificationDetails(
        android: details,
        iOS: const DarwinNotificationDetails(),
      );

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing simple notification: $e');
    }
  }

  // ================= LÊN LỊCH THÔNG BÁO SAU 1 KHOẢNG DELAY =================
  Future<void> scheduleNotificationAfter({
    int id = 1,
    required Duration delay,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
    String? payload,
  }) async {
    DateTime scheduledTime;
    try {
      scheduledTime = tz.TZDateTime.now(tz.local).add(delay);
    } catch (_) {
      scheduledTime = DateTime.now().add(delay);
    }

    await scheduleNotificationAt(
      id: id,
      scheduledTime: scheduledTime,
      channelId: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
      title: title,
      body: body,
      payload: payload,
    );
  }

  // ================= LÊN LỊCH THÔNG BÁO THEO THỜI ĐIỂM CỤ THỂ =================
  Future<void> scheduleNotificationAt({
    required int id,
    required DateTime scheduledTime,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      // Hủy timer cũ nếu có
      _webTimers[id]?.cancel();
      _webPendingList.removeWhere((req) => req.id == id);

      // Thêm vào danh sách chờ hiển thị trong giao diện Lịch Nhắc
      _webPendingList.add(PendingNotificationRequest(
        id,
        title,
        body,
        payload,
      ));

      final duration = scheduledTime.difference(DateTime.now());
      debugPrint('⏰ [WEB ĐẶT LỊCH] $title sau ${duration.inSeconds} giây');

      if (!duration.isNegative) {
        _webTimers[id] = Timer(duration, () {
          // Báo thức chuông trên Web khi tới giờ
          SystemSound.play(SystemSoundType.alert);
          debugPrint('⏰⏰⏰ [WEB BÁO THỨC CHUÔNG NỔ] $title: $body');
          _webPendingList.removeWhere((req) => req.id == id);
          _webTimers.remove(id);
        });
      }
      return;
    }

    try {
      final details = _createAndroidDetails(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
      );

      final tzDateTime = scheduledTime is tz.TZDateTime
          ? scheduledTime
          : tz.TZDateTime.from(scheduledTime, tz.local);

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDateTime,
        notificationDetails: NotificationDetails(
          android: details,
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  // ================= LẤY DANH SÁCH LỊCH THÔNG BÁO ĐANG CHỜ =================
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (kIsWeb) {
      return List.from(_webPendingList);
    }

    try {
      return await _plugin.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }

  // ================= HỦY THÔNG BÁO =================
  Future<void> cancelNotification(int id) async {
    if (kIsWeb) {
      _webTimers[id]?.cancel();
      _webTimers.remove(id);
      _webPendingList.removeWhere((req) => req.id == id);
      return;
    }

    try {
      await _plugin.cancel(id: id);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }

  Future<void> cancelAll() async {
    if (kIsWeb) {
      for (final timer in _webTimers.values) {
        timer.cancel();
      }
      _webTimers.clear();
      _webPendingList.clear();
      return;
    }

    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Error canceling all notifications: $e');
    }
  }
}
