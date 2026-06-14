import 'package:flutter/material.dart';
import 'package:crud_flutter/view/relatorio_item/enums/tipo_grafico.dart';

class Relatorio_Botoes_Grafico extends StatelessWidget {
  final TipoGrafico tipoGrafico;
  final ValueChanged<TipoGrafico> onChanged;

  const RelatorioBotoesGrafico({
    super.key,
    required this.tipoGrafico,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tipos = [
      (TipoGrafico.pizza, Icons.pie_chart, 'Pizza'),
      (TipoGrafico.barra, Icons.bar_chart, 'Barra'),
    ];

    return Row(
      children: tipos.map((t) {
        final selecionado = tipoGrafico == t.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(t.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selecionado ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red, width: 1.5),
                boxShadow: selecionado
                    ? [
                        BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(t.$2,
                      size: 20, color: selecionado ? Colors.white : Colors.red),
                  const SizedBox(height: 4),
                  Text(t.$3,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selecionado ? Colors.white : Colors.red)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}