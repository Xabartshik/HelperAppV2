import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Логика по клику на системное уведомление
      },
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> showNotification(String title, String body, String type) async {
    Importance importance = Importance.defaultImportance;
    Priority priority = Priority.defaultPriority;

    // ПРИОРИТЕТ 3: Критический (Максимальная важность + агрессивная вибрация)
    if (type == 'high_priority' || type == 'helper_required' || type == 'priority_escalated_3') {
      importance = Importance.max;
      priority = Priority.high;
      
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
      }
    } 
    // ПРИОРИТЕТ 2: Высокий (Обычная важность + короткая вибрация)
    else if (type == 'priority_escalated_2') {
      importance = Importance.defaultImportance;
      priority = Priority.defaultPriority;
      
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500);
      }
    } 
    // Дефолтное поведение для остальных типов
    else {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500);
      }
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_channel_id',
      'Задачи склада',
      channelDescription: 'Уведомления о новых задачах и помощи',
      importance: importance,
      priority: priority,
      playSound: true,
      enableVibration: true,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}