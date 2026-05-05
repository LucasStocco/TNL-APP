import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:flutter/material.dart';

class ListaItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onLongPress;

  const ListaItemTile({
    super.key,
    required this.item,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.nomeProduto),
      subtitle: Text(
        "Qtd: ${item.quantidade} • ${item.nomeCategoria} • R\$ ${item.preco.toStringAsFixed(2)}",
      ),
      trailing: Icon(
        item.comprado ? Icons.check_circle : Icons.radio_button_unchecked,
        color: item.comprado ? Colors.green : null,
      ),
      onLongPress: onLongPress,
    );
  }
}
