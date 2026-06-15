import 'package:flutter/material.dart';
import '../../../model/cadastrar_categoria/categoria.dart';

class CategorySection extends StatelessWidget {
  final List<Categoria> categorias;
  final void Function(Categoria categoria) onTapCard;

  const CategorySection({
    super.key,
    required this.categorias,
    required this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: categorias.map((categoria) {
      return GestureDetector(
        onTap: () => onTapCard(categoria),
        child: Container(
          width: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: const Offset(0, 3),
                color: Theme.of(context)
                    .shadowColor
                    .withValues(alpha: 0.15),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                Icons.category,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                categoria.nome,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }).toList(),
  )); 
  
  }
}