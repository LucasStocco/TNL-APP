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

  /// Construtor a partir de JSON (ResponseDTO do backend)
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] as int? ?? int.tryParse(json['id']?.toString() ?? ''),
      nome: json['nome'] ?? '',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'],
      // se o backend retornar apenas categoriaId, podemos criar Categoria com fallback
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'])
          : Categoria(id: json['categoriaId'] ?? 0, nome: 'Sem Categoria'),
    );
  }

  /// Converte para JSON compatível com ProdutoRequestDTO
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'preco': preco,
      if (descricao != null && descricao!.isNotEmpty) 'descricao': descricao,
      'categoriaId': categoria.id, // backend espera apenas o ID
    };
  }

  @override
  String toString() =>
      'Produto{id: $id, nome: $nome, preco: $preco, descricao: $descricao, categoria: $categoria}';
}
