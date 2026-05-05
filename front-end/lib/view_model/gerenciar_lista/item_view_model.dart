import 'package:flutter/material.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/dto/item_create_dto.dart';
import 'package:crud_flutter/dto/item_update_dto.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemService service;

  ItemViewModel(this.service);

  // =========================
  // STATE
  // =========================
  List<Item> itens = [];

  bool isLoading = false;
  bool isSaving = false;

  String? erro;

  // =========================
  // LISTAR ITENS
  // =========================
  Future<void> carregar(int listaId) async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      itens = await service.listar(listaId);
    } catch (e) {
      erro = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // =========================
  // CRIAR ITEM
  // =========================
  Future<Item?> criar({
    required int listaId,
    required int idProduto,
    required int quantidade,
    required double preco,
  }) async {
    isSaving = true;
    erro = null;
    notifyListeners();

    try {
      final dto = ItemCreateDTO(
        produtoId: idProduto,
        quantidade: quantidade,
        preco: preco,
      );

      final novo = await service.criar(listaId, dto);

      // 🔥 MELHOR PRÁTICA: sincroniza com backend
      await carregar(listaId);

      return novo;
    } catch (e) {
      erro = e.toString();
      return null;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Item?> atualizar({
    required int listaId,
    required int idItem,
    required int quantidade,
    required double preco,
  }) async {
    isSaving = true;
    erro = null;
    notifyListeners();

    try {
      final dto = ItemUpdateDTO(
        quantidade: quantidade,
        preco: preco,
      );

      final atualizado = await service.atualizar(listaId, idItem, dto);

      // 🔥 GARANTE CONSISTÊNCIA COM BACKEND
      await carregar(listaId);

      return atualizado;
    } catch (e) {
      erro = e.toString();
      return null;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // =========================
  // TOGGLE COMPRADO
  // =========================
  Future<void> marcarComprado(
    int listaId,
    int idItem,
    bool comprado,
  ) async {
    try {
      if (comprado) {
        await service.marcarComprado(listaId, idItem);
      } else {
        await service.desmarcarComprado(listaId, idItem);
      }

      final index = itens.indexWhere((i) => i.id == idItem);

      if (index != -1) {
        itens[index] = itens[index].copyWith(comprado: comprado);
        notifyListeners();
      }
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }

  // =========================
  // DELETAR ITEM
  // =========================
  Future<void> deletar(int listaId, int idItem) async {
    try {
      await service.deletar(listaId, idItem);

      itens.removeWhere((i) => i.id == idItem);
      notifyListeners();
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }
}
