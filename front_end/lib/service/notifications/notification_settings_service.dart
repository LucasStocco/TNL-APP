import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';
import 'package:crud_flutter/core/utils/notification/notification_settings_storage.dart';
import 'package:crud_flutter/model/sistema_notificações/notification_settings_model.dart';
import 'package:crud_flutter/service/notifications/scheduler/notification_scheduler.dart';
import 'package:crud_flutter/service/notifications/notification_service.dart';
import 'package:flutter/material.dart';

/// =========================
/// NOTIFICATION SETTINGS SERVICE
/// =========================
///
/// Camada de alto nível responsável por:
/// - salvar configurações
/// - carregar configurações
/// - atualizar configurações parcialmente
/// - sincronizar comportamento do sistema (FASE 7)
///
/// Agora também controla:
/// - cancelamento de notificações
/// - sincronização com scheduler
/// - ativação/desativação global do sistema
class NotificationSettingsService {
  /// =========================
  /// GET SETTINGS
  /// =========================
  static Future<NotificationSettingsModel> getSettings() async {
    final settings = await NotificationSettingsStorage.load();

    return settings ?? NotificationSettingsStorage.defaultSettings();
  }

  /// =========================
  /// SAVE SETTINGS
  /// =========================
  static Future<void> saveSettings(NotificationSettingsModel settings) async {
    await NotificationSettingsStorage.save(settings);

    // sincroniza automaticamente após salvar
    await _syncSystem(settings);
  }

  /// =========================
  /// UPDATE SETTINGS
  /// =========================
  static Future<void> updateSettings(
    NotificationSettingsModel Function(NotificationSettingsModel current)
        updater,
  ) async {
    final current = await getSettings();
    final updated = updater(current);

    await saveSettings(updated);
  }

  /// =========================
  /// RESET SETTINGS
  /// =========================
  static Future<void> reset() async {
    final defaultSettings = NotificationSettingsStorage.defaultSettings();

    await saveSettings(defaultSettings);
  }

  /// =========================
  /// FASE 7 — SYNC SYSTEM
  /// =========================
  ///
  /// Responsável por sincronizar o estado global do sistema:
  /// ✔ liga/desliga notificações
  /// ✔ cancela scheduler quando necessário
  /// ✔ mantém sistema consistente
  static Future<void> _syncSystem(NotificationSettingsModel settings) async {
    // =========================
    // NOTIFICAÇÕES DESATIVADAS
    // =========================
    if (!settings.enabled) {
      print("🔕 SETTINGS OFF → cancelando sistema");

      // cancela scheduler interno
      NotificationScheduler.reset();

      // cancela notificações ativas do sistema
      await NotificationService.cancelAll();

      return;
    }

    // =========================
    // NOTIFICAÇÕES ATIVADAS
    // =========================
    print("🔔 SETTINGS ON → sistema ativo");

    // aqui futuramente pode:
    // - reavaliar scheduler
    // - reprocessar regras
    // - reagendar notificações
  }

  /// =========================
  /// ATUALIZAR HORÁRIO
  /// =========================
  static Future<void> updatePreferredTime(TimeOfDay time) async {
    await updateSettings((current) {
      return current.copyWith(preferredTime: time);
    });
    await NotificationSettingsService.getSettings();
  }

  /// =========================
  /// ATUALIZAR FREQUÊNCIA
  /// =========================
  static Future<void> updateFrequency(FrequenciaNotificacao value) async {
    await updateSettings((current) {
      return current.copyWith(frequency: value);
    });

    // atualiza lógica de envio imediatamente
    // não precisa chamar nada no NotificationService
// porque a regra já é dinâmica via NotificationPreferencesService

// OU se quiser manter consistência:
    await NotificationSettingsService.updateSettings((current) => current);
  }

  /// =========================
  /// HELPERS CONVENIÊNCIA
  /// =========================

  /// Verifica se notificações estão ativas globalmente
  static Future<bool> isEnabled() async {
    final settings = await getSettings();
    return settings.enabled;
  }

  /// Ativa/desativa notificações globais
  static Future<void> setEnabled(bool value) async {
    await updateSettings((current) {
      return current.copyWith(enabled: value);
    });
  }
}
