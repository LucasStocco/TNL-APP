import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';

class Produto {
  final int? id;
  final String nome;
  final double preco;
  final String? descricao;

  final int idCategoria;
  final Categoria categoria;

  final int? idUsuario;

  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

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

  factory Produto.fromJson(Map<String, dynamic> json) {
    final categoriaJson = json['categoria'];

    final categoria = categoriaJson != null
        ? Categoria.fromJson(categoriaJson)
        : Categoria(
            id: json['idCategoria'] ?? 0,
            nome: json['nomeCategoria'] ?? '',
            codigo: 'UNKNOWN',
            deletado: false,
          );

    return Produto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'] ?? '',

      categoria: categoria,

      // ⚠️ mantém compatibilidade, mas agora depende da categoria
      idCategoria: categoria.id,

      idUsuario: json['idUsuario'],

      criadoEm:
          json['criadoEm'] != null ? DateTime.tryParse(json['criadoEm']) : null,

      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.tryParse(json['atualizadoEm'])
          : null,

      deletado: json['deletado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'preco': preco,
      'descricao': descricao,
      'idCategoria': idCategoria, // ✅ corrigido
      'idUsuario': idUsuario,
      'deletado': deletado,
    };
  }

  bool get isAtivo => !deletado;
  bool get isGlobal => idUsuario == null;
}
