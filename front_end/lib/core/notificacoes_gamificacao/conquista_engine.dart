import 'package:crud_flutter/core/notificacoes_gamificacao/conquista_service.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';

/// =========================
/// CONQUISTA ENGINE
/// =========================
///
/// Centro de controle da gamificação.
///
/// Responsável por:
/// - Orquestrar regras de conquista
/// - Delegar validação para serviços especializados
/// - Retornar conquista desbloqueada (ou null)
///
/// Obs:
/// Nesta fase inicial, ele apenas delega para o ConquistaService.
/// Depois ele pode crescer para combinar múltiplas regras.
///
class ConquistaEngine {
  final ConquistaService _conquistaService;

  ConquistaEngine(this._conquistaService);

  /// =========================
  /// AVALIAÇÃO PRINCIPAL
  /// =========================
  ///
  /// Entrada:
  /// - total de listas concluídas
  ///
  /// Saída:
  /// - conquista desbloqueada ou null
  ///
  TipoEventoConquista? avaliarConclusaoLista(
    int totalListasConcluidas,
  ) {
    return _conquistaService.verificarConquista(totalListasConcluidas);
  }
}
