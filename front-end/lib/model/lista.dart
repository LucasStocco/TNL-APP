class Lista {
  final int? id;
  final String nome;
  final DateTime? dataConclusao;

  Lista({
    this.id,
    required this.nome,
    this.dataConclusao,
  });

  /// Construtor a partir de JSON (backend -> Dart)
  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
      id: json['id'] as int?,
      nome: json['nome'] as String? ?? 'Sem Nome',
      dataConclusao: json['dataConclusao'] != null
          ? DateTime.tryParse(json['dataConclusao'] as String)
          : null,
    );
  }

  /// Converte para JSON (Dart -> backend)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      if (dataConclusao != null)
        'dataConclusao': dataConclusao!.toIso8601String(),
    };
  }

  /// Comparação de objetos
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lista &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nome == other.nome &&
          dataConclusao == other.dataConclusao;

  @override
  int get hashCode =>
      id.hashCode ^ nome.hashCode ^ (dataConclusao?.hashCode ?? 0);

  /// Para debugging
  @override
  String toString() =>
      'Lista{id: $id, nome: $nome, dataConclusao: $dataConclusao}';

  /// Retorna uma nova instância com dataConclusao atualizada
  Lista concluir() {
    return Lista(
      id: id,
      nome: nome,
      dataConclusao: DateTime.now(),
    );
  }
}
