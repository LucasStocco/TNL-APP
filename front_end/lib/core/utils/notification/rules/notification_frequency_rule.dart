import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';

class NotificationFrequencyRule {
  static int _sentToday = 0;
  static DateTime _lastReset = DateTime.now();

  static const bool testMode = true;

  static void _resetIfNeeded() {
    final now = DateTime.now();

    if (testMode) {
      if (now.difference(_lastReset).inSeconds >= 20) {
        _sentToday = 0;
        _lastReset = now;
      }
      return;
    }

    if (now.day != _lastReset.day) {
      _sentToday = 0;
      _lastReset = now;
    }
  }

  static bool canSend(FrequenciaNotificacao frequency) {
    _resetIfNeeded();

    switch (frequency) {
      case FrequenciaNotificacao.low:
        return _sentToday < 1;

      case FrequenciaNotificacao.normal:
        return _sentToday < 3;

      case FrequenciaNotificacao.high:
        return true;
    }
  }

  static void registerSend() {
    _sentToday++;

    print("📊 enviadas no período: $_sentToday");
  }
}

/// =========================
/// REGRA DE FREQUÊNCIA DE NOTIFICAÇÕES
/// =========================
///
/// MODO TESTE:
/// Low    = 1 notificação a cada 20 segundos
/// Normal = até 3 notificações a cada 20 segundos
/// High   = sem limite
///
/// PRODUÇÃO:
/// Low    = 1 notificação por dia
/// Normal = até 3 notificações por dia
/// High   = sem limite
