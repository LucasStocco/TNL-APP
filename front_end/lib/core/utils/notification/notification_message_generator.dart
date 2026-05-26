import 'package:crud_flutter/core/utils/notification/messages/almost_completed_messages.dart';
import 'package:crud_flutter/core/utils/notification/messages/message_randomizer.dart';
import 'package:crud_flutter/core/utils/notification/messages/pending_messages.dart';
import 'package:crud_flutter/core/utils/notification/messages/urgency_messages.dart';

import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_data.dart';

class NotificationMessageGenerator {
  /// =========================
  /// PENDÊNCIAS
  /// =========================
  static NotificationData pendingLists(
    NotificationContext context,
  ) {
    final selected = MessageRandomizer.pick(
      pendingMessages,
    );

    return NotificationData(
      title: selected.$1,
      body: selected.$2,
      type: "pending_lists",
    );
  }

  /// =========================
  /// URGÊNCIA
  /// =========================
  static NotificationData highUrgency(
    NotificationContext context,
  ) {
    final selected = MessageRandomizer.pick(
      urgencyMessages,
    );

    return NotificationData(
      title: selected.$1,
      body: selected.$2,
      type: "high_urgency",
    );
  }

  /// =========================
  /// QUASE FINALIZADA
  /// =========================
  static NotificationData almostCompleted(
    NotificationContext context,
  ) {
    final selected = MessageRandomizer.pick(
      almostCompletedMessages,
    );

    return NotificationData(
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
