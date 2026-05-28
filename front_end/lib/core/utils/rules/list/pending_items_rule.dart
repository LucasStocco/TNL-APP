import 'package:crud_flutter/core/utils/rules/base/notification_rule.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';

/// =========================
/// RULE: ITENS PENDENTES
/// =========================
/// Dispara notificação quando existe
/// pelo menos um item não comprado.

class PendingItemsRule implements NotificationRule {
  @override
  String get id => "pending_items";

  @override
  bool shouldNotify(NotificationContext context) {
    return context.hasPendingItems;
  }

  @override
  NotificationResult build(
    NotificationContext context,
  ) {
    return NotificationResult(
      shouldNotify: true,
      title: "Itens pendentes",
      body: "Você ainda tem itens na lista para finalizar 🛒",
      type: id,
    );
  }
}

/// =========================
/// RULE: ITENS PENDENTES
/// =========================
///
/// Esta regra é responsável por disparar uma notificação
/// quando o usuário possui itens pendentes em suas listas.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Verificar o contexto atual do sistema
/// ✔ Identificar se existem itens pendentes
/// ✔ Definir se a notificação deve ser enviada (shouldNotify)
/// ✔ Criar a notificação final (build)
///
/// =========================
/// REGRA DE EXECUÇÃO
/// =========================
///
/// - Se existirem itens pendentes, a regra é ativada
/// - Caso contrário, nenhuma notificação é gerada
///
/// =========================
/// COMO SE ENCAIXA NA ARQUITETURA
/// =========================
///
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// PendingItemsRule
///        ↓
/// NotificationData
///        ↓
/// NotificationService
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não acessa API ou banco de dados
/// ❌ Não agenda notificações
/// ❌ Não envia notificações diretamente
/// ❌ Não contém lógica de infraestrutura
///
/// Essas responsabilidades ficam separadas em outras camadas:
///
/// - Engine → avalia e executa regras
/// - Scheduler → controla quando executar
/// - Service → envia notificações
/// - ContextBuilder → monta o contexto do sistema
///
/// =========================
/// RESUMO
/// =========================
///
/// Esta regra define o comportamento de notificação
/// relacionado a itens pendentes no sistema.
///
