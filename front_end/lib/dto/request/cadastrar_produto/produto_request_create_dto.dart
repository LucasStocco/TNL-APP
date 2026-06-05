class ProdutoCreateDTO {
  final String nome;
  final String? descricao;
  final int idCategoria;

  ProdutoCreateDTO({
    required this.nome,
    this.descricao,
    required this.idCategoria,
  });

  Map<String, dynamic> toJson() => {
        "nome": nome,
        if (descricao != null) "descricao": descricao,
        "idCategoria": idCategoria,
      };
}
