import 'package:flutter/material.dart';

class RelatorioHeader extends StatelessWidget {
  const RelatorioHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relatório Financeiro',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: Color(0xFF22202A),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Acompanhe seus gastos',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF9B9B9B),
          ),
        ),
      ],
    );
  }
}