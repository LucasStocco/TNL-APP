class Categoria {
  final int id;
  final String nome;
  final String codigo;
  final bool deletado;

  Categoria({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.deletado,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
      codigo: json['codigo'] ?? '',
      deletado: json['deletado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "codigo": codigo,
      "deletado": deletado,
    };
  }
}
/*
beck retorna: 
{
  "id": 1,
  "nome": "Alimentos"
} */
