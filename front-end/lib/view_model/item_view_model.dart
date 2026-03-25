import 'package:flutter/material.dart';
import '../model/item.dart';
import '../service/item_service.dart';
import '../service/lista_service.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemService _service = ItemService();
  final ListaService _listaService = ListaService();

  List<Item> itens = [];
  bool isLoading = false;
  String? erro;

  // ---------------------- UTIL ----------------------
  void _startLoading() {
    isLoading = true;
    erro = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ---------------------- LISTAR ----------------------
  Future<void> carregar(int listaId) async {
    _startLoading();
    try {
      itens = await _service.listar(listaId);
    } catch (e) {
      itens = [];
      erro = 'Falha ao carregar itens: $e';
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- CRIAR ----------------------
  Future<void> criar(int listaId, Item item) async {
    _startLoading();
    try {
      if (item.produto.id == null) {
        throw Exception(
          'Produto ainda não possui ID. Crie no backend primeiro.',
        );
      }

      // 🔥 SALVA NO BACKEND
      final Item novoItem = await _service.criar(listaId, item);

      // 🔥 ATUALIZA LISTA LOCAL (sem recarregar tudo)
      itens.add(novoItem);

      notifyListeners();

      // 🔥 REGRA DE NEGÓCIO
      await _verificarConclusao(listaId);
    } catch (e) {
      erro = 'Erro ao criar item: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- ATUALIZAR ----------------------
  Future<void> atualizar(int listaId, Item item) async {
    _startLoading();
    try {
      final Item itemAtualizado = await _service.atualizar(listaId, item);

      final index = itens.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        itens[index] = itemAtualizado;
      }

      notifyListeners();

      await _verificarConclusao(listaId);
    } catch (e) {
      erro = 'Erro ao atualizar item: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- DELETAR ----------------------
  Future<void> deletar(int listaId, int itemId) async {
    _startLoading();
    try {
      await _service.deletar(listaId, itemId);

      itens.removeWhere((i) => i.id == itemId);

      notifyListeners();

      await _verificarConclusao(listaId);
    } catch (e) {
      erro = 'Erro ao deletar item: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- REGRA DE NEGÓCIO ----------------------
  Future<void> _verificarConclusao(int listaId) async {
    if (itens.isEmpty) return;

    final todosComprados = itens.every((i) => i.comprado);

    if (todosComprados) {
      try {
        await _listaService.finalizarLista(listaId, DateTime.now());
      } catch (e) {
        erro = 'Erro ao finalizar lista: $e';
        notifyListeners();
      }
    }
  }

  // ---------------------- RESET ----------------------
  void resetar() {
    itens = [];
    isLoading = false;
    erro = null;
    notifyListeners();
  }
}







