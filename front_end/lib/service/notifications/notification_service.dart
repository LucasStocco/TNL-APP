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

    // FASE 7 — efeito colateral do OFF
    if (!value) {
      print("🚨 notificações desativadas — cancelando agendadas");
      await NotificationService.cancelAll();
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

    // dispara quando o usuário clica na notificação
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        NotificationClickHandler.handle(response.payload);
      },
    );
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
  // ATUALIZA FREQUÊNCIA DINÂMICA
  // =========================
  static Future<void> updateFrequency() async {
    print("📊 atualizando frequência de notificações");

    // aqui não precisa cancelar tudo
    // apenas garantir que regra usa valor novo

    final frequency = await NotificationPreferencesService.getFrequency();

    print("📊 nova frequência aplicada: $frequency");
  }

  // =========================
  // 🚨 FASE - CANCELAMENTO GLOBAL
  // =========================
  static Future<void> cancelAll() async {
    print("🧹 cancelando todas notificações do sistema");

    await _notifications.cancelAll();
  }

// =========================
// REAGENDAMENTO GLOBAL
// =========================
  static Future<void> rescheduleAll() async {
    print("🔄 REAGENDANDO TODAS AS NOTIFICAÇÕES");

    // 1. cancela notificações antigas do sistema
    await cancelAll();

    // 2. busca settings atualizados (horário novo já está salvo)
    final settings = await NotificationSettingsService.getSettings();

    if (!settings.enabled) {
      print("⛔ reschedule ignorado (notificações OFF)");
      return;
    }

    // 3. aqui você pode disparar um rebuild do scheduler futuramente
    // (ou acionar o engine novamente quando tiver dados)
    print(
        "✅ sistema pronto para novo agendamento em ${settings.preferredTime}");
  }

  // =========================
  // GATE GLOBAL + TIME + FREQUENCY (UNIFICADO)
  // =========================
  static Future<bool> _canSendNotification() async {
    // 1. GLOBAL (FASE 7 - fonte única da verdade)
    final enabled = await NotificationSettingsService.isEnabled();

    if (!enabled) {
      print("⛔ bloqueado: SETTINGS OFF (FASE 7)");
      return false;
    }

    // 2. HORÁRIO
    /// Pega o horario preferido do usuário e compara com o horário atual.
    final preferred = await NotificationPreferencesService.getPreferredTime();

    final now = TimeOfDay.now();

    final preferredTimeEnabled =
        await NotificationPreferencesService.isPreferredTimeEnabled();

    /// Converter ambos para minutos para facilitar comparação
    final nowMinutes = now.hour * 60 + now.minute;
    final preferredMinutes = preferred.hour * 60 + preferred.minute;

    /// pode enviar entre -5 e +5 minutos do horário escolhido
    const tolerance = 5;

    final diff = (nowMinutes - preferredMinutes).abs();

    if (preferredTimeEnabled && diff > tolerance) {
      print("⏰ bloqueado: fora do horário ($now vs $preferred)");
      return false;
    }

    /// 3. FREQUÊNCIA
    /// Quantas notificações posso enviar hoje? (Low=1, Normal=3, High=ilimitado)
    final frequency = await NotificationPreferencesService.getFrequency();

    /// Aplica a regra de frequência
    final allowed = NotificationFrequencyRule.canSend(frequency);

    if (!allowed) {
      print("📊 bloqueado por frequência: $frequency");
      return false;
    }

    return true;
  }

  // =========================
  // PUBLIC SEND
  // =========================
  // (gate global + horário + frequência)
  /// Usuário desligou notificações?
  /// Se sim, bloqueia tudo
  /// Se não, continua fluxo
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
    int? listId,
  }) async {
    print("📤 preparando envio...");

    final canSend = await _canSendNotification();
    if (!canSend) return;

    // registra frequência
    final frequency = await NotificationPreferencesService.getFrequency();

    // registra o envio para controle de frequência
    NotificationFrequencyRule.registerSend();

    const androidDetails = AndroidNotificationDetails(
      'tnl_channel',
      'TNL Notifications',
      channelDescription: 'Canal de notificações do TNL',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    // payload da notificação (deep link)
    final payload = jsonEncode({
      "type": "open_list",
      "listId": 12,
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
  // RESULT
  // =========================
  static Future<void> sendNotificationResult(
    NotificationResult notification,
  ) async {
    if (!notification.shouldNotify) return;

    await showNotification(
      notification.title ?? '',
      notification.body ?? '',
    );
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

  static Future<void> sendDecision(
    NotificationDecision decision,
  ) async {
    if (!decision.shouldNotify) return;

    await showNotification(
      decision.title,
      decision.body,
    );
  }
}

/// 
/// 
/// FLUXO:  
/// 1. Verifica se pode enviar
/// 2. Verifica horário
/// 3. Verifica frequência
/// 4. Se tudo ok, envia a notificação