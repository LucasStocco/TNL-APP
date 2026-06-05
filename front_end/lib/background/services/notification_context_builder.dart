import 'package:crud_flutter/core/utils/rules/model/notification_context.dart';
import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';

class NotificationContextBuilder {
  static NotificationContext build(
    List<ListaResumoResponseDTO> listas, {
    String? filter,
  }) {
    print("🧠 [BUILDER] iniciando transformação de dados");
    print("🎯 [FILTER] recebido: $filter");

    /// =========================
    /// APLICAR FILTRO (CORREÇÃO PRINCIPAL)
    /// =========================
    List<ListaResumoResponseDTO> filtered = listas;

    if (filter == "pendentes") {
      filtered = listas.where((l) => l.progresso < 100).toList();
    }

    if (filter == "concluidas") {
      filtered = listas.where((l) => l.progresso >= 100).toList();
    }

    if (filter == "urgentes") {
      filtered = listas.where((l) => l.progresso < 50).toList();
    }

    /// =========================
    /// EMPTY STATE
    /// =========================
    if (filtered.isEmpty) {
      print("⚠️ [BUILDER] lista vazia após filtro");

      return NotificationContext(
        totalLists: 0,
        pendingLists: 0,
        completedLists: 0,
        remainingItems: 0,
        hasPendingItems: false,
        hasAlmostCompletedList: false,
        lastActivity: null,
        urgencyLevel: 0,
      );
    }

    print("📦 [BUILDER] input size filtrado: ${filtered.length}");

    /// =========================
    /// LISTAS PENDENTES
    /// =========================
    final pendentes = filtered.where((l) => l.progresso < 100).toList();

    /// =========================
    /// LISTAS CONCLUÍDAS
    /// =========================
    final concluidas = filtered.where((l) => l.progresso >= 100).toList();

    /// =========================
    /// CONTADORES
    /// =========================
    final totalLists = filtered.length;
    final pendingLists = pendentes.length;
    final completedLists = concluidas.length;

    /// =========================
    /// LISTA PRINCIPAL
    /// =========================
    final listaPrincipal = pendentes.isNotEmpty ? pendentes.first : null;

    /// =========================
    /// ITENS FALTANTES
    /// =========================
    final faltantes = listaPrincipal == null
        ? 0
        : (listaPrincipal.totalItens - listaPrincipal.itensComprados);

    /// =========================
    /// URGÊNCIA
    /// =========================
    final urgencyLevel = faltantes >= 10
        ? 2
        : faltantes >= 5
            ? 1
            : 0;

    /// =========================
    /// CONTEXT
    /// =========================
    final context = NotificationContext(
      totalLists: totalLists,
      pendingLists: pendingLists,
      completedLists: completedLists,
      remainingItems: faltantes,
      hasPendingItems: pendentes.isNotEmpty,
      hasAlmostCompletedList: faltantes > 0 && faltantes <= 3,
      lastActivity: DateTime.now(),
      urgencyLevel: urgencyLevel,
    );

    print("🧠 [BUILDER] contexto criado");
    print("   total: ${context.totalLists}");
    print("   pendentes: ${context.pendingLists}");
    print("   concluídas: ${context.completedLists}");
    print("   faltantes: ${context.remainingItems}");
    print("   urgência: ${context.urgencyLevel}");

    return context;
  }
}
