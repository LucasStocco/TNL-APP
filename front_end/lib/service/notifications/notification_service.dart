import 'dart:convert';

import 'package:crud_flutter/core/utils/model/notification_decision.dart';
import 'package:crud_flutter/core/utils/notification/rules/notification_frequency_rule.dart';
import 'package:crud_flutter/core/utils/notification_click_handler.dart';
import 'package:crud_flutter/model/sistema_notificações/notification_result.dart';
import 'package:crud_flutter/service/notifications/notification_preferences_service.dart';
import 'package:crud_flutter/service/notifications/notification_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// =========================
/// BACKGROUND CALLBACK (OBRIGATÓRIO SER TOP-LEVEL)
/// =========================
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print("📌 BACKGROUND CALLBACK DISPARADO");
  print("📦 payload: ${response.payload}");

  NotificationClickHandler.handle(response.payload);
}

/// =========================
/// NOTIFICATION SERVICE
/// =========================
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'tnl_channel',
    'TNL Notifications',
    description: 'Canal principal de notificações do TNL',
    importance: Importance.high,
  );

  // ========================
  // HOOK DE DESLIGAMENTO
  // ========================
  static Future<void> setEnabled(bool value) async {
    await NotificationSettingsService.updateSettings((current) {
      return current.copyWith(enabled: value);
    });

    if (!value) {
      print("🚨 notificações desativadas — cancelando agendadas");
      await cancelAll();
    }
  }

  // =========================
  // INIT
  // =========================
  static Future<void> initialize({
    bool background = false,
  }) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("🔥 FOREGROUND CLICK DISPARADO");
        print("📦 payload: ${response.payload}");

        NotificationClickHandler.handle(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final details = await _notifications.getNotificationAppLaunchDetails();

    print("🚀 APP ABERTO POR NOTIFICAÇÃO?");
    print(details?.didNotificationLaunchApp);

    if (details?.notificationResponse != null) {
      print("📦 PAYLOAD INICIAL:");
      print(details!.notificationResponse!.payload);

      // 🔥 IMPORTANTE: trata cold start
      NotificationClickHandler.handle(
        details.notificationResponse!.payload,
      );
    }

    await _createChannel();

    if (!background) {
      await requestPermissions();
      initTimezone();
    }
  }

  static Future<void> _createChannel() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);
  }

  // =========================
  // GATE GLOBAL + TIME + FREQUENCY
  // =========================
  static Future<bool> _canSendNotification() async {
    final enabled = await NotificationSettingsService.isEnabled();

    if (!enabled) {
      print("⛔ bloqueado: SETTINGS OFF");
      return false;
    }

    final preferred = await NotificationPreferencesService.getPreferredTime();
    final now = TimeOfDay.now();

    final preferredTimeEnabled =
        await NotificationPreferencesService.isPreferredTimeEnabled();

    final nowMinutes = now.hour * 60 + now.minute;
    final preferredMinutes = preferred.hour * 60 + preferred.minute;

    const tolerance = 5;

    final diff = (nowMinutes - preferredMinutes).abs();

    if (preferredTimeEnabled && diff > tolerance) {
      print("⏰ bloqueado: fora do horário");
      return false;
    }

    final frequency = await NotificationPreferencesService.getFrequency();

    final allowed = NotificationFrequencyRule.canSend(frequency);

    if (!allowed) {
      print("📊 bloqueado por frequência");
      return false;
    }

    return true;
  }

  // =========================
  // PUBLIC SEND
  // =========================
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

  // =========================
  // INTERNAL SEND
  // =========================
  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    print("📤 preparando envio...");

    final canSend = await _canSendNotification();
    if (!canSend) return;

    NotificationFrequencyRule.registerSend();

    const androidDetails = AndroidNotificationDetails(
      'tnl_channel',
      'TNL Notifications',
      channelDescription: 'Canal de notificações do TNL',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    final payload = jsonEncode({
      "type": "open_filtered_lists",
      "filter": "pendentes",
    });

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );

    print("🔔 notificação enviada com sucesso");
  }

  // =========================
  // TEST
  // =========================
  static Future<void> showTestNotification() async {
    await showNotification(
      'TNL 🛒',
      'Teste funcionando com sucesso.',
    );
  }

  // =========================
  // PERMISSIONS
  // =========================
  static Future<void> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    print("🔐 permissão: $result");
  }

  // =========================
  // TIMEZONE
  // =========================
  static void initTimezone() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
  }

  // =========================
  // CANCEL ALL
  // =========================
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
