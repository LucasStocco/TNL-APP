import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/relatorio_financeiro/financeiro_view_model.dart';
import 'widgets/relatorio_card.dart';
import 'widgets/relatorio_grafico.dart';
import 'widgets/relatorio_header.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FinanceiroViewModel>().carregarRelatorio();
    });
  }

  String formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FF),
      body: SafeArea(
        child: Consumer<FinanceiroViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RelatorioHeader(),

                  const SizedBox(height: 32),

                  RelatorioCard(
                    titulo: 'Total geral',
                    valor: formatarMoeda(viewModel.total),
                    backgroundColor: const Color(0xFFF1F1F1),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: RelatorioCard(
                          titulo: 'Média',
                          valor: formatarMoeda(viewModel.mediaGasto),
                          backgroundColor: const Color(0xFFEAF5EC),
                          textColor: const Color(0xFF45B654),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RelatorioCard(
                          titulo: 'Categorias',
                          valor:
                              '${viewModel.gastosPorCategoria.length}',
                          backgroundColor: const Color(0xFFFFF3DE),
                          textColor: const Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  RelatorioGraficoCategorias(
                    dados: viewModel.gastosPorCategoria,
                  ),

                  if (viewModel.erro != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      viewModel.erro!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}