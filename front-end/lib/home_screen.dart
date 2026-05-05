// Flutter & Packages
import 'package:crud_flutter/view/categorias/home_widgets/category_section.dart';
import 'package:crud_flutter/view/categorias/home_widgets/promo_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';

// Views
import 'package:crud_flutter/view/categorias/categoria_produtos_screen.dart';
import 'package:crud_flutter/view/categorias/categorias_screen.dart';
import 'package:crud_flutter/view/relatorio_financeiro/relatorio_screen.dart';
import 'package:crud_flutter/view/gerenciar_lista/minhas_listas_screen.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriaViewModel>().listar();
    });
  }

  void _openCategory(String label, int idCategoria) {
    final listaVm = context.read<ListaViewModel>();
    final lista = listaVm.listaAtual;

    if (lista == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione uma lista primeiro"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoriasProdutosScreen(
          nomeCategoria: label,
          idCategoria: idCategoria,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriaVM = context.watch<CategoriaViewModel>();

    final pages = [
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategorySection(
              categorias: categoriaVM.categorias,
              onTapCard: (categoria) => _openCategory(
                categoria.nome,
                categoria.id,
              ),
            ),
            const SizedBox(height: 24),
            const PromoBanner(),
          ],
        ),
      ),
      const CategoriasScreen(),
      const SizedBox(),
      const MinhasListasScreen(),
      const RelatorioScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
    );
  }
}
