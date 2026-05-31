import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';

/// =========================
/// NOTIFICATION PREFERENCES SERVICE
/// =========================
/// Responsável por armazenar e recuperar preferências do usuário.
/// Apenas persistência local (SharedPreferences).
class NotificationPreferencesService {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _hourKey = 'preferred_hour';
  static const String _minuteKey = 'preferred_minute';
  static const String _frequencyKey = 'notification_frequency';
  static const String preferredTimeEnabledKey = 'preferred_time_enabled';

  // =========================
  // NOTIFICATIONS ENABLED
  // =========================
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  // =========================
  // PREFERRED TIME
  // =========================
  static Future<void> setPreferredTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, time.hour);
    await prefs.setInt(_minuteKey, time.minute);
  }

  static Future<TimeOfDay> getPreferredTime() async {
    final prefs = await SharedPreferences.getInstance();

    return TimeOfDay(
      hour: prefs.getInt(_hourKey) ?? 19,
      minute: prefs.getInt(_minuteKey) ?? 0,
    );
  }

  static Future<void> setPreferredTimeEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      preferredTimeEnabledKey,
      value,
    );
  }

  static Future<bool> isPreferredTimeEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          preferredTimeEnabledKey,
        ) ??
        false;
  }

  // =========================
  // FREQUENCY
  // =========================
  static Future<void> setFrequency(FrequenciaNotificacao frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_frequencyKey, frequency.name);
  }

  static Future<FrequenciaNotificacao> getFrequency() async {
    final prefs = await SharedPreferences.getInstance();

    final value = prefs.getString(_frequencyKey);

    return FrequenciaNotificacao.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FrequenciaNotificacao.normal,
    );
  }

  // =========================
  // REMINDERS
  // =========================
  static const String _remindersKey = 'reminders_enabled';

  static Future<void> setRemindersEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersKey, value);
  }

  static Future<bool> isRemindersEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_remindersKey) ?? true;
  }

  // =========================
  // CONTEXT
  // =========================
  static const String _contextKey = 'context_enabled';

  static Future<void> setContextEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_contextKey, value);
  }

  static Future<bool> isContextEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_contextKey) ?? true;
  }

  // =========================
  // INCENTIVES
  // =========================
  static const String _incentivesKey = 'incentives_enabled';

  static Future<void> setIncentivesEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_incentivesKey, value);
  }

  static Future<bool> isIncentivesEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_incentivesKey) ?? true;
  }
}

/// =========================
/// NOTIFICATION PREFERENCES SERVICE
/// =========================
///
/// Esta classe é responsável por gerenciar as preferências do usuário
/// relacionadas ao sistema de notificações.
///
/// Ela utiliza o SharedPreferences para armazenar dados localmente
/// no dispositivo.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Salvar se o usuário ativou ou desativou notificações
/// ✔ Recuperar o estado salvo anteriormente
/// ✔ Garantir persistência mesmo após fechar o app
///
/// =========================
/// COMO FUNCIONA NO SISTEMA
/// =========================
///
/// UI (Switch de notificações)
///        ↓
/// NotificationPreferencesService
///        ↓
/// SharedPreferences (armazenamento local)
///
/// E também pode ser consultado por:
///
/// Scheduler / Service
///        ↓
/// Verifica se pode ou não enviar notificações
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não envia notificações
/// ❌ Não contém regras de negócio
/// ❌ Não controla quando notificar
/// ❌ Não interage com UI diretamente
///
/// Essas responsabilidades ficam separadas em outras camadas:
///
/// - Engine → decide quais notificações serão geradas
/// - Rules → definem a lógica de notificação
/// - Scheduler → controla quando executar
/// - Service → envia notificações ao usuário
///
/// =========================
/// RESUMO
/// =========================
///
/// Esta classe atua apenas como camada de persistência,
/// garantindo que a preferência do usuário sobre notificações
/// seja salva e recuperada corretamente.
///
