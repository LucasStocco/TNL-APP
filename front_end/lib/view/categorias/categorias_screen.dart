import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:crud_flutter/shared/helpers/bottom_nav_padding.dart';
import 'package:crud_flutter/shared/widgets/navigation/section_header.dart';
import 'package:crud_flutter/view/categorias/widgets/categoria_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/cadastrar_categoria/categoria_view_model.dart';

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

        return SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER COM BOTÃO
              SectionHeader(
                title: "Categorias",
                subtitle: "Organize seus itens por tipo",
                isGrid: vm.isGrid,
                onToggleLayout: vm.toggleLayout,
              ),

              // GRID / LIST
              Expanded(
                child: vm.isGrid
                    ? GridView.builder(
                        key: const ValueKey('categorias_grid'),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                      )
                    : ListView.builder(
                        key: const ValueKey('categorias_list'),
                        padding: EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          bottomNavPadding(context),
                        ),
                        itemCount: categorias.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CategoriaCard(
                              categoria: categorias[index],
                              isHorizontal: true,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
