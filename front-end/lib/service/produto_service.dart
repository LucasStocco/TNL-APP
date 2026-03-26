import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/produto.dart';
import '../config/api_config.dart';

class ProdutoService {
  static const String baseUrl = '${ApiConfig.baseUrl}/produtos';

  // ---------------------- LISTAR ----------------------
  Future<List<Produto>> listar() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => Produto.fromJson(e)).toList();
      } else if (decoded is Map && decoded.containsKey('content')) {
        return (decoded['content'] as List)
            .map((e) => Produto.fromJson(e))
            .toList();
      } else {
        throw Exception('Formato inesperado da resposta');
      }
    } else {
      throw Exception('Erro ao listar produtos: ${response.statusCode}');
    }
  }

  // ---------------------- CRIAR ----------------------
  Future<Produto> criar(Produto produto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if ([200, 201].contains(response.statusCode)) {
      return Produto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar produto: ${response.statusCode}');
    }
  }

  // ---------------------- ATUALIZAR ----------------------
  Future<Produto> atualizar(Produto produto) async {
    if (produto.id == null) {
      throw Exception('ID obrigatório para atualizar produto');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar produto: ${response.statusCode}');
    }
  }

  // ---------------------- DELETAR ----------------------
  Future<void> deletar(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (![200, 204].contains(response.statusCode)) {
      throw Exception('Erro ao deletar produto: ${response.statusCode}');
    }
  }
}
