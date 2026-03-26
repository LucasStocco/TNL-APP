import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/item.dart';
import '../view_model/item_view_model.dart';
import 'criar_item_screen.dart';

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
    // Carrega itens da lista ao iniciar
    Future.microtask(() {
      context.read<ItemViewModel>().listar(widget.listaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Itens: ${widget.listaNome}')),
      body: Consumer<ItemViewModel>(
        builder: (context, itemVM, _) {
          if (itemVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (itemVM.erro != null) {
            return Center(child: Text(itemVM.erro!));
          }

          if (itemVM.itens.isEmpty) {
            return const Center(child: Text('Nenhum item encontrado'));
          }

          return ListView.builder(
            itemCount: itemVM.itens.length,
            itemBuilder: (context, index) {
              final item = itemVM.itens[index];

              return ListTile(
                title: Text(
                  item.produto.nome,
                  style: TextStyle(
                    decoration:
                        item.comprado ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  'Qtd: ${item.quantidade} | Categoria: ${item.produto.categoria.nome}',
                ),
                leading: Icon(
                  item.comprado
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: item.comprado ? Colors.green : null,
                ),
                trailing: const Icon(Icons.more_vert),

                // MARCAR COMO COMPRADO
                onTap: () async {
                  final atualizado = item.copyWith(comprado: !item.comprado);
                  await context
                      .read<ItemViewModel>()
                      .atualizar(widget.listaId, atualizado);
                },

                // MENU EDITAR / DELETAR
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Atualizar'),
                          onTap: () async {
                            Navigator.pop(context);
                            final itemEditado = await Navigator.push<Item>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CriarItemScreen(
                                  listaId: widget.listaId,
                                  item: item,
                                ),
                              ),
                            );

                            if (itemEditado != null) {
                              await context
                                  .read<ItemViewModel>()
                                  .atualizar(widget.listaId, itemEditado);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Deletar'),
                          onTap: () async {
                            Navigator.pop(context);
                            if (item.id != null) {
                              await context
                                  .read<ItemViewModel>()
                                  .deletar(widget.listaId, item.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      // BOTÃO DE CRIAR ITEM
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(
              builder: (_) => CriarItemScreen(
                listaId: widget.listaId,
              ),
            ),
          );

          if (novoItem != null) {
            // Adiciona item na lista imediatamente e notifica a UI
            await context.read<ItemViewModel>().criar(widget.listaId, novoItem);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
