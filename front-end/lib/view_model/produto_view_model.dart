import 'package:flutter/material.dart';
import '../model/produto.dart';
import '../service/produto_service.dart';

class ProdutoViewModel extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> produtos = [];
  bool isLoading = false;
  String? erro;

  void _startLoading() {
    isLoading = true;
    erro = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// Carrega todos os produtos do backend
  Future<void> carregar() async {
    _startLoading();
    try {
      produtos = await _service.getAll();
    } catch (e) {
      produtos = [];
      erro = 'Falha ao carregar produtos: $e';
    } finally {
      _stopLoading();
    }
  }

  /// Cria produto no backend e já adiciona na lista local
  Future<Produto?> criarProduto(Produto produto) async {
    _startLoading();
    try {
      final Produto criado = await _service.create(produto);
      produtos.add(criado); // garante que o produto com ID vá para a lista
      notifyListeners();
      return criado;
    } catch (e) {
      erro = 'Erro ao criar produto: $e';
      notifyListeners();
      return null;
    } finally {
      _stopLoading();
    }
  }

  /// Atualiza lista local manualmente
  void atualizarProdutos(List<Produto> novaLista) {
    produtos = novaLista;
    notifyListeners();
  }

  /// Resetar estado
  void resetar() {
    produtos = [];
    isLoading = false;
    erro = null;
    notifyListeners();
  }
}
