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
  // Guarda se o usuário ativou ou desativou as notificações
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
  // Retorna se notificações estão ativas ou não, com base no valor salvo
  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          _notificationsKey,
        ) ??
        true;
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
