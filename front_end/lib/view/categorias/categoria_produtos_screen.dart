import 'package:crud_flutter/model/cadastrar_produto/produto.dart';
import 'package:crud_flutter/shared/mappers/categoria_color_mapper.dart';
import 'package:crud_flutter/view/categorias/widgets/lista_selecao_bottom_sheet.dart';
import 'package:crud_flutter/view/categorias/widgets/subcategoria_header_widget.dart';
import 'package:crud_flutter/shared/mappers/subcategoria_icon_mapper.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';

class CategoriasProdutosScreen extends StatefulWidget {
  final String nomeCategoria;
  final int idCategoria;

  const CategoriasProdutosScreen({
    super.key,
    required this.nomeCategoria,
    required this.idCategoria,
  });

  @override
  State<CategoriasProdutosScreen> createState() =>
      _CategoriasProdutosScreenState();
}

class _CategoriasProdutosScreenState extends State<CategoriasProdutosScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      print("🚀 [INIT] Categoria ID: ${widget.idCategoria}");

      context
          .read<CategoriaDetalhesViewModel>()
          .carregarSubcategoriasDaCategoria();

      context.read<ListaViewModel>().listar();
    });
  }

  void _adicionarNaLista(BuildContext context, Produto produto) {
    print("🛒 [ADD LISTA] Produto: ${produto.nome} | ID: ${produto.id}");

    ListaSelecaoBottomSheet.show(
      context: context,
      produtoId: produto.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📦 ${widget.nomeCategoria}"),
      ),
      body: Consumer<CategoriaDetalhesViewModel>(
        builder: (context, vm, child) {
          print("📊 [STATE] loading=${vm.isLoading} erro=${vm.erro}");

          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (vm.erro != null) {
            print("❌ [VIEW ERROR] ${vm.erro}");

            return Center(
              child: Text(
                vm.erro!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          final subcategorias = vm.subcategorias;

          print("📦 [SUBCATEGORIAS COUNT] ${subcategorias.length}");

          if (subcategorias.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum produto nesta categoria",
              ),
            );
          }

          return ListView.builder(
            itemCount: subcategorias.length,
            itemBuilder: (context, index) {
              final sub = subcategorias[index];

              print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
              print("📂 SUBCATEGORIA: ${sub.nome} (ID: ${sub.id})");

              final produtos = sub.produtos;

              print("📦 PRODUTOS TYPE: ${produtos.runtimeType}");
              print("📦 PRODUTOS COUNT: ${produtos.length}");

              for (var i = 0; i < produtos.length; i++) {
                final p = produtos[i];

                print(
                  "👉 PRODUTO [$i] ${p.nome} | "
                  "ID=${p.id} | "
                  "SUB=${p.nomeSubcategoria}",
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubcategoriaHeaderWidget(
                      subcategoria: sub,
                      cor: CategoriaColorMapper.cor(
                        widget.nomeCategoria,
                      ),
                      icone: SubcategoriaIconMapper.icone(
                        categoria: widget.nomeCategoria,
                        subcategoria: sub.nome,
                      ),
                    ),
                    ...produtos.map((produto) {
                      print("🎯 BUILD TILE: ${produto.nome}");

                      return ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text(produto.nome),
                        subtitle: Text(
                          produto.descricao ?? '',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                          ),
                          onPressed: () => _adicionarNaLista(context, produto),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
