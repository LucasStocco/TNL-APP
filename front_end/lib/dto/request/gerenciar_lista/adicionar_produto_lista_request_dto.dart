class AdicionarProdutoListaRequestDTO {
  final int produtoId;
  final double preco;
  final int quantidade;

  AdicionarProdutoListaRequestDTO({
    required this.produtoId,
    this.preco = 0.0,
    this.quantidade = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'preco': preco,
      'quantidade': quantidade,
    };
  }
}
