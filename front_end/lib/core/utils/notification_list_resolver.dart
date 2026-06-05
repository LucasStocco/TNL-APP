import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';

/// Responsável por resolver filtros vindos de notificações
/// e transformar isso em listas reais exibidas na UI.
class NotificationListResolver {
  static List<ListaResumo> resolve(
    List<ListaResumo> listas,
    String? filter,
  ) {
    print("🧠 LIST RESOLVER");
    print("🧠 FILTER RECEBIDO: $filter");
    print("📦 TOTAL LISTAS: ${listas.length}");

    if (filter == null) return listas;

    switch (filter) {
      // =========================
      // PENDENTES (< 100%)
      // =========================
      case 'pendentes':
        final result = listas.where((l) => (l.progresso ?? 0) < 100).toList();

        print("📌 PENDENTES: ${result.length}");
        return result;

      // =========================
      // URGENTES (< 30%)
      // =========================
      case 'urgentes':
        final result = listas.where((l) => (l.progresso ?? 0) < 30).toList();

        print("🚨 URGENTES: ${result.length}");
        return result;

      // =========================
      // QUASE CONCLUÍDAS (30% - 70%)
      // =========================
      case 'quase_concluidas':
        final result = listas
            .where((l) => (l.progresso ?? 0) >= 30 && (l.progresso ?? 0) < 100)
            .toList();

        print("⚠️ QUASE CONCLUÍDAS: ${result.length}");
        return result;

      // =========================
      // CONCLUÍDAS (100%)
      // =========================
      case 'concluidas':
        final result = listas.where((l) => (l.progresso ?? 0) == 100).toList();

        print("✅ CONCLUÍDAS: ${result.length}");
        return result;

      default:
        print("⚠️ FILTRO DESCONHECIDO -> retornando tudo");
        return listas;
    }
  }
}
