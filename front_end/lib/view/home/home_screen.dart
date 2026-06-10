import 'package:crud_flutter/view/home/widgets/home_carousel.dart';
import 'package:crud_flutter/view/home/widgets/home_header_widget.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_flutter/shared/widgets/navigation/app_navigation_bar.dart';
import 'package:crud_flutter/view/categorias/categorias_screen.dart';
import 'package:crud_flutter/view/home/widgets/home_content_container.dart';

import '../gerenciar_lista/criar_nova_lista_screen.dart';
import '../gerenciar_lista/minhas_listas_screen.dart';
import '../relatorio_financeiro/relatorio_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? initialFilter;

  const HomeScreen({
    super.key,
    this.initialFilter,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  bool _showSettingsFeedback = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // TESTE: listas pendentes (< 100%)
    /*
  Future.microtask(() {
    context.read<ListaResumoViewModel>()
      .aplicarFiltro('pendentes');
  });
  */

    // TESTE: listas urgentes (< 30%)
    /*
  Future.microtask(() {
    context.read<ListaResumoViewModel>()
      .aplicarFiltro('urgentes');
  });
  */

    // TESTE: listas quase concluídas (<= 70% e < 100%)
    /*
  Future.microtask(() {
    context.read<ListaResumoViewModel>()
      .aplicarFiltro('quase_concluidas');
  });
  */
                         
    _pages = [
      const HomeCarousel(),
      const CategoriasScreen(),
      const SizedBox(),
      const MinhasListasScreen(),
      const RelatorioScreen(),
    ];

    if (widget.initialFilter != null) {
      _selectedIndex = 3;

      Future.microtask(() {
        context
            .read<ListaResumoViewModel>()
            .aplicarFiltro(widget.initialFilter);
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CriarNovaListaScreen()),
      );
      return;
    }

    void showSettingsFeedback() {
      setState(() {
        _showSettingsFeedback = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _showSettingsFeedback = false;
        });
      });
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
      backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : const Color(0xFFD32F2F),
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
            top: isHome ? 180 : 0,
            left: 0,
            right: 0,
            bottom: isHome ? 90 : 0,
            child: isHome
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: HomeContentContainer(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _pages[_selectedIndex],
                        ),
                      ),
                    ),
                  )
                : Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
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
            child: SafeArea(
              top: false,
            child: AppNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
          )
        ],
      ),
    );
  }
}
