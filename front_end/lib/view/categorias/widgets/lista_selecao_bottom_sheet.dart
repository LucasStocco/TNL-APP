import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/gerenciar_lista/item_service.dart';

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
      builder: (_) {
        return Consumer<ListaViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 🔥 força carregamento inicial
            if (vm.listas.isEmpty) {
              Future.microtask(() {
                context.read<ListaViewModel>().listar();
              });

              return const Center(child: CircularProgressIndicator());
            }

            final listas = vm.listas;

            return ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Escolha uma lista",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...listas.map((lista) {
                  return ListTile(
                    leading: const Icon(Icons.list),
                    title: Text(lista.nome),
                    onTap: () async {
                      final service = context.read<ItemService>();

                      await service.adicionarProdutoNaLista(
                        listaId: lista.id!,
                        produtoId: produtoId,
                      );

                      Navigator.pop(context);

                      // snackbar de confirmação
                      OverlayEntry entry = OverlayEntry(
                        builder: (context) => Positioned(
                          bottom: 80,
                          left: 20,
                          right: 20,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.check, color: Colors.white),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Produto adicionado com sucesso",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                      Overlay.of(context).insert(entry);

                      Future.delayed(const Duration(seconds: 2), () {
                        entry.remove();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Produto adicionado em ${lista.nome}",
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
