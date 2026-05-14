import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/core/api/api_endpoints.dart';
import 'package:crud_flutter/core/api/api_response.dart';
import 'package:crud_flutter/dto/categoria_create_dto.dart';
import 'package:crud_flutter/dto/categoria_update_dto.dart';
import 'package:crud_flutter/model/cadastrar_categoria/cadastrar_categoria_completa_model.dart';
import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';

class CategoriaService {
  final ApiClient _client;

  CategoriaService(this._client);

  void _log(String msg) => print("[CATEGORIA_SERVICE] $msg");

  void _logReq(String method, String url, [dynamic body]) {
    _log("➡️ $method $url");
    if (body != null) _log("📦 BODY: $body");
  }

  void _logRes(dynamic res) {
    _log("⬅️ RESPONSE: $res");
  }

  // =========================
  // 📥 LISTAR CATEGORIAS
  // =========================
  Future<List<Categoria>> buscarCategorias() async {
    final url = ApiEndpoints.categorias;

    _logReq("GET", url);

    final res = await _client.get<List<Categoria>>(
      url,
      (data) {
        final list = data as List<dynamic>;
        return list.map((e) => Categoria.fromJson(e)).toList();
      },
    );

    _logRes(res);

    return res.data ?? [];
  }

  // =========================
  // ➕ CRIAR
  // =========================
  Future<Categoria> criarCategoria(CategoriaCreateDTO dto) async {
    final url = ApiEndpoints.categorias;

    _logReq("POST", url, dto.toJson());

    final res = await _client.post<Categoria>(
      url,
      dto.toJson(),
      (data) => Categoria.fromJson(data),
    );

    _logRes(res);

    return res.data!;
  }

  // =========================
  // ✏️ ATUALIZAR
  // =========================
  Future<Categoria> atualizarCategoria(
    int id,
    CategoriaUpdateDTO dto,
  ) async {
    final url = ApiEndpoints.categoriaPorId(id);

    _logReq("PUT", url, dto.toJson());

    final res = await _client.put<Categoria>(
      url,
      dto.toJson(),
      (data) => Categoria.fromJson(data),
    );

    _logRes(res);

    return res.data!;
  }

  // =========================
  // 🗑 DELETAR
  // =========================
  Future<void> deletarCategoria(int id) async {
    final url = ApiEndpoints.categoriaPorId(id);

    _logReq("DELETE", url);

    await _client.delete(url, null);

    _log("✔ Categoria deletada");
  }

  // =========================
  // 📦 SUBCATEGORIAS COM PRODUTOS (LISTA COMPLETA)
  // =========================
  Future<CategoriaCompletaModel> buscarCategoriaCompleta(int id) async {
    final url = ApiEndpoints.categoriaCompleta(id);

    _logReq("GET", url);

    final res = await _client.get<CategoriaCompletaModel>(
      url,
      (data) {
        if (data == null) {
          throw Exception("Backend retornou data null");
        }

        return CategoriaCompletaModel.fromJson(data);
      },
    );

    _logRes(res);

    if (res.data == null) {
      throw Exception("Categoria completa veio null");
    }

    return res.data!;
  }

  // =========================
  // 📦 SUBCATEGORIAS (LISTA SIMPLES)
  // =========================
  Future<List<dynamic>> buscarCategoriasComSubcategorias() async {
    final url = ApiEndpoints.categoriaCompleta(0); // ⚠️ opcional remover depois

    _logReq("GET", url);

    final res = await _client.get(url, (data) => data);

    _logRes(res);

    return res.data ?? [];
  }
}
