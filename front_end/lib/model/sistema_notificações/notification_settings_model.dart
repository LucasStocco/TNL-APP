import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_type.dart';
import 'package:flutter/material.dart';

/// Configurações globais de notificações do usuário.
///
/// Representa todas as preferências que controlam como,
/// quando e quais notificações o usuário deseja receber.
///
/// Esse model é usado como fonte única de verdade para o sistema de notificações do app.
class NotificationSettingsModel {
  /// Define se o sistema de notificações está ativo globalmente.
  /// Se for false, nenhuma notificação deve ser enviada.
  final bool enabled;

  /// Controle individual por tipo de notificação.
  ///
  /// Exemplo:
  /// - reminder: true
  /// - context: false
  /// - incentive: true
  final Map<NotificationType, bool> typesEnabled;

  /// Frequência de envio das notificações.
  ///
  /// Controla a intensidade do sistema:
  /// - low → poucas notificações
  /// - normal → padrão
  /// - high → mais engajamento
  final FrequenciaNotificacao frequency;

  /// Horário preferido do usuário para notificações programadas.
  final TimeOfDay preferredTime;

  const NotificationSettingsModel({
    required this.enabled,
    required this.typesEnabled,
    required this.frequency,
    required this.preferredTime,
  });

  /// =========================
  /// COPY WITH
  /// =========================
  NotificationSettingsModel copyWith({
    bool? enabled,
    Map<NotificationType, bool>? typesEnabled,
    FrequenciaNotificacao? frequency,
    TimeOfDay? preferredTime,
  }) {
    return NotificationSettingsModel(
      enabled: enabled ?? this.enabled,
      typesEnabled: typesEnabled ?? this.typesEnabled,
      frequency: frequency ?? this.frequency,
      preferredTime: preferredTime ?? this.preferredTime,
    );
  }
}
