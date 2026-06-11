import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/core/api/api_endpoints.dart';
import 'package:crud_flutter/model/relatorio_item/relatorio_item_model.dart';

class RelatorioItemService {
  final ApiClient _client;

  RelatorioItemService(this._client);

  Future<List<ItemMaisComprado>> getMaisComprados(int listaId) async {
    final result = await _client.get<List<ItemMaisComprado>>(
      ApiEndpoints.relatorioMaisComprados(listaId),
      (data) => data == null ? [] : (data as List).map((e) => ItemMaisComprado.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  Future<List<ItemPorCategoria>> getPorCategoria(int listaId) async {
    final result = await _client.get<List<ItemPorCategoria>>(
      ApiEndpoints.relatorioPorCategoria(listaId),
      (data) => data == null ? [] : (data as List).map((e) => ItemPorCategoria.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  Future<List<ItemRankingPreco>> getMaisCaros(int listaId) async {
    final result = await _client.get<List<ItemRankingPreco>>(
      ApiEndpoints.relatorioMaisCaros(listaId),
      (data) => data == null ? [] : (data as List).map((e) => ItemRankingPreco.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  Future<List<ItemRankingPreco>> getMaisBaratos(int listaId) async {
    final result = await _client.get<List<ItemRankingPreco>>(
      ApiEndpoints.relatorioMaisBaratos(listaId),
      (data) => data == null ? [] : (data as List).map((e) => ItemRankingPreco.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }
}