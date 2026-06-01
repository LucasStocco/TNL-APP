import 'package:crud_flutter/core/utils/notification/notification_message_generator.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/model/sistema_notificações/notification_result.dart';

enum NotificationTestMode {
  none,
  highUrgency,
  almostCompleted,
  pending,
}

class NotificationEngine {
  /// 🔧 modo de teste (desligue em produção)
  static const bool enableTestMode = true;

  static const NotificationTestMode testMode =
      NotificationTestMode.almostCompleted;

  static NotificationResult evaluate(
    NotificationContext context,
  ) {
    print("🧠 [ENGINE] avaliando contexto");

    /// =========================
    /// 🔥 MODO TESTE (BLOQUEADO EM UM SÓ FLUXO)
    /// =========================
    if (enableTestMode) {
      switch (testMode) {
        case NotificationTestMode.highUrgency:
          print("🧪 TESTE → urgência alta");
          return NotificationMessageGenerator.highUrgency(context);

        case NotificationTestMode.almostCompleted:
          print("🧪 TESTE → quase concluída");
          return NotificationMessageGenerator.almostCompleted(context);

        case NotificationTestMode.pending:
          print("🧪 TESTE → padrão");
          return NotificationMessageGenerator.pendingLists(context);

        case NotificationTestMode.none:
          break;
      }
    }

    /// =========================
    /// PRODUÇÃO NORMAL
    /// =========================
    if (!context.hasPendingItems) {
      return NotificationResult.noNotification();
    }

    if (context.urgencyLevel == 2) {
      print("🚨 [ENGINE] urgência alta");
      return NotificationMessageGenerator.highUrgency(context);
    }

    if (context.hasAlmostCompletedList) {
      print("🔥 [ENGINE] quase concluída");
      return NotificationMessageGenerator.almostCompleted(context);
    }

    print("📌 [ENGINE] padrão");
    return NotificationMessageGenerator.pendingLists(context);
  }
}
