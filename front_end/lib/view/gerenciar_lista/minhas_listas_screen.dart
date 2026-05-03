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
    Future.microtask(
      () => context.read<ListaResumoViewModel>().carregarResumo(),
    );
  }

  Color _corProgresso(double p) {
    if (p >= 100) return Colors.green;
    if (p >= 50) return Colors.orange;
    return Colors.red;
  }

  void _abrirOpcoes(BuildContext context, ListaResumo lista) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Renomear"),
              onTap: () {
                Navigator.pop(context);
                _editarLista(context, lista);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Excluir"),
              onTap: () {
                Navigator.pop(context);
                _deletarLista(context, lista);
              },
            ),
          ],
        );
      },
    );
  }

  void _editarLista(BuildContext context, ListaResumo lista) {
    final controller = TextEditingController(text: lista.nome);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Renomear lista"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Nome da lista",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ListaResumoViewModel>().renomearLista(
                      lista.id,
                      controller.text,
                    );

                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _deletarLista(BuildContext context, ListaResumo lista) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Excluir lista?"),
          content: const Text("Essa ação não pode ser desfeita."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ListaResumoViewModel>().deletarLista(lista.id);
                Navigator.pop(context);
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
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
              final lista = viewModel.listas[index];

              return InkWell(
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
                    context.read<ListaResumoViewModel>().carregarResumo();
                  });
                },
                onLongPress: () => _abrirOpcoes(context, lista),
                child: Card(
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
