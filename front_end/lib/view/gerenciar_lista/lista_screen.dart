// ================= PACKAGES =================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ================= CORE =================
import 'package:crud_flutter/core/api/api_client.dart';

// ================= SERVICES =================
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';

// ================= VIEW MODELS =================
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_produto/produto_view_model.dart';

// ================= VIEWS / WIDGETS =================
import 'package:crud_flutter/view/gerenciar_lista/widgets/categoria_bottom_sheet.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/item_actions_sheet.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/lista_fab_menu.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/lista_item_tile.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/lista_total_header.dart';
import 'package:crud_flutter/view/cadastrar_produto/criar_item_screen.dart';

class ListaScreen extends StatefulWidget {
  final int listaId;
  final String listaNome;

  const ListaScreen({
    super.key,
    required this.listaId,
    required this.listaNome,
  });

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ItemViewModel>().carregar(widget.listaId);
      context.read<CategoriaViewModel>().listar();
    });
  }

  Future<void> _abrirCriarItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: context.read<CategoriaViewModel>(),
            ),
            ChangeNotifierProvider(
              create: (_) => ProdutoViewModel(
                ProdutoService(ApiClient(http.Client())),
              ),
            ),
          ],
          child: CriarItemScreen(listaId: widget.listaId),
        ),
      ),
    );

    // 🔥 SEMPRE SINCRONIZA COM BACKEND AO VOLTAR
    if (mounted) {
      await context.read<ItemViewModel>().carregar(widget.listaId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listaNome),
      ),
      body: Consumer<ItemViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.itens.isEmpty) {
            return const Center(child: Text("Nenhum item na lista"));
          }

          return Column(
            children: [
              ListaTotalHeader(itens: vm.itens),
              Expanded(
                child: ListView.builder(
                  itemCount: vm.itens.length,
                  itemBuilder: (_, index) {
                    final item = vm.itens[index];

                    return ListaItemTile(
                      item: item,
                      onLongPress: () {
                        ItemActionsSheet.show(
                          context,
                          item,
                          widget.listaId,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: ListaFabMenu(
        onAddItem: _abrirCriarItem,
        onAddCategoria: () {
          CategoriaBottomSheet.show(context);
        },
      ),
    );
  }
}
