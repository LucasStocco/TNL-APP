import 'package:flutter/material.dart';

class UserOptionTile extends StatelessWidget {
  // faz com que o widget seja dinâmico
  final String title;
  final IconData icon;
  // funcao sem retorno
  final VoidCallback onTap;

  const UserOptionTile({
    super.key,
    // passar os valores é obrigatorio
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
