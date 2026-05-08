import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/shared/helpers/categoria_icon_mapper.dart';
import 'package:crud_flutter/view/categorias/categoria_produtos_screen.dart';
import 'package:crud_flutter/view/categorias/widgets/categoria_actions.dart';
import 'package:crud_flutter/view/categorias/widgets/categoria_color_mapper.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final bool isHorizontal;

  const CategoriaCard({
    super.key,
    required this.categoria,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final corCategoria = CategoriaColorMapper.cor(categoria.codigo);

    final bool isCategoriaPadrao = [
      'BEBIDAS',
      'CARNES',
      'PADARIA',
      'HORTIFRUTI',
      'LATICINIOS',
      'MERCEARIA',
      'HIGIENE',
      'LIMPEZA',
      'PETS',
      'DOCES',
      'UTILIDADES',
      'BEBES',
      'SAZONAIS',
    ].contains(categoria.codigo.toUpperCase());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final produtoService = context.read<ProdutoService>();
          final itemService = context.read<ItemService>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => CategoriaDetalhesViewModel(
                  produtoService: produtoService,
                  itemService: itemService,
                  idCategoria: categoria.id,
                )..carregarProdutos(),
                child: CategoriasProdutosScreen(
                  nomeCategoria: categoria.nome,
                  idCategoria: categoria.id,
                ),
              ),
            ),
          );
        },
        onLongPress: () {
          CategoriaActions.show(context, categoria);
        },
        child: Container(
          height: isHorizontal ? 60 : null,
          decoration: BoxDecoration(
            // 🎨 Cor do fundo do card
            color: corCategoria.withOpacity(0.32),

            // 🔲 Bordas arredondadas
            borderRadius: BorderRadius.circular(16),

            // 🖼️ Borda colorida
            border: Border.all(
              color: corCategoria.withOpacity(0.55),
              width: 1.2,
            ),

            // 🌫️ Sombra suave
            boxShadow: [
              BoxShadow(
                color: corCategoria.withOpacity(0.14),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          // 🔄 Layout dinâmico
          child: isHorizontal
              // =========================
              // 📋 LAYOUT HORIZONTAL
              // =========================
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        CategoriaIconMapper.icone(
                          codigo: categoria.codigo,
                          isUsuario: !isCategoriaPadrao,
                        ),
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          categoria.nome,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.alphaBlend(
                              Colors.black.withOpacity(0.15),
                              corCategoria,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              // =========================
              // 🟦 LAYOUT GRID
              // =========================
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      CategoriaIconMapper.icone(
                        codigo: categoria.codigo,
                        isUsuario: !isCategoriaPadrao,
                      ),
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categoria.nome,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.alphaBlend(
                          Colors.black.withOpacity(0.15),
                          corCategoria,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
