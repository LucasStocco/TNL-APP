class Categoria {
  final int id;
  final String nome;
  final String? codigo;
  final bool deletado;

  Categoria({
    required this.id,
    required this.nome,
    this.codigo,
    this.deletado = false,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      codigo: json['codigo']?.toString(),
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
