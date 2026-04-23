import 'package:flutter/material.dart';
import '../../model/cadastrar_produto/produto.dart';
import '../../service/cadastrar_produto/produto_service.dart';
import '../../service/cadastrar_produto/produto_service.dart';

class ProdutoViewModel extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  // =========================
  // STATE
  // =========================
  List<Produto> produtos = [];

  bool isLoading = false;
  bool isSaving = false;

  String? erro;

  // =========================
  // HELPERS
  // =========================

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  String _parseErro(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  Future<T?> _execute<T>({
    required Future<T> Function() action,
    bool useSaving = false,
  }) async {
    if (useSaving) {
      _setSaving(true);
    } else {
      _setLoading(true);
    }

    erro = null;

    try {
      return await action();
    } catch (e) {
      erro = _parseErro(e);
      return null;
    } finally {
      if (useSaving) {
        _setSaving(false);
      } else {
        _setLoading(false);
      }
    }
  }

  // =========================
  // LISTAR
  // =========================
  Future<void> listar() async {
    final result = await _execute<List<Produto>>(
      action: () => _service.listar(),
    );

    if (result != null) {
      produtos = result;
      notifyListeners();
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Produto?> criar(Produto produto) async {
    final novo = await _execute<Produto>(
      useSaving: true,
      action: () => _service.criar(produto),
    );

    if (novo != null) {
      produtos = [...produtos, novo];
      notifyListeners();
    }

    return novo;
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Produto?> atualizar(Produto produto) async {
    if (produto.id == null) {
      erro = 'ID obrigatório';
      notifyListeners();
      return null;
    }

    final atualizado = await _execute<Produto>(
      useSaving: true,
      action: () => _service.atualizar(produto),
    );

    if (atualizado != null) {
      produtos = produtos.map((p) {
        return p.id == atualizado.id ? atualizado : p;
      }).toList();

      notifyListeners();
    }

    return atualizado;
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletar(int id) async {
    await _execute<void>(
      useSaving: true,
      action: () => _service.deletar(id),
    );

    if (erro != null) return;

    produtos.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // =========================
  // RESET
  // =========================
  void resetar() {
    produtos = [];
    isLoading = false;
    isSaving = false;
    erro = null;
    notifyListeners();
  }
}
