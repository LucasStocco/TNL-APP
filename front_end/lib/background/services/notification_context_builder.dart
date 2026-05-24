import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import 'package:crud_flutter/service/notifications/rules/model/notification_context.dart';

class NotificationContextBuilder {
  static NotificationContext build(
    List<ListaResumoResponseDTO> listas,
  ) {
    print("🧠 [BUILDER] iniciando transformação de dados");

    if (listas.isEmpty) {
      print("⚠️ [BUILDER] lista vazia");

      return NotificationContext(
        hasPendingItems: false,
        pendingCount: 0,
        remainingItems: 0,
        hasAlmostCompletedList: false,
      );
    }

    print("📦 [BUILDER] input size: ${listas.length}");

    // ✅ LISTAS PENDENTES
    final pendentes = listas.where((l) => l.progresso < 100).toList();

    final quantidadePendentes = pendentes.length;

    // ✅ LISTA PRINCIPAL
    final listaPrincipal = pendentes.isNotEmpty ? pendentes.first : null;

    // ✅ ITENS FALTANTES
    final faltantes = listaPrincipal == null
        ? 0
        : (listaPrincipal.totalItens - listaPrincipal.itensComprados);

    final context = NotificationContext(
      hasPendingItems: pendentes.isNotEmpty,
      pendingCount: quantidadePendentes,
      remainingItems: faltantes,
      hasAlmostCompletedList: faltantes > 0 && faltantes <= 3,
    );

    print("🧠 [BUILDER] contexto criado");
    print("   pendentes: ${context.pendingCount}");
    print("   faltantes: ${context.remainingItems}");

    return context;
  }
}
