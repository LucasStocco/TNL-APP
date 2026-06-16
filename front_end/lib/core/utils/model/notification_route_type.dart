// Lista fixa de opções possíveis para o tipo da notificação
enum NotificationRouteType {
  openList,
  openItem,
  openHome,
  openPending,
  openSettings,
  openFilteredLists,
}

/// Converte String (payload bruto) para enum tipado
extension NotificationRouteTypeMapper on String {
  NotificationRouteType toRouteType() {
    switch (this) {
      case 'open_list':
        return NotificationRouteType.openList;

      case 'open_item':
        return NotificationRouteType.openItem;

      case 'open_home':
        return NotificationRouteType.openHome;

      case 'open_pending':
        return NotificationRouteType.openPending;

      case 'open_settings':
        return NotificationRouteType.openSettings;

      case 'open_filtered_lists':
        return NotificationRouteType.openFilteredLists;

      default:
        return NotificationRouteType.openHome;
    }
  }
}
