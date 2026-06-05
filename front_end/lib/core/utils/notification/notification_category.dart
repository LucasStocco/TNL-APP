/// Define as categorias de notificações suportadas pelo sistema.
///
/// Cada categoria representa um tipo específico de notificação que pode
/// ser habilitada/desabilitada individualmente nas configurações do usuário.
///
/// Usado pelo NotificationService, ViewModel de Settings e regras da engine
/// para decidir se uma notificação deve ou não ser exibida.
enum NotificationCategory {
  reminders,
  context,
  incentives,
  reengagement,
}