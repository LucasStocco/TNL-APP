import 'package:crud_flutter/core/utils/rules/model/notification_decision.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';
import 'package:crud_flutter/service/notifications/notification_preferences_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// =========================
/// NOTIFICATION SERVICE
/// =========================
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// =========================
  /// ANDROID CHANNEL
  /// =========================
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'tnl_channel',
    'TNL Notifications',
    description: 'Canal principal de notificações do TNL',
    importance: Importance.high,
  );

  /// =========================
  /// INIT (SAFE + NORMAL)
  /// =========================
  static Future<void> initialize({
    bool background = false,
  }) async {
    print("⚙️ [NOTIFICATION] INIT iniciando...");

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);

    print("✅ [NOTIFICATION] plugin inicializado");

    /// =========================
    /// CREATE CHANNEL
    /// =========================
    await _createChannel();

    if (!background) {
      await requestPermissions();

      initTimezone();
    } else {
      print(
        "⚠️ [NOTIFICATION] modo background - init reduzido",
      );
    }

    print("🚀 [NOTIFICATION] INIT finalizado");
  }

  /// =========================
  /// CREATE CHANNEL
  /// =========================
  static Future<void> _createChannel() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      _channel,
    );

    print("📢 [NOTIFICATION] canal criado");
  }

  /// =========================
  /// SEND NOTIFICATION RESULT
  /// =========================
  static Future<void> sendNotificationResult(
    NotificationResult notification,
  ) async {
    /// Evita envio desnecessário
    if (!notification.shouldNotify) return;

    await showNotification(
      notification.title ?? '',
      notification.body ?? '',
    );
  }

  /// =========================
  /// PUBLIC METHOD (WORKER USE)
  /// =========================
  static Future<void> showNotification(
    String title,
    String body,
  ) async {
    await _showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
    );
  }

  /// =========================
  /// TEST NOTIFICATION
  /// =========================
  static Future<void> showTestNotification() async {
    print("🧪 [NOTIFICATION] TESTE disparado");

    await showNotification(
      'TNL 🛒',
      'Teste de notificação funcionando com sucesso.',
    );
  }

  /// =========================
  /// INTERNAL NOTIFICATION
  /// =========================
  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    print("📤 [NOTIFICATION] preparando envio...");
    print("📤 [NOTIFICATION] title: $title");
    print("📤 [NOTIFICATION] body: $body");

    final canSend =
        await NotificationPreferencesService.isNotificationsEnabled();

    print("🔎 [NOTIFICATION] pode enviar? $canSend");

    if (!canSend) {
      print(
        "⛔ [NOTIFICATION] bloqueado por preferências",
      );

      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'tnl_channel',
      'TNL Notifications',
      channelDescription: 'Canal de notificações do TNL',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
    );

    print("🔔 [NOTIFICATION] enviada com sucesso");
  }

  /// =========================
  /// PERMISSION (ONLY FOREGROUND)
  /// =========================
  static Future<void> requestPermissions() async {
    print(
      "🔐 [NOTIFICATION] solicitando permissões...",
    );

    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print(
      "🔐 [NOTIFICATION] permissão resultado: $result",
    );
  }

  static Future<void> sendDecision(
    NotificationDecision decision,
  ) async {
    if (!decision.shouldNotify) {
      print("🔕 [SERVICE] notificação cancelada");

      return;
    }

    await showNotification(
      decision.title,
      decision.body,
    );
  }

  /// =========================
  /// TIMEZONE
  /// =========================
  static void initTimezone() {
    print(
      "🌍 [NOTIFICATION] inicializando timezone...",
    );

    tz.initializeTimeZones();

    tz.setLocalLocation(
      tz.getLocation('America/Sao_Paulo'),
    );

    print(
      "🌍 [NOTIFICATION] timezone configurado SP",
    );
  }
}
