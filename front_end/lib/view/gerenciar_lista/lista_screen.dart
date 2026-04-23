import 'package:crud_flutter/dto/item_global_dto.dart';
import 'package:crud_flutter/dto/item_manual_dto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/gerenciar_lista/item_view_model.dart';
import '../../view_model/cadastrar_categoria/categoria_view_model.dart';
import '../../model/cadastrar_produto/item.dart';

import '../cadastrar_produto/criar_item_screen.dart';

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
  bool _fabExpanded = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ItemViewModel>().carregarItens(widget.listaId);
      context.read<CategoriaViewModel>().listar();
    });
  }

  void _toggleFab() => setState(() => _fabExpanded = !_fabExpanded);

  void _abrirCriarCategoria() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Nova Categoria",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Nome da categoria",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final nome = controller.text.trim();
                  if (nome.isEmpty) return;

                  await context.read<CategoriaViewModel>().criar(nome);

                  await context.read<CategoriaViewModel>().listar();

                  Navigator.pop(context);
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

  // ================= MENU ITEM (🔥 EDITAR / DELETAR / COMPRADO) =================
  void _abrirMenu(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CriarItemScreen(
                      listaId: widget.listaId,
                      item: item,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: Text(item.comprado ? "Desmarcar" : "Marcar comprado"),
              onTap: () async {
                Navigator.pop(context);

                await context.read<ItemViewModel>().marcarComprado(
                      widget.listaId,
                      item.id!,
                      true,
                    );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Deletar"),
              onTap: () async {
                Navigator.pop(context);

                await context.read<ItemViewModel>().deletarItem(
                      widget.listaId,
                      item.id!,
                    );
              },
            ),
          ],
        );
      },
    );
  }

  // ================= TOTAL =================
  double _calcularTotal(List<Item> itens) =>
      itens.fold(0.0, (s, i) => s + i.valorTotal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.listaNome)),

      body: Consumer<ItemViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.itens.isEmpty) {
            return const Center(child: Text("Nenhum item"));
          }

          final total = _calcularTotal(vm.itens);

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: Colors.green.shade50,
                child: Text(
                  "Total: R\$ ${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: vm.itens.length,
                  itemBuilder: (_, i) {
                    final item = vm.itens[i];

                    return ListTile(
                      title: Text(item.nomeProdutoSnapshot),
                      subtitle: Text(
                        "Qtd: ${item.quantidade} • ${item.nomeCategoriaSnapshot}",
                      ),
                      trailing: Text(
                        "R\$ ${item.valorTotal.toStringAsFixed(2)}",
                      ),

                      // 🔥 MENU AQUI
                      onLongPress: () => _abrirMenu(context, item),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // ================= FAB =================
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_fabExpanded) ...[
            FloatingActionButton.extended(
              heroTag: "cat",
              onPressed: () {
                _toggleFab();
                _abrirCriarCategoria();
              },
              label: const Text("Categoria"),
              icon: const Icon(Icons.category),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              heroTag: "item",
              onPressed: () {
                _toggleFab();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CriarItemScreen(
                      listaId: widget.listaId,
                    ),
                  ),
                );
              },
              label: const Text("Item"),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            onPressed: _toggleFab,
            child: Icon(_fabExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }
}
