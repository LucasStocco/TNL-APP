import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:flutter/material.dart';

class ListaTotalHeader extends StatelessWidget {
  final List<Item> itens;

  const ListaTotalHeader({
    super.key,
    required this.itens,
  });

  double _calcularTotal() {
    // Se ainda não tem preço, retorna 0 por enquanto
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final total = _calcularTotal();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: Text(
        "Total: R\$ ${total.toStringAsFixed(2)}",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
