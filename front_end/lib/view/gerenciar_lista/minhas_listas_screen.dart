import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lista_screen.dart';

class MinhasListasScreen extends StatefulWidget {
  const MinhasListasScreen({super.key});

  @override
  State<MinhasListasScreen> createState() => _MinhasListasScreenState();
}

class _MinhasListasScreenState extends State<MinhasListasScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ListaResumoViewModel>().carregar());
  }

  Color _corProgresso(double p) {
    if (p >= 100) return Colors.green;
    if (p >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Listas')),
      body: Consumer<ListaResumoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.listas.isEmpty) {
            return const Center(child: Text('Nenhuma lista encontrada'));
          }

          return ListView.builder(
            itemCount: viewModel.listas.length,
            itemBuilder: (context, index) {
              final ListaResumo lista = viewModel.listas[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(lista.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: lista.progresso / 100,
                        backgroundColor: Colors.grey.shade300,
                        color: _corProgresso(lista.progresso),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lista.progresso.toStringAsFixed(0)}% concluída '
                        '(${lista.itensComprados}/${lista.totalItens})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaScreen(
                          listaId: lista.id,
                          listaNome: lista.nome,
                        ),
                      ),
                    ).then((_) {
                      context.read<ListaResumoViewModel>().carregar();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
