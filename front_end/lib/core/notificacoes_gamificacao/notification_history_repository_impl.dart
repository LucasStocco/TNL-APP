/// importando a interface (contrato). Define oque essa classe deve fazer
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/notification_history_repository.dart';

/// Essa classe OBRIGATORIAMENTE segue o contrato da interface
class NotificationHistoryRepositoryImpl
    implements NotificationHistoryRepository {
  
  /// chave usada para armazenar o histórico no SharedPreferences
  static const String _chaveHistoricoNotificacoes =
      'historico_notificacoes';

  @override

  /// Salvar notificacao (recebe a mensagem e adiciona no histórico persistente)
  Future<void> salvarNotificacao(String mensagem) async {
    final prefs = await SharedPreferences.getInstance();

    final listaAtual =
        prefs.getStringList(_chaveHistoricoNotificacoes) ?? [];

    listaAtual.add(mensagem);

    await prefs.setStringList(_chaveHistoricoNotificacoes, listaAtual);
  }

  @override

  /// Buscar histórico (retorna as mensagens armazenadas no dispositivo)
  /// Para produção melhor adequar: limite de tamanho, ordenar por data, filtrar duplicados, etc
  Future<List<String>> buscarHistorico() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_chaveHistoricoNotificacoes) ?? [];
  }

  @override

  /// Limpar histórico (remove tudo do armazenamento local)
  /// Pode ser usado para: reset de dados, logout e limpeza de cache
  Future<void> limparHistorico() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_chaveHistoricoNotificacoes);
  }
}