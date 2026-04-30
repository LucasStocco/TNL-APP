import 'package:flutter/material.dart';

class ListaFabMenu extends StatelessWidget {
  final VoidCallback onAddItem;
  final VoidCallback onAddCategoria;

  const ListaFabMenu({
    super.key,
    required this.onAddItem,
    required this.onAddCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: "cat",
          onPressed: onAddCategoria,
          label: const Text("Categoria"),
          icon: const Icon(Icons.category),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: "item",
          onPressed: onAddItem,
          label: const Text("Item"),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
