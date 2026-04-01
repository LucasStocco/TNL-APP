import 'categoria.dart';

class Produto {
  final int? id;
  final String nome;
  final double preco;
  final String? descricao;
  final Categoria categoria;

  Produto({
    this.id,
    required this.nome,
    required this.preco,
    this.descricao,
    required this.categoria,
  });

  // DESSERIALIZAÇÃO
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as int?,
      nome: json['nome'] as String? ?? 'Produto Inválido',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'] as String?,

      // IMPORTANTE: Backend manda OBJETO categoria → então chamamos fromJson
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'])
          : Categoria(id: 0, nome: 'Sem Categoria'),
    );
  }

  // SERIALIZAÇÃO
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'preco': preco,
      'descricao': descricao ?? '',

      // IMPORTANTE: Backend espera apenas o ID da categoria
      'categoriaId': categoria.id,
    };
  }

  @override
  String toString() =>
      'Produto{id: $id, nome: $nome, preco: $preco, descricao: $descricao, categoria: $categoria}';
}
