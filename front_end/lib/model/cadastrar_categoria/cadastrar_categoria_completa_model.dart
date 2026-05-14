import 'package:crud_flutter/model/cadastrar_categoria/subcategoria_mode.dart';

class CategoriaCompletaModel {
  final int id;
  final String nome;
  final List<SubcategoriaModel> subcategorias;

  CategoriaCompletaModel({
    required this.id,
    required this.nome,
    required this.subcategorias,
  });

  factory CategoriaCompletaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaCompletaModel(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      subcategorias: (json['subcategorias'] as List<dynamic>?)
              ?.map((e) => SubcategoriaModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
