import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/cadastrar_categoria/categoria.dart';
import '../../../view_model/cadastrar_categoria/categoria_view_model.dart';

class CategoriaDialogs {
  static void rename(BuildContext context, Categoria categoria) {
    final controller = TextEditingController(text: categoria.nome);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Renomear categoria"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Novo nome",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final novoNome = controller.text.trim();
                if (novoNome.isEmpty) return;

                final vm = context.read<CategoriaViewModel>();

                await vm.atualizar(
                  Categoria(
                    id: categoria.id,
                    nome: novoNome,
                    codigo: categoria.codigo,
                    deletado: categoria.deletado,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  static void delete(BuildContext context, Categoria categoria) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Excluir categoria"),
          content: Text("Deseja excluir '${categoria.nome}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                final vm = context.read<CategoriaViewModel>();

                await vm.deletar(categoria.id);

                Navigator.pop(context);
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }
}
