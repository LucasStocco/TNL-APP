import 'dart:convert';
import 'package:crud_flutter/core/utils/model/notification_payload.dart';

class NotificationClickHandler {
  // Plugin de notificações retorna apenas uma string (payloadString)
  static void handle(String? payloadString) {
    /// evita crash se notificação vier vazia
    if (payloadString == null || payloadString.isEmpty) {
      print("⚠️ payload vazio");
      return;
    }

    try {
      // transforma string → mapa (notificações só transportam string)
      final Map<String, dynamic> json = jsonDecode(payloadString);
      // Converte mapa → objeto Dart
      final payload = NotificationPayload.fromJson(json);

      _execute(payload);
    } catch (e) {
      print("❌ erro ao processar payload: $e");
    }
  }

  static void _execute(NotificationPayload payload) {
    // Decide ação com base no tipo da notificação
    switch (payload.type) {
      // execução da ação
      case "open_list":
        print("📂 abrir lista: ${payload.listId}");
        break;
      // execução da ação
      case "open_item":
        print("📌 abrir item: ${payload.itemId}");
        break;
      // execução da ação
      case "open_home":
        print("🏠 abrir home");
        break;

      default:
        print("⚠️ ação desconhecida: ${payload.type}");
        break;
    }
  }
}

/// Recebe payload bruto
/// Converte para NotificationPayload
/// Decide ação
/// Chama navegação
