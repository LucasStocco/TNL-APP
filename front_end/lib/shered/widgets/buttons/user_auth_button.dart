import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAuthButton extends StatelessWidget {
  const UserAuthButton({super.key});

  // função que trata login/logout com snackbar
 void _handleAuth(BuildContext context, UserViewModel vm) async {
  try {

    if (vm.isLogged) {

      await vm.logout();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout realizado com sucesso'),
        ),
      );

    } else {

      final confirmar = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Entrar com Google'),
          content: const Text(
            'Ao continuar, o aplicativo utilizará:\n\n'
            '• Seu nome\n'
            '• Seu e-mail\n'
            '• Sua foto de perfil\n\n'
            'Esses dados serão usados apenas para autenticação da conta.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (confirmar == true) {

        await vm.login();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso'),
          ),
        );
      }
    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();

    return ElevatedButton(
      onPressed: vm.isLoading ? null : () => _handleAuth(context, vm),
      child: vm.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(vm.isLogged ? 'Sair' : 'Entrar'),
    );
  }
}
