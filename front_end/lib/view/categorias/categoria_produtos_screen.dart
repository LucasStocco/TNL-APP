import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';
import '../../model/cadastrar_produto/produto.dart';

class CategoriasProdutosScreen extends StatefulWidget {
  final String nomeCategoria;
  final int idCategoria;

  const CategoriasProdutosScreen({
    super.key,
    required this.nomeCategoria,
    required this.idCategoria,
  });

  @override
  State<CategoriasProdutosScreen> createState() =>
      _CategoriasProdutosScreenState();
}

class _CategoriasProdutosScreenState extends State<CategoriasProdutosScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriaDetalhesViewModel>().carregarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeCategoria),
      ),
      body: Consumer<CategoriaDetalhesViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.erro != null) {
            return Center(
              child: Text(
                vm.erro!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final List<Produto> produtos = vm.produtos;

          if (produtos.isEmpty) {
            return const Center(
              child: Text("Nenhum produto nesta categoria"),
            );
          }

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];

              return ListTile(
                title: Text(produto.nome),
                subtitle: Text(produto.descricao ?? ''),
                trailing: const Icon(Icons.add_shopping_cart),
              );
            },
          );
        },
      ),
    );
  }
}
