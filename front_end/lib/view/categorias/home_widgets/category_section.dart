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
        color: Colors.grey.shade200,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 3),
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.category),
                  const SizedBox(height: 8),
                  Text(
                    categoria.nome,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}