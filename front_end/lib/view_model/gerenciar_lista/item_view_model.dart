import 'package:flutter/material.dart';
import '../../model/criar_produto/item.dart';
import '../../service/criar_produto/item_service.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemService _service = ItemService();

  List<Item> _itens = [];
  List<Item> get itens => _itens;

  bool isLoading = false;
  String? erro;

  // ================= LISTAR =================
  Future<void> listar(int listaId) async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final data = await _service.listar(listaId);
      _itens = List.from(data);
    } catch (e) {
      erro = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= CRIAR =================
  Future<void> criar(int listaId, Item item) async {
    final novo = await _service.criar(listaId, item);
    _itens.add(novo);
    notifyListeners();
  }

  // ================= ATUALIZAR =================
  Future<void> atualizar(int listaId, Item item) async {
    final atualizado = await _service.atualizar(listaId, item);

    _itens = _itens.map((i) => i.id == atualizado.id ? atualizado : i).toList();
    notifyListeners();
  }

  // ================= DELETAR =================
  Future<void> deletar(int listaId, int itemId) async {
    await _service.deletar(listaId, itemId);

    _itens = _itens.where((i) => i.id != itemId).toList();
    notifyListeners();
  }
}
