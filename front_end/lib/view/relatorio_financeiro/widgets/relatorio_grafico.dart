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
            const Text(
              'Nenhum gasto por categoria encontrado.',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
              ),
            )
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