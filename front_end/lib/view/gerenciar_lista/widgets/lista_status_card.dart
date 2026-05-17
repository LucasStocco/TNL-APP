import 'package:flutter/material.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';

// CARDS DE STATUS (COMPRADOS X PENDENTES)
class ListaStatusCards extends StatelessWidget {
  final List<Item> itens;

  const ListaStatusCards({
    super.key,
    required this.itens,
  });

  int _comprados() {
    return itens
        .where((i) => i.comprado)
        .fold(0, (total, i) => total + i.quantidade);
  }

  int _pendentes() {
    return itens
        .where((i) => !i.comprado)
        .fold(0, (total, i) => total + i.quantidade);
  }

  @override
  Widget build(BuildContext context) {
    final comprados = _comprados();
    final pendentes = _pendentes();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 🟢 Comprados
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Comprados: $comprados",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 🔴 Pendentes
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    pendentes == 0 ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Pendentes: $pendentes",
                style: TextStyle(
                  color: pendentes == 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
