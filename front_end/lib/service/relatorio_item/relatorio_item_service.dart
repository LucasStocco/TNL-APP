import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/model/relatorio_item/relatorio_item_model.dart';

class RelatorioItemService {
  final ApiClient _client;

  RelatorioItemService(this._client);

  void _log(String msg) => print('[RELATORIO_ITEM_SERVICE] $msg');

  Future<List<ItemMaisComprado>> getMaisComprados(int listaId) async {
    final url = '/relatorios/$listaId/mais-comprados';
    _log('➡️ GET $url');
    final result = await _client.get<List<ItemMaisComprado>>(
      url,
      (data) => data == null ? [] : (data as List).map((e) => ItemMaisComprado.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  Future<List<ItemPorCategoria>> getPorCategoria(int listaId) async {
    final url = '/relatorios/$listaId/por-categoria';
    _log('➡️ GET $url');
    final result = await _client.get<List<ItemPorCategoria>>(
      url,
      (data) => data == null ? [] : (data as List).map((e) => ItemPorCategoria.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  Future<List<ItemRankingPreco>> getMaisCaros(int listaId) async {
    final url = '/relatorios/$listaId/mais-caros';
    _log('➡️ GET $url');
    final result = await _client.get<List<ItemRankingPreco>>(
      url,
      (data) => data == null ? [] : (data as List).map((e) => ItemRankingPreco.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }

  Future<List<ItemRankingPreco>> getMaisBaratos(int listaId) async {
    final url = '/relatorios/$listaId/mais-baratos';
    _log('➡️ GET $url');
    final result = await _client.get<List<ItemRankingPreco>>(
      url,
      (data) => data == null ? [] : (data as List).map((e) => ItemRankingPreco.fromJson(e)).toList(),
    );
    if (!result.success) throw Exception(result.message);
    return result.data ?? [];
  }
}