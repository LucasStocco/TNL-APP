import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../view_model/cadastrar_categoria/categoria_view_model.dart';
import '../../view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';

import '../../service/cadastrar_produto/produto_service.dart';
import '../../service/gerenciar_lista/item_service.dart';

import 'categoria_produtos_screen.dart';

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

        final categorias = vm.categorias;

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
            final categoria = categorias[index];

            return _CategoriaCard(
              categoria: categoria,
            );
          },
        );
      },
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final dynamic categoria; // depois tipamos melhor se quiser

  const _CategoriaCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          print("CLICOU NA CATEGORIA");

          final produtoService = context.read<ProdutoService>();
          final itemService = context.read<ItemService>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => CategoriaDetalhesViewModel(
                  produtoService: produtoService,
                  itemService: itemService,
                  idCategoria: categoria.id,
                ),
                child: CategoriasProdutosScreen(
                  nomeCategoria: categoria.nome,
                  idCategoria: categoria.id,
                ),
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.category, size: 40),
              const SizedBox(height: 8),
              Text(
                categoria.nome,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
