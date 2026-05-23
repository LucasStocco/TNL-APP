import 'package:shared_preferences/shared_preferences.dart';

/// =========================
/// NOTIFICATION PREFERENCES SERVICE
/// =========================
/// Responsável por armazenar e recuperar preferências do usuário
/// relacionadas às notificações.
///
/// Funções principais:
/// - Salvar se o usuário ativou/desativou notificações
/// - Recuperar estado salvo no SharedPreferences
///
/// ⚠️ NÃO envia notificações e NÃO lida com UI.
/// Apenas persistência de dados.
///
/// Usado para garantir que o estado do switch
/// seja mantido mesmo após fechar o app.

class NotificationPreferencesService {
  static const String _notificationsKey = 'notifications_enabled';

  // =========================
  // Salva estado das notificações
  // =========================
  static Future<void> setNotificationsEnabled(
    bool enabled,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _notificationsKey,
      enabled,
    );
  }

  // =========================
  // Retorna estado salvo
  // =========================
  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          _notificationsKey,
        ) ??
        true;
  }
}
