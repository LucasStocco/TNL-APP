import 'package:crud_flutter/model/cadastrar_categoria/subcategoria_mode.dart';
import 'package:flutter/material.dart';

class SubcategoriaHeaderWidget extends StatelessWidget {
  final SubcategoriaModel subcategoria;
  final Color cor;

  // ✅ NOVO
  final String icone;

  const SubcategoriaHeaderWidget({
    super.key,
    required this.subcategoria,
    required this.cor,

    // ✅ NOVO
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ✅ ÍCONE DA SUBCATEGORIA
          Image.asset(
            icone,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              subcategoria.nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
