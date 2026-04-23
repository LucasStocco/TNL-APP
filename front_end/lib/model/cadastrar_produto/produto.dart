import '../cadastrar_categoria/categoria.dart';

class Produto {
  final int? id;
  final String nome;
  final double preco;
  final String? descricao;

  // 🔥 agora obrigatório (regra do backend)
  final int idCategoria;
  final Categoria categoria;

  final int? idUsuario;

  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  // soft delete
  final bool deletado;

  Produto({
    this.id,
    required this.nome,
    required this.preco,
    this.descricao,
    required this.idCategoria,
    required this.categoria,
    this.idUsuario,
    this.criadoEm,
    this.atualizadoEm,
    this.deletado = false,
  });

  // =========================
  // FROM JSON
  // =========================
  factory Produto.fromJson(Map<String, dynamic> json) {
    final categoriaJson = json['categoria'];

    if (categoriaJson == null) {
      throw Exception("Categoria é obrigatória no Produto");
    }

    final categoria = Categoria.fromJson(categoriaJson);

    return Produto(
      id: json['id'],
      nome: json['nome'] ?? 'Produto inválido',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'],

      idCategoria: categoria.id!, // vem da entidade
      categoria: categoria,

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
      'preco': preco,
      'descricao': descricao,

      // mantém compatibilidade com backend
      'idCategoria': idCategoria,

      'idUsuario': idUsuario,
      'deletado': deletado,
    };
  }

  // =========================
  // HELPERS
  // =========================
  bool get isAtivo => !deletado;
  bool get isDeletado => deletado;

  bool get isGlobal => idUsuario == null;

  Produto copyWith({
    int? id,
    String? nome,
    double? preco,
    String? descricao,
    int? idCategoria,
    Categoria? categoria,
    int? idUsuario,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
    bool? deletado,
  }) {
    return Produto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      descricao: descricao ?? this.descricao,
      idCategoria: idCategoria ?? this.idCategoria,
      categoria: categoria ?? this.categoria,
      idUsuario: idUsuario ?? this.idUsuario,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      deletado: deletado ?? this.deletado,
    );
  }

  @override
  String toString() {
    return 'Produto{id: $id, nome: $nome, categoria: ${categoria.nome}, deletado: $deletado}';
  }
}
