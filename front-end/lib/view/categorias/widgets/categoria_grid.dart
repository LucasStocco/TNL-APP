import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'categoria_card.dart';

class CategoriaGrid extends StatefulWidget {
  const CategoriaGrid({super.key});

  @override
  State<CategoriaGrid> createState() => _CategoriaGridState();
}

class _CategoriaGridState extends State<CategoriaGrid> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriaViewModel>().listar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriaViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Categoria> categorias = vm.categorias;

        if (categorias.isEmpty) {
          return const Center(
            child: Text("Nenhuma categoria"),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            return CategoriaCard(
              categoria: categorias[index],
            );
          },
        );
      },
    );
  }
}
