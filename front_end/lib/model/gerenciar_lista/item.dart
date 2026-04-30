// ===== Representa o que o backend retorna ====
// Entidade item representa apenas a lista
class Item {
  final int id;
  final int quantidade;
  final bool comprado;

  final int idProduto;
  final String nomeProduto;

  final int idCategoria;
  final String nomeCategoria;

  final double preco;

  Item({
    required this.id,
    required this.quantidade,
    required this.comprado,
    required this.idProduto,
    required this.nomeProduto,
    required this.idCategoria,
    required this.nomeCategoria,
    required this.preco,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      quantidade: json['quantidade'],
      comprado: json['comprado'] ?? false,
      idProduto: json['produtoId'],
      nomeProduto: json['nomeProduto'] ?? '',
      idCategoria: json['categoriaId'],
      nomeCategoria: json['nomeCategoria'] ?? '',
      preco: (json['preco'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantidade": quantidade,
      "comprado": comprado,
      "produtoId": idProduto,
      "nomeProduto": nomeProduto,
      "categoriaId": idCategoria,
      "nomeCategoria": nomeCategoria,
      "preco": preco,
    };
  }

  Item copyWith({
    int? id,
    int? quantidade,
    bool? comprado,
    int? idProduto,
    String? nomeProduto,
    int? idCategoria,
    String? nomeCategoria,
    double? preco,
  }) {
    return Item(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
      idProduto: idProduto ?? this.idProduto,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      idCategoria: idCategoria ?? this.idCategoria,
      nomeCategoria: nomeCategoria ?? this.nomeCategoria,
      preco: preco ?? this.preco,
    );
  }
}
