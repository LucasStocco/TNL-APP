import 'package:flutter/material.dart';

class ListaForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool enabled;

  const ListaForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: const InputDecoration(
          labelText: 'Nome da Lista',
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'O nome é obrigatório';
          }
          return null;
        },
      ),
    );
  }
}
