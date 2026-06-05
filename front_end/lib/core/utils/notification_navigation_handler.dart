import 'package:crud_flutter/core/utils/model/notification_payload.dart';
import 'package:crud_flutter/core/utils/model/notification_route_type.dart';
import 'package:crud_flutter/service/notifications/notification_navigation_state.dart';
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

  // Recebe o payload já interpretado e manda navegar
  void handle(NotificationPayload payload) {
    _navigate(payload);
  }

  void _openFilteredLists(String? filter) {
    NotificationNavigationState.openedFromNotification = true;

    navigatorKey.currentState?.pushNamed(
      '/home',
      arguments: filter,
    );
  }

  // Ele olha o payload.type e decide para onde navegar
  void _navigate(NotificationPayload payload) {
    switch (payload.type.toRouteType()) {
      // DESABILITADO TEMPORARIAMENTE
      // Ainda não temos informações suficientes
      // para abrir uma ListaScreen diretamente.
      case NotificationRouteType.openList:
        _openHome();
        break;

      case NotificationRouteType.openFilteredLists:
        _openFilteredLists(payload.filter);
        break;

      // DESABILITADO TEMPORARIAMENTE
      // Ainda não existe rota preparada para abrir
      // um item específico via notificação.
      case NotificationRouteType.openItem:
        _openHome();
        break;

      case NotificationRouteType.openHome:
        _openHome();
        break;

      case NotificationRouteType.openSettings:
        _openSettings();
        break;

      default:
        _openHome();
        break;
    }
  }

  // =========================
  // NAVEGAÇÕES
  // =========================

  void _openHome() {
    navigatorKey.currentState?.pushNamed('/home');
  }

  void _openSettings() {
    navigatorKey.currentState?.pushNamed('/settings');
  }
}
