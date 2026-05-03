import 'package:flutter/material.dart';

class ItemForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final String nome;
  final String descricao;
  final int quantidade;
  final double preco;

  final bool enabled;

  final Function(String?) onNome;
  final Function(String?) onDescricao;
  final Function(String?) onQuantidade;
  final Function(String?) onPreco;

  const ItemForm({
    super.key,
    required this.formKey,
    required this.nome,
    required this.descricao,
    required this.quantidade,
    required this.preco,
    required this.enabled,
    required this.onNome,
    required this.onDescricao,
    required this.onQuantidade,
    required this.onPreco,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: nome,
            enabled: enabled,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
            onSaved: onNome,
          ),
          TextFormField(
            initialValue: descricao,
            enabled: enabled,
            decoration: const InputDecoration(labelText: 'Descrição'),
            onSaved: onDescricao,
          ),
          TextFormField(
            initialValue: quantidade.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantidade'),
            onSaved: onQuantidade,
          ),
          TextFormField(
            initialValue: preco.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Preço'),
            onSaved: onPreco,
          ),
        ],
      ),
    );
  }
}
