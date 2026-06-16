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

  /// =========================
  /// FROM JSON
  /// =========================
  /// Converte JSON da API
  /// em objeto Dart.
  factory ListaResumoResponseDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return ListaResumoResponseDTO(
      id: json['id'],
      nome: json['nome'],
      totalItens: json['totalItens'],
      itensComprados: json['itensComprados'],
      progresso: (json['progresso'] as num).toDouble(),
    );
  }

  /// =========================
  /// TO JSON
  /// =========================
  /// Converte objeto Dart
  /// em JSON serializável.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'totalItens': totalItens,
      'itensComprados': itensComprados,
      'progresso': progresso,
    };
  }
}
