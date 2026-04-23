// SERVE APENAS DE REQUEST
class ItemManualDTO {
  final String nomeProdutoSnapshot;
  final double precoProdutoSnapshot;
  final int idCategoria;
  final int quantidade;

  ItemManualDTO({
    required this.nomeProdutoSnapshot,
    required this.precoProdutoSnapshot,
    required this.idCategoria,
    required this.quantidade,
  });

  Map<String, dynamic> toJson() {
    return {
      "nomeProdutoSnapshot": nomeProdutoSnapshot,
      "precoProdutoSnapshot": precoProdutoSnapshot,
      "idCategoria": idCategoria,
      "quantidade": quantidade,
    };
  }

  @override
  String toString() {
    return 'ItemManualDTO(nome: $nomeProdutoSnapshot, preco: $precoProdutoSnapshot, categoria: $idCategoria, quantidade: $quantidade)';
  }
}
