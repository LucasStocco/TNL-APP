import 'package:flutter/material.dart';

class RelatorioCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color backgroundColor;
  final Color textColor;

  const RelatorioCard({
    super.key,
    required this.titulo,
    required this.valor,
    this.backgroundColor = const Color(0xFFF1F1F1),
    this.textColor = const Color(0xFF22202A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 17,
              color: textColor.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            valor,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}