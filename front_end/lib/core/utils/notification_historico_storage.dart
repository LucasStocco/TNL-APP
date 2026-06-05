import 'dart:convert';
import 'package:crud_flutter/core/utils/model/notification_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHistoricoStorage {
  static const String _chave = 'historico_notificacoes';

  /// Salva uma notificação no histórico local
  Future<void> salvar(NotificationHistoryModel modelo) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> lista = prefs.getStringList(_chave) ?? [];

    lista.add(jsonEncode(modelo.toMap()));

    await prefs.setStringList(_chave, lista);
  }

  /// Busca todo o histórico de notificações
  Future<List<NotificationHistoryModel>> buscarTodos() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> lista = prefs.getStringList(_chave) ?? [];

    return lista.map((item) {
      final map = jsonDecode(item);
      return NotificationHistoryModel.fromMap(
        Map<String, dynamic>.from(map),
      );
    }).toList();
  }

  /// Remove notificações antigas baseado no tempo
  Future<void> removerAntigos(Duration duracao) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> lista = prefs.getStringList(_chave) ?? [];

    final agora = DateTime.now();

    final filtrado = lista.where((item) {
      final map = jsonDecode(item);
      final modelo = NotificationHistoryModel.fromMap(
        Map<String, dynamic>.from(map),
      );

      return agora.difference(modelo.timestamp) < duracao;
    }).toList();

    await prefs.setStringList(_chave, filtrado);
  }

  /// Remove todo o histórico
  Future<void> limparTudo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chave);
  }
}
