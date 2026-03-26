import 'item.dart';

class Lista {
  final int? id;
  final String nome;
  final List<Item> itens;
  final DateTime? dataConclusao;

  Lista({
    this.id,
    required this.nome,
    this.itens = const [],
    this.dataConclusao,
  });

  // DESSERIALIZAÇÃO
  factory Lista.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Lista(
        id: 0,
        nome: 'Lista Inválida',
        itens: [],
        dataConclusao: null,
      );
    }

    return Lista(
      id: json['id'] as int? ?? 0,
      nome: json['nome'] as String? ?? 'Lista Inválida',

      // IMPORTANTE: Lista de itens → precisa mapear cada um
      itens: (json['itens'] as List<dynamic>?)
              ?.map((i) => Item.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],

      dataConclusao: json['dataConclusao'] != null
          ? DateTime.parse(json['dataConclusao'])
          : null,
    );
  }

  // SERIALIZAÇÃO
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,

      // Converte lista de objetos → lista de JSON
      'itens': itens.map((i) => i.toJson()).toList(),

      if (dataConclusao != null)
        'dataConclusao': dataConclusao!.toIso8601String(),
    };
  }

  Lista concluir() {
    return Lista(
      id: id,
      nome: nome,
      itens: itens,
      dataConclusao: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'Lista{id: $id, nome: $nome, itens: $itens, dataConclusao: $dataConclusao}';
}
