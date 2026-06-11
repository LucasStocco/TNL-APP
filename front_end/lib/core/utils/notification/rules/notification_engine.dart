
import 'package:crud_flutter/core/utils/notification/notification_message_generator.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_settings_model.dart';

enum NotificationTestMode {
  none,
  highUrgency,
  almostCompleted,
  pending,
}

class NotificationEngine {
  static const bool enableTestMode = true;

  static const NotificationTestMode testMode =
      NotificationTestMode.almostCompleted;

  static NotificationResult evaluate({
    required NotificationContext context,
    required NotificationSettingsModel settings,
  }) {
    print("🧠 [ENGINE] avaliando contexto");

    /// =========================
    /// 🔒 CHECK GLOBAL
    /// =========================
    if (!settings.enabled) {
      print("🚫 notificações desativadas pelo usuário");
      return NotificationResult.noNotification();
    }

    /// =========================
    /// 🔧 MODO TESTE
    /// =========================
    if (enableTestMode) {
      switch (testMode) {
        case NotificationTestMode.highUrgency:
          return NotificationMessageGenerator.highUrgency(context);

        case NotificationTestMode.almostCompleted:
          return NotificationMessageGenerator.almostCompleted(context);

        case NotificationTestMode.pending:
          return NotificationMessageGenerator.pendingLists(context);

        case NotificationTestMode.none:
          break;
      }
    }

    /// =========================
    /// 🔥 PRODUÇÃO (lógica baseada em contexto)
    /// =========================
    if (!context.hasPendingItems) {
      return NotificationResult.noNotification();
    }

    if (context.urgencyLevel == 2) {
      return NotificationMessageGenerator.highUrgency(context);
    }

    if (context.hasAlmostCompletedList) {
      return NotificationMessageGenerator.almostCompleted(context);
    }

    return NotificationMessageGenerator.pendingLists(context);
  }
}
