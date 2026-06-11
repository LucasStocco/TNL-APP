import 'package:crud_flutter/core/api/api_response.dart';
import 'package:crud_flutter/model/cadastrar_categoria/cadastrar_categoria_completa_model.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../model/cadastrar_produto/produto.dart';
import '../../dto/request/cadastrar_produto/produto_request_create_dto.dart';
import '../../dto/request/cadastrar_produto/produto_request_update_dto.dart';

class ProdutoService {
  final ApiClient _client;

  ProdutoService(this._client);

  void _log(String msg) => print("[PRODUTO_SERVICE] $msg");

  void _logReq(String method, String url, [dynamic body]) {
    _log("➡️ $method $url");
    if (body != null) _log("📦 BODY: $body");
  }

  void _logRes(dynamic res) {
    _log("⬅️ RESPONSE: $res");
  }

  // =========================
  // LISTAR TODOS
  // =========================
  Future<List<Produto>> listar() async {
    final url = ApiEndpoints.produtos;

    _logReq("GET", url);

    final res = await _client.get<List<Produto>>(
      url,
      (data) => (data as List).map((e) => Produto.fromJson(e)).toList(),
    );

    _logRes(res);

    if (!res.success) {
      throw Exception(res.message);
    }

    return res.data ?? [];
  }

  // =========================
  // LISTAR POR CATEGORIA
  // =========================
  Future<List<Produto>> listarPorCategoria(int idCategoria) async {
    final url = ApiEndpoints.produtosPorCategoria(idCategoria);

    _logReq("GET", url);

    final res = await _client.get<List<Produto>>(
      url,
      (data) {
        if (data is! List) {
          print("❌ ERRO: esperado lista -> $data");
          return [];
        }

        return data.map((e) => Produto.fromJson(e)).toList();
      },
    );

    _logRes(res);

    if (!res.success) {
      throw Exception(res.message);
    }

    return res.data ?? [];
  }

  // =========================
  // CATEGORIA COMPLETA (SUBCATEGORIAS + PRODUTOS)
  // =========================
  Future<CategoriaCompletaModel> buscarCategoriaCompleta(int id) async {
    final url = ApiEndpoints.categoriaCompleta(id);

    _logReq("GET", url);

    final res = await _client.get<ApiResponse<CategoriaCompletaModel>>(
      url,
      (json) => ApiResponse.fromJson(
        json,
        (data) => CategoriaCompletaModel.fromJson(data),
      ),
    );

    _logRes(res);

    return res.data.data;
  }

  // =========================
  // CRIAR PRODUTO
  // =========================
  Future<Produto> criar(ProdutoCreateDTO dto) async {
    final url = ApiEndpoints.produtos;

    _logReq("POST", url, dto.toJson());

    final res = await _client.post<Produto>(
      url,
      dto.toJson(),
      (data) => Produto.fromJson(data),
    );

    _logRes(res);

    if (!res.success) {
      throw Exception(res.message);
    }

    return res.data;
  }

  // =========================
  // ATUALIZAR PRODUTO
  // =========================
  Future<Produto> atualizar(int id, ProdutoUpdateDTO dto) async {
    final url = ApiEndpoints.produtoPorId(id);

    _logReq("PUT", url, dto.toJson());

    final res = await _client.put<Produto>(
      url,
      dto.toJson(),
      (data) => Produto.fromJson(data),
    );

    _logRes(res);

    if (!res.success) {
      throw Exception(res.message);
    }

    return res.data;
  }

  // =========================
  // DELETAR PRODUTO
  // =========================
  Future<void> deletar(int id) async {
    final url = ApiEndpoints.produtoPorId(id);

    _logReq("DELETE", url);

    final res = await _client.delete<void>(
      url,
      null,
    );

    _logRes(res);

    if (!res.success) {
      throw Exception(res.message);
    }
  }
}
