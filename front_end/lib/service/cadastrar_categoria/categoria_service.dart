import 'package:crud_flutter/core/helpers/service_utils.dart';

import '../../model/cadastrar_categoria/categoria.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';

class CategoriaService {
  final ApiClient _client = ApiClient();

  // =====================================================
  // 📥 LISTAR
  // =====================================================
  Future<List<Categoria>> buscarCategorias() async {
    final url = ApiEndpoints.categorias;

    final res = await _client.get<List<Categoria>>(
      url,
      (data) => (data as List).map((e) => Categoria.fromJson(e)).toList(),
    );

    return ServiceUtils.extractList<Categoria>(res);
  }

  // =====================================================
  // ➕ CRIAR
  // =====================================================
  Future<Categoria> criarCategoria(String nome) async {
    final url = ApiEndpoints.categorias;

    final res = await _client.post<Categoria>(
      url,
      {"nome": nome},
      (data) => Categoria.fromJson(data),
    );

    return ServiceUtils.extract<Categoria>(res);
  }

  // =====================================================
  // ✏️ ATUALIZAR
  // =====================================================
  Future<Categoria> atualizarCategoria(int id, String nome) async {
    final url = "${ApiEndpoints.categorias}/$id";

    final res = await _client.put<Categoria>(
      url,
      {"nome": nome},
      (data) => Categoria.fromJson(data),
    );

    return ServiceUtils.extract<Categoria>(res);
  }

  // =====================================================
  // 🗑 DELETAR
  // =====================================================
  Future<void> deletarCategoria(int id) async {
    final url = "${ApiEndpoints.categorias}/$id";

    final res = await _client.delete<void>(url);

    ServiceUtils.validate(res);
  }
}
