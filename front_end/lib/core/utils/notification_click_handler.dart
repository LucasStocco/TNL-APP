import 'dart:convert';
import 'package:crud_flutter/core/utils/model/notification_payload.dart';
import 'package:crud_flutter/core/utils/notification_navigation_handler.dart';

class NotificationClickHandler {
  /// Handler responsável por executar a navegação do app
  /// Ele é injetado para evitar dependência direta de contexto
  static NotificationNavigationHandler? _navigationHandler;

  /// Inicializa o handler de navegação (injeção de dependência)
  /// Isso deve ser chamado no main() ou ponto de inicialização do app
  static void init(NotificationNavigationHandler handler) {
    _navigationHandler = handler;
    print("✅ NotificationNavigationHandler inicializado");
  }

  // =========================
  // ENTRADA DO CLICK DA NOTIFICAÇÃO
  // =========================
  static void handle(String? payloadString) {
    print("📩 Notification clicked");

    if (payloadString == null || payloadString.isEmpty) {
      print("⚠️ payload vazio");
      return;
    }

    print("📦 Payload recebido:");
    print(payloadString);

    try {
      final Map<String, dynamic> json =
          jsonDecode(payloadString) as Map<String, dynamic>;

      print("📦 JSON convertido:");
      print(json);

      final payload = NotificationPayload.fromJson(json);

      print("📦 DTO criado:");
      print("type = ${payload.type}");
      print("filter = ${payload.filter}");

      _execute(payload);
    } catch (e, stack) {
      print("❌ NotificationClickHandler error: $e");
      print("📍 Stack: $stack");
    }
  }

  // =========================
  // EXECUÇÃO DA NAVEGAÇÃO
  // =========================
  static void _execute(NotificationPayload payload) {
    if (_navigationHandler == null) {
      print("❌ NavigationHandler NÃO inicializado");
      return;
    }

    print("🚀 Executando navegação para: ${payload.type}");

    try {
      _navigationHandler!.handle(payload);
    } catch (e, stack) {
      print("❌ Erro ao navegar: $e");
      print("📍 Stack: $stack");
    }
  }
}

/// =========================
/// FLUXO DO SISTEMA
/// =========================
/// 1. Usuário clica na notificação
/// 2. Plugin envia payload (String JSON)
/// 3. handle() recebe a string
/// 4. decode JSON → Map
/// 5. converte para NotificationPayload
/// 6. envia para NavigationHandler
/// 7. NavigationHandler decide rota e navega
