import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../model/cadastrar_produto/produto.dart';
import '../../dto/produto_create_dto.dart';
import '../../dto/produto_update_dto.dart';

class ProdutoService {
  final ApiClient _client;

  ProdutoService(this._client);

  // =========================
  // LOGS
  // =========================
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
    const url = ApiEndpoints.produtos;

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
    final url = "/categorias/$idCategoria/produtos";

    _logReq("GET", url);

    final res = await _client.get<List<Produto>>(
      url,
      (data) {
        // 🔍 DEBUG FORTE
        if (data is! List) {
          print("❌ ERRO: data não é lista -> $data");
          return [];
        }

        print("✅ DATA É LISTA: ${data.length} itens");

        return data.map((e) {
          print("🔹 item bruto: $e");
          return Produto.fromJson(e);
        }).toList();
      },
    );

    _logRes(res);

    if (!res.success) {
      throw Exception(res.message);
    }

    // 🔥 AQUI O PRINT FINAL
    print("🚀 LISTA FINAL: ${res.data}");

    return res.data ?? [];
  }

  // =========================
  // CRIAR PRODUTO
  // =========================
  Future<Produto> criar(ProdutoCreateDTO dto) async {
    const url = ApiEndpoints.produtos;

    _logReq("POST", url, dto.toJson());

    final res = await _client.post<Produto>(
      url,
      dto.toJson(),
      (data) => Produto.fromJson(data),
    );

    _logRes(res);

    if (!res.success || res.data == null) {
      throw Exception(res.message);
    }

    return res.data!;
  }

  // =========================
  // ATUALIZAR PRODUTO
  // =========================
  Future<Produto> atualizar(int id, ProdutoUpdateDTO dto) async {
    final url = "${ApiEndpoints.produtos}/$id";

    _logReq("PUT", url, dto.toJson());

    final res = await _client.put<Produto>(
      url,
      dto.toJson(),
      (data) => Produto.fromJson(data),
    );

    _logRes(res);

    if (!res.success || res.data == null) {
      throw Exception(res.message);
    }

    return res.data!;
  }

  // =========================
  // DELETAR PRODUTO
  // =========================
  Future<void> deletar(int id) async {
    final url = "${ApiEndpoints.produtos}/$id";

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
