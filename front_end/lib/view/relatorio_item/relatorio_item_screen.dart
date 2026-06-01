import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:crud_flutter/view_model/relatorio_item/relatorio_item_view_model.dart';

enum RelatorioAba { maisComprados, porCategoria, maisCaros, maisBaratos }
enum TipoGrafico { pizza, barra, linha }

class RelatorioItemScreen extends StatefulWidget {
  const RelatorioItemScreen({super.key});

  @override
  State<RelatorioItemScreen> createState() => _RelatorioItemScreenState();
}

class _RelatorioItemScreenState extends State<RelatorioItemScreen> {
  Lista? _listaSelecionada;
  RelatorioAba _abaSelecionada = RelatorioAba.maisComprados;
  TipoGrafico _tipoGrafico = TipoGrafico.pizza;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListaViewModel>().listar();
    });
  }

  void _onListaSelecionada(Lista? lista) {
    if (lista == null) return;
    setState(() => _listaSelecionada = lista);
    context.read<RelatorioItemViewModel>().carregar(lista.id!);
  }

  // =========================
  // CORES
  // =========================
  static const _cores = [
    Color(0xFFE53935),
    Color(0xFF1E88E5),
    Color(0xFF43A047),
    Color(0xFFFB8C00),
    Color(0xFF8E24AA),
    Color(0xFF00ACC1),
    Color(0xFFE91E63),
    Color(0xFF00897B),
  ];

  Color _cor(int i) => _cores[i % _cores.length];

  // =========================
  // DADOS GENÉRICOS POR ABA
  // =========================
  List<MapEntry<String, double>> _dadosAtivos(RelatorioItemViewModel vm) {
    switch (_abaSelecionada) {
      case RelatorioAba.maisComprados:
        return vm.maisComprados
            .map((e) => MapEntry(e.nomeProduto, e.totalQuantidade.toDouble()))
            .toList();
      case RelatorioAba.porCategoria:
        return vm.porCategoria
            .map((e) => MapEntry(e.nomeCategoria, e.totalGasto))
            .toList();
      case RelatorioAba.maisCaros:
        return vm.maisCaros
            .map((e) => MapEntry(e.nomeProduto, e.preco))
            .toList();
      case RelatorioAba.maisBaratos:
        return vm.maisBaratos
            .map((e) => MapEntry(e.nomeProduto, e.preco))
            .toList();
    }
  }

  // =========================
  // BUILD PRINCIPAL
  // =========================
  @override
  Widget build(BuildContext context) {
    return Consumer2<ListaViewModel, RelatorioItemViewModel>(
      builder: (context, listaVm, relatorioVm, _) {
        return RefreshIndicator(
          color: Colors.red,
          onRefresh: () async {
            if (_listaSelecionada != null) {
              await relatorioVm.carregar(_listaSelecionada!.id!);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown(listaVm),
                const SizedBox(height: 24),

                if (_listaSelecionada == null)
                  _buildPlaceholder()
                else if (relatorioVm.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  )
                else if (relatorioVm.erro != null)
                  _buildErro(relatorioVm)
                else ...[
                  // BOTÕES DE ABA
                  _buildBotoesAba(),
                  const SizedBox(height: 16),

                  // BOTÕES DE TIPO DE GRÁFICO
                  _buildBotoesGrafico(),
                  const SizedBox(height: 24),

                  // GRÁFICO
                  _buildGrafico(relatorioVm),
                  const SizedBox(height: 24),

                  // LISTA
                  _buildListaAtual(relatorioVm),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================
  // BOTÕES DE ABA
  // =========================
  Widget _buildBotoesAba() {
    final abas = [
      (RelatorioAba.maisComprados, Icons.trending_up,    Colors.orange, 'Comprados'),
      (RelatorioAba.porCategoria,  Icons.category,       Colors.blue,   'Categorias'),
      (RelatorioAba.maisCaros,     Icons.arrow_upward,   Colors.red,    'Mais caros'),
      (RelatorioAba.maisBaratos,   Icons.arrow_downward, Colors.green,  'Mais baratos'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: abas.map((a) {
        final selecionado = _abaSelecionada == a.$1;
        return GestureDetector(
          onTap: () => setState(() => _abaSelecionada = a.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selecionado ? a.$3 : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: a.$3, width: 1.5),
              boxShadow: selecionado
                  ? [BoxShadow(color: a.$3.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(a.$2, size: 16, color: selecionado ? Colors.white : a.$3),
                const SizedBox(width: 6),
                Text(a.$4, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selecionado ? Colors.white : a.$3)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================
  // BOTÕES DE TIPO DE GRÁFICO
  // =========================
  Widget _buildBotoesGrafico() {
    final tipos = [
      (TipoGrafico.pizza, Icons.pie_chart,    'Pizza'),
      (TipoGrafico.barra, Icons.bar_chart,    'Barra'),
      (TipoGrafico.linha, Icons.show_chart,   'Linha'),
    ];

    return Row(
      children: tipos.map((t) {
        final selecionado = _tipoGrafico == t.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _tipoGrafico = t.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selecionado ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red, width: 1.5),
                boxShadow: selecionado
                    ? [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(t.$2, size: 20, color: selecionado ? Colors.white : Colors.red),
                  const SizedBox(height: 4),
                  Text(t.$3, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selecionado ? Colors.white : Colors.red)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // =========================
  // GRÁFICO (switch por tipo)
  // =========================
  Widget _buildGrafico(RelatorioItemViewModel vm) {
    final dados = _dadosAtivos(vm);

    if (dados.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text('Nenhum dado para exibir', style: TextStyle(color: Colors.grey[400])),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: _tipoGrafico == TipoGrafico.pizza
                ? _graficoPizza(dados)
                : _tipoGrafico == TipoGrafico.barra
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

  // =========================
  // PIZZA
  // =========================
  Widget _graficoPizza(List<MapEntry<String, double>> dados) {
    final total = dados.fold<double>(0, (s, e) => s + e.value);
    return PieChart(
      PieChartData(
        sections: dados.asMap().entries.map((e) {
          final pct = e.value.value / total * 100;
          return PieChartSectionData(
            value: e.value.value,
            title: '${pct.toStringAsFixed(1)}%',
            color: _cor(e.key),
            radius: 80,
            titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  // =========================
  // BARRA
  // =========================
  Widget _graficoBarra(List<MapEntry<String, double>> dados) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: dados.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i < 0 || i >= dados.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
                color: _cor(e.key),
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // =========================
  // LINHA
  // =========================
  Widget _graficoLinha(List<MapEntry<String, double>> dados) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: dados.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2,
        lineTouchData: const LineTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i < 0 || i >= dados.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${i + 1}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: dados.asMap().entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: FlDotData(
              getDotPainter: (spot, _, __, i) => FlDotCirclePainter(
                radius: 5,
                color: _cor(i),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.08),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // LEGENDA
  // =========================
  List<Widget> _legenda(List<MapEntry<String, double>> dados) {
    return dados.asMap().entries.map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: _cor(e.key), shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text('${e.key + 1}.', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(width: 4),
          Expanded(child: Text(e.value.key, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    )).toList();
  }

  // =========================
  // LISTA ATUAL
  // =========================
  Widget _buildListaAtual(RelatorioItemViewModel vm) {
    switch (_abaSelecionada) {
      case RelatorioAba.maisComprados:
        return _buildSecao(
          titulo: 'Mais comprados',
          icone: Icons.trending_up,
          cor: Colors.orange,
          itens: vm.maisComprados.isEmpty
              ? [_vazio()]
              : vm.maisComprados.asMap().entries.map((e) => _buildCard(
                  posicao: e.key + 1,
                  linha1: e.value.nomeProduto,
                  linha2: '${e.value.totalQuantidade}x em ${e.value.frequencia} lista(s)',
                  valor: null,
                  cor: Colors.orange,
                )).toList(),
        );
      case RelatorioAba.porCategoria:
        return _buildSecao(
          titulo: 'Gasto por categoria',
          icone: Icons.category,
          cor: Colors.blue,
          itens: vm.porCategoria.isEmpty
              ? [_vazio()]
              : vm.porCategoria.map((item) => _buildCard(
                  posicao: null,
                  linha1: item.nomeCategoria,
                  linha2: '${item.totalItens} produto(s) · ${item.totalQuantidade} unid.',
                  valor: 'R\$ ${item.totalGasto.toStringAsFixed(2)}',
                  cor: Colors.blue,
                )).toList(),
        );
      case RelatorioAba.maisCaros:
        return _buildSecao(
          titulo: 'Mais caros',
          icone: Icons.arrow_upward,
          cor: Colors.red,
          itens: vm.maisCaros.isEmpty
              ? [_vazio()]
              : vm.maisCaros.asMap().entries.map((e) => _buildCard(
                  posicao: e.key + 1,
                  linha1: e.value.nomeProduto,
                  linha2: e.value.nomeCategoria,
                  valor: 'R\$ ${e.value.preco.toStringAsFixed(2)}',
                  cor: Colors.red,
                )).toList(),
        );
      case RelatorioAba.maisBaratos:
        return _buildSecao(
          titulo: 'Mais baratos',
          icone: Icons.arrow_downward,
          cor: Colors.green,
          itens: vm.maisBaratos.isEmpty
              ? [_vazio()]
              : vm.maisBaratos.asMap().entries.map((e) => _buildCard(
                  posicao: e.key + 1,
                  linha1: e.value.nomeProduto,
                  linha2: e.value.nomeCategoria,
                  valor: 'R\$ ${e.value.preco.toStringAsFixed(2)}',
                  cor: Colors.green,
                )).toList(),
        );
    }
  }

  // =========================
  // DROPDOWN
  // =========================
  Widget _buildDropdown(ListaViewModel listaVm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: DropdownButtonHideUnderline(
        child: listaVm.isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red)),
                    SizedBox(width: 10),
                    Text('Carregando listas...'),
                  ],
                ),
              )
            : DropdownButton<Lista>(
                isExpanded: true,
                hint: const Text('Selecione uma lista'),
                value: _listaSelecionada,
                items: listaVm.listas.map((lista) => DropdownMenuItem<Lista>(
                  value: lista,
                  child: Text(lista.nome, overflow: TextOverflow.ellipsis),
                )).toList(),
                onChanged: _onListaSelecionada,
              ),
      ),
    );
  }

  // =========================
  // PLACEHOLDER
  // =========================
  Widget _buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Selecione uma lista para ver o relatório',
                style: TextStyle(color: Colors.grey[400], fontSize: 15), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // =========================
  // ERRO
  // =========================
  Widget _buildErro(RelatorioItemViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(vm.erro!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => vm.carregar(_listaSelecionada!.id!),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tentar novamente', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SEÇÃO
  // =========================
  Widget _buildSecao({required String titulo, required IconData icone, required Color cor, required List<Widget> itens}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: cor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icone, color: cor, size: 20),
            ),
            const SizedBox(width: 10),
            Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          ],
        ),
        const SizedBox(height: 12),
        ...itens,
      ],
    );
  }

  // =========================
  // CARD
  // =========================
  Widget _buildCard({required int? posicao, required String linha1, required String linha2, required String? valor, required Color cor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          if (posicao != null) ...[
            Container(
              width: 28, height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: cor.withOpacity(0.12), shape: BoxShape.circle),
              child: Text('$posicao', style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 12)),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(linha1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), overflow: TextOverflow.ellipsis),
                Text(linha2, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          if (valor != null)
            Text(valor, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: cor)),
        ],
      ),
    );
  }

  // =========================
  // VAZIO
  // =========================
  Widget _vazio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(child: Text('Nenhum dado encontrado', style: TextStyle(color: Colors.grey[400], fontSize: 14))),
    );
  }
}