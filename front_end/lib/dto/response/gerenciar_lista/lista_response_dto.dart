class Lista {
  final int id;
  final String nome;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;
  final DateTime? concluidoEm;

  Lista({
    required this.id,
    required this.nome,
    this.criadoEm,
    this.atualizadoEm,
    this.concluidoEm,
  });

  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
      id: json['id'],
      nome: json['nome'],
      criadoEm:
          json['criadoEm'] != null ? DateTime.parse(json['criadoEm']) : null,
      atualizadoEm: json['atualizadoEm'] != null
          ? DateTime.parse(json['atualizadoEm'])
          : null,
      concluidoEm: json['concluidoEm'] != null
          ? DateTime.parse(json['concluidoEm'])
          : null,
    );
  }
}
