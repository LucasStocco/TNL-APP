import 'package:crud_flutter/model/gerenciar_lista/item.dart';

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

  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
      id: json['id'],
      nome: json['nome'] ?? 'Sem nome',
      idUsuario: json['idUsuario'],
      itens: (json['itens'] as List<dynamic>?)
              ?.map((i) => Item.fromJson(i))
              .toList() ??
          [],
      criadoEm: DateTime.tryParse(json['criadoEm'] ?? ''),
      atualizadoEm: DateTime.tryParse(json['atualizadoEm'] ?? ''),
      concluidoEm: DateTime.tryParse(json['concluidoEm'] ?? ''),
      deletado: json['deletado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'idUsuario': idUsuario,
      'deletado': deletado,
    };
  }

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

  // =========================
  // HELPERS
  // =========================
  bool get concluida => concluidoEm != null;
  bool get isAtiva => !deletado;
  bool get isEmpty => itens.isEmpty;

  @override
  String toString() {
    return 'Lista{id: $id, nome: $nome, concluida: $concluida}';
  }
}
