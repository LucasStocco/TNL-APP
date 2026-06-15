import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/core/api/api_endpoints.dart';
import 'package:crud_flutter/model/relatorio_item/relatorio_item_model.dart';

class RelatorioItemService {
  final ApiClient _client;

  RelatorioItemService(this._client);

  // =========================
  // UTIL: EXTRATOR SEGURO
  // =========================
  List _extractList(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['data'] as List;
    }
    if (data is List) {
      return data;
    }
    return [];
  }

  // =========================
  // MAIS COMPRADOS
  // =========================
  Future<List<ItemMaisComprado>> getMaisComprados(int listaId) async {
    final result = await _client.get<List<ItemMaisComprado>>(
      ApiEndpoints.relatorioMaisComprados(listaId),
      (data) {
        final list = _extractList(data);

        return list
            .map((e) => ItemMaisComprado.fromJson(e))
            .toList();
      },
    );

    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  // =========================
  // POR CATEGORIA
  // =========================
  Future<List<ItemPorCategoria>> getPorCategoria(int listaId) async {
    final result = await _client.get<List<ItemPorCategoria>>(
      ApiEndpoints.relatorioPorCategoria(listaId),
      (data) {
        final list = _extractList(data);

        return list
            .map((e) => ItemPorCategoria.fromJson(e))
            .toList();
      },
    );

    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  // =========================
  // MAIS CAROS
  // =========================
  Future<List<ItemRankingPreco>> getMaisCaros(int listaId) async {
    final result = await _client.get<List<ItemRankingPreco>>(
      ApiEndpoints.relatorioMaisCaros(listaId),
      (data) {
        final list = _extractList(data);

        return list
            .map((e) => ItemRankingPreco.fromJson(e))
            .toList();
      },
    );

    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  // =========================
  // MAIS BARATOS
  // =========================
  Future<List<ItemRankingPreco>> getMaisBaratos(int listaId) async {
    final result = await _client.get<List<ItemRankingPreco>>(
      ApiEndpoints.relatorioMaisBaratos(listaId),
      (data) {
        final list = _extractList(data);

        return list
            .map((e) => ItemRankingPreco.fromJson(e))
            .toList();
      },
    );

    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }
}