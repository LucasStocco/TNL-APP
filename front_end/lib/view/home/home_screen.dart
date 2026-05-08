import 'package:crud_flutter/view/home/widgets/home_header_widget.dart';
import 'package:flutter/material.dart';

import 'package:crud_flutter/shared/widgets/navigation/app_navigation_bar.dart';
import 'package:crud_flutter/view/categorias/categorias_screen.dart';
import 'package:crud_flutter/view/home/widgets/home_content_container.dart';

import '../gerenciar_lista/criar_nova_lista_screen.dart';
import '../gerenciar_lista/minhas_listas_screen.dart';
import '../relatorio_financeiro/relatorio_screen.dart';

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
      // 🏠 HOME
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/img_super_oferta.jpg',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),

      // 📂 CATEGORIAS
      const CategoriasScreen(),

      // ➕ (botão central - não usa página)
      const SizedBox(),

      // 🛒 LISTAS
      const MinhasListasScreen(),

      // 📊 RELATÓRIO
      const RelatorioScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CriarNovaListaScreen()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔥 HEADER DINÂMICO
  AppHeaderWidget _buildHeader() {
    switch (_selectedIndex) {
      case 0:
        return const AppHeaderWidget(
          title: "TáNaLista",
          subtitle: "Organize suas compras no",
        );

      case 1:
        return const AppHeaderWidget(
          title: "Categorias",
          subtitle: "Organize por tipo",
        );

      case 3:
        return const AppHeaderWidget(
          title: "Minhas Listas",
          subtitle: "Gerencie suas compras",
        );

      case 4:
        return const AppHeaderWidget(
          title: "Relatório",
          subtitle: "Acompanhe seus gastos",
        );

      default:
        return const AppHeaderWidget(
          title: "TáNaLista",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isHome = _selectedIndex == 0;

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      body: Stack(
        children: [
          // 🔴 HEADER DINÂMICO
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(),
          ),

          // ⚪ CONTEÚDO
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
            top: isHome ? 200 : 0,
            left: 0,
            right: 0,
            bottom: isHome ? 90 : 0,
            child: isHome
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeContentContainer(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _pages[_selectedIndex],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _pages[_selectedIndex],
                      ),
                    ),
                  ),
          ),

          // 🔥 NAVBAR
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: AppNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
