class CategoriaCreateDTO {
  final String nome;

  CategoriaCreateDTO({required this.nome});

  Map<String, dynamic> toJson() => {
    "nome": nome,
  };
}

/*
endpoint: POST /categorias
 */