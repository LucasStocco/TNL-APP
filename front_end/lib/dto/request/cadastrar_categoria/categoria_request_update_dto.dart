class CategoriaUpdateDTO {
  final String nome;

  CategoriaUpdateDTO({required this.nome});

  Map<String, dynamic> toJson() => {
    "nome": nome,
  };
}

/*
endpoint: PUT /categorias/{id}
 */