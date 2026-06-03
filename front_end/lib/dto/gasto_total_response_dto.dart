class GastoTotalResponseDTO {
  final double total;

  GastoTotalResponseDTO({
    required this.total,
  });

  factory GastoTotalResponseDTO.fromJson(
    Map<String, dynamic> json,
  ) {
    return GastoTotalResponseDTO(
      total: (json['total'] as num).toDouble(),
    );
  }
}