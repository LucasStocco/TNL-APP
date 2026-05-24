class NotificationContext {
  // Existe algo pendente?
  final bool hasPendingItems;
  // Quantas listas estão abertas?
  final int pendingCount;
  // Quantos itens faltam na lista principal?
  final int remainingItems;
  // Está perto de finalizar?
  final bool hasAlmostCompletedList;

  // Mais performático, imutável e fácil de comparar
  const NotificationContext({
    required this.hasPendingItems,
    required this.pendingCount,
    required this.remainingItems,
    required this.hasAlmostCompletedList,
  });
}

/// =========================
/// NOTIFICATION CONTEXT
/// =========================
///
/// Esta classe representa o estado atual do sistema
/// no momento em que as regras de notificação são avaliadas.
///
/// Ela funciona como um "resumo inteligente" dos dados do app,
/// simplificando informações complexas (como listas e itens)
/// em sinais fáceis de interpretar pelas Rules.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Transportar dados do estado atual do app
/// ✔ Fornecer informações simplificadas para o NotificationEngine
/// ✔ Servir como base para tomada de decisão das NotificationRules
///
/// =========================
/// COMO É GERADO
/// =========================
///
/// ListaResumo (dados do app)
///        ↓
/// NotificationContextBuilder
///        ↓
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// NotificationRules
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não contém regras de negócio
/// ❌ Não acessa API ou banco de dados
/// ❌ Não executa lógica de notificação
/// ❌ Não agenda ou envia notificações
///
/// Essas responsabilidades ficam distribuídas em:
///
/// - ContextBuilder → monta este contexto
/// - Engine → avalia regras
/// - Rules → definem decisões
/// - Scheduler → controla execução
/// - Service → envia notificações
///
/// =========================
/// RESUMO
/// =========================
///
/// Este contexto é a base de decisão do sistema de notificações,
/// fornecendo um estado simplificado e consistente para as Rules.
///
