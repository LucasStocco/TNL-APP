import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCooldownManager {
  /// Chave da última data de envio
  static const _lastNotificationKey = 'last_notification_date';

  /// Chave do último tipo enviado
  static const _lastNotificationTypeKey = 'last_notification_type';

  /// =========================
  /// CAN SEND
  /// =========================
  /// Verifica se já foi enviada
  /// alguma notificação hoje.
  ///
  /// Retorna:
  /// - true  → pode enviar
  /// - false → bloqueia envio
  static Future<bool> canSend() async {
    final prefs = await SharedPreferences.getInstance();

    final savedDate = prefs.getString(_lastNotificationKey);

    /// Nunca enviou notificação
    if (savedDate == null) {
      return true;
    }

    final lastDate = DateTime.parse(savedDate);

    final now = DateTime.now();

    /// Verifica se é o mesmo dia
    final isSameDay = lastDate.year == now.year &&
        lastDate.month == now.month &&
        lastDate.day == now.day;

    /// Se já enviou hoje:
    /// bloqueia
    return !isSameDay;
  }

  /// =========================
  /// SAVE SEND DATA
  /// =========================
  /// Salva informações do último envio.
  static Future<void> saveSendData(
    NotificationResult notification,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    /// Salva data
    await prefs.setString(
      _lastNotificationKey,
      DateTime.now().toIso8601String(),
    );

    /// Salva tipo
    await prefs.setString(
      _lastNotificationTypeKey,
      notification.type ?? 'unknown',
    );
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
