/// Qualquer classe que for um NotificationHistoryRepository PRECISA ter esses métodos.
abstract class NotificationHistoryRepository {
  Future<void> salvarNotificacao(String mensagem);

  Future<List<String>> buscarHistorico();

  Future<void> limparHistorico();
}