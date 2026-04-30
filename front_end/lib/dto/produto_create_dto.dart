class ProdutoCreateDTO {
  final String nome;
  final double preco;
  final String? descricao;
  final int idCategoria;

  ProdutoCreateDTO({
    required this.nome,
    required this.preco,
    this.descricao,
    required this.idCategoria,
  });

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "preco": preco,
        "descricao": descricao,
        "idCategoria": idCategoria, // ✅ CORRIGIDO
      };
}

/*
endpoint: POST /produtos
 */
