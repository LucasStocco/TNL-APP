class Categoria {
  final int id;
  final String nome;

  Categoria({required this.id, required this.nome});

  factory Categoria.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // fallback caso venha null do backend
      return Categoria(id: 0, nome: 'Sem Categoria');
    }
    return Categoria(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? 'Sem Nome',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
