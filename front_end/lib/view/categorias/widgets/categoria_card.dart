import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/shared/mappers/categoria_icon_mapper.dart';
import 'package:crud_flutter/view/categorias/categoria_produtos_screen.dart';
import 'package:crud_flutter/view/categorias/widgets/categoria_actions.dart';
import 'package:crud_flutter/shared/mappers/categoria_color_mapper.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud_flutter/service/cadastrar_categoria/categoria_service.dart';

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
    final codigoSeguro = (categoria.codigo ?? '').toUpperCase();

    final corCategoria = CategoriaColorMapper.cor(codigoSeguro);

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
    ].contains(codigoSeguro);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final categoriaService = context.read<CategoriaService>();
          final produtoService = context.read<ProdutoService>();
          final itemService = context.read<ItemService>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => CategoriaDetalhesViewModel(
                  produtoService: produtoService,
                  itemService: itemService,
                  categoriaService: categoriaService,
                  idCategoria: categoria.id,
                )..carregarSubcategoriasDaCategoria(), // ⚠️ corrigido aqui
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
            color: corCategoria.withOpacity(0.32),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: corCategoria.withOpacity(0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: corCategoria.withOpacity(0.14),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isHorizontal
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Image.asset(
                        CategoriaIconMapper.icone(
                          codigo: codigoSeguro,
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      CategoriaIconMapper.icone(
                        codigo: codigoSeguro,
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
