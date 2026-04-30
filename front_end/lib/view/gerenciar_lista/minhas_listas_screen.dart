import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/gerenciar_lista/lista_view_model.dart';
import '../../model/gerenciar_lista/lista.dart';
import 'criar_nova_lista_screen.dart';
import 'lista_screen.dart' hide Scaffold;

class MinhasListasScreen extends StatefulWidget {
  const MinhasListasScreen({super.key});

  @override
  State<MinhasListasScreen> createState() => _MinhasListasScreenState();
}

class _MinhasListasScreenState extends State<MinhasListasScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega listas ao abrir a tela
    Future.microtask(() => context.read<ListaViewModel>().listar());
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    print('>>>>> ESTOU NA MINHAS LISTAS SCREEN');
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Listas')),
      body: Consumer<ListaViewModel>(
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
              final Lista lista = viewModel.listas[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(lista.nome),
                  subtitle: lista.concluidoEm != null
                      ? Text(
                          'Concluída em ${_formatarData(lista.concluidoEm!)}')
                      : null,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (lista.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListaScreen(
                            listaId: lista.id!,
                            listaNome: lista.nome,
                          ),
                        ),
                      ).then((_) => context.read<ListaViewModel>().listar());
                    }
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Atualizar'),
                            onTap: () async {
                              Navigator.pop(context);

                              final Lista? listaAtualizada =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CriarNovaListaScreen(lista: lista),
                                ),
                              );

                              if (listaAtualizada != null) {
                                await context
                                    .read<ListaViewModel>()
                                    .atualizar(listaAtualizada);
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Deletar'),
                            onTap: () async {
                              Navigator.pop(context);

                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirmação'),
                                  content: const Text(
                                      'Deseja realmente deletar esta lista?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Não'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Sim'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true && lista.id != null) {
                                await context
                                    .read<ListaViewModel>()
                                    .deletar(lista.id!);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Lista? novaLista = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CriarNovaListaScreen(),
            ),
          );

          if (novaLista != null) {
            // Recarrega as listas do backend via ViewModel
            await context.read<ListaViewModel>().listar();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
