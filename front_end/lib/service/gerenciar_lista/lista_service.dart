import 'package:crud_flutter/core/helpers/service_utils.dart';

import '../../model/gerenciar_lista/lista.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class ListaService {
  final ApiClient _client = ApiClient();

  // =====================================================
  // 🧠 LOG HELPERS
  // =====================================================
  void _log(String msg) => print("[LISTA_SERVICE] $msg");
  void _logReq(String method, String url, [dynamic body]) {
    _log("➡️ $method $url");
    if (body != null) _log("📦 BODY: $body");
  }

  void _logRes(dynamic res) {
    _log("⬅️ RESPONSE: $res");
  }

  // =====================================================
  // 📥 LISTAR
  // =====================================================
  Future<List<Lista>> getAll() async {
    const url = ApiEndpoints.listas;

    _logReq("GET", url);

    final res = await _client.get<List<Lista>>(
      url,
      (data) => (data as List).map((e) => Lista.fromJson(e)).toList(),
    );

    _logRes(res);

    return ServiceUtils.extractList<Lista>(res);
  }

  // =====================================================
  // ➕ CRIAR
  // =====================================================
  Future<Lista> create(String nome) async {
    const url = ApiEndpoints.listas;

    final body = {"nome": nome};

    _logReq("POST", url, body);

    final res = await _client.post<Lista>(
      url,
      body,
      (data) => Lista.fromJson(data),
    );

    _logRes(res);

    return ServiceUtils.extract<Lista>(res);
  }

  // =====================================================
  // ✏️ ATUALIZAR
  // =====================================================
  Future<Lista> update(Lista lista) async {
    if (lista.id == null) {
      throw Exception("Lista sem ID");
    }

    final url = "${ApiEndpoints.listas}/${lista.id}";
    final body = {"nome": lista.nome};

    _logReq("PUT", url, body);

    try {
      final res = await _client.put<Lista>(
        url,
        body,
        (data) => Lista.fromJson(data),
      );

      _logRes(res);

      return ServiceUtils.extract<Lista>(res);
    } catch (e, s) {
      _log("❌ ERRO NO UPDATE");
      _log("MSG: $e");
      _log("STACK: $s");
      rethrow;
    }
  }

  // =====================================================
  // ✅ FINALIZAR
  // =====================================================
  Future<void> finalizarLista(int listaId) async {
    final url = "${ApiEndpoints.listas}/$listaId/finalizar";

    _logReq("POST", url);

    final res = await _client.post<void>(
      url,
      {},
      null,
    );

    _logRes(res);

    ServiceUtils.validate(res);
  }

  // =====================================================
  // 🗑 DELETAR
  // =====================================================
  Future<void> delete(int id) async {
    final url = "${ApiEndpoints.listas}/$id";

    _logReq("DELETE", url);

    final res = await _client.delete<void>(url);

    _logRes(res);

    ServiceUtils.validate(res);
  }
}
