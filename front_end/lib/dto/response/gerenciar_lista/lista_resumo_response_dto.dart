class ListaResumo {
  final int id;
  final String nome;
  final int totalItens;
  final int itensComprados;
  final double progresso;

  ListaResumo({
    required this.id,
    required this.nome,
    required this.totalItens,
    required this.itensComprados,
    required this.progresso,
  });

  factory ListaResumo.fromJson(Map<String, dynamic> json) {
    return ListaResumo(
      id: json['id'],
      nome: json['nome'],
      totalItens: json['totalItens'],
      itensComprados: json['itensComprados'],
      progresso: (json['progresso'] as num).toDouble(),
    );
  }
}
