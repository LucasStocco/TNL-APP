import 'package:crud_flutter/service/notification/notification_preferences_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// =========================
/// NOTIFICATION SERVICE
/// =========================
///
/// Central de notificações do app.
///
/// Responsável por:
/// - inicialização
/// - permissões
/// - timezone
/// - exibição de notificações
/// - agendamento
///
/// Este service NÃO possui regras de negócio.
///
/// Toda inteligência fica no:
/// NotificationEngine.
///
///
class NotificationService {
  // Plugin principal de notificações
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // =========================
  // INIT
  // =========================
  //
  // Inicializa plugin e permissões.
  //
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
    );

    // Android 13+
    await requestPermissions();

    // Necessário para schedule
    initTimezone();
  }

  // =========================
  // PERMISSÃO ANDROID 13+
  // =========================
  //
  // Solicita permissão para
  // enviar notificações.
  //
  static Future<void> requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // =========================
  // TIMEZONE
  // =========================
  //
  // Necessário para notificações
  // agendadas corretamente.
  //
  static void initTimezone() {
    tz.initializeTimeZones();

    tz.setLocalLocation(
      tz.getLocation(
        'America/Sao_Paulo',
      ),
    );
  }

  // =========================
  // VERIFICA PERMISSÃO
  // =========================
  //
  // Verifica se usuário deixou
  // notificações ativadas.
  //
  static Future<bool> _canSendNotifications() async {
    return await NotificationPreferencesService.isNotificationsEnabled();
  }

  // =========================
  // BASE NOTIFICATION
  // =========================
  //
  // Método central usado por
  // todas notificações.
  //
  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final canSend = await _canSendNotifications();

    if (!canSend) return;

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
  }

  // =========================
  // TESTE
  // =========================
  //
  // Notificação usada para
  // testes rápidos.
  //
  static Future<void> showTestNotification() async {
    await _showNotification(
      id: 0,
      title: 'TNL 🛒',
      body: 'Teste de notificação funcionando com sucesso.',
    );
  }

  // =========================
  // LISTAS PENDENTES
  // =========================
  //
  // Exibe lembretes inteligentes
  // de listas pendentes.
  //
  static Future<void> showPendingItemsNotification(
    String title,
    String body,
  ) async {
    await _showNotification(
      id: 1,
      title: title,
      body: body,
    );
  }

  // =========================
  // AGENDAMENTO DIÁRIO
  // =========================
  //
  // Agenda lembrete diário fixo.
  //
  // (Opcional futuramente,
  // pois Workmanager já executa
  // em background.)
  //
  static Future<void> scheduleDailyReminder() async {
    final canSend = await _canSendNotifications();

    if (!canSend) return;

    const androidDetails = AndroidNotificationDetails(
      'tnl_channel_reminder',
      'TNL Reminders',
      channelDescription: 'Lembretes diários do TNL',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      10,
      '🛒 Lembrete TNL',
      'Você ainda possui listas pendentes.',
      _nextInstanceOfHour(18),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // =========================
  // CALCULA PRÓXIMA HORA
  // =========================
  //
  // Utilizado pelo schedule.
  //
  static tz.TZDateTime _nextInstanceOfHour(
    int hour,
  ) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(
        const Duration(days: 1),
      );
    }

    return scheduled;
  }
}
