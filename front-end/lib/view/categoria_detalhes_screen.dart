import 'package:crud_flutter/my_widgets/app_navigation_bar.dart';
import 'package:crud_flutter/view/criar_nova_lista_screen.dart';
import 'package:crud_flutter/view/home_screen.dart';
import 'package:crud_flutter/view/minhas_listas_screen.dart';
import 'package:crud_flutter/view/categorias_screen.dart';
import 'package:crud_flutter/view/relatorio_screen.dart';
import 'package:flutter/material.dart';

class CategoriaDetalhesScreen extends StatefulWidget {
  final String nomeCategoria; // nome da categoria dinamicamente

  const CategoriaDetalhesScreen({super.key, required this.nomeCategoria});

  @override
  State<CategoriaDetalhesScreen> createState() =>
      _CategoriaDetalhesScreenState();
}

class _CategoriaDetalhesScreenState extends State<CategoriaDetalhesScreen> {
  int _selectedIndex = 1; // ícone "Categorias" ativo por padrão

  void _onItemTapped(int index) {
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 1: // Categorias
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CategoriasScreen()),
        );
        break;
      case 2: // "+"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CriarNovaListaScreen()),
        );
        break;
      case 3: // Minhas Listas
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MinhasListasScreen()),
        );
        break;
      case 4: // Relatórios
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RelatorioScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // fundo branco
      appBar: AppBar(
        title: Text(
          widget.nomeCategoria,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // aqui você pode adicionar a lista de produtos ou cards da categoria
            Center(
              child: Text(
                'Itens da categoria ${widget.nomeCategoria} aparecerão aqui',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
