import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';
import '../../view_model/gerenciar_lista/lista_view_model.dart';
import '../../model/cadastrar_produto/produto.dart';

class CategoriaDetalhesScreen extends StatefulWidget {
  final String nomeCategoria;
  final String codigoCategoria;
  final int idLista;

  const CategoriaDetalhesScreen({
    super.key,
    required this.nomeCategoria,
    required this.codigoCategoria,
    required this.idLista,
  });

  @override
  State<CategoriaDetalhesScreen> createState() =>
      _CategoriaDetalhesScreenState();
}

class _CategoriaDetalhesScreenState extends State<CategoriaDetalhesScreen> {
  // ================= SELEÇÃO DE LISTA =================
  Future<void> _selecionarListaEAdicionar(
    BuildContext context,
    CategoriaDetalhesViewModel vm,
    Produto produto,
  ) async {
    final listaVm = context.read<ListaViewModel>();

    print("━━━━━━━━━━━━━━━━━━━━━━");
    print("🧠 ABRINDO SELETOR DE LISTA");
    print("📦 Produto: ${produto.nome}");
    print("📊 Total listas: ${listaVm.listas.length}");

    // 🔥 GARANTE LISTAS
    if (listaVm.listas.isEmpty) {
      print("📡 Carregando listas...");
      await listaVm.listar();
    }

    if (listaVm.listas.isEmpty) {
      print("❌ Nenhuma lista encontrada");

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nenhuma lista disponível"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Escolha a lista",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Divider(),
              ...listaVm.listas.map((lista) {
                return ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(lista.nome),
                  onTap: () async {
                    Navigator.pop(context);

                    print("📌 Lista escolhida: ${lista.id}");

                    try {
                      await vm.adicionarProdutoNaLista(
                        lista.id!,
                        produto,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("✔ Adicionado em ${lista.nome}"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      print("❌ ERRO AO ADICIONAR: $e");

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeCategoria),
      ),
      body: Consumer<CategoriaDetalhesViewModel>(
        builder: (context, vm, child) {
          // ERRO
          if (vm.erro != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(vm.erro!),
                  backgroundColor: Colors.red,
                ),
              );
              vm.erro = null;
            });
          }

          // LOADING
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // VAZIO
          if (vm.produtos.isEmpty) {
            return const Center(
              child: Text("Nenhum produto nessa categoria"),
            );
          }

          // LISTA
          return ListView.builder(
            itemCount: vm.produtos.length,
            itemBuilder: (context, index) {
              final produto = vm.produtos[index];

              return ListTile(
                title: Text(produto.nome),
                subtitle: Text(produto.descricao ?? "Sem descrição"),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    print("━━━━━━━━━━━━━━━━━━━━━━");
                    print("🛒 CLICK ADD: ${produto.nome}");

                    if (produto.id == null) return;

                    _selecionarListaEAdicionar(context, vm, produto);
                  },
                ),
                onLongPress: () async {
                  if (produto.id == null) return;

                  await vm.deletarProduto(produto.id!);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Produto deletado"),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
