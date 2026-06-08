import 'package:crud_flutter/core/notificacoes_gamificacao/armazenamento_conquistas.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/conquista_message_generator.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';
import 'package:crud_flutter/core/utils/notification_data.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';

class ConquistaRule {
  final ConquistaMessageGenerator generator;
  final ArmazenamentoConquistas armazenamento;

  ConquistaRule(
    this.generator,
    this.armazenamento,
  );

  Future<List<NotificationData>> evaluate(
    List<ListaResumo> listas,
  ) async {
    final notifications = <NotificationData>[];

    final concluidas =
        listas.where((l) => l.progresso == 100).length;

    final conquistasSalvas =
        await armazenamento.obterConquistas();

    final conquistas = <TipoEventoConquista, int>{
      TipoEventoConquista.primeiraListaConcluida: 1,
      TipoEventoConquista.cincoListasConcluidas: 5,
      TipoEventoConquista.dezListasConcluidas: 10,
      TipoEventoConquista.cinquentaListasConcluidas: 50,
    };

    for (final entry in conquistas.entries) {
      final tipo = entry.key;
      final meta = entry.value;

      final jaDesbloqueada =
          conquistasSalvas.contains(tipo.name);

      if (concluidas >= meta && !jaDesbloqueada) {
        await armazenamento.salvarConquista(tipo);

        notifications.add(_build(tipo));
      }
    }

    return notifications;
  }

  NotificationData _build(TipoEventoConquista tipo) {
    return NotificationData(
      tipo: "conquista",
      conteudo: generator.gerarMensagem(tipo),
    );
  }
}