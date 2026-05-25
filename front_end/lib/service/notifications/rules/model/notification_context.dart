class NotificationContext {
  /// =========================
  /// LISTAS
  /// =========================

  /// Quantidade total de listas
  final int totalLists;

  /// Quantidade de listas pendentes
  final int pendingLists;

  /// Quantidade de listas concluídas
  final int completedLists;

  /// =========================
  /// ITENS
  /// =========================

  /// Quantidade de itens restantes
  /// da lista principal pendente
  final int remainingItems;

  /// =========================
  /// STATUS
  /// =========================

  /// Existe algo pendente?
  final bool hasPendingItems;

  /// Está perto de finalizar?
  final bool hasAlmostCompletedList;

  /// =========================
  /// COMPORTAMENTO
  /// =========================

  /// Última atividade conhecida do usuário
  final DateTime? lastActivity;

  /// Nível de urgência:
  ///
  /// 0 → baixa
  /// 1 → média
  /// 2 → alta
  final int urgencyLevel;

  /// =========================
  /// CONSTRUCTOR
  /// =========================

  /// Mais performático, imutável e fácil de comparar
  const NotificationContext({
    required this.totalLists,
    required this.pendingLists,
    required this.completedLists,
    required this.remainingItems,
    required this.hasPendingItems,
    required this.hasAlmostCompletedList,
    required this.lastActivity,
    required this.urgencyLevel,
  });

  /// =========================
  /// HELPERS
  /// =========================

  /// Define rapidamente se o sistema
  /// deve considerar notificação
  bool get shouldNotify => hasPendingItems;

  /// Usuário considerado inativo
  /// após 2 dias sem atividade
  bool get isInactive {
    if (lastActivity == null) return false;

    return DateTime.now().difference(lastActivity!).inDays >= 2;
  }

  @override
  String toString() {
    return '''
NotificationContext(
  totalLists: $totalLists,
  pendingLists: $pendingLists,
  completedLists: $completedLists,
  remainingItems: $remainingItems,
  hasPendingItems: $hasPendingItems,
  hasAlmostCompletedList: $hasAlmostCompletedList,
  urgencyLevel: $urgencyLevel,
  lastActivity: $lastActivity
)
''';
  }
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
