import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';

/// Responsável por persistir dados da gamificação.
///
/// Armazena:
/// - Conquistas desbloqueadas
/// - Progresso do usuário
///   (quantidade de listas concluídas)
abstract class ArmazenamentoConquistas {
  /// Guardar o progresso do usuário.
  Future<void> salvarTotalListasConcluidas(
    int total,
  );

  /// Recuperar o progresso salvo.
  Future<int> obterTotalListasConcluidas();

  /// Registrar que uma conquista foi desbloqueada.
  Future<void> salvarConquista(
    TipoEventoConquista conquista,
  );

  /// Recuperar todas as conquistas desbloqueadas.
  Future<List<TipoEventoConquista>> obterConquistas();

  /// Reseta o progresso
  Future<void> resetarProgresso();

  /// salva lista já usada na gamificação
  Future<void> salvarListaConcluida(int listaId);

  /// obtém listas já usadas na gamificação
  Future<List<int>> obterListasConcluidas();

  /// limpa listas usadas (RESET TOTAL)
  Future<void> limparListasConcluidas();

  /// limpa conquistas (RESET TOTAL)
  Future<void> limparConquistas();
}
