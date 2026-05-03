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

  // =====================================================
  // ✅ REGRA DE NEGÓCIO: categoria editável pelo usuário
  // =====================================================
  bool get isUsuario {
    const categoriasPadrao = [
      'BEBIDAS',
      'CARNES',
      'PADARIA',
      'HORTIFRUTI',
      'LATICINIOS',
      'MERCEARIA',
      'HIGIENE',
      'LIMPEZA',
      'PETS',
      'DOCES',
      'UTILIDADES',
      'BEBES',
      'SAZONAIS',
    ];

    return !categoriasPadrao.contains(codigo.toUpperCase());
  }
}
/*
beck retorna: 
{
  "id": 1,
  "nome": "Alimentos"
} */
