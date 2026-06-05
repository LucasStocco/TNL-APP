import 'package:crud_flutter/core/utils/anti_spam_engine.dart';
import 'package:crud_flutter/model/sistema_notificações/notification_result.dart';
import 'package:crud_flutter/core/utils/model/notification_history_model.dart';

class NotificationSpamGuard {
  final AntiSpamEngine engine;

  NotificationSpamGuard(this.engine);

  Future<bool> podeEnviar(
    NotificationResult notification,
    String hash,
  ) async {
    return await engine.podeEnviar(
      conteudo: "${notification.title}${notification.body}",
      tipo: "default",
    );
  }

  Future<void> registrar(
    NotificationResult notification,
    String hash,
  ) async {
    final model = NotificationHistoryModel(
      id: hash, // usando hash como ID único
      title: notification.title ?? '',
      body: notification.body ?? '',
      type: "default",
      timestamp: DateTime.now(),
      hash: hash,
    );

    await engine.registrarEnvio(model);
  }
}
