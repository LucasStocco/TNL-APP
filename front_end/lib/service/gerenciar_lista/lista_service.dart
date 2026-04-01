import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/gerenciar_lista/lista.dart';
import '../../config/api_config.dart';

class ListaService {
  static const String baseUrl = '${ApiConfig.baseUrl}/listas';

  // ---------------------- LISTAR ----------------------
  Future<List<Lista>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    print('URL: $baseUrl');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded.map((e) => Lista.fromJson(e)).toList();
      } else if (decoded is Map && decoded.containsKey('content')) {
        return (decoded['content'] as List)
            .map((e) => Lista.fromJson(e))
            .toList();
      } else {
        throw Exception('Formato inesperado da resposta');
      }
    } else {
      throw Exception('Erro ao listar listas: ${response.statusCode}');
    }
  }

  // ---------------------- CRIAR ----------------------
  Future<Lista> create(Lista lista) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(lista.toJson()),
    );

    if ([200, 201].contains(response.statusCode)) {
      return Lista.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar lista: ${response.statusCode}');
    }
  }

  // ---------------------- ATUALIZAR ----------------------
  Future<Lista> update(Lista lista) async {
    if (lista.id == null) {
      throw Exception('ID obrigatório para atualizar');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${lista.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(lista.toJson()),
    );

    if (response.statusCode == 200) {
      return Lista.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar lista: ${response.statusCode}');
    }
  }

  // ---------------------- DELETAR ----------------------
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (![200, 204].contains(response.statusCode)) {
      throw Exception('Erro ao deletar lista: ${response.statusCode}');
    }
  }

  // ---------------------- FINALIZAR ----------------------
  Future<void> finalizarLista(int listaId, DateTime dataConclusao) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$listaId/finalizar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dataConclusao': dataConclusao.toIso8601String(),
      }),
    );

    if (![200, 204].contains(response.statusCode)) {
      throw Exception('Erro ao finalizar lista: ${response.statusCode}');
    }
  }
}
