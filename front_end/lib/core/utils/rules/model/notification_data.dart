class NotificationData {
  // Título da notificação
  final String title;
  // Mensagem principal
  final String body;
  // Identificador do tipo de notificação (ex: "daily_reminder", "pending_items")
  final String type;

  const NotificationData({
    required this.title,
    required this.body,
    required this.type,
  });
}

/// =========================
/// NOTIFICATION DATA
/// =========================
///
/// Esta classe representa o resultado final de uma regra de notificação.
///
/// Ela contém os dados prontos que serão enviados para o usuário
/// pelo NotificationService.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Representar uma notificação já construída
/// ✔ Transportar título, mensagem e tipo
/// ✔ Servir como saída final das NotificationRules
///
/// =========================
/// COMO É GERADA
/// =========================
///
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// NotificationRule.build()
///        ↓
/// NotificationData
///        ↓
/// NotificationService (envio)
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não contém lógica de decisão
/// ❌ Não acessa dados do app ou API
/// ❌ Não envia notificações
/// ❌ Não agenda notificações
///
/// Essas responsabilidades ficam distribuídas em outras camadas:
///
/// - Engine → avalia regras
/// - Rules → definem quando e o que gerar
/// - Scheduler → controla execução
/// - Service → envia notificações
///
/// =========================
/// RESUMO
/// =========================
///
/// Este modelo representa a notificação final pronta para ser exibida ao usuário.
///
