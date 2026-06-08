import '../tipo_evento_conquista.dart';

extension ConquistaUI on TipoEventoConquista {
  String get titulo {
    switch (this) {
      case TipoEventoConquista.primeiraListaConcluida:
        return "Primeira conquista";

      case TipoEventoConquista.cincoListasConcluidas:
        return "5 listas concluídas";

      case TipoEventoConquista.dezListasConcluidas:
        return "10 listas concluídas";

      case TipoEventoConquista.cinquentaListasConcluidas:
        return "50 listas concluídas";
    }
  }

  String get descricao {
    switch (this) {
      case TipoEventoConquista.primeiraListaConcluida:
        return "Você finalizou sua primeira lista!";

      case TipoEventoConquista.cincoListasConcluidas:
        return "Você já concluiu 5 listas!";

      case TipoEventoConquista.dezListasConcluidas:
        return "Você está ficando avançado! 10 listas concluídas.";

      case TipoEventoConquista.cinquentaListasConcluidas:
        return "Incrível! 50 listas concluídas!";
    }
  }
}
