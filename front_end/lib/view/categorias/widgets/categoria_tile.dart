// Widget do card da categoria

import 'package:flutter/material.dart';

class CategoriaTile extends StatelessWidget {
  final String nome;
  final String icone;
  final bool isGlobal;
  final VoidCallback onTap;

  const CategoriaTile({
    super.key,
    required this.nome,
    required this.icone,
    required this.isGlobal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isGlobal ? Colors.grey.shade200 : Colors.purple.shade100,
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
                nome,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
  }
}
