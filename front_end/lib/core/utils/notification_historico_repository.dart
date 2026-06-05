
import 'package:crud_flutter/core/utils/model/notification_history_model.dart';
import 'package:crud_flutter/core/utils/notification_historico_storage.dart';

class NotificationHistoricoRepository {
  final NotificationHistoricoStorage storage;

  NotificationHistoricoRepository(this.storage);

  /// Salva uma notificação no histórico
  Future<void> salvar(NotificationHistoryModel modelo) {
    return storage.salvar(modelo);
  }

  /// Busca todo o histórico
  Future<List<NotificationHistoryModel>> buscarTodos() {
    return storage.buscarTodos();
  }

  /// Remove notificações antigas
  Future<void> removerAntigos(Duration duracao) {
    return storage.removerAntigos(duracao);
  }

  /// Limpa tudo
  Future<void> limparTudo() {
    return storage.limparTudo();
  }
}
