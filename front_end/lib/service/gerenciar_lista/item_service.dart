import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/dto/request/gerenciar_lista/adicionar_produto_lista_request_dto.dart';
import 'package:crud_flutter/dto/request/gerenciar_lista/item_request_create_dto.dart';
import 'package:crud_flutter/dto/request/gerenciar_lista/item_request_update_dto.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';

class ItemService {
  final ApiClient _client;

  ItemService(this._client);

  // =====================================================
  // 📥 LISTAR ITENS
  // =====================================================
  Future<List<Item>> listar(int listaId) async {
    final url = '/listas/$listaId/itens';

    final result = await _client.get<List<Item>>(
      url,
      (data) => (data as List).map((e) => Item.fromJson(e)).toList(),
    );

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

    final result = await _client.post<Item>(
      url,
      dto.toJson(),
      (data) => Item.fromJson(data),
    );

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

    final result = await _client.put<Item>(
      url,
      dto.toJson(),
      (data) => Item.fromJson(data),
    );

    if (!result.success || result.data == null) {
      throw Exception(result.message);
    }

    return result.data!;
  }

  // =====================================================
  // ➕ ADICIONAR PRODUTO NA LISTA
  // =====================================================
  Future<Item> adicionarProdutoNaLista(
    int listaId,
    AdicionarProdutoListaRequestDTO dto,
  ) async {
    final url = '/listas/$listaId/itens';

    final result = await _client.post<Item>(
      url,
      dto.toJson(),
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

    print("📡 [ITEM SERVICE] marcarComprado INICIO");
    print("📡 [ITEM SERVICE] listaId=$listaId itemId=$idItem");
    print("🌐 [ITEM SERVICE] URL=$url");

    try {
      final result = await _client.patch<void>(
        url,
        {},
        null,
      );

      print("📨 [ITEM SERVICE] resposta recebida");
      print("📨 [ITEM SERVICE] success=${result.success}");
      print("📨 [ITEM SERVICE] message=${result.message}");

      if (!result.success) {
        print("❌ [ITEM SERVICE] ERRO ao marcar como comprado");
        throw Exception(result.message);
      }

      print("✅ [ITEM SERVICE] item marcado como comprado com sucesso");
    } catch (e) {
      print("💥 [ITEM SERVICE] EXCEPTION: $e");
      rethrow;
    }
  }

  // =====================================================
  // ❌ DESMARCAR COMO COMPRADO
  // =====================================================
  Future<void> desmarcarComprado(int listaId, int idItem) async {
    final url = '/listas/$listaId/itens/$idItem/desmarcar';

    final result = await _client.patch<void>(
      url,
      {},
      null,
    );

    if (!result.success) {
      throw Exception(result.message);
    }
  }

  // =====================================================
  // 🗑 DELETAR ITEM
  // =====================================================
  Future<void> deletar(int listaId, int idItem) async {
    final url = '/listas/$listaId/itens/$idItem';

    final result = await _client.delete<void>(url);

    if (!result.success) {
      throw Exception(result.message);
    }
  }
}
