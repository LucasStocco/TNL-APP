import 'package:flutter/material.dart';

import '../../model/cadastrar_produto/produto.dart';
import '../../service/cadastrar_produto/produto_service.dart';
import '../../service/gerenciar_lista/item_service.dart';
import '../../dto/item_global_dto.dart';

class CategoriaDetalhesViewModel extends ChangeNotifier {
  final ProdutoService produtoService;
  final ItemService itemService;

  final int idCategoria;

  CategoriaDetalhesViewModel({
    required this.produtoService,
    required this.itemService,
    required this.idCategoria,
  });

  bool isLoading = false;
  String? erro;

  List<Produto> produtos = [];

  // ================= PRODUTOS =================
  Future<void> carregarProdutos() async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      produtos = await produtoService.listarPorCategoria(idCategoria);
    } catch (e) {
      erro = e.toString();
      produtos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= ADD ITEM =================
  Future<void> adicionarProdutoNaLista(
    int idLista,
    Produto produto,
  ) async {
    try {
      print("━━━━━━━━━━━━━━━━━━━━━━");
      print("🛒 ADD ITEM");
      print("listaId: $idLista");
      print("produtoId: ${produto.id}");
      print("categoriaProduto: ${produto.categoria?.id}");

      if (produto.id == null) {
        throw Exception("Produto sem ID");
      }

      final categoriaId = produto.categoria?.id ?? idCategoria;

      if (categoriaId == null) {
        throw Exception("Produto sem categoria");
      }

      final dto = ItemGlobalDTO(
        idProduto: produto.id!,
        idCategoria: categoriaId,
        quantidade: 1,
      );

      print("📦 DTO: ${dto.toJson()}");

      final item = await itemService.criarGlobal(idLista, dto);

      print("✅ ITEM CRIADO: ${item.id}");
    } catch (e) {
      erro = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ================= DELETE =================
  Future<void> deletarProduto(int id) async {
    try {
      await produtoService.deletar(id);
      await carregarProdutos();
    } catch (e) {
      erro = e.toString();
      notifyListeners();
    }
  }
}
