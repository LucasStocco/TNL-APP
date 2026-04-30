class ItemCreateDTO {
  final int produtoId;
  final int quantidade;
  final double preco;

  ItemCreateDTO({
    required this.produtoId,
    required this.quantidade,
    required this.preco,
  });

  Map<String, dynamic> toJson() => {
    "produtoId": produtoId,
    "quantidade": quantidade,
    "preco": preco,
  };
}
/*
endpoint: POST /listas/{id}/itens
 */
