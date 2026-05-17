import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/shared/helpers/categoria_icon_mapper.dart';
import 'package:crud_flutter/view/categorias/categoria_produtos_screen.dart';
import 'package:crud_flutter/view/categorias/widgets/categoria_actions.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_detalhes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;

  const CategoriaCard({
    super.key,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
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
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                CategoriaIconMapper.icone(
                  codigo: categoria.codigo,
                  isUsuario: ![
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
                  ].contains(categoria.codigo.toUpperCase()),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
