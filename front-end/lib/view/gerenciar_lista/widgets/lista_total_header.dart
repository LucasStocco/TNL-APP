import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:flutter/material.dart';

class ListaTotalHeader extends StatelessWidget {
  final List<Item> itens;

  const ListaTotalHeader({
    super.key,
    required this.itens,
  });

  double _calcularTotalValor() {
    return itens.fold(0.0, (total, item) {
      return total + (item.preco * item.quantidade);
    });
  }

  int _totalItens() {
    return itens.fold(0, (total, item) {
      return total + item.quantidade;
    });
  }

  int _itensComprados() {
    return itens
        .where((item) => item.comprado)
        .fold(0, (total, item) => total + item.quantidade);
  }

  int _itensPendentes() {
    return itens
        .where((item) => !item.comprado)
        .fold(0, (total, item) => total + item.quantidade);
  }

  @override
  Widget build(BuildContext context) {
    final totalValor = _calcularTotalValor();
    final comprados = _itensComprados();
    final pendentes = _itensPendentes();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total: R\$ ${totalValor.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // 🔥 COMPRADOS (VERDE)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Comprados: $comprados",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ⚠️ PENDENTES (AMARELO / VERMELHO)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  pendentes == 0 ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Pendentes: $pendentes",
              style: TextStyle(
                color: pendentes == 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
