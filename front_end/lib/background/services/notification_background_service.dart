import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationBackgroundService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// =========================
  /// INIT (OBRIGATÓRIO)
  /// =========================
  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _plugin.initialize(initSettings);
  }

  /// =========================
  /// SHOW NOTIFICATION
  /// =========================
  static Future<void> show({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Notifications',
      channelDescription: 'Background notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
/* executor final (não pensa, só mostra)
- cria notificação
- configura Android
- exibe no sistema
 */
