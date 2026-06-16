/// Resultado processado pela NotificationEngine.
///
/// Contém a decisão da regra e os dados necessários
/// para exibir uma notificação.
class NotificationResult {
  // Define se deve exibir notificação
  final bool shouldNotify;

  // Título da notificação
  final String? title;

  // Mensagem principal
  final String? body;

  // Identificador da notificação
  // Ex: pending_items, high_urgency
  final String? type;

  // Dados extras para navegação,
  // analytics ou ações futuras
  final Map<String, dynamic>? payload;

  const NotificationResult({
    required this.shouldNotify,
    this.title,
    this.body,
    this.type,
    this.payload,
  });

  /// Resultado vazio
  /// usado quando nenhuma regra
  /// deve disparar notificação.
  factory NotificationResult.noNotification() {
    return const NotificationResult(
      shouldNotify: false,
    );
  }
}
