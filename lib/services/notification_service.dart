import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:tahania_app/services/auto_reply_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static const int _autoReplyChannelId = 1;
  static const String _autoReplyChannelName = 'الردود التلقائية';
  static const String _autoReplyChannelDescription = 'إشعارات الردود التلقائية';

  /// تهيئة خدمة الإشعارات
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // إنشاء قناة الإشعارات للأندرويد
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel(
        'auto_reply_channel',
        _autoReplyChannelName,
        description: _autoReplyChannelDescription,
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
    );
  }

  /// إرسال إشعار لرسالة جديدة تحتاج إلى اعتماد
  static Future<void> showAutoReplyNotification(AutoReplyMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      'auto_reply_channel',
      _autoReplyChannelName,
      channelDescription: _autoReplyChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      actions: [
        const AndroidNotificationAction(
          'approve',
          'اعتماد',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'edit',
          'تعديل',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'dismiss',
          'إلغاء',
          showsUserInterface: true,
        ),
      ],
    );

    final iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _autoReplyChannelId,
      'رسالة جديدة من ${message.senderName}',
      '${message.originalMessage}\n\nالرد المقترح: ${message.suggestedReply}',
      details,
      payload: message.id,
    );
  }

  /// جدولة إشعار للرسائل المعلقة
  static Future<void> schedulePendingMessagesNotification() async {
    final pendingMessages = AutoReplyService.messagesNotifier.value
        .where((m) => m.status == AutoReplyStatus.pending)
        .toList();

    if (pendingMessages.isNotEmpty) {
      final androidDetails = AndroidNotificationDetails(
        'auto_reply_channel',
        _autoReplyChannelName,
        channelDescription: _autoReplyChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      final iosDetails = const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        _autoReplyChannelId + 1,
        'رسائل تحتاج إلى اعتماد',
        'لديك ${pendingMessages.length} رسائل تحتاج إلى اعتماد',
        details,
        payload: 'pending_messages',
      );
    }
  }

  /// إلغاء إشعار
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// إلغاء جميع الإشعارات
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// معالجة النقر على الإشعار
  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload == 'pending_messages') {
      // فتح شاشة الردود التلقائية
      // يمكن إضافة كود التنقل هنا
    } else if (response.payload != null) {
      // فتح تفاصيل الرسالة
      final messageId = response.payload!;
      // يمكن إضافة كود التنقل هنا
    }
  }
} 