import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:crud_flutter/shared/mappers/categoria_color_mapper.dart';
import 'package:flutter/material.dart';

class ListaItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onLongPress;
  final VoidCallback onDoubleTap;

  const ListaItemTile({
    super.key,
    required this.item,
    required this.onLongPress,
    required this.onDoubleTap,
  });

  Widget _buildChecked() {
  return Container(
    key: const ValueKey("checked"),
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Icon(
      Icons.check,
      color: Colors.white,
      size: 16,
    ),
  );
}

Widget _buildUnchecked() {
  return Container(
    key: const ValueKey("unchecked"),
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.grey),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final categoria = item.produto.nomeCategoria;

    final corCategoria = categoria != null
        ? CategoriaColorMapper.cor(categoria)
        : Colors.grey.shade200;

    return ListTile(
      onLongPress: onLongPress,
      onTap: onDoubleTap, // mais natural que GestureDetector aqui

      // =========================
      // CHECK ANIMADO
      // =========================
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: item.comprado ? _buildChecked() : _buildUnchecked(),
      ),

      // =========================
      // TITULO + CATEGORIA
      // =========================
      title: Row(
        children: [
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                decoration: item.comprado
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: item.comprado ? Colors.grey : Colors.black,
              ),
              child: Text(
                item.produto.nome,
                overflow: TextOverflow.ellipsis,
              ),
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

      // =========================
      // SUBTITULO
      // =========================
      subtitle: Text(
        "Qtd: ${item.quantidade} • R\$ ${item.preco.toStringAsFixed(2)}",
      ),
    );
  }
}
