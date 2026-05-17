import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:crud_flutter/shared/mappers/categoria_color_mapper.dart';
import 'package:flutter/material.dart';

class ListaItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onLongPress;
  final VoidCallback onDoubleTap; // 👈 novo

  const ListaItemTile({
    super.key,
    required this.item,
    required this.onLongPress,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoria = item.produto.nomeCategoria;

    final corCategoria = categoria != null
        ? CategoriaColorMapper.cor(categoria)
        : Colors.grey.shade200;

    return GestureDetector(
      onDoubleTap: onDoubleTap, // 👈 ação de toggle

      child: ListTile(
        onLongPress: onLongPress,

        // 🔲 quadrado status
        leading: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: item.comprado ? Colors.green : Colors.transparent,
            border: Border.all(
              color: item.comprado ? Colors.green : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // nome + categoria
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.produto.nome,
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (categoria != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: corCategoria.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  categoria,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ],
        ),

        subtitle: Text(
          "Qtd: ${item.quantidade} • R\$ ${item.preco.toStringAsFixed(2)}",
        ),
      ),
    );
  }
}
