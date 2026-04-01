import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/criar_produto/item.dart';
import '../../config/api_config.dart';

class ItemService {
  static const String baseUrl = ApiConfig.baseUrl;

  Future<List<Item>> listar(int listaId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/listas/$listaId/itens'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao listar itens: ${response.statusCode}');
    }
  }

  Future<Item> criar(int listaId, Item item) async {
    final url = Uri.parse('$baseUrl/listas/$listaId/itens');
    final body = jsonEncode(item.toJson());

    print('======================');
    print('CRIANDO ITEM');
    print('URL: $url');
    print('BODY: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');
    print('======================');

    if ([200, 201].contains(response.statusCode)) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar item: ${response.statusCode}');
    }
  }

  Future<Item> atualizar(int listaId, Item item) async {
    if (item.id == null) throw Exception('ID obrigatório para atualizar item');
    final response = await http.put(
      Uri.parse('$baseUrl/listas/$listaId/itens/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar item: ${response.statusCode}');
    }
  }

  Future<void> deletar(int listaId, int itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/listas/$listaId/itens/$itemId'),
    );
    if (![200, 204].contains(response.statusCode)) {
      throw Exception('Erro ao deletar item: ${response.statusCode}');
    }
  }
}
