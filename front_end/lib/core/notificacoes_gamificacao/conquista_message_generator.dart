/// importa o enum porque a classe trabalha diretamente com: TipoEventoConquista
/// Sem isso, o Dart não saberia quais conquistas existem.
import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';

/// Gerador de mensagens para conquistas.
class ConquistaMessageGenerator {
  /// Método principal
  /// Recebe: TipoEventoConquista (enum)
  /// Saída: String (mensagem para o usuário)
  /// Ou seja, a entrada é um tipo de conquista e a saída é uma mensagem personalizada para essa conquista.
  String gerarMensagem(
    TipoEventoConquista conquista,
  ) {
    /// Mapeamento
    switch (conquista) {
      /// .primeiraListaConcluida -> Mensagem personalizada para a primeira conquista
      case TipoEventoConquista.primeiraListaConcluida:
        return '🏆 Parabéns! Você concluiu sua primeira lista!';

      /// .cincoListasConcluidas -> Mensagem personalizada para a conquista de 5 listas
      case TipoEventoConquista.cincoListasConcluidas:
        return '🏆 Você concluiu 5 listas!';

      /// .dezListasConcluidas -> Mensagem personalizada para a conquista de 10 listas
      case TipoEventoConquista.dezListasConcluidas:
        return '🏆 Você concluiu 10 listas!';

      /// .cinquentaListasConcluidas -> Mensagem personalizada para a conquista de 50 listas
      case TipoEventoConquista.cinquentaListasConcluidas:
        return '🏆 Você concluiu 50 listas! Incrível!';
    }
  }
}
