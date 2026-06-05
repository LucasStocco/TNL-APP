class NotificationContext {
  /// =========================
  /// LISTAS
  /// =========================
  final int totalLists;
  final int pendingLists;
  final int completedLists;

  /// =========================
  /// ITENS
  /// =========================
  final int remainingItems;

  /// =========================
  /// STATUS
  /// =========================
  final bool hasPendingItems;
  final bool hasAlmostCompletedList;

  /// =========================
  /// COMPORTAMENTO
  /// =========================
  final DateTime? lastActivity;

  /// 0 = baixo
  /// 1 = médio
  /// 2 = alto
  final int urgencyLevel;

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

  bool get shouldNotify => hasPendingItems;

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
  urgencyLevel: $urgencyLevel
)
''';
  }
}
