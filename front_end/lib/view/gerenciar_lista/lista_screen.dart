/// ================= PACKAGES =================
import 'package:crud_flutter/core/notificacoes_gamificacao/conquistas_notifications_ui/conquista_notification_controller.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/empty_lista_widget.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/lista_item_tile_with_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

/// ================= CORE =================
import 'package:crud_flutter/core/api/api_client.dart';

/// ================= SERVICES =================
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';

/// ================= VIEW MODELS =================
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_produto/produto_view_model.dart';

/// ================= VIEWS / WIDGETS =================
import 'package:crud_flutter/view/gerenciar_lista/widgets/categoria_bottom_sheet.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/item_actions_sheet.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/lista_fab_menu.dart';
import 'package:crud_flutter/view/cadastrar_produto/criar_item_screen.dart';
import 'package:crud_flutter/view/gerenciar_lista/widgets/lista_resumo_header.dart';

class ListaScreen extends StatefulWidget {
  final int listaId;
  final String listaNome;

  const ListaScreen({
    super.key,
    required this.listaId,
    required this.listaNome,
  });

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ItemViewModel>().carregar(widget.listaId);
      context.read<CategoriaViewModel>().listar();
    });
  }

  /// =========================
  /// DESCRIÇÃO CONQUISTAS
  /// =========================
  String _descricaoPorConquista(TipoEventoConquista conquista) {
    switch (conquista) {
      case TipoEventoConquista.primeiraListaConcluida:
        return "Você finalizou sua primeira lista!";
      case TipoEventoConquista.cincoListasConcluidas:
        return "Você já concluiu 5 listas!";
      case TipoEventoConquista.dezListasConcluidas:
        return "Você está ficando avançado! 10 listas concluídas.";
      case TipoEventoConquista.cinquentaListasConcluidas:
        return "Incrível! 50 listas concluídas!";
      default:
        return "Conquista desbloqueada!";
    }
  }

  /// =========================
  /// CRIAR ITEM
  /// =========================
  Future<void> _abrirCriarItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: context.read<CategoriaViewModel>(),
            ),
            ChangeNotifierProvider(
              create: (_) => ProdutoViewModel(
                ProdutoService(ApiClient(http.Client())),
              ),
            ),
          ],
          child: CriarItemScreen(listaId: widget.listaId),
        ),
      ),
    );

    if (mounted) {
      await context.read<ItemViewModel>().carregar(widget.listaId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listaNome),
      ),
      body: Consumer<ItemViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.itens.isEmpty) {
            return const EmptyListaWidget();
          }

          return Column(
            children: [
              ListaResumoHeader(itens: vm.itens),
              const SizedBox(height: 8),

              // 🔧 BOTÃO DE DEBUG (RESET CONQUISTAS)
              ElevatedButton(
                onPressed: () {
                  context.read<ItemViewModel>().resetarConquistas();
                },
                child: const Text("Reset conquistas"),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  itemCount: vm.itens.length,
                  itemBuilder: (_, index) {
                    final item = vm.itens[index];

                    return ListaItemTileWithDivider(
                        item: item,
                        isLast: index == vm.itens.length - 1,
                        onLongPress: () {
                          ItemActionsSheet.show(
                            context,
                            item,
                            widget.listaId,
                          );
                        },

                        /// =========================
                        /// FLUXO REAL DE CONQUISTA
                        /// =========================
                        onDoubleTap: () async {
                          print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━');
                          print('👆 DOUBLE TAP INICIADO');
                          print('━━━━━━━━━━━━━━━━━━━━━━━━━━');
                          print('📌 listaId: ${widget.listaId}');
                          print('📌 itemId: ${item.id}');
                          print('📌 comprado atual: ${item.comprado}');
                          print('━━━━━━━━━━━━━━━━━━━━━━━━━━');

                          final viewModel = context.read<ItemViewModel>();

                          try {
                            print('🔄 Chamando marcarComprado...');

                            final novaConquista =
                                await viewModel.marcarComprado(
                              widget.listaId,
                              item.id,
                              !item.comprado,
                            );

                            print(
                                '⬅ RETORNO VIEWMODEL: ${novaConquista?.name ?? "null"}');

                            if (!mounted) {
                              print(
                                  '⚠️ WIDGET NÃO MONTADO MAIS - abortando UI');
                              return;
                            }

                            if (novaConquista == null) {
                              print('⚠️ NENHUMA CONQUISTA RECEBIDA');
                              print('👉 Possíveis causas:');
                              print('   - lista não completada');
                              print('   - já foi contabilizada');
                              print('   - engine retornou null');
                              print('━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
                              return;
                            }

                            print('🏆 CONQUISTA DETECTADA!');

                            ConquistaNotificationController.show(
                              context,
                              novaConquista,
                            );

                            print('✅ NOTIFICAÇÃO EXIBIDA COM SUCESSO');
                            print('━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
                          } catch (e, stack) {
                            print('❌ ERRO NO ONDOUBLE TAP');
                            print('Erro: $e');
                            print('Stack: $stack');
                            print('━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
                          }
                        });
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: ListaFabMenu(
        onAddItem: _abrirCriarItem,
        onAddCategoria: () {
          CategoriaBottomSheet.show(context);
        },
      ),
    );
  }
}
