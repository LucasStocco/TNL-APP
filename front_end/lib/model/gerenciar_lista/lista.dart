import '../cadastrar_produto/item.dart';

class Lista {
  final int? id;
  final String nome;
  final int? idUsuario;

  final List<Item> itens;

  final DateTime? criadoEm;
  final DateTime? atualizadoEm;
  final DateTime? concluidoEm;

  final bool deletado;

  Lista({
    this.id,
    required this.nome,
    this.idUsuario,
    this.itens = const [],
    this.criadoEm,
    this.atualizadoEm,
    this.concluidoEm,
    this.deletado = false,
  });

  // =========================
  // FROM JSON
  // =========================
  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
      id: json['id'],
      nome: json['nome'] ?? 'Sem nome',
      idUsuario: json['idUsuario'],
      itens: (json['itens'] as List<dynamic>?)
              ?.map((i) => Item.fromJson(i))
              .toList() ??
          [],
      criadoEm:
          json['criadoEm'] != null ? DateTime.tryParse(json['criadoEm']) : null,
      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.tryParse(json['atualizadoEm'])
          : null,
      concluidoEm: json['concluidoEm'] != null
          ? DateTime.tryParse(json['concluidoEm'])
          : null,
      deletado: json['deletado'] ?? false,
    );
  }

  // =========================
  // TO JSON
  // =========================
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'idUsuario': idUsuario,
      'deletado': deletado,
      // Adicione as linhas abaixo para satisfazer o banco de dados
      'criadoEm': criadoEm?.toIso8601String(),
      'atualizadoEm': atualizadoEm?.toIso8601String(),
      'concluidoEm': concluidoEm?.toIso8601String(),
    };
  }

  // =========================
  // HELPERS
  // =========================
  bool get concluida => concluidoEm != null;

  bool get isAtiva => !deletado;

  // =========================
  // CONCLUIR LISTA
  // =========================
  Lista concluir() {
    return copyWith(
      concluidoEm: DateTime.now(),
      atualizadoEm: DateTime.now(),
    );
  }

  // =========================
  // COPY WITH
  // =========================
  Lista copyWith({
    int? id,
    String? nome,
    int? idUsuario,
    List<Item>? itens,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
    DateTime? concluidoEm,
    bool? deletado,
  }) {
    return Lista(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idUsuario: idUsuario ?? this.idUsuario,
      itens: itens ?? this.itens,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      concluidoEm: concluidoEm ?? this.concluidoEm,
      deletado: deletado ?? this.deletado,
    );
  }

  @override
  String toString() {
    return 'Lista{id: $id, nome: $nome, concluida: $concluida}';
  }
}
