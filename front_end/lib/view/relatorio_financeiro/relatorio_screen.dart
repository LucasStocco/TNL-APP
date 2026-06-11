import 'package:flutter/material.dart';

import 'relatorio_financeiro_screen.dart';
import 'relatorio_item_screen.dart';

import 'package:crud_flutter/view/relatorio_item/relatorio_item_screen.dart';

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFFDF7FF),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 24),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Relatórios',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22202A),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: TabBar(
                  labelColor: Color(0xFFFF3B30),
                  unselectedLabelColor: Color(0xFF9B9B9B),
                  indicatorColor: Color(0xFFFF3B30),
                  tabs: [
                    Tab(text: 'Financeiro'),
                    Tab(text: 'Compras'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    RelatorioFinanceiroScreen(),
                    RelatorioItemScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}