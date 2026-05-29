import 'package:crud_flutter/model/sistema_notificações/notification_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CooldownTimer {
  final bool canSend;
  final Duration remaining;

  CooldownTimer({
    required this.canSend,
    required this.remaining,
  });
}

class NotificationCooldownManager {
  static const _lastNotificationKey = 'last_notification_date';
  static const _lastNotificationTypeKey = 'last_notification_type';

  /// =========================
  /// 🔧 FLAG DE TESTE
  /// =========================
  static const bool TEST_MODE = true;

  /// intervalo de teste (30 segundos)
  static const Duration testCooldown = Duration(seconds: 30);

  /// cooldown real (1 dia)
  static const Duration realCooldown = Duration(days: 1);

  /// =========================
  /// CHECK COOLDOWN
  /// =========================
  static Future<CooldownTimer> checkCooldown() async {
    final prefs = await SharedPreferences.getInstance();

    final savedDate = prefs.getString(_lastNotificationKey);

    final cooldown = TEST_MODE ? testCooldown : realCooldown;

    if (savedDate == null) {
      return CooldownTimer(
        canSend: true,
        remaining: Duration.zero,
      );
    }

    final lastDate = DateTime.parse(savedDate);
    final now = DateTime.now();

    final difference = now.difference(lastDate);
    final remaining = cooldown - difference;

    final canSend = difference >= cooldown;

    return CooldownTimer(
      canSend: canSend,
      remaining: remaining.isNegative ? Duration.zero : remaining,
    );
  }

  /// =========================
  /// SAVE SEND DATA
  /// =========================
  static Future<void> saveSendData(
    NotificationResult notification,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _lastNotificationKey,
      DateTime.now().toIso8601String(),
    );

    await prefs.setString(
      _lastNotificationTypeKey,
      notification.type ?? 'unknown',
    );
  }

  /// =========================
  /// 🧪 RESET (TESTE)
  /// =========================
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastNotificationKey);
    await prefs.remove(_lastNotificationTypeKey);
  }
}

/* CLASSE NOTIFICATION COOLDOWN MANAGER (UM CONTROLADOR DE FREQUÊNCIA)
- A responsabilidade desta classe é impedir spa de notificaçõe
- O CooldownManager é uma regra que faz com que só pode enviar uma notificação por dia
- Ele deve: verificar o ultimo envio, salvar o ultimo envio, controlar o cooldown temporal e bloquear o span diário

COMO FUNCIONA:
- O worker chama NotificationCooldownManager.canSend()
- Manager lê SharedPreferences, para procurar o lasta_notification_date
- Se não existir → significa que nunca enviou notificação
- Se existir → ele pega a data e compara com a data atual (ano, mês, dia)]
- Se já enviou hoje, o worker é encerrado
- Se não enviou hoje, o fluxo continua normalmente

 */
