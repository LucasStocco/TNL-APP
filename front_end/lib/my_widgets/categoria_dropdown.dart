import 'package:flutter/material.dart';
import '../model/criar_produto/categoria.dart';
import '../view_model/criar_produto/categoria_view_model.dart';

class CategoriaDropdown extends StatelessWidget {
  final CategoriaViewModel viewModel;
  final Categoria? selecionada;
  final ValueChanged<Categoria?> onChanged;

  const CategoriaDropdown({
    super.key,
    required this.viewModel,
    required this.selecionada,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Se ainda estiver carregando, mostra loader
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Se não houver categorias, mostra mensagem
    if (viewModel.categorias.isEmpty) {
      return const Text('Nenhuma categoria disponível');
    }

    // Dropdown normal
    return DropdownButtonFormField<Categoria>(
      value: selecionada,
      items: viewModel.categorias
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat.nome)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(),
      ),
      validator: (v) => v == null ? 'Selecione uma categoria' : null,
    );
  }
}
