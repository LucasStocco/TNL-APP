/// Registrar conclusão de listas
/// Contar quantas listas o usuário concluiu
/// Gerar eventos
/// exemplo:
/// Primeira lista concluída
/// 5 listas concluídas
/// 10 listas concluídas
/// 50 listas concluídas

import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';

/// Responsável por verificar conquistas relacionadas
/// à conclusão de listas.
class ConquistaService {
  /// Verifica se uma conquista foi desbloqueada
  /// com base na quantidade total de listas concluídas.
  TipoEventoConquista? verificarConquista(
    int totalListasConcluidas,
  ) {
    switch (totalListasConcluidas) {
      case 1:
        return TipoEventoConquista.primeiraListaConcluida;

      case 5:
        return TipoEventoConquista.cincoListasConcluidas;

      case 10:
        return TipoEventoConquista.dezListasConcluidas;

      case 50:
        return TipoEventoConquista.cinquentaListasConcluidas;

      default:
        return null;
    }
  }
}
