import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemActionsSheet {
  static void show(
    BuildContext context,
    Item item,
    int listaId,
  ) {
    final vm = context.read<ItemViewModel>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            // ================= EDITAR =================
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar item"),
              onTap: () {
                Navigator.pop(context);
                _abrirEdicao(context, item, listaId);
              },
            ),

            // ================= MARCAR =================
            ListTile(
              leading: const Icon(Icons.check),
              title: Text(item.comprado ? "Desmarcar" : "Marcar comprado"),
              onTap: () async {
                Navigator.pop(context);

                await vm.marcarComprado(
                  listaId,
                  item.id,
                  !item.comprado,
                );
              },
            ),

            // ================= DELETAR =================
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Deletar"),
              onTap: () async {
                Navigator.pop(context);

                await vm.deletar(listaId, item.id);
              },
            ),
          ],
        );
      },
    );
  }

  // ================= EDITAR ITEM =================
  static void _abrirEdicao(
    BuildContext context,
    Item item,
    int listaId,
  ) {
    final vm = context.read<ItemViewModel>();

    final quantidadeController =
        TextEditingController(text: item.quantidade.toString());

    final precoController =
        TextEditingController(text: item.preco.toStringAsFixed(2));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Editar item",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ================= QUANTIDADE =================
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantidade",
                ),
              ),

              const SizedBox(height: 12),

              // ================= PREÇO =================
              TextField(
                controller: precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Preço",
                ),
              ),

              const SizedBox(height: 20),

              // ================= BOTÃO SALVAR =================
              ElevatedButton(
                onPressed: () async {
                  final quantidade =
                      int.tryParse(quantidadeController.text) ?? 1;

                  final preco = double.tryParse(precoController.text) ?? 0.0;

                  Navigator.pop(ctx);

                  await vm.atualizar(
                    listaId: listaId,
                    idItem: item.id,
                    quantidade: quantidade,
                    preco: preco,
                  );
                },
                child: const Text("Salvar"),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
