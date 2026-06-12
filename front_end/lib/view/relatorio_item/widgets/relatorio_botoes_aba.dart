import 'package:flutter/material.dart';
import 'package:crud_flutter/view/relatorio_item/enums/relatorio_aba.dart';

class RelatorioBotoesAba extends StatelessWidget {
  final RelatorioAba abaSelecionada;
  final ValueChanged<RelatorioAba> onChanged;

  const RelatorioBotoesAba({
    super.key,
    required this.abaSelecionada,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final abas = [
      (
        RelatorioAba.maisComprados,
        Icons.trending_up,
        Colors.orange,
        'Comprados'
      ),
      (RelatorioAba.porCategoria, Icons.category, Colors.blue, 'Categorias'),
      (RelatorioAba.maisCaros, Icons.arrow_upward, Colors.red, 'Mais caros'),
      (
        RelatorioAba.maisBaratos,
        Icons.arrow_downward,
        Colors.green,
        'Mais baratos'
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: abas.map((a) {
        final selecionado = abaSelecionada == a.$1;
        return GestureDetector(
          onTap: () => onChanged(a.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selecionado ? a.$3 : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: a.$3, width: 1.5),
              boxShadow: selecionado
                  ? [
                      BoxShadow(
                          color: a.$3.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(a.$2, size: 16, color: selecionado ? Colors.white : a.$3),
                const SizedBox(width: 6),
                Text(a.$4,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selecionado ? Colors.white : a.$3)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}