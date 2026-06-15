import 'package:flutter/material.dart';

class RelatorioCard extends StatelessWidget {
  final int? posicao;
  final String linha1;
  final String linha2;
  final String? valor;
  final Color cor;

  const RelatorioCard({
    super.key,
    required this.posicao,
    required this.linha1,
    required this.linha2,
    required this.valor,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          if (posicao != null) ...[
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: cor.withOpacity(0.12), shape: BoxShape.circle),
              child: Text('$posicao',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: cor, fontSize: 12)),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(linha1,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    overflow: TextOverflow.ellipsis),
                Text(linha2,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          if (valor != null)
            Text(valor!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: cor)),
        ],
      ),
    );
  }
}