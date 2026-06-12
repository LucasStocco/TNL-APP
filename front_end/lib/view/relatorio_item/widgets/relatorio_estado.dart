import 'package:flutter/material.dart';

class RelatorioPlaceholder extends StatelessWidget {
  const RelatorioPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Selecione uma lista para ver o relatório',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RelatorioErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;

  const RelatorioErro({
    super.key,
    required this.mensagem,
    required this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onTentarNovamente,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tentar novamente',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class RelatorioVazio extends StatelessWidget {
  const RelatorioVazio({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
          child: Text('Nenhum dado encontrado',
              style: TextStyle(color: Colors.grey[400], fontSize: 14))),
    );
  }
}