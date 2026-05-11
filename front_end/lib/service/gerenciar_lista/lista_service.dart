import 'package:crud_flutter/core/helpers/service_utils.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class ListaService {
  final ApiClient _client;

  ListaService(this._client);

  void _log(String msg) => print("[LISTA_SERVICE] $msg");

  void _logReq(String method, String url, [dynamic body]) {
    _log("➡️ $method $url");
    if (body != null) _log("📦 BODY: $body");
  }

  void _logRes(dynamic res) {
    _log("⬅️ RESPONSE: $res");
  }

  void _logErr(String method, String url, Object e, StackTrace s) {
    _log("❌ ERROR $method $url");
    _log("MSG: $e");
    _log("STACK: $s");
  }

  // =========================
  // LISTAR
  // =========================
  Future<List<Lista>> getAll() async {
    const url = ApiEndpoints.listas;

    _logReq("GET", url);

    try {
      final res = await _client.get<List<Lista>>(
        url,
        (data) => (data as List).map((e) => Lista.fromJson(e)).toList(),
      );

      _logRes(res);

      return ServiceUtils.extractList<Lista>(res);
    } catch (e, s) {
      _logErr("GET", url, e, s);
      rethrow;
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Lista> create(String nome) async {
    const url = ApiEndpoints.listas;
    final body = {"nome": nome};

    _logReq("POST", url, body);

    try {
      final res = await _client.post<Lista>(
        url,
        body,
        (data) => Lista.fromJson(data),
      );

      _logRes(res);

      return ServiceUtils.extract<Lista>(res);
    } catch (e, s) {
      _logErr("POST", url, e, s);
      rethrow;
    }
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Lista> update(Lista lista) async {
    final url = ApiEndpoints.listaPorId(lista.id);

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
      _logErr("PUT", url, e, s);
      rethrow;
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<void> delete(int id) async {
    final url = ApiEndpoints.listaPorId(id);

    _logReq("DELETE", url);

    try {
      final res = await _client.delete<void>(url);

      _logRes(res);

      ServiceUtils.validate(res);
    } catch (e, s) {
      _logErr("DELETE", url, e, s);
      rethrow;
    }
  }

  // =========================
  // FINALIZAR (⚠️ NÃO EXISTE NO BACKEND)
  // =========================
  Future<void> finalizarLista(int listaId) async {
    throw Exception(
      "Endpoint /listas/$listaId/finalizar NÃO existe no backend ainda",
    );
  }
}
