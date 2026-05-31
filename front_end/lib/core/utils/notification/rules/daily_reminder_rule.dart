import 'package:crud_flutter/core/utils/notification/rules/notification_rule.dart';
import 'package:crud_flutter/core/utils/model/notification_context.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';

class DailyReminderRule implements NotificationRule {
  @override
  String get id => "daily_reminder";

  @override
  bool shouldNotify(NotificationContext context) {
    return context.hasPendingItems;
  }

  @override
  NotificationResult build(
    NotificationContext context,
  ) {
    if (context.hasAlmostCompletedList) {
      return NotificationResult(
        shouldNotify: true,
        title: "Quase lá! 🛒",
        body: "Suas listas estão quase finalizadas!",
        type: id,
      );
    }

    return NotificationResult(
      shouldNotify: true,
      title: "Lembrete diário 📋",
      body: "Você ainda tem listas pendentes para organizar.",
      type: id,
    );
  }
}
/// =========================
/// DAILY REMINDER RULE
/// =========================
///
/// Esta regra define a lógica de notificação de lembrete diário.
///
/// Ela é responsável por decidir quando o usuário deve receber
/// um lembrete sobre listas de compras pendentes.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Verificar se existem itens pendentes no sistema
/// ✔ Definir se a notificação deve ser enviada (shouldNotify)
/// ✔ Montar a mensagem da notificação (build)
///
/// =========================
/// REGRAS DE EXECUÇÃO
/// =========================
///
/// - Se não houver itens pendentes, NÃO notifica
/// - Se houver listas quase concluídas, envia mensagem motivacional
/// - Caso contrário, envia lembrete padrão diário
///
/// =========================
/// COMO SE ENCAIXA NO SISTEMA
/// =========================
///
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// DailyReminderRule
///        ↓
/// NotificationResult
///        ↓
/// NotificationService
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não acessa banco de dados ou API
/// ❌ Não agenda notificações
/// ❌ Não envia notificações diretamente
/// ❌ Não contém lógica de infraestrutura
///
/// Essas responsabilidades ficam em outras camadas:
///
/// - Engine → avalia todas as rules
/// - Scheduler → controla quando executar
/// - Service → envia notificações
/// - ContextBuilder → monta os dados do contexto
///
/// =========================
/// RESUMO
/// =========================
///
/// Esta regra define o comportamento do lembrete diário,
/// determinando quando e qual mensagem deve ser exibida ao usuário.
///