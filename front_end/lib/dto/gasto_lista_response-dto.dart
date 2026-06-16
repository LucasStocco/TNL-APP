class GastoPorListaResponseDTO {
  final String lista;
  final double total;

  GastoPorListaResponseDTO({
    required this.lista,
    required this.total,
  });

  factory GastoPorListaResponseDTO.fromJson(Map<String, dynamic> json) {
    return GastoPorListaResponseDTO(
      lista: json['lista'],
      total: (json['total'] as num).toDouble(),
    );
  }
}