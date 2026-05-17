import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/dto/item_create_dto.dart';
import 'package:crud_flutter/dto/item_update_dto.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';

class ItemService {
  final ApiClient _client;

  ItemService(this._client);

  // =====================================================
  // 🧠 LOG HELPERS
  // =====================================================
  void _log(String msg) => print("[ITEM_SERVICE] $msg");

  void _logReq(String method, String url, [dynamic body]) {
    _log("➡️ $method $url");
    if (body != null) _log("📦 BODY: $body");
  }

  void _logRes(dynamic res) {
    _log("⬅️ RESPONSE: $res");
  }

  // =====================================================
  // 📥 LISTAR ITENS
  // =====================================================
  Future<List<Item>> listar(int listaId) async {
    final url = '/listas/$listaId/itens';

    _logReq("GET", url);

    final result = await _client.get<List<Item>>(
      url,
      (data) => (data as List).map((e) => Item.fromJson(e)).toList(),
    );

    _logRes(result);

    if (!result.success) {
      throw Exception(result.message);
    }

    return result.data ?? [];
  }

  // =====================================================
  // ➕ CRIAR ITEM
  // =====================================================
  Future<Item> criar(int listaId, ItemCreateDTO dto) async {
    final url = '/listas/$listaId/itens';

    _logReq("POST", url, dto.toJson());

    final result = await _client.post<Item>(
      url,
      dto.toJson(),
      (data) => Item.fromJson(data),
    );

    _logRes(result);

    if (!result.success || result.data == null) {
      throw Exception(result.message);
    }

    return result.data!;
  }

  // =====================================================
  // ✏️ ATUALIZAR ITEM
  // =====================================================
  Future<Item> atualizar(
    int listaId,
    int idItem,
    ItemUpdateDTO dto,
  ) async {
    final url = '/listas/$listaId/itens/$idItem';

    _logReq("PUT", url, dto.toJson());

    final result = await _client.put<Item>(
      url,
      dto.toJson(),
      (data) => Item.fromJson(data),
    );

    _logRes(result);

    if (!result.success || result.data == null) {
      throw Exception(result.message);
    }

    return result.data!;
  }

  // =====================================================
  // ADICIONAR PRODUTO NA LISTA
  // =====================================================
  Future<Item> adicionarProdutoNaLista({
    required int listaId,
    required int produtoId,
    double preco = 0.0,
    int quantidade = 1,
  }) async {
    final url = '/listas/$listaId/itens';

    final body = {
      "produtoId": produtoId,
      "preco": preco,
      "quantidade": quantidade,
    };

    final result = await _client.post<Item>(
      url,
      body,
      (data) => Item.fromJson(data),
    );

    if (!result.success || result.data == null) {
      throw Exception(result.message);
    }

    return result.data!;
  }

  // =====================================================
  // ✅ MARCAR COMO COMPRADO
  // =====================================================
  Future<void> marcarComprado(int listaId, int idItem) async {
    final url = '/listas/$listaId/itens/$idItem/comprado';

    _logReq("PATCH", url);

    final result = await _client.patch<void>(
      url,
      {},
      null,
    );

    _logRes(result);

    if (!result.success) {
      throw Exception(result.message);
    }
  }

  // =====================================================
  // ❌ DESMARCAR
  // =====================================================
  Future<void> desmarcarComprado(int listaId, int idItem) async {
    final url = '/listas/$listaId/itens/$idItem/desmarcar';

    _logReq("PATCH", url);

    final result = await _client.patch<void>(
      url,
      {},
      null,
    );

    _logRes(result);

    if (!result.success) {
      throw Exception(result.message);
    }
  }

  // =====================================================
  // 🗑 DELETAR
  // =====================================================
  Future<void> deletar(int listaId, int idItem) async {
    final url = '/listas/$listaId/itens/$idItem';

    _logReq("DELETE", url);

    final result = await _client.delete<void>(url);

    _logRes(result);

    if (!result.success) {
      throw Exception(result.message);
    }
  }
}
