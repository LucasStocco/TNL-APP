class ListaRequestDTO {
  final String nome;

  ListaRequestDTO({
    required this.nome,
  });

  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
    };
  }
}