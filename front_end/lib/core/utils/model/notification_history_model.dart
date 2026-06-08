/// Registro (log) de notificações já enviadas pelo sistema inteligente.
///
/// Essa classe é usada para rastrear notificações disparadas pela Rules Engine,
/// evitando duplicações e permitindo análise de comportamento do usuário.
class NotificationHistoryModel {
  /// Identificador único do registro no banco de dados.
  final String id;

  /// Título exibido na notificação enviada.
  final String title;

  /// Corpo (conteúdo principal) da notificação enviada.
  final String body;

  /// Tipo da notificação gerada pela Rules Engine.
  ///
  /// Exemplos:
  /// - LISTA_QUASE_CONCLUIDA
  /// - MULTIPLAS_LISTAS_PENDENTES
  /// - ALERTA_INATIVIDADE
  final String type;

  /// Data e hora em que a notificação foi enviada.
  final DateTime timestamp;

  /// Hash único que identifica a origem lógica da notificação.
  ///
  /// Usado para evitar duplicação de notificações com a mesma regra e contexto.
  final String hash;

  NotificationHistoryModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    required this.hash,
  });

  /// Cria uma nova instância com valores atualizados.
  NotificationHistoryModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    DateTime? timestamp,
    String? hash,
  }) {
    return NotificationHistoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      hash: hash ?? this.hash,
    );
  }

  /// Converte o modelo para Map (persistência em banco/local storage).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'hash': hash,
    };
  }

  /// Cria o modelo a partir de um Map (leitura do banco/local storage).
  factory NotificationHistoryModel.fromMap(Map<String, dynamic> map) {
    return NotificationHistoryModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
      hash: map['hash'],
    );
  }
}