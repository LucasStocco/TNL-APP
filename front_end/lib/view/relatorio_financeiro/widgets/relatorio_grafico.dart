import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../model/relatorio_financeiro/financeiro.dart';

class RelatorioGraficoCategorias extends StatelessWidget {
  final List<GastoPorCategoriaModel> dados;

  const RelatorioGraficoCategorias({
    super.key,
    required this.dados,
  });

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final maiorValor = dados.isEmpty
        ? 1.0
        : dados.map((e) => e.total).reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gasto por categoria',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF22202A),
            ),
          ),
          const SizedBox(height: 22),
          if (dados.isEmpty)
            const Text('Selecione uma lista para ver os gastos por categoria.')
          else
            ...dados.map((item) {
              final porcentagem =
                  maiorValor == 0 ? 0.0 : item.total / maiorValor;

              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.categoria,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF22202A),
                          ),
                        ),
                        Text(
                          _formatarMoeda(item.total),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        value: porcentagem,
                        backgroundColor: const Color(0xFFE1E1E1),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class RelatorioGraficoListas extends StatelessWidget {
  final List<GastoPorListaModel> dados;
  final double media;

  const RelatorioGraficoListas({
    super.key,
    required this.dados,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final maiorValor = dados.isEmpty
        ? 1.0
        : dados.map((e) => e.total).reduce((a, b) => a > b ? a : b);

    final maxY = maiorValor + 30;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total por lista',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF22202A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Linha média: R\$ ${media.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFFE1E1E1),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: media,
                      color: const Color(0xFF45B654),
                      strokeWidth: 2,
                      dashArray: [6, 4],
                    ),
                  ],
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= dados.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            dados[index].lista.length > 8
                                ? '${dados[index].lista.substring(0, 8)}...'
                                : dados[index].lista,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF777777),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  dados.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dados[index].total,
                        width: 22,
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF6C63FF),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}