import 'package:flutter/material.dart';

class ListaEmptyState extends StatelessWidget {
  final VoidCallback onAddItem;

  const ListaEmptyState({
    super.key,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              "Sua lista está vazia",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "Adicione seu primeiro item para começar",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAddItem,
              child: const Text("Adicionar item"),
            ),
          ],
        ),
      ),
    );
  }
}