import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:crud_flutter/view/relatorio_item/enums/tipo_grafico.dart';

class RelatorioGrafico extends StatelessWidget {
  final TipoGrafico tipoGrafico;
  final List<MapEntry<String, double>> dados;
  final Color Function(int i) cor;

  const RelatorioGrafico({
    super.key,
    required this.tipoGrafico,
    required this.dados,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    if (dados.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text('Nenhum dado para exibir',
              style: TextStyle(color: Colors.grey[400])),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: tipoGrafico == TipoGrafico.pizza
                ? _graficoPizza(dados)
                : tipoGrafico == TipoGrafico.barra
                    ? _graficoBarra(dados)
                    : _graficoLinha(dados),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          ..._legenda(dados),
        ],
      ),
    );
  }

  Widget _graficoPizza(List<MapEntry<String, double>> dados) {
    final total = dados.fold<double>(0, (s, e) => s + e.value);
    return PieChart(
      PieChartData(
        sections: dados.asMap().entries.map((e) {
          final pct = e.value.value / total * 100;
          return PieChartSectionData(
            value: e.value.value,
            title: '${pct.toStringAsFixed(1)}%',
            color: cor(e.key),
            radius: 80,
            titleStyle: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _graficoBarra(List<MapEntry<String, double>> dados) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: dados.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i < 0 || i >= dados.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${i + 1}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: dados.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.value,
                color: cor(e.key),
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _graficoLinha(List<MapEntry<String, double>> dados) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: dados.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2,
        lineTouchData: const LineTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i < 0 || i >= dados.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${i + 1}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: dados
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: FlDotData(
              getDotPainter: (spot, _, __, i) => FlDotCirclePainter(
                radius: 5,
                color: cor(i),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData:
                BarAreaData(show: true, color: Colors.red.withOpacity(0.08)),
          ),
        ],
      ),
    );
  }

  List<Widget> _legenda(List<MapEntry<String, double>> dados) {
    return dados
        .asMap()
        .entries
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: cor(e.key), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('${e.key + 1}.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(e.value.key,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis)),
                ],
              ),
            ))
        .toList();
  }
}