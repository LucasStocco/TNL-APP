import '../../core/api/api_client.dart';
import '../../model/cadastrar_produto/item.dart';
import '../../dto/item_manual_dto.dart';
import '../../dto/item_global_dto.dart';
import '../../dto/item_update_dto.dart';

class ItemService {
  final ApiClient _client = ApiClient();

  // =========================
  // LISTAR
  // =========================
  Future<List<Item>> listarPorLista(int idLista) async {
    final response = await _client.get(
      "/listas/$idLista/itens",
      (data) => (data as List).map((e) => Item.fromJson(e)).toList(),
    );

    return response.data ?? [];
  }

  // =========================
  // CRIAR MANUAL
  // =========================
  Future<Item> criarManual(int idLista, ItemManualDTO dto) async {
    final response = await _client.post(
      "/listas/$idLista/itens/manual",
      dto.toJson(),
      (data) => Item.fromJson(data),
    );

    return response.data!;
  }

  // =========================
  // CRIAR GLOBAL
  // =========================
  Future<Item> criarGlobal(int idLista, ItemGlobalDTO dto) async {
    final response = await _client.post(
      "/listas/$idLista/itens/global",
      dto.toJson(),
      (data) => Item.fromJson(data),
    );

    return response.data!;
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<void> atualizar(
    int idLista,
    int itemId,
    ItemUpdateDTO dto,
  ) async {
    await _client.put(
      "/listas/$idLista/itens/$itemId",
      dto.toJson(),
      null,
    );
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletar(int idLista, int itemId) async {
    await _client.delete(
      "/listas/$idLista/itens/$itemId",
      fromJson: null,
    );
  }

  // =========================
  // MARCAR COMPRADO
  // =========================
  Future<void> marcarComprado(
    int idLista,
    int itemId,
    bool valor,
  ) async {
    await _client.patch(
      "/listas/$idLista/itens/$itemId/comprado",
      {"comprado": valor},
      fromJson: null,
    );
  }
}
