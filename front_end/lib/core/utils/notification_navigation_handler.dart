import 'package:crud_flutter/core/utils/model/notification_payload.dart';
import 'package:crud_flutter/core/utils/model/notification_route_type.dart';
import 'package:flutter/material.dart';

// Responsável por decidir para onde o app vai abrir quando a notificação for clicada
class NotificationNavigationHandler {
  /// Permite navegar no app sem precisar de BuildContext
  /// Isso é MUITO importante para notificações, porque:
  /// o app pode estar fechado
  /// pode estar em background
  /// você não tem UI disponível
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationNavigationHandler({
    required this.navigatorKey,
  });

  // Recebe o payload já “interpretado” e manda navegar:
  void handle(NotificationPayload payload) {
    _navigate(payload);
  }

  // Ele olha o payload.type e com base nele decide para onde navegar
  void _navigate(NotificationPayload payload) {
    /// Cada type é uma ação
    /// open_list → navega para a tela da lista (precisa do listId)
    /// open_item → navega para a tela do item (precisa do itemId e listId)
    /// open_home → navega para a home (não precisa de nada)
    switch (payload.type.toRouteType()) {
      case NotificationRouteType.openList:
        // abre uma lista específica
        _openList(payload.listId);
        break;

      case NotificationRouteType.openItem:
        // abre um item dentro de uma lista
        _openItem(payload.itemId, payload.listId);
        break;

      case NotificationRouteType.openHome:
        // volta para tela principal
        _openHome();
        break;

      case NotificationRouteType.openSettings:
        // abre tela de configurações
        _openSettings();
        break;

      default:
        // fallback seguro (evita crash se vier type desconhecido)
        _openHome();
        break;
    }
  }

  // =========================
  // NAVEGAÇÕES
  // =========================

  void _openList(int? listId) {
    if (listId == null) {
      _openHome();
      return;
    }

    navigatorKey.currentState?.pushNamed(
      '/list',
      arguments: listId,
    );
  }

  void _openItem(int? itemId, int? listId) {
    if (itemId == null) {
      _openHome();
      return;
    }

    navigatorKey.currentState?.pushNamed(
      '/item',
      arguments: {
        'itemId': itemId,
        'listId': listId,
      },
    );
  }

  void _openHome() {
    navigatorKey.currentState?.pushNamed('/home');
  }

  void _openSettings() {
    navigatorKey.currentState?.pushNamed('/settings');
  }
}
