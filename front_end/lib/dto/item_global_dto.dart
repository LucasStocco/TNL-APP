class ItemGlobalDTO {
  final int idProduto;
  final int idCategoria;
  final int quantidade;

  ItemGlobalDTO({
    required this.idProduto,
    required this.idCategoria,
    required this.quantidade,
  });

  Map<String, dynamic> toJson() => {
        "idProduto": idProduto,
        "idCategoria": idCategoria,
        "quantidade": quantidade,
      };

  @override
  String toString() {
    return 'ItemGlobalDTO(idProduto: $idProduto, idCategoria: $idCategoria, quantidade: $quantidade)';
  }
}
