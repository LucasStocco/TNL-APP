import 'package:crud_flutter/core/utils/notification/notification_message_generator.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_data.dart';

class NotificationEngine {
  static NotificationData? evaluate(
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

      return null;
    }

    /// =========================
    /// ALTA URGÊNCIA
    /// =========================
    if (context.urgencyLevel == 2) {
      print("🚨 [ENGINE] urgência alta");

      return NotificationMessageGenerator.highUrgency(
        context,
      );
    }

    /// =========================
    /// QUASE FINALIZADA
    /// =========================
    if (context.hasAlmostCompletedList) {
      print("🔥 [ENGINE] lista quase concluída");

      return NotificationMessageGenerator.almostCompleted(
        context,
      );
    }

    /// =========================
    /// DEFAULT
    /// =========================
    print("📌 [ENGINE] lembrete padrão");

    return NotificationMessageGenerator.pendingLists(
      context,
    );
  }
}
