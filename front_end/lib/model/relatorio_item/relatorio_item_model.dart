class ItemMaisComprado {
  final String nomeProduto;
  final int totalQuantidade;
  final int frequencia;

  ItemMaisComprado({
    required this.nomeProduto,
    required this.totalQuantidade,
    required this.frequencia,
  });

  factory ItemMaisComprado.fromJson(Map<String, dynamic> json) {
    return ItemMaisComprado(
      nomeProduto: json['nomeProduto'] ?? '',
      totalQuantidade: (json['totalQuantidade'] ?? 0).toInt(),
      frequencia: (json['frequencia'] ?? 0).toInt(),
    );
  }
}

class ItemPorCategoria {
  final String nomeCategoria;
  final int totalItens;
  final int totalQuantidade;
  final double totalGasto;

  ItemPorCategoria({
    required this.nomeCategoria,
    required this.totalItens,
    required this.totalQuantidade,
    required this.totalGasto,
  });

  factory ItemPorCategoria.fromJson(Map<String, dynamic> json) {
    return ItemPorCategoria(
      nomeCategoria: json['nomeCategoria'] ?? '',
      totalItens: (json['totalItens'] ?? 0).toInt(),
      totalQuantidade: (json['totalQuantidade'] ?? 0).toInt(),
      totalGasto: (json['totalGasto'] ?? 0.0).toDouble(),
    );
  }
}

class ItemRankingPreco {
  final String nomeProduto;
  final String nomeCategoria;
  final double preco;

  ItemRankingPreco({
    required this.nomeProduto,
    required this.nomeCategoria,
    required this.preco,
  });

  factory ItemRankingPreco.fromJson(Map<String, dynamic> json) {
    return ItemRankingPreco(
      nomeProduto: json['nomeProduto'] ?? '',
      nomeCategoria: json['nomeCategoria'] ?? '',
      preco: (json['preco'] ?? 0.0).toDouble(),
    );
  }
}