import 'dart:convert';
import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_settings_model.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// =========================
/// NOTIFICATION SETTINGS STORAGE
/// =========================
///
/// Responsável por persistir e recuperar as preferências do usuário
/// relacionadas ao sistema de notificações.
///
/// Usa SharedPreferences como armazenamento local simples,
/// ideal para dados leves e estruturais como settings.
///
/// NÃO deve ser confundido com cache de API.
/// Aqui lidamos apenas com preferências do usuário.
class NotificationSettingsStorage {
  static const String _key = "notification_settings";

  /// =========================
  /// SAVE SETTINGS
  /// =========================
  static Future<void> save(NotificationSettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      "enabled": settings.enabled,
      "frequency": settings.frequency.name,
      "preferredTime": {
        "hour": settings.preferredTime.hour,
        "minute": settings.preferredTime.minute,
      },
      "typesEnabled": settings.typesEnabled.map(
        (key, value) => MapEntry(key.name, value),
      ),
    };

    await prefs.setString(_key, jsonEncode(data));
  }

  /// =========================
  /// LOAD SETTINGS
  /// =========================
  static Future<NotificationSettingsModel?> load() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_key);

    if (raw == null) {
      return null;
    }

    final Map<String, dynamic> json = jsonDecode(raw);

    return NotificationSettingsModel(
      enabled: json["enabled"] ?? true,
      frequency: FrequenciaNotificacao.values.firstWhere(
        (e) => e.name == json["frequency"],
        orElse: () => FrequenciaNotificacao.normal,
      ),
      preferredTime: TimeOfDay(
        hour: json["preferredTime"]["hour"],
        minute: json["preferredTime"]["minute"],
      ),
      typesEnabled: (json["typesEnabled"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          NotificationType.values.firstWhere(
            (e) => e.name == key,
            orElse: () => NotificationType.reminder,
          ),
          value as bool,
        ),
      ),
    );
  }

  /// =========================
  /// DEFAULT SETTINGS
  /// =========================
  static NotificationSettingsModel defaultSettings() {
    return NotificationSettingsModel(
      enabled: true,
      frequency: FrequenciaNotificacao.normal,
      preferredTime: const TimeOfDay(hour: 9, minute: 0),
      typesEnabled: {
        NotificationType.reminder: true,
        NotificationType.context: true,
        NotificationType.incentive: true,
      },
    );
  }
}
