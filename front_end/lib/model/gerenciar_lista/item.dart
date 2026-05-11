import 'package:crud_flutter/model/cadastrar_produto/produto.dart';

class Item {
  final int id;
  final int quantidade;
  final bool comprado;
  final double preco;

  final Produto produto;

  Item({
    required this.id,
    required this.quantidade,
    required this.comprado,
    required this.preco,
    required this.produto,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      quantidade: json['quantidade'],
      comprado: json['comprado'] ?? false,
      preco: (json['preco'] ?? 0).toDouble(),
      produto: Produto.fromJson(json['produto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantidade": quantidade,
      "comprado": comprado,
      "preco": preco,
      "produto": produto.toJson(),
    };
  }

  // =========================
  // COPY WITH
  // =========================
  Item copyWith({
    int? id,
    int? quantidade,
    bool? comprado,
    double? preco,
    Produto? produto,
  }) {
    return Item(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
      comprado: comprado ?? this.comprado,
      preco: preco ?? this.preco,
      produto: produto ?? this.produto,
    );
  }
}
