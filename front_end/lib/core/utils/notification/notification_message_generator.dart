import 'package:crud_flutter/background/workers/notification_context.dart';
import 'package:crud_flutter/core/utils/notification/messages/almost_completed_messages.dart';
import 'package:crud_flutter/core/utils/notification/messages/message_randomizer.dart';
import 'package:crud_flutter/core/utils/notification/messages/pending_messages.dart';
import 'package:crud_flutter/core/utils/notification/messages/urgency_messages.dart';


import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';

class NotificationMessageGenerator {
  /// =========================
  /// PENDÊNCIAS
  /// =========================
  static NotificationResult pendingLists(
    NotificationContext context,
  ) {
    final selected = MessageRandomizer.pick(
      pendingMessages,
    );

    return NotificationResult(
      shouldNotify: true,
      title: selected.$1,
      body: selected.$2,
      type: "pending_lists",
    );
  }

  /// =========================
  /// URGÊNCIA
  /// =========================
  static NotificationResult highUrgency(
    NotificationContext context,
  ) {
    final selected = MessageRandomizer.pick(
      urgencyMessages,
    );

    return NotificationResult(
      shouldNotify: true,
      title: selected.$1,
      body: selected.$2,
      type: "high_urgency",
    );
  }

  /// =========================
  /// QUASE FINALIZADA
  /// =========================
  static NotificationResult almostCompleted(
    NotificationContext context,
  ) {
    final selected = MessageRandomizer.pick(
      almostCompletedMessages,
    );

    return NotificationResult(
      shouldNotify: true,
      title: selected.$1,
      body: selected.$2,
      type: "almost_completed",
    );
  }
}

/* responsabilidades:
centraliza mensagens
randomiza textos
gera título/body
evita repetição
 */
