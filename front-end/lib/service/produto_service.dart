import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/produto.dart';
import '../config/api_config.dart';

class ProdutoService {
  static const String baseUrl = '${ApiConfig.baseUrl}/produtos';

  /// LISTAR TODOS OS PRODUTOS
  Future<List<Produto>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Produto.fromJson(e)).toList();
    } else {
      throw Exception(
          'Erro ao carregar produtos: ${response.statusCode} - ${response.body}');
    }
  }

  /// BUSCAR PRODUTO POR ID
  Future<Produto> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Erro ao buscar produto: ${response.statusCode} - ${response.body}');
    }
  }

  /// CRIAR PRODUTO
  Future<Produto> create(Produto produto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Produto.fromJson(jsonDecode(response.body)); // Produto com ID
    } else {
      throw Exception(
          'Erro ao criar produto: ${response.statusCode} - ${response.body}');
    }
  }

  /// ATUALIZAR PRODUTO
  Future<Produto> update(Produto produto) async {
    if (produto.id == null) {
      throw Exception('ID do produto é obrigatório para atualizar.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Erro ao atualizar produto: ${response.statusCode} - ${response.body}');
    }
  }

  /// DELETAR PRODUTO
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
          'Erro ao deletar produto: ${response.statusCode} - ${response.body}');
    }
  }
}
