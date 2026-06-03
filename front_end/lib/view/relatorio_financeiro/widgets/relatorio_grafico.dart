import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../model/relatorio_financeiro/financeiro.dart';

class RelatorioGraficoCategorias extends StatelessWidget {
  final List<GastoPorCategoriaModel> dados;

  const RelatorioGraficoCategorias({
    super.key,
    required this.dados,
  });

  @override
  Widget build(BuildContext context) {
    final maiorValor = dados.isEmpty
        ? 1.0
        : dados.map((e) => e.total).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
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
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maiorValor,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 82,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= dados.length) {
                          return const SizedBox();
                        }

                        return Text(
                          dados[index].categoria,
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: List.generate(
                  dados.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dados[index].total,
                        width: 16,
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