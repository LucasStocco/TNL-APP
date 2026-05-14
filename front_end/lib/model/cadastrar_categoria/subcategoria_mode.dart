import 'package:crud_flutter/model/cadastrar_produto/produto.dart';

class SubcategoriaModel {
  final int id;
  final String nome;
  final List<Produto> produtos;

  SubcategoriaModel({
    required this.id,
    required this.nome,
    required this.produtos,
  });

  factory SubcategoriaModel.fromJson(Map<String, dynamic> json) {
    final rawProdutos = json['produtos'];

    List<Produto> parsedProdutos = [];

    if (rawProdutos is List) {
      parsedProdutos = rawProdutos
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) {
            try {
              return Produto.fromJson(e as Map<String, dynamic>);
            } catch (err) {
              // evita crash silenciosamente e mantém app vivo
              print("[SubcategoriaModel] erro ao parsear produto: $err");
              return null;
            }
          })
          .whereType<Produto>()
          .toList();
    }

    return SubcategoriaModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      nome: json['nome']?.toString() ?? '',
      produtos: parsedProdutos,
    );
  }

  // =========================
  // UI helpers
  // =========================

  bool get isEmpty => produtos.isEmpty;

  int get totalProdutos => produtos.length;
}
