import 'produto.dart';

class Item {
  final int? id;
  final int quantidade;
  final bool comprado;
  final Produto produto;

  Item({
    this.id,
    required this.quantidade,
    this.comprado = false,
    required this.produto,
  });

  // DESSERIALIZAÇÃO (CRÍTICA)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int?,
      quantidade: json['quantidade'] as int? ?? 0,
      comprado: json['comprado'] as bool? ?? false,

      // ESSENCIAL: Backend manda produto COMPLETO → precisa converter corretamente
      produto: Produto.fromJson(json['produto'] as Map<String, dynamic>),
    );
  }

  // SERIALIZAÇÃO
  Map<String, dynamic> toJson() {
    if (produto.id == null) {
      throw Exception("Produto precisa ter ID antes de criar um Item");
    }

    return {
      'quantidade': quantidade,
      'comprado': comprado,

      // MPORTANTE: Backend espera apenas o ID do produto
      'produtoId': produto.id,
    };
  }

  Item copyWith({
    int? id,
    int? quantidade,
    bool? comprado,
    Produto? produto,
  }) {
    return Item(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
      produto: produto ?? this.produto,
    );
  }

  @override
  String toString() =>
      'Item{id: $id, quantidade: $quantidade, comprado: $comprado, produto: $produto}';
}
