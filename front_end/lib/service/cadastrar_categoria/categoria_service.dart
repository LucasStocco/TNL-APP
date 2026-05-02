import 'package:crud_flutter/core/helpers/service_utils.dart';

import '../../model/cadastrar_categoria/categoria.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../dto/categoria_create_dto.dart';
import '../../dto/categoria_update_dto.dart';

class CategoriaService {
  final ApiClient _client;

  CategoriaService(this._client);

  // =====================================================
  // 🧠 LOG HELPERS
  // =====================================================
  void _log(String msg) => print("[CATEGORIA_SERVICE] $msg");

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
  Future<List<Categoria>> buscarCategorias() async {
    const url = ApiEndpoints.categorias;

    _logReq("GET", url);

    final res = await _client.get<List<Categoria>>(
      url,
      (data) => (data as List).map((e) => Categoria.fromJson(e)).toList(),
    );

    _logRes(res);

    return ServiceUtils.extractList<Categoria>(res);
  }

  // =====================================================
  // ➕ CRIAR
  // =====================================================
  Future<Categoria> criarCategoria(CategoriaCreateDTO dto) async {
    const url = ApiEndpoints.categorias;

    _logReq("POST", url, dto.toJson());

    final res = await _client.post<Categoria>(
      url,
      dto.toJson(),
      (data) => Categoria.fromJson(data),
    );

    _logRes(res);

    return ServiceUtils.extract<Categoria>(res);
  }

  // =====================================================
  // ✏️ ATUALIZAR
  // =====================================================
  Future<Categoria> atualizarCategoria(
    int id,
    CategoriaUpdateDTO dto,
  ) async {
    final url = "${ApiEndpoints.categorias}/$id";

    _logReq("PUT", url, dto.toJson());

    final res = await _client.put<Categoria>(
      url,
      dto.toJson(),
      (data) => Categoria.fromJson(data),
    );

    _logRes(res);

    return ServiceUtils.extract<Categoria>(res);
  }

  // =====================================================
  // 🗑 DELETAR
  // =====================================================
  Future<void> deletarCategoria(int id) async {
    final url = "${ApiEndpoints.categorias}/$id";

    _log("🔥 DELETE CHAMADO REAL: $url");

    final res = await _client.delete(
      url,
      null,
    );

    _log("🔥 DELETE RESPONSE RAW: $res");

    // ⚠️ COMENTA ISSO TEMPORARIAMENTE
    // ServiceUtils.validate(res);
  }
}
