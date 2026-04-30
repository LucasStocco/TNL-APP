import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';
import 'package:flutter/material.dart';

import 'package:crud_flutter/view/categorias/categoria_produtos_screen.dart';

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoriasProdutosScreen(
                nomeCategoria: categoria.nome,
                idCategoria: categoria.id,
              ),
            ),
          );
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
              const Icon(Icons.category, size: 40),
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
