import 'package:flutter/material.dart';

import '../../model/cadastrar_produto/produto.dart';
import '../../service/cadastrar_produto/produto_service.dart';
import '../../dto/produto_create_dto.dart';
import '../../dto/produto_update_dto.dart';

class ProdutoViewModel extends ChangeNotifier {
  final ProdutoService _service;

  ProdutoViewModel(this._service);

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

  void _setError(Object e) {
    erro = e.toString().replaceAll('Exception: ', '');
  }

  // =========================
  // LISTAR TODOS
  // =========================
  Future<void> listar() async {
    _setLoading(true);
    erro = null;

    try {
      produtos = await _service.listar();
    } catch (e) {
      _setError(e);
    }

    _setLoading(false);
  }

  // =========================
  // LISTAR POR CATEGORIA
  // =========================
  Future<void> listarPorCategoria(int idCategoria) async {
    _setLoading(true);
    erro = null;

    try {
      produtos = await _service.listarPorCategoria(idCategoria);
    } catch (e) {
      _setError(e);
      produtos = [];
    }

    _setLoading(false);
  }

  // =========================
  // CRIAR PRODUTO
  // =========================
  Future<Produto?> criar({
    required String nome,
    required double preco,
    String? descricao,
    required int idCategoria,
  }) async {
    _setSaving(true);
    erro = null;

    try {
      final novo = await _service.criar(
        ProdutoCreateDTO(
          nome: nome,
          preco: preco,
          descricao: descricao,
          idCategoria: idCategoria,
        ),
      );

      produtos = [...produtos, novo];
      return novo;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
      notifyListeners();
    }
  }

  // =========================
  // ATUALIZAR PRODUTO
  // =========================
  Future<Produto?> atualizar(Produto produto) async {
    if (produto.id == null) {
      erro = "ID obrigatório";
      notifyListeners();
      return null;
    }

    _setSaving(true);
    erro = null;

    try {
      final atualizado = await _service.atualizar(
        produto.id!,
        ProdutoUpdateDTO(
          nome: produto.nome,
          preco: produto.preco,
          descricao: produto.descricao,
          idCategoria: produto.idCategoria,
        ),
      );

      produtos = produtos.map((p) {
        return p.id == atualizado.id ? atualizado : p;
      }).toList();

      return atualizado;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
      notifyListeners();
    }
  }

  // =========================
  // DELETAR PRODUTO
  // =========================
  Future<void> deletar(int id) async {
    _setSaving(true);
    erro = null;

    try {
      await _service.deletar(id);

      produtos.removeWhere((p) => p.id == id);
    } catch (e) {
      _setError(e);
    }

    _setSaving(false);
    notifyListeners();
  }

  // =========================
  // BUSCA LOCAL (UI FILTER)
  // =========================
  List<Produto> buscarPorNome(String query) {
    if (query.isEmpty) return produtos;

    return produtos
        .where((p) => p.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
