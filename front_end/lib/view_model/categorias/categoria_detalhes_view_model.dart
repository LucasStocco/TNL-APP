import 'package:crud_flutter/model/criar_produto/item.dart';
import 'package:crud_flutter/service/criar_produto/item_service.dart';
import 'package:flutter/material.dart';
import '../../model/criar_produto/produto.dart';
import '../criar_produto/produto_view_model.dart';
import '../gerenciar_lista/lista_view_model.dart';

class CategoriaDetalhesViewModel extends ChangeNotifier {
  final ProdutoViewModel produtoVM;
  final ListaViewModel listaVM;
  final int categoriaId;
  final ItemService itemService;

  bool isLoading = false;
  String? erro;
  List<Produto> produtos = [];

  CategoriaDetalhesViewModel({
    required this.produtoVM,
    required this.listaVM,
    required this.categoriaId,
    required this.itemService,
  }) {
    carregarProdutos();
  }

  // ---------------------- LOADING ----------------------
  void _startLoading() {
    isLoading = true;
    erro = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ---------------------- CARREGAR PRODUTOS ----------------------
  Future<void> carregarProdutos() async {
    _startLoading();
    try {
      produtos = produtoVM.produtos
          .where((p) => p.categoria.id == categoriaId)
          .toList();
    } catch (e) {
      produtos = [];
      erro = 'Erro ao carregar produtos: $e';
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- ADICIONAR PRODUTO NA LISTA ----------------------
  Future<void> adicionarProdutoNaLista(int listaId, Produto produto) async {
    _startLoading();
    try {
      // Cria Item com quantidade 1
      final novoItem = Item(
        quantidade: 1,
        produto: produto,
      );

      // Chama backend via ItemService
      final itemCriado = await itemService.criar(listaId, novoItem);

      // Atualiza lista local
      final lista = listaVM.listas.firstWhere((l) => l.id == listaId);
      lista.itens.add(itemCriado);

      // Notifica a UI
      listaVM.notifyListeners();
    } catch (e) {
      erro = 'Erro ao adicionar produto: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }
}
