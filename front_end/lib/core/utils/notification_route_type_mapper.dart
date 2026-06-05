import 'package:crud_flutter/core/utils/model/notification_route_type.dart';

// Mapper — converte o tipo da notificação (string) para um tipo seguro (enum)
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
