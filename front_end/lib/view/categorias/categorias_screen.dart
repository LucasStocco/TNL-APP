import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../view_model/cadastrar_categoria/categoria_view_model.dart';
import '../../view_model/gerenciar_lista/lista_view_model.dart';
import '../../view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';

import '../../shered/helpers/categoria_icon_mapper.dart';
import '../../service/gerenciar_lista/item_service.dart';

import 'categoria_detalhes_screen.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CategoriaViewModel>().listar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriaViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final categorias = vm.categorias;

        if (categorias.isEmpty) {
          return const Center(child: Text("Nenhuma categoria"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            final categoria = categorias[index];
            final isGlobal = categoria.idUsuario == null;

            final icone = CategoriaIconMapper.icone(
              codigo: categoria.codigo ?? categoria.nome,
              isUsuario: !isGlobal,
            );

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),

                // ================= NAVEGAÇÃO =================
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        final produtoService = context.read<ProdutoService>();
                        final itemService = context.read<ItemService>();
                        final listaVm = context.read<ListaViewModel>();

                        return ChangeNotifierProvider(
                          create: (_) => CategoriaDetalhesViewModel(
                            produtoService: produtoService,
                            itemService: itemService,
                            idCategoria: categoria.id!,
                          )..carregarProdutos(),
                          child: CategoriaDetalhesScreen(
                            nomeCategoria: categoria.nome,
                            codigoCategoria: categoria.codigo!,
                            idLista: listaVm.listaAtual?.id ?? 1, // ✅ FIX
                          ),
                        );
                      },
                    ),
                  );
                },

                child: Container(
                  decoration: BoxDecoration(
                    color: isGlobal
                        ? Colors.grey.shade200
                        : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isGlobal ? Colors.grey : Colors.purple,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(icone, width: 45, height: 45),
                      const SizedBox(height: 8),
                      Text(
                        categoria.nome,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      if (!isGlobal)
                        const Text(
                          "Criada por você!",
                          style: TextStyle(fontSize: 10),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
