import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:flutter/material.dart';

import '../../dto/item_global_dto.dart';
import '../../dto/item_manual_dto.dart';
import '../../dto/item_update_dto.dart';
import '../../model/cadastrar_produto/item.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemService _service;

  ItemViewModel(this._service);

  List<Item> itens = [];
  bool isLoading = false;
  bool isSaving = false;
  String? erro;

  // =========================
  // LISTAR
  // =========================
  Future<void> carregarItens(int idLista) async {
    isLoading = true;
    notifyListeners();

    try {
      itens = await _service.listarPorLista(idLista);
      erro = null;
    } catch (e) {
      erro = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // =========================
  // CRIAR MANUAL
  // =========================
  Future<void> criarItemManual(int idLista, ItemManualDTO dto) async {
    isSaving = true;
    notifyListeners();

    try {
      await _service.criarManual(idLista, dto);
      erro = null;

      await carregarItens(idLista);
    } catch (e) {
      erro = e.toString();
    }

    isSaving = false;
    notifyListeners();
  }

  // =========================
  // 🔥 CRIAR GLOBAL (CORRETO)
  // =========================
  Future<void> criarItemGlobal(int idLista, ItemGlobalDTO dto) async {
    isSaving = true;
    notifyListeners();

    try {
      await _service.criarGlobal(idLista, dto);
      erro = null;

      await carregarItens(idLista);
    } catch (e) {
      erro = e.toString();
    }

    isSaving = false;
    notifyListeners();
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<void> atualizarItem(
    int idLista,
    int itemId,
    ItemUpdateDTO dto,
  ) async {
    isSaving = true;
    notifyListeners();

    try {
      await _service.atualizar(idLista, itemId, dto);
      erro = null;

      await carregarItens(idLista);
    } catch (e) {
      erro = e.toString();
    }

    isSaving = false;
    notifyListeners();
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletarItem(int idLista, int itemId) async {
    try {
      await _service.deletar(idLista, itemId);
      await carregarItens(idLista);
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }

  // =========================
  // TOGGLE COMPRADO
  // =========================
  Future<void> marcarComprado(int idLista, int itemId, bool valor) async {
    try {
      await _service.marcarComprado(idLista, itemId, valor);
      await carregarItens(idLista);
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }
}
