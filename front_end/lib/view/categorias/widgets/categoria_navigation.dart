import 'package:crud_flutter/view/categorias/categoria_produtos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/cadastrar_produto/produto_service.dart';
import '../../../service/gerenciar_lista/item_service.dart';
import '../../../view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';

class CategoriaNavigation {
  static void abrirDetalhes({
    required BuildContext context,
    required int idCategoria,
    required String nomeCategoria,
  }) {
    final produtoService = context.read<ProdutoService>();
    final itemService = context.read<ItemService>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider(
            create: (_) => CategoriaDetalhesViewModel(
              produtoService: produtoService,
              itemService: itemService,
              idCategoria: idCategoria, // ✅ agora vai no construtor
            )..carregarProdutos(), // ✅ sem parâmetro
            child: CategoriasProdutosScreen(
              nomeCategoria: nomeCategoria,
              idCategoria: idCategoria,
            ),
          );
        },
      ),
    );
  }
}
