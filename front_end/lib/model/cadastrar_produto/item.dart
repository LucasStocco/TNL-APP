class Item {
  final int? id;
  final int idLista;

  final int? idProduto;

  /// Snapshot (estado congelado do produto no momento da adição)
  final String nomeProdutoSnapshot;
  final double precoProdutoSnapshot;
  final String? descricaoProdutoSnapshot;

  final String nomeCategoriaSnapshot;
  final String? codigoCategoriaSnapshot;

  final int quantidade;
  bool comprado;

  final int? idCategoria;

  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Item({
    this.id,
    required this.idLista,
    this.idProduto,
    required this.nomeProdutoSnapshot,
    required this.precoProdutoSnapshot,
    this.descricaoProdutoSnapshot, // 🔥 NOVO

    required this.nomeCategoriaSnapshot,
    this.codigoCategoriaSnapshot,
    required this.quantidade,
    this.comprado = false,
    this.idCategoria,
    this.criadoEm,
    this.atualizadoEm,
  });

  // ================= FROM JSON =================
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      idLista: json['idLista'] ?? -1,
      idProduto: json['idProduto'],

      nomeProdutoSnapshot: json['nomeProdutoSnapshot'] ?? 'Sem nome',
      precoProdutoSnapshot:
          (json['precoProdutoSnapshot'] as num?)?.toDouble() ?? 0.0,

      descricaoProdutoSnapshot: json['descricaoProdutoSnapshot'], // 🔥 NOVO

      nomeCategoriaSnapshot: json['nomeCategoriaSnapshot'] ?? 'Sem categoria',
      codigoCategoriaSnapshot: json['codigoCategoriaSnapshot'],

      quantidade: json['quantidade'] ?? 1,
      comprado: json['comprado'] ?? false,

      idCategoria: json['idCategoria'],

      criadoEm:
          json['criadoEm'] != null ? DateTime.tryParse(json['criadoEm']) : null,

      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.tryParse(json['atualizadoEm'])
          : null,
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      'idLista': idLista,
      'idProduto':
          idProduto, // 🔥 Verifique se não está 'id_produto' ou 'produtoId'
      'nomeProdutoSnapshot': nomeProdutoSnapshot,
      'precoProdutoSnapshot': precoProdutoSnapshot,
      'descricaoProdutoSnapshot': descricaoProdutoSnapshot,
      'nomeCategoriaSnapshot': nomeCategoriaSnapshot,
      'codigoCategoriaSnapshot': codigoCategoriaSnapshot,
      'quantidade': quantidade,
      'comprado': comprado,
      'idCategoria': idCategoria,
    };
  }

  // ================= COPY WITH =================
  Item copyWith({
    int? id,
    int? idLista,
    int? idProduto,
    String? nomeProdutoSnapshot,
    double? precoProdutoSnapshot,
    String? descricaoProdutoSnapshot, // 🔥 NOVO
    String? nomeCategoriaSnapshot,
    String? codigoCategoriaSnapshot,
    int? quantidade,
    bool? comprado,
    int? idCategoria,
    DateTime? criadoEm,
    DateTime? atualizadoEm,
  }) {
    return Item(
      id: id ?? this.id,
      idLista: idLista ?? this.idLista,
      idProduto: idProduto ?? this.idProduto,
      nomeProdutoSnapshot: nomeProdutoSnapshot ?? this.nomeProdutoSnapshot,
      precoProdutoSnapshot: precoProdutoSnapshot ?? this.precoProdutoSnapshot,
      descricaoProdutoSnapshot:
          descricaoProdutoSnapshot ?? this.descricaoProdutoSnapshot,
      nomeCategoriaSnapshot:
          nomeCategoriaSnapshot ?? this.nomeCategoriaSnapshot,
      codigoCategoriaSnapshot:
          codigoCategoriaSnapshot ?? this.codigoCategoriaSnapshot,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
      idCategoria: idCategoria ?? this.idCategoria,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  double get valorTotal => precoProdutoSnapshot * quantidade;
}
