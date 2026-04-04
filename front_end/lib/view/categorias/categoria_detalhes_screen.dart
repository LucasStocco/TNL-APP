import 'package:crud_flutter/model/criar_produto/categoria.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/criar_produto/produto.dart';
import '../../view_model/criar_produto/produto_view_model.dart';
import '../../view_model/gerenciar_lista/lista_view_model.dart';
import '../../view_model/categorias/categoria_detalhes_view_model.dart';
import '../../view_model/categorias/categoria_view_model.dart';
import '../../service/criar_produto/item_service.dart';

// Navegação
import 'package:crud_flutter/my_widgets/app_navigation_bar.dart';
import '../home_screen.dart';
import '../gerenciar_lista/criar_nova_lista_screen.dart';
import '../gerenciar_lista/minhas_listas_screen.dart';
import '../categorias/categorias_screen.dart';
import '../relatorio_financeiro/relatorio_screen.dart';

class CategoriaDetalhesScreen extends StatefulWidget {
  final String nomeCategoria;

  const CategoriaDetalhesScreen({super.key, required this.nomeCategoria});

  @override
  State<CategoriaDetalhesScreen> createState() =>
      _CategoriaDetalhesScreenState();
}

class _CategoriaDetalhesScreenState extends State<CategoriaDetalhesScreen> {
  int _selectedIndex = 1;
  late CategoriaDetalhesViewModel categoriaDetalhesVM;

  @override
  void initState() {
    super.initState();

    final produtoVM = Provider.of<ProdutoViewModel>(context, listen: false);
    final listaVM = Provider.of<ListaViewModel>(context, listen: false);
    final categoriaVM = Provider.of<CategoriaViewModel>(context, listen: false);

    final categoriaSelecionada = categoriaVM.categorias.firstWhere(
      (c) => c.nome == widget.nomeCategoria,
      orElse: () => Categoria(id: 0, nome: 'Desconhecida'),
    );

    int categoriaId = categoriaSelecionada.id ?? 0;

    categoriaDetalhesVM = CategoriaDetalhesViewModel(
      produtoVM: produtoVM,
      listaVM: listaVM,
      categoriaId: categoriaId,
      itemService: ItemService(),
    );

    // Carrega produtos e listas
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (produtoVM.produtos.isEmpty) {
        await produtoVM.listar();
      }
      await categoriaDetalhesVM.carregarProdutos();

      // Carrega listas do backend
      await listaVM.listar();
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const CategoriasScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CriarNovaListaScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const MinhasListasScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const RelatorioScreen()));
        break;
    }
  }

  // ---------------------- MODAL DE SELEÇÃO DE LISTAS ----------------------
  void _mostrarCatalogoListas(Produto produto) async {
    final listaVM = Provider.of<ListaViewModel>(context, listen: false);

    // Garante que as listas estão carregadas
    await listaVM.listar();

    if (listaVM.listas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma lista disponível')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Escolha a lista para adicionar o produto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listaVM.listas.length,
                itemBuilder: (context, index) {
                  final lista = listaVM.listas[index];
                  return ListTile(
                    title: Text(lista.nome),
                    onTap: () async {
                      await categoriaDetalhesVM.adicionarProdutoNaLista(
                          lista.id!, produto);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '${produto.nome} adicionado à lista ${lista.nome}!')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.nomeCategoria,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ChangeNotifierProvider.value(
        value: categoriaDetalhesVM,
        child: Consumer<CategoriaDetalhesViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading)
              return const Center(child: CircularProgressIndicator());
            if (vm.erro != null)
              return Center(
                  child: Text(vm.erro!,
                      style: const TextStyle(color: Colors.red)));
            if (vm.produtos.isEmpty)
              return const Center(
                  child: Text('Nenhum produto nesta categoria'));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.produtos.length,
              itemBuilder: (context, index) {
                final produto = vm.produtos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(produto.nome),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () => _mostrarCatalogoListas(produto),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar:
          AppNavigationBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
