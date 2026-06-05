// um dto (um objeto que carrega dados entre sistemas (notificação → app))
class NotificationPayload {
  final String type;
  final int? listId;
  final int? itemId;
  final String? filter;
  final Map<String, dynamic>? data;

  NotificationPayload({
    required this.type,
    this.listId,
    this.itemId,
    this.data,
    this.filter,
  });

  /// Converte JSON (vindo da notificação) para objeto Dart
  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'] ?? '',
      listId: json['listId'],
      itemId: json['itemId'],
      data: json['data'],
      filter: json['filter'],
    );
  }

  /// Converte objeto Dart para JSON (para envio de notificação)
  /// "open_list" → abre uma lista
  ///"open_item" → abre um item
  ///"open_home" → vai pra home
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'listId': listId,
      'itemId': itemId,
      'data': data,
      'filter': filter,
    };
  }
}
