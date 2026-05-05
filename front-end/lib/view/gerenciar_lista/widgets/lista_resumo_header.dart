import 'package:flutter/material.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';

class ListaResumoHeader extends StatelessWidget {
  final List<Item> itens;

  const ListaResumoHeader({
    super.key,
    required this.itens,
  });

  double get total {
    return itens.fold(
      0.0,
      (sum, item) => sum + (item.preco * item.quantidade),
    );
  }

  int get comprados {
    return itens
        .where((i) => i.comprado)
        .fold(0, (sum, i) => sum + i.quantidade);
  }

  int get pendentes {
    return itens
        .where((i) => !i.comprado)
        .fold(0, (sum, i) => sum + i.quantidade);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TOTAL =================
            Text(
              "Total da lista",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              "R\$ ${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // ================= STATUS =================
            Row(
              children: [
                Expanded(
                  child: _StatusCard(
                    label: "Comprados",
                    value: comprados,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatusCard(
                    label: "Pendentes",
                    value: pendentes,
                    color: pendentes == 0 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatusCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
