class Produto {
  final int id;
  final String nome;
  final String? descricao;

  final int subcategoriaId;
  final String? nomeSubcategoria;

  final int categoriaId;
  final String? nomeCategoria;

  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Produto({
    required this.id,
    required this.nome,
    this.descricao,
    required this.subcategoriaId,
    this.nomeSubcategoria,
    required this.categoriaId,
    this.nomeCategoria,
    this.criadoEm,
    this.atualizadoEm,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
      subcategoriaId: json['subcategoriaId'] ?? 0,
      nomeSubcategoria: json['nomeSubcategoria'],
      categoriaId: json['categoriaId'] ?? 0,
      nomeCategoria: json['nomeCategoria'],
      criadoEm:
          json['criadoEm'] != null ? DateTime.tryParse(json['criadoEm']) : null,
      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.tryParse(json['atualizadoEm'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'subcategoriaId': subcategoriaId,
    };
  }
}
