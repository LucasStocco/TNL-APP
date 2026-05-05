import 'package:flutter/material.dart';

import '../../model/cadastrar_produto/produto.dart';
import '../../service/cadastrar_produto/produto_service.dart';
import '../../service/gerenciar_lista/item_service.dart';
import '../../dto/item_create_dto.dart';

class CategoriaDetalhesViewModel extends ChangeNotifier {
  final ProdutoService produtoService;
  final ItemService itemService;
  final int idCategoria;

  CategoriaDetalhesViewModel({
    required this.produtoService,
    required this.itemService,
    required this.idCategoria,
  });

  // ================= STATE =================
  List<Produto> produtos = [];
  bool isLoading = false;
  String? erro;

  // ================= LOG =================
  void _log(String msg) {
    print("[CATEGORIA_DETALHES_VM] $msg");
  }

  // ================= HELPERS =================
  void _setLoading(bool value) {
    isLoading = value;
    _log("loading = $value");
    notifyListeners();
  }

  void _setError(Object e) {
    erro = e.toString().replaceAll('Exception: ', '');
    _log("❌ erro = $erro");
    notifyListeners();
  }

  // ================= PRODUTOS =================
  Future<void> carregarProdutos() async {
    _log("🚀 carregando produtos da categoria $idCategoria");

    _setLoading(true);
    erro = null;

    try {
      final result = await produtoService.listarPorCategoria(idCategoria);

      _log("📥 produtos recebidos: ${result.length}");

      produtos = result;

      _log("📦 lista final no VM: ${produtos.length}");
    } catch (e) {
      _log("❌ erro = $e");

      _setError(e);
      produtos = [];
    }

    _setLoading(false);
    _log("✅ carregamento finalizado");
  }

  // ================= ADICIONAR ITEM =================
  Future<void> adicionarProdutoNaLista(
    int idLista,
    Produto produto,
  ) async {
    _log("➕ adicionando produto ${produto.nome} na lista $idLista");

    try {
      if (produto.id == null) {
        throw Exception("Produto sem ID");
      }

      if (produto.preco == null) {
        throw Exception("Produto sem preço");
      }

      await itemService.criar(
        idLista,
        ItemCreateDTO(
          produtoId: produto.id!,
          quantidade: 1,
          preco: produto.preco!, // 🔥 ESSENCIAL
        ),
      );

      _log("✅ produto adicionado com sucesso");
    } catch (e) {
      _setError(e);
    }
  }

  // ================= DELETE PRODUTO =================
  Future<void> deletarProduto(int id) async {
    _log("🗑 deletando produto id=$id");

    try {
      await produtoService.deletar(id);

      _log("✅ produto deletado");

      // 🔥 recarrega usando o id fixo da categoria
      await carregarProdutos();
    } catch (e) {
      _setError(e);
    }
  }
}
