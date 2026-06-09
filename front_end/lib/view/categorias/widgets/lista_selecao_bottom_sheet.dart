import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaSelecaoBottomSheet {
  static void show({
    required BuildContext context,
    required int produtoId,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final listaVM = ctx.read<ListaViewModel>();

        // 🔥 carrega uma única vez
        if (listaVM.listas.isEmpty && !listaVM.isLoading) {
          Future.microtask(() => listaVM.listar());
        }

        return Consumer<ListaViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final listas = vm.listas;

            if (listas.isEmpty) {
              return Center(
                child: Text(
                  "Nenhuma lista encontrada",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                  "Escolha uma lista",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ),
                ...listas.map((lista) {
                  return ListTile(
                      leading: Icon(
                        Icons.list,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(lista.nome),
                      onTap: () async {
                        final itemVM = context.read<ItemViewModel>();
                        final precoController = TextEditingController();

                        // 🔥 fecha bottom sheet
                        Navigator.pop(context);

                        // 🔥 garante flush da UI sem usar mounted
                        await Future.delayed(const Duration(milliseconds: 100));

                        // 🔥 usa root context seguro
                        if (!ctx.mounted) return;

                        await showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text("Definir preço"),
                            content: TextField(
                              controller: precoController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Digite o preço",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final preco =
                                      double.tryParse(precoController.text) ??
                                          0;

                                  await itemVM.criar(
                                    listaId: lista.id!,
                                    idProduto: produtoId,
                                    quantidade: 1,
                                    preco: preco,
                                  );

                                  Navigator.pop(dialogContext);
                                },
                                child: const Text("Adicionar"),
                              ),
                            ],
                          ),
                        );
                      });
                }),
              ],
            );
          },
        );
      },
    );
  }
}
