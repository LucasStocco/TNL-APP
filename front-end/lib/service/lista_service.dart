import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../model/lista.dart';

class ListaService {
  static const String baseUrl = '${ApiConfig.baseUrl}/listas';

  /// CREATE
  Future<Lista> create(Lista lista) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(lista.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Lista.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Erro ao criar lista: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// READ - listar todas
  Future<List<Lista>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Lista.fromJson(e)).toList();
    } else {
      throw Exception(
        'Erro ao buscar listas: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// UPDATE
  Future<Lista> update(Lista lista) async {
    if (lista.id == null) {
      throw Exception('ID da lista é obrigatório para atualizar.');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${lista.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(lista.toJson()),
    );

    if (response.statusCode == 200) {
      return Lista.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Erro ao atualizar lista: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// DELETE
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Erro ao deletar lista: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// FINALIZAR LISTA
  Future<void> finalizarLista(int listaId, DateTime dataConclusao) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$listaId/concluir'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dataConclusao': dataConclusao.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao finalizar lista: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
