class Categoria {
  final int? id;
  final String nome;

  Categoria({this.id, required this.nome});

  // DESSERIALIZAÇÃO (JSON → OBJETO)
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int?,
      nome: json['nome'] as String? ?? 'Sem nome',
    );
  }

  // SERIALIZAÇÃO (OBJETO → JSON)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
    };
  }

  @override
  String toString() => 'Categoria{id: $id, nome: $nome}';
}
