// componente
import 'package:crud_flutter/shared/widgets/buttons/user_auth_button.dart';
import 'package:crud_flutter/view/auto_cadastro/widgets/user_header.dart';
import 'package:crud_flutter/view/auto_cadastro/widgets/user_options_list.dart';
import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// usei statelessWidget por não ter estado ainda, a tela é fixa
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // componente de header
            const UserHeader(),
            SizedBox(height: 20),
            // botao de entrar
            if (!vm.isLogged)
              // componente botao auto cadastro
              const UserAuthButton(),
            // botao de sair
            if (vm.isLogged)
              ElevatedButton(
                onPressed: vm.logout,
                child: const Text('Sair'),
              ),
            SizedBox(height: 20),

            // mensagem para usuários não logados
            if (!vm.isLogged)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Faça login para acessar suas opções',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            // lista de opções de usuário
            // só renderiza a lista se usuário estiver logado
            if (vm.isLogged)
              const Expanded(
                child: UserOptionsList(),
              ),
          ],
        ),
      ),
    );
  }
}
