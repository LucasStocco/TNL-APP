import 'package:crud_flutter/core/utils/model/notification_context.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';

import '../../../core/utils/notification/rules/notification_rule.dart';

class NotificationEngine {
  final List<NotificationRule> rules;

  NotificationEngine(this.rules);

  List<NotificationResult> evaluate(
    NotificationContext context,
  ) {
    final result = <NotificationResult>[];

    for (final rule in rules) {
      if (rule.shouldNotify(context)) {
        result.add(rule.build(context));
      }
    }

    return result;
  }
}

/// =========================
/// NOTIFICATION ENGINE
/// =========================
///
/// O NotificationEngine é o "cérebro" do sistema de notificações.
///
/// Ele NÃO busca dados, NÃO envia notificações e NÃO contém regras.
///
/// Sua responsabilidade é:
///
/// ✔ Receber um NotificationContext (estado atual do app)
/// ✔ Receber uma lista de NotificationRule (regras)
/// ✔ Avaliar quais regras devem ser executadas
/// ✔ Gerar uma lista de NotificationResult (notificações prontas)
///
/// Fluxo de execução:
///
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓ (avalia cada rule)
/// NotificationRule.shouldNotify()
///        ↓
/// NotificationRule.build()
///        ↓
/// List<NotificationResult>
///
/// =========================
/// O QUE ELE NÃO FAZ
/// =========================
///
/// ❌ Não acessa API
/// ❌ Não busca listas ou dados do app
/// ❌ Não envia notificações
/// ❌ Não controla tempo ou agendamento
///
/// Essas responsabilidades ficam em:
///
/// - Scheduler → controla quando executar
/// - Rules → definem a lógica de decisão
/// - ContextBuilder → monta os dados do app
/// - NotificationService → envia notificações
///
/// =========================
/// RESUMO
/// =========================
///
/// O Engine apenas decide:
/// "Quais notificações devem ser geradas com base no contexto atual?"
///
