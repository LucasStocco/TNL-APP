// Flutter & Packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';

// Views
import 'package:crud_flutter/view/categorias/categoria_detalhes_screen.dart';
import 'package:crud_flutter/view/categorias/categorias_screen.dart';
import 'package:crud_flutter/view/settings_screen.dart';
import 'package:crud_flutter/view/relatorio_financeiro/relatorio_screen.dart';
import 'package:crud_flutter/view/gerenciar_lista/criar_nova_lista_screen.dart';
import 'package:crud_flutter/view/gerenciar_lista/minhas_listas_screen.dart';
import 'package:crud_flutter/view/auto_cadastro/user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryCard(
                      'assets/icons/ic_bebidas.png', 'Bebidas', 'BEBIDAS'),
                  _buildCategoryCard('assets/icons/ic_hortifrut.png',
                      'Hortifrut', 'HORTIFRUTI'),
                  _buildCategoryCard(
                      'assets/icons/ic_padaria.png', 'Padaria', 'PADARIA'),
                  _buildCategoryCard(
                      'assets/icons/ic_acougue.png', 'Carnes', 'CARNES'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/img_super_oferta.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      const CategoriasScreen(),
      const SizedBox(),
      const MinhasListasScreen(),
      const RelatorioScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CriarNovaListaScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildCategoryCard(String imagePath, String label, String codigo) {
    return GestureDetector(
      onTap: () {
        final listaVm = context.read<ListaViewModel>();

        if (listaVm.listaAtual == null) {
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
            builder: (_) => CategoriaDetalhesScreen(
              nomeCategoria: label,
              codigoCategoria: codigo,
              idLista: listaVm.listaAtual!.id!, // ✅ CORRETO
            ),
          ),
        );
      },
      child: Container(
        width: 70,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(imagePath, width: 50, height: 50),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.red,
        title: Text(
          "TáNaLista",
          style: GoogleFonts.delius(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: ''),
        ],
      ),
    );
  }
}
