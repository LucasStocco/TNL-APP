/// =========================
/// NOTIFICATION SETTINGS KEYS
/// =========================
///
/// Centraliza todas as chaves usadas no SharedPreferences para o sistema de notificações.
class NotificationSettingsKeys {
  /// Ativa ou desativa todas as notificações do sistema
  static const String enabled = 'notifications_enabled';

  /// Controla se notificações de lembrete estão ativadas
  static const String reminderEnabled = 'reminder_enabled';

  /// Controla se notificações de contexto estão ativadas
  static const String contextEnabled = 'context_enabled';

  /// Controla se notificações de reengajamento estão ativadas
  static const String reengagementEnabled = 'reengagement_enabled';

  /// Define a frequência geral das notificações (low / normal / high)
  static const String frequency = 'notification_frequency';

  /// Hora preferida do usuário para receber notificações (0–23)
  static const String preferredHour = 'preferred_hour';

  /// Minuto preferido do usuário para receber notificações (0–59)
  static const String preferredMinute = 'preferred_minute';
}