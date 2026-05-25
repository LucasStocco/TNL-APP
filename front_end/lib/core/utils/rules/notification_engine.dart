import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_decision.dart';

class NotificationEngine {
  static NotificationDecision evaluate(
    NotificationContext context,
  ) {
    print("🧠 [ENGINE] avaliando contexto");

    /// =========================
    /// SEM PENDÊNCIAS
    /// =========================
    /// Se não há listas, não notifica
    /// Se tudo completo, não notifica
    if (!context.hasPendingItems) {
      print("✅ [ENGINE] nada pendente");

      return const NotificationDecision(
        shouldNotify: false,
        title: '',
        body: '',
      );
    }

    /// =========================
    /// ALTA URGÊNCIA
    /// =========================
    if (context.urgencyLevel == 2) {
      print("🚨 [ENGINE] urgência alta");

      return NotificationDecision(
        shouldNotify: true,
        title: "Sua lista precisa de atenção 📋",
        body: "Você ainda possui ${context.remainingItems} itens pendentes.",
      );
    }

    /// =========================
    /// QUASE FINALIZADA
    /// =========================
    if (context.hasAlmostCompletedList) {
      print("🔥 [ENGINE] lista quase concluída");

      return NotificationDecision(
        shouldNotify: true,
        title: "Você está quase terminando 🎯",
        body: "Faltam apenas ${context.remainingItems} itens na sua lista.",
      );
    }

    /// =========================
    /// DEFAULT
    /// =========================
    print("📌 [ENGINE] lembrete padrão");

    return NotificationDecision(
      shouldNotify: true,
      title: "Você possui listas pendentes 📋",
      body: "${context.pendingLists} listas aguardam finalização.",
    );
  }
}
