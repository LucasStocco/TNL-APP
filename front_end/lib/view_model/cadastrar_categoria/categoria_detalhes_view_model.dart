import 'package:crud_flutter/dto/item_create_dto.dart';
import 'package:crud_flutter/model/cadastrar_categoria/subcategoria_mode.dart';
import 'package:crud_flutter/model/cadastrar_produto/produto.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:flutter/material.dart';
import 'package:crud_flutter/service/cadastrar_categoria/categoria_service.dart';

class CategoriaDetalhesViewModel extends ChangeNotifier {
  final ProdutoService produtoService;
  final CategoriaService categoriaService;
  final ItemService itemService;
  final int idCategoria;

  CategoriaDetalhesViewModel({
    required this.produtoService,
    required this.itemService,
    required this.categoriaService,
    required this.idCategoria,
  });

  List<SubcategoriaModel> subcategorias = [];
  bool isLoading = false;
  String? erro;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setError(Object e) {
    erro = e.toString().replaceAll('Exception: ', '');
    notifyListeners();
  }

  void _clearError() {
    erro = null;
  }

  // ================= CARREGAR =================
  Future<void> carregarSubcategoriasDaCategoria() async {
    _setLoading(true);
    _clearError();

    try {
      print("🚀 [VM] Buscando categoria ID: $idCategoria");

      final categoria =
          await categoriaService.buscarCategoriaCompleta(idCategoria);

      if (categoria == null) {
        throw Exception("Categoria veio null do backend");
      }

      if (categoria.subcategorias == null) {
        print("⚠️ subcategorias veio null → convertendo para []");
        subcategorias = [];
      } else {
        subcategorias = categoria.subcategorias;
      }

      print("✅ [VM] Subcategorias carregadas: ${subcategorias.length}");
    } catch (e, stack) {
      print("❌ [VM ERROR] $e");
      print(stack);

      subcategorias = [];
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ================= ADICIONAR =================
  Future<void> adicionarProdutoNaLista(
    int idLista,
    Produto produto,
    double preco,
  ) async {
    try {
      if (produto.id == null) {
        _setError("Produto inválido (id null)");
        return;
      }

      await itemService.criar(
        idLista,
        ItemCreateDTO(
          produtoId: produto.id!, // ✔ fix null safety
          quantidade: 1,
          preco: preco,
        ),
      );
    } catch (e) {
      _setError(e);
    }
  }

  // ================= DELETE =================
  Future<void> deletarProduto(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await produtoService.deletar(id);
      await carregarSubcategoriasDaCategoria();
    } catch (e) {
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }
}
