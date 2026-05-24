import 'package:crud_flutter/service/notifications/rules/base/notification_rule.dart';
import 'package:crud_flutter/service/notifications/rules/model/notification_context.dart';
import 'package:crud_flutter/service/notifications/rules/model/notification_data.dart';

class DailyReminderRule implements NotificationRule {
  @override
  String get id => "daily_reminder";

  @override
  bool shouldNotify(NotificationContext context) {
    return context.hasPendingItems;
  }

  @override
  NotificationData build(NotificationContext context) {
    if (context.hasAlmostCompletedList) {
      return NotificationData(
        title: "Quase lá! 🛒",
        body: "Suas listas estão quase finalizadas!",
        type: id,
      );
    }

    return NotificationData(
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
/// NotificationData
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