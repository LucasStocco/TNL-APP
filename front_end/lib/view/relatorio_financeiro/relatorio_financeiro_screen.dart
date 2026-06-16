import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_flutter/view/relatorio_financeiro/widgets/empty_meus_relatorios_widget.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:crud_flutter/view_model/relatorio_financeiro/financeiro_view_model.dart';

import 'widgets/relatorio_card.dart';
import 'widgets/relatorio_grafico.dart';
import 'widgets/relatorio_header.dart';

class RelatorioFinanceiroScreen extends StatefulWidget {
  const RelatorioFinanceiroScreen({super.key});

  @override
  State<RelatorioFinanceiroScreen> createState() =>
      _RelatorioFinanceiroScreenState();
}

class _RelatorioFinanceiroScreenState
    extends State<RelatorioFinanceiroScreen> {
  Lista? _listaSelecionada;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ListaViewModel>().listar();
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
            final listaVm = context.watch<ListaViewModel>();
            if (viewModel.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (listaVm.listas.isEmpty) {
              return const EmptyMeusRelatoriosWidget();
            } 

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RelatorioHeader(),

                  const SizedBox(height: 32),

                  Consumer<ListaViewModel>(
                    builder: (context, listaVm, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Lista>(
                            isExpanded: true,
                            hint: const Text('Selecione uma lista'),
                            value: _listaSelecionada,
                            items: listaVm.listas
                                .map(
                                  (lista) => DropdownMenuItem<Lista>(
                                    value: lista,
                                    child: Text(
                                      lista.nome,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (lista) {
                              if (lista == null) return;

                              setState(() {
                                _listaSelecionada = lista;
                              });

                              context
                                  .read<FinanceiroViewModel>()
                                  .carregarRelatorio(
                                    listaId: lista.id,
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: RelatorioCard(
                      titulo: 'Total geral',
                      valor: formatarMoeda(viewModel.total),
                      backgroundColor: const Color(0xFFF1F1F1),
                    ),
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
                          valor: '${viewModel.gastosPorCategoria.length}',
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

                  const SizedBox(height: 24),

                  RelatorioGraficoListas(
                    dados: viewModel.gastosPorLista,
                    media: viewModel.mediaGasto,
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