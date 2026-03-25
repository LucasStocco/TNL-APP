import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/item.dart';
import '../config/api_config.dart';

class ItemService {
  static const String baseUrl = ApiConfig.baseUrl;

  /// ---------------------- LISTAR ----------------------
  Future<List<Item>> listar(int listaId) async {
    final url = Uri.parse('$baseUrl/listas/$listaId/itens');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception(
        'Erro ao listar itens: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// ---------------------- CRIAR ----------------------
  Future<Item> criar(int listaId, Item item) async {
    if (item.produto.id == null) {
      throw Exception(
        'Produto não possui ID. Salve o produto antes de criar o item.',
      );
    }

    final url = Uri.parse('$baseUrl/listas/$listaId/itens');

    final body = jsonEncode({
      'quantidade': item.quantidade,
      'comprado': item.comprado,
      'produtoId': item.produto.id,
      'listaId': listaId,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Item.fromJson(data);
    } else {
      throw Exception(
        'Erro ao criar item: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// ---------------------- ATUALIZAR ----------------------
  Future<Item> atualizar(int listaId, Item item) async {
    if (item.id == null) {
      throw Exception('Item precisa ter ID para ser atualizado.');
    }
    if (item.produto.id == null) {
      throw Exception('Produto do item não possui ID.');
    }

    final url = Uri.parse('$baseUrl/listas/$listaId/itens/${item.id}');

    final body = jsonEncode({
      'quantidade': item.quantidade,
      'comprado': item.comprado,
      'produtoId': item.produto.id,
      'listaId': listaId,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Item.fromJson(data);
    } else {
      throw Exception(
        'Erro ao atualizar item: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// ---------------------- DELETAR ----------------------
  Future<void> deletar(int listaId, int itemId) async {
    final url = Uri.parse('$baseUrl/listas/$listaId/itens/$itemId');

    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception(
        'Erro ao deletar item: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
