import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/cadastrar_categoria/categoria_view_model.dart';

import 'widgets/categoria_card.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
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
          return const Center(child: Text("Nenhuma categoria"));
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
