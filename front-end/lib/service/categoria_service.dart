import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/categoria.dart';
import '../config/api_config.dart';

class CategoriaService {
  /// Buscar todas categorias
  Future<List<Categoria>> buscarCategorias() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categorias');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((jsonItem) =>
              Categoria.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Erro ao buscar categorias: ${response.statusCode} - ${response.body}');
    }
  }

  /// Buscar categoria por ID
  Future<Categoria> buscarPorId(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categorias/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Erro ao buscar categoria: ${response.statusCode} - ${response.body}');
    }
  }

  /// Criar nova categoria
  Future<Categoria> criarCategoria(Categoria categoria) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categorias');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 201) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Erro ao criar categoria: ${response.statusCode} - ${response.body}');
    }
  }

  /// Atualizar categoria
  Future<Categoria> atualizarCategoria(Categoria categoria) async {
    if (categoria.id == null) {
      throw Exception('ID da categoria é obrigatório para atualizar');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/categorias/${categoria.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 200) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Erro ao atualizar categoria: ${response.statusCode} - ${response.body}');
    }
  }

  /// Deletar categoria
  Future<void> deletarCategoria(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/categorias/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception(
          'Erro ao deletar categoria: ${response.statusCode} - ${response.body}');
    }
  }
}
