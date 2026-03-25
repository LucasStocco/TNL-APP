import 'produto.dart';

class Item {
  final int? id;
  final int quantidade;
  final bool comprado;
  final Produto produto;

  Item({
    this.id,
    required this.quantidade,
    required this.comprado,
    required this.produto,
  });

  /// Construtor a partir de JSON (Response do backend)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int?,
      quantidade: json['quantidade'] as int? ?? 0,
      comprado: json['comprado'] as bool? ?? false,
      produto: json['produto'] != null
          ? Produto.fromJson(json['produto'])
          : throw Exception('Produto inválido no item'),
    );
  }

  /// Converte para JSON compatível com o backend (RequestDTO)
  Map<String, dynamic> toJson() {
    return {
      'quantidade': quantidade,
      'comprado': comprado,
      'produto': produto.toJson(), // objeto completo do produto
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          quantidade == other.quantidade &&
          comprado == other.comprado &&
          produto == other.produto;

  @override
  int get hashCode =>
      id.hashCode ^ quantidade.hashCode ^ comprado.hashCode ^ produto.hashCode;

  @override
  String toString() =>
      'Item{id: $id, quantidade: $quantidade, comprado: $comprado, produto: $produto}';

  /// Retorna uma nova instância com o status de comprado atualizado
  Item marcarComoComprado(bool status) {
    return Item(
      id: id,
      quantidade: quantidade,
      comprado: status,
      produto: produto,
    );
  }
}
