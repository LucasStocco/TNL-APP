import 'package:flutter/material.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/dto/request/gerenciar_lista/item_request_create_dto.dart';
import 'package:crud_flutter/dto/request/gerenciar_lista/item_request_update_dto.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemService _service;

  ItemViewModel(this._service);

  // =========================
  // STATE
  // =========================
  final List<Item> _itens = [];

  bool _isLoading = false;
  bool _isSaving = false;

  String? _erro;

  // =========================
  // GETTERS
  // =========================
  List<Item> get itens => List.unmodifiable(_itens);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get erro => _erro;

  // =========================
  // STATE HELPERS
  // =========================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void _setError(Object e) {
    _erro = e.toString();
    notifyListeners();
  }

  void _clearError() {
    _erro = null;
    notifyListeners();
  }

  // =========================
  // EXECUTION HELPERS
  // =========================
  Future<T?> _runLoading<T>(Future<T> Function() action) async {
    try {
      _clearError();
      _setLoading(true);
      return await action();
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<T?> _runSaving<T>(Future<T> Function() action) async {
    try {
      _clearError();
      _setSaving(true);
      return await action();
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // LISTAR ITENS (SOURCE OF TRUTH)
  // =========================
  Future<void> carregar(int listaId) async {
    final resultado = await _runLoading(
      () => _service.listar(listaId),
    );

    if (resultado != null) {
      _itens
        ..clear()
        ..addAll(resultado);
    }
  }

  // =========================
  // CRIAR ITEM (RELOAD)
  // =========================
  Future<Item?> criar({
    required int listaId,
    required int idProduto,
    required int quantidade,
    required double preco,
  }) async {
    return await _runSaving(() async {
      final dto = ItemCreateDTO(
        produtoId: idProduto,
        quantidade: quantidade,
        preco: preco,
      );

      final novo = await _service.criar(listaId, dto);

      await carregar(listaId); // 🔥 única fonte da verdade

      return novo;
    });
  }

  // =========================
  // ATUALIZAR (RELOAD)
  // =========================
  Future<Item?> atualizar({
    required int listaId,
    required int idItem,
    required int quantidade,
    required double preco,
  }) async {
    return await _runSaving(() async {
      final dto = ItemUpdateDTO(
        quantidade: quantidade,
        preco: preco,
      );

      final atualizado = await _service.atualizar(
        listaId,
        idItem,
        dto,
      );

      await carregar(listaId); // 🔥 reload

      return atualizado;
    });
  }

  // =========================
  // TOGGLE COMPRADO (RELOAD CENTRALIZADO)
  // =========================
  Future<void> marcarComprado(
    int listaId,
    int idItem,
    bool comprado,
  ) async {
    await _runSaving(() async {
      if (comprado) {
        await _service.marcarComprado(listaId, idItem);
      } else {
        await _service.desmarcarComprado(listaId, idItem);
      }

      await carregar(listaId); // 🔥 centralizado
    });
  }

  // =========================
  // DELETAR ITEM (RELOAD CENTRALIZADO)
  // =========================
  Future<void> deletar(
    int listaId,
    int idItem,
  ) async {
    await _runSaving(() async {
      await _service.deletar(listaId, idItem);

      await carregar(listaId); // 🔥 centralizado
    });
  }
}
