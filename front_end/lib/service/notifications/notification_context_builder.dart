import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';
import 'package:crud_flutter/core/utils/model/notification_context.dart';

class NotificationContextBuilder {
  // =========================
  // BUILD CONTEXT
  // =========================
  //
  // Transforma dados do app
  // (listas, progresso etc.)
  // em um contexto limpo
  // para o sistema de notificações.
  //

  static NotificationContext build(List<ListaResumo> listas) {
    // Filtra listas pendentes (progresso < 100%)
    final pendentes = listas.where((l) => l.progresso < 100).toList();

    // =========================
    // CONTADORES
    // =========================
    final quantidadePendentes = pendentes.length;

    final listaPrincipal = pendentes.isNotEmpty ? pendentes.first : null;

    final faltantes = listaPrincipal == null
        ? 0
        : (listaPrincipal.totalItens - listaPrincipal.itensComprados);

    // =========================
    // CONTEXTO FINAL
    // =========================
    return NotificationContext(
      totalLists: listas.length,
      pendingLists: quantidadePendentes,
      completedLists: listas.where((l) => l.progresso >= 100).length,
      remainingItems: faltantes,
      hasPendingItems: pendentes.isNotEmpty,
      hasAlmostCompletedList: faltantes > 0 && faltantes <= 3,
      lastActivity: DateTime.now(), // mock temporário
      urgencyLevel: faltantes >= 10
          ? 2
          : faltantes >= 5
              ? 1
              : 0,
    );
  }
}

/// =========================
/// NOTIFICATION CONTEXT BUILDER
/// =========================
///
/// Esta classe é responsável por transformar os dados brutos do aplicativo
/// (como ListasResumo) em um contexto simplificado e estruturado
/// para o sistema de notificações.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Converter dados complexos do app em um contexto simples
/// ✔ Filtrar listas pendentes
/// ✔ Calcular métricas importantes (quantidade, itens restantes)
/// ✔ Criar o NotificationContext usado pelas regras (Rules)
///
/// =========================
/// COMO FUNCIONA NO SISTEMA
/// =========================
///
/// ListaResumo (dados do app)
///        ↓
/// NotificationContextBuilder
///        ↓
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// NotificationRules
///        ↓
/// NotificationData
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
/// ❌ Não contém regras de notificação
/// ❌ Não envia notificações
/// ❌ Não agenda notificações
/// ❌ Não acessa serviços externos (API, banco, etc.)
///
/// Essas responsabilidades ficam separadas em outras camadas:
///
/// - Engine → avalia regras
/// - Rules → definem lógica de notificação
/// - Scheduler → controla quando executar
/// - Service → envia notificações ao usuário
///
/// =========================
/// RESUMO
/// =========================
///
/// O ContextBuilder atua como um "tradutor" entre os dados do app
/// e o sistema de regras de notificação, preparando um contexto limpo
/// e fácil de ser interpretado pelo NotificationEngine.
