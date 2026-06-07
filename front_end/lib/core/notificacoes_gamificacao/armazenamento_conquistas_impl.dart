/// Permite acessar o armazenamento local do dispositivo.
import 'package:shared_preferences/shared_preferences.dart';

/// Importa o contrato.
import 'package:crud_flutter/core/notificacoes_gamificacao/armazenamento_conquistas.dart';

/// Importa o enum das conquistas.
import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';

/// Implementação responsável por persistir dados da gamificação
/// utilizando SharedPreferences.
///
/// Armazena:
/// - Total de listas concluídas (progresso)
/// - Conquistas desbloqueadas
/// - Listas já contabilizadas (EVITA DUPLICAÇÃO)
///
/// Implementa o contrato ArmazenamentoConquistas, ou seja, OBRIGATORIAMENTE tem que ter os métodos definidos na interface.
class ArmazenamentoConquistasImpl implements ArmazenamentoConquistas {
  /// (Progresso) Quantidade total de listas concluídas pelo usuário
  static const String _chaveTotalListasConcluidas = 'total_listas_concluidas';

  /// (Conquistas) Lista de conquistas desbloqueadas
  static const String _chaveConquistas = 'conquistas_desbloqueadas';

  /// (Controle anti-bug) Listas já contabilizadas como concluídas
  static const String _chaveListasConcluidas = 'listas_concluidas_ids';

  @override
  Future<void> resetarProgresso() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_chaveTotalListasConcluidas);
    await prefs.remove(_chaveConquistas);
    await prefs.remove(_chaveListasConcluidas); // 🔥 IMPORTANTE
  }

  @override
  Future<void> salvarTotalListasConcluidas(int total) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      _chaveTotalListasConcluidas,
      total,
    );
  }

  @override
  Future<int> obterTotalListasConcluidas() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_chaveTotalListasConcluidas) ?? 0;
  }

  // =========================
  // 🔥 LISTAS JÁ CONTABILIZADAS
  // =========================

  @override
  Future<void> salvarListaConcluida(int listaId) async {
    final prefs = await SharedPreferences.getInstance();

    final listas = prefs.getStringList(_chaveListasConcluidas) ?? [];

    final idStr = listaId.toString();

    if (!listas.contains(idStr)) {
      listas.add(idStr);

      await prefs.setStringList(
        _chaveListasConcluidas,
        listas,
      );
    }
  }

  @override
  Future<List<int>> obterListasConcluidas() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getStringList(_chaveListasConcluidas) ?? [])
        .map(int.parse)
        .toList();
  }

  @override
  Future<void> limparListasConcluidas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveListasConcluidas);
  }

  @override
  Future<void> salvarConquista(TipoEventoConquista conquista) async {
    final prefs = await SharedPreferences.getInstance();

    final conquistas = prefs.getStringList(_chaveConquistas) ?? [];

    if (!conquistas.contains(conquista.name)) {
      conquistas.add(conquista.name);

      await prefs.setStringList(
        _chaveConquistas,
        conquistas,
      );
    }
  }

  @override
  Future<List<TipoEventoConquista>> obterConquistas() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_chaveConquistas) ?? [];

    return list.map((e) => TipoEventoConquista.values.byName(e)).toList();
  }

  @override
  Future<void> limparConquistas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveConquistas);
  }
}
