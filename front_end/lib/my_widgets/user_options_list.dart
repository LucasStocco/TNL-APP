import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_option_title.dart';

// AQUI É ONDE A NAVEGAÇÃO ACONTECE!
// a navegação deve ser protegida: Navigator.pushNamed(context, '/settings');

class UserOptionsList extends StatelessWidget {
  const UserOptionsList({super.key});

  // funcao de proteção de rotas
  void _handleNavigation(BuildContext context, String route, UserViewModel vm) {
    if (!vm.isLogged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para acessar'),
        ),
      );
      return;
    }

    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserViewModel>();

    return Column(
      children: [
        UserOptionTile(
          title: 'Configurações',
          icon: Icons.settings,
          onTap: () {
            _handleNavigation(context, '/settings', vm);
          },
        ),
        UserOptionTile(
          title: 'Aparência',
          icon: Icons.palette,
          onTap: () {
            _handleNavigation(context, '/theme', vm);
          },
        ),
        UserOptionTile(
          title: 'Assine já!',
          icon: Icons.workspace_premium,
          onTap: () {
            _handleNavigation(context, '/premium', vm);
          },
        ),
        const Spacer(),
        const Divider(),
        UserOptionTile(
          title: 'Curtiu nosso aplicativo?',
          icon: Icons.emoji_emotions_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}
