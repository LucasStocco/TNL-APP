import 'package:crud_flutter/core/helpers/service_utils.dart';

import '../../model/cadastrar_produto/produto.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class ProdutoService {
  final ApiClient _client = ApiClient();

  // =====================================================
  // 📥 LISTAR TODOS
  // =====================================================
  Future<List<Produto>> listar() async {
    final url = ApiEndpoints.produtos;

    final res = await _client.get<List<Produto>>(
      url,
      (data) => (data as List).map((e) => Produto.fromJson(e)).toList(),
    );

    return ServiceUtils.extractList<Produto>(res);
  }

  // =====================================================
  // 📥 LISTAR POR CATEGORIA 🔥 (CORRIGIDO)
  // =====================================================
  Future<List<Produto>> listarPorCategoria(int idCategoria) async {
    final url = "${ApiEndpoints.produtos}/categoria/$idCategoria";

    final res = await _client.get<List<Produto>>(
      url,
      (data) => (data as List).map((e) => Produto.fromJson(e)).toList(),
    );

    return ServiceUtils.extractList<Produto>(res);
  }

  // =====================================================
  // ➕ CRIAR PRODUTO
  // =====================================================
  Future<Produto> criar(Produto produto) async {
    final url = ApiEndpoints.produtos;

    final res = await _client.post<Produto>(
      url,
      {
        "nome": produto.nome,
        "descricao": produto.descricao,
        "preco": produto.preco,
        "idCategoria": produto.idCategoria ?? produto.categoria?.id,
      },
      (data) => Produto.fromJson(data),
    );

    return ServiceUtils.extract<Produto>(res);
  }

  // =====================================================
  // ✏️ ATUALIZAR PRODUTO
  // =====================================================
  Future<Produto> atualizar(Produto produto) async {
    if (produto.id == null) {
      throw Exception("Produto sem ID");
    }

    final url = "${ApiEndpoints.produtos}/${produto.id}";

    final res = await _client.put<Produto>(
      url,
      {
        "nome": produto.nome,
        "descricao": produto.descricao,
        "preco": produto.preco,
        "idCategoria": produto.idCategoria ?? produto.categoria?.id,
      },
      (data) => Produto.fromJson(data),
    );

    return ServiceUtils.extract<Produto>(res);
  }

  // =====================================================
  // 🗑 DELETAR
  // =====================================================
  Future<void> deletar(int id) async {
    final url = "${ApiEndpoints.produtos}/$id";

    final res = await _client.delete<void>(url);

    ServiceUtils.validate(res);
  }
}
