class ItemUpdateDTO {
  final String? nomeProdutoSnapshot;
  final double? precoProdutoSnapshot;
  final int? quantidade;
  final int? idCategoria;

  ItemUpdateDTO({
    this.nomeProdutoSnapshot,
    this.precoProdutoSnapshot,
    this.quantidade,
    this.idCategoria,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nomeProdutoSnapshot != null)
        "nomeProdutoSnapshot": nomeProdutoSnapshot,
      if (precoProdutoSnapshot != null)
        "precoProdutoSnapshot": precoProdutoSnapshot,
      if (quantidade != null) "quantidade": quantidade,
      if (idCategoria != null) "idCategoria": idCategoria,
    };
  }
}
