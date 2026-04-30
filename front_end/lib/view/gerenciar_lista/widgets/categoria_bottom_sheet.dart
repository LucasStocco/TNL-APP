import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriaBottomSheet {
  static void show(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // 🔥 CORRETO: usar o context do builder
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Nova Categoria",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Nome da categoria",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final nome = controller.text.trim();

                  print("🟡 CLICOU SALVAR");
                  print("🟡 NOME: $nome");

                  if (nome.isEmpty) {
                    print("🔴 Nome vazio");
                    return;
                  }

                  try {
                    final vm = context.read<CategoriaViewModel>();

                    await vm.criar(nome);
                    print("🟢 Categoria criada");

                    await vm.listar();
                    print("🟢 Lista atualizada");

                    Navigator.pop(context);
                  } catch (e) {
                    print("🔴 ERRO AO CRIAR: $e");
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        );
      },
    );
  }
}
