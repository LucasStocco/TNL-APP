import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:crud_flutter/view/categorias/widgets/categoria_dialogs.dart';
import 'package:flutter/material.dart';

class CategoriaActions {
  static void show(BuildContext context, Categoria categoria) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Renomear"),
              onTap: () {
                Navigator.pop(context);
                CategoriaDialogs.rename(context, categoria);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Excluir"),
              onTap: () {
                Navigator.pop(context);
                CategoriaDialogs.delete(context, categoria);
              },
            ),
          ],
        );
      },
    );
  }
}
