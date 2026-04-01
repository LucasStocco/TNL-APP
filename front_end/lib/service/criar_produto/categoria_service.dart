import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/criar_produto/categoria.dart';
import '../../config/api_config.dart';

class CategoriaService {
  static const String baseUrl = '${ApiConfig.baseUrl}/categorias';

  /// Listar todas categorias
  Future<List<Categoria>> buscarCategorias() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
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
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Categoria.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Erro ao buscar categoria: ${response.statusCode} - ${response.body}');
    }
  }

  /// Criar categoria
  Future<Categoria> criarCategoria(Categoria categoria) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(categoria.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Categoria.fromJson(jsonDecode(response.body));
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

    final response = await http.put(
      Uri.parse('$baseUrl/${categoria.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(categoria.toJson()),
    );

    if (response.statusCode == 200) {
      return Categoria.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Erro ao atualizar categoria: ${response.statusCode} - ${response.body}');
    }
  }

  /// Deletar categoria
  Future<void> deletarCategoria(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception(
          'Erro ao deletar categoria: ${response.statusCode} - ${response.body}');
    }
  }
}
