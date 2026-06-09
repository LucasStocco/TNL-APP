class GastoPorCategoriaResponseDTO {
  final String categoria;
  final double total;

  GastoPorCategoriaResponseDTO({
    required this.categoria,
    required this.total,
  });

  factory GastoPorCategoriaResponseDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return GastoPorCategoriaResponseDTO(
      categoria: json['categoria'],
      total: (json['total'] as num).toDouble(),
    );
  }
}