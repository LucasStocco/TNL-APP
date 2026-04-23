class Categoria {
  final int? id;
  final String nome;
  final String? codigo;
  final int? idUsuario;

  // 🔥 DO DIAGRAMA (soft delete)
  // vindo do backend (apenas leitura no front)
  final bool deletado;

  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Categoria({
    this.id,
    required this.nome,
    this.codigo,
    this.idUsuario,
    this.criadoEm,
    this.atualizadoEm,

    // backend pode ou não enviar, mas front espera
    this.deletado = false,
  });

  // =========================
  // FROM JSON
  // =========================
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'] ?? 'Sem nome',
      codigo: json['codigo'],
      idUsuario: json['idUsuario'],
      criadoEm:
          json['criadoEm'] != null ? DateTime.tryParse(json['criadoEm']) : null,
      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.tryParse(json['atualizadoEm'])
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
      if (codigo != null) 'codigo': codigo,
      if (idUsuario != null) 'idUsuario': idUsuario,

      // enviado só se backend aceitar (senão pode ignorar no service)
      'deletado': deletado,
    };
  }

  // =========================
  // HELPERS (APENAS LEITURA)
  // =========================

  bool get isGlobal => idUsuario == null;
  bool get isUsuario => idUsuario != null;

  bool get isAtivo => !deletado;
  bool get isDeletado => deletado;

  // =========================
  // COPY WITH
  // =========================
  Categoria copyWith({
    int? id,
    String? nome,
    String? codigo,
    int? idUsuario,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
    bool? deletado,
  }) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      idUsuario: idUsuario ?? this.idUsuario,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      deletado: deletado ?? this.deletado,
    );
  }

  @override
  String toString() {
    return 'Categoria{id: $id, nome: $nome, deletado: $deletado}';
  }
}
