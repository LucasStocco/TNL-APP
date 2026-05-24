class ListaResumoResponseDTO {
  final int id;
  final String nome;
  final int totalItens;
  final int itensComprados;
  final double progresso;

  ListaResumoResponseDTO({
    required this.id,
    required this.nome,
    required this.totalItens,
    required this.itensComprados,
    required this.progresso,
  });

  factory ListaResumoResponseDTO.fromJson(Map<String, dynamic> json) {
    return ListaResumoResponseDTO(
      id: json['id'],
      nome: json['nome'],
      totalItens: json['totalItens'],
      itensComprados: json['itensComprados'],
      progresso: (json['progresso'] as num).toDouble(),
    );
  }
}
