import 'package:flutter/material.dart';
import 'package:crud_flutter/model/cadastrar_categoria/categoria.dart';

class CategoriaDropdown extends StatelessWidget {
  final List<Categoria> categorias;
  final Categoria? selected;
  final ValueChanged<Categoria?> onChanged;
  final bool enabled;

  const CategoriaDropdown({
    super.key,
    required this.categorias,
    required this.selected,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Categoria>(
      value: selected,
      items: categorias
          .map<DropdownMenuItem<Categoria>>(
            (Categoria c) => DropdownMenuItem<Categoria>(
              value: c,
              child: Text(c.nome),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(),
      ),
    );
  }
}
