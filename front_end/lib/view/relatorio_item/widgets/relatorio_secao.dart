import 'package:flutter/material.dart';

class RelatorioSecao extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final List<Widget> itens;

  const RelatorioSecao({
    super.key,
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.itens,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: cor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icone, color: cor, size: 20),
            ),
            const SizedBox(width: 10),
            Text(titulo,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800])),
          ],
        ),
        const SizedBox(height: 12),
        ...itens,
      ],
    );
  }
}