
import 'package:crud_flutter/background/workers/notification_context.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';

abstract class NotificationRule {
  String get id;

  bool shouldNotify(NotificationContext context);

  NotificationResult build(NotificationContext context);
}

/// =========================
/// NOTIFICATION RULE (BASE)
/// =========================
///
/// Esta classe define o contrato base para todas as regras de notificação.
///
/// Toda regra do sistema deve implementar esta classe.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// Cada NotificationRule deve:
///
/// ✔ Ter um identificador único (id)
/// ✔ Decidir se deve ou não disparar a notificação (shouldNotify)
/// ✔ Gerar a notificação final (build)
///
/// =========================
/// COMO FUNCIONA NO SISTEMA
/// =========================
///
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// NotificationRule.shouldNotify()
///        ↓
/// NotificationRule.build()
///        ↓
/// NotificationData
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não contém regras de negócio
/// ❌ Não acessa API ou banco de dados
/// ❌ Não envia notificações
/// ❌ Não controla tempo ou agendamento
///
/// Essas responsabilidades ficam separadas em:
///
/// - Engine → executa e avalia regras
/// - Scheduler → controla quando rodar
/// - Service → envia notificações
/// - ContextBuilder → monta dados do sistema
///
/// =========================
/// RESUMO
/// =========================
///
/// Esta classe serve como "contrato" que garante que todas as regras
/// de notificação sigam o mesmo padrão de implementação.
///
