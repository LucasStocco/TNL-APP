import 'dart:convert';
import 'package:crud_flutter/core/utils/model/notification_payload.dart';
import 'package:crud_flutter/core/utils/notification_navigation_handler.dart';

class NotificationClickHandler {
  /// Handler responsável por executar a navegação do app
  /// Ele é injetado para evitar dependência direta de contexto
  static late NotificationNavigationHandler _navigationHandler;

  /// Inicializa o handler de navegação (injeção de dependência)
  /// Isso deve ser chamado no main() ou ponto de inicialização do app
  static void init(NotificationNavigationHandler handler) {
    _navigationHandler = handler;
  }

  // =========================
  // ENTRADA DO CLICK DA NOTIFICAÇÃO
  // =========================
  // O plugin de notificações envia apenas uma String (payload bruto)
  static void handle(String? payloadString) {
    /// evita crash se notificação vier vazia
    if (payloadString == null || payloadString.isEmpty) {
      print("⚠️ payload vazio");
      return;
    }

    try {
      // transforma string JSON → Map (formato bruto vindo da notificação)
      final Map<String, dynamic> json = jsonDecode(payloadString);

      // converte Map → objeto tipado do sistema
      final payload = NotificationPayload.fromJson(json);

      // encaminha para execução da navegação centralizada
      _execute(payload);
    } catch (e) {
      print("❌ erro ao processar payload: $e");
    }
  }

  // =========================
  // EXECUÇÃO DA NAVEGAÇÃO
  // =========================
  // Responsável por delegar o payload para o NavigationHandler
  static void _execute(NotificationPayload payload) {
    _navigationHandler.handle(payload);
  }
}

/// =========================
/// FLUXO DO SISTEMA
/// =========================
/// 1. Usuário clica na notificação
/// 2. Plugin envia payload (String JSON)
/// 3. handle() recebe a string
/// 4. decode JSON → Map
/// 5. converte para NotificationPayload (DTO tipado)
/// 6. envia para NotificationNavigationHandler
/// 7. NavigationHandler decide rota e navega no app
