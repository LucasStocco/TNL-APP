import 'package:flutter/material.dart';
import '../../model/criar_produto/produto.dart';
import '../../service/criar_produto/produto_service.dart';

class ProdutoViewModel extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> _produtos = [];
  List<Produto> get produtos => _produtos;

  bool isLoading = false;
  String? erro;

  // ================= LISTAR =================
  Future<void> listar() async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final data = await _service.listar();
      _produtos = List.from(data);
    } catch (e) {
      erro = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= CRIAR =================
  Future<Produto> criar(Produto produto) async {
    final novo = await _service.criar(produto);
    _produtos.add(novo);
    notifyListeners();
    return novo;
  }

  // ================= ATUALIZAR =================
  Future<Produto> atualizar(Produto produto) async {
    if (produto.id == null)
      throw Exception('ID obrigatório para atualizar produto');

    final atualizado = await _service.atualizar(produto);
    _produtos =
        _produtos.map((p) => p.id == atualizado.id ? atualizado : p).toList();
    notifyListeners();
    return atualizado;
  }

  // ================= DELETAR =================
  Future<void> deletar(int id) async {
    await _service.deletar(id);
    _produtos = _produtos.where((p) => p.id != id).toList();
    notifyListeners();
  }
}
