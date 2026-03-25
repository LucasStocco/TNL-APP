import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/item.dart';
import '../view_model/item_view_model.dart';
import '../view_model/produto_view_model.dart';
import 'cadastro_item_screen.dart';

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
      final itemVM = context.read<ItemViewModel>();
      final produtoVM = context.read<ProdutoViewModel>();

      itemVM.carregar(widget.listaId);
      produtoVM.carregar();
    });
  }

  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2)}';
  }

  Future<void> _recarregarItens() async {
    final itemVM = context.read<ItemViewModel>();
    await itemVM.carregar(widget.listaId);
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

          if (itemVM.itens.isEmpty) {
            return const Center(child: Text('Nenhum item encontrado'));
          }

          return ListView.builder(
            itemCount: itemVM.itens.length,
            itemBuilder: (context, index) {
              final item = itemVM.itens[index];

              return GestureDetector(
                onTap: () async {
                  final atualizado = Item(
                    id: item.id,
                    quantidade: item.quantidade,
                    comprado: !item.comprado,
                    produto: item.produto,
                  );

                  await itemVM.atualizar(widget.listaId, atualizado);
                  await _recarregarItens(); // atualiza UI
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: item.comprado
                        ? Colors.greenAccent.withOpacity(0.3)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(
                      item.produto.nome,
                      style: TextStyle(
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      'Qtd: ${item.quantidade} | Preço: ${_formatarPreco(item.produto.preco)}',
                    ),
                    leading: Icon(
                      item.comprado
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: item.comprado ? Colors.green : null,
                    ),
                    trailing: const Icon(Icons.more_vert),
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ATUALIZAR
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Atualizar'),
                              onTap: () async {
                                Navigator.pop(context);

                                final itemAtualizado =
                                    await Navigator.push<Item>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CriarItemScreen(
                                      item: item,
                                      listaId: widget.listaId,
                                    ),
                                  ),
                                );

                                if (itemAtualizado != null) {
                                  await itemVM.atualizar(
                                    widget.listaId,
                                    itemAtualizado,
                                  );
                                  await _recarregarItens(); // 🔥
                                }
                              },
                            ),

                            // DELETAR
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Deletar'),
                              onTap: () async {
                                Navigator.pop(context);

                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Confirmação'),
                                    content: const Text(
                                        'Deseja realmente deletar este item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Não'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Sim'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true && item.id != null) {
                                  await itemVM.deletar(
                                      widget.listaId, item.id!);
                                  await _recarregarItens(); // 🔥
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      // BOTÃO ADICIONAR
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final itemVM = context.read<ItemViewModel>();

          final novoItem = await Navigator.push<Item>(
            context,
            MaterialPageRoute(
              builder: (_) => CriarItemScreen(listaId: widget.listaId),
            ),
          );

          if (novoItem != null) {
            await itemVM.criar(widget.listaId, novoItem);
            await _recarregarItens();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
