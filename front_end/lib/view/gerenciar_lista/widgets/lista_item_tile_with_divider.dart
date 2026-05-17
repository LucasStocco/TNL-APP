import 'package:flutter/material.dart';
import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'lista_item_tile.dart';

class ListaItemTileWithDivider extends StatelessWidget {
  final Item item;
  final bool isLast;
  final VoidCallback onLongPress;
  final VoidCallback onDoubleTap; // 👈 novo

  const ListaItemTileWithDivider({
    super.key,
    required this.item,
    required this.isLast,
    required this.onLongPress,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListaItemTile(
          item: item,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }
}
