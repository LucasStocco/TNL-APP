import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

 String abreviarNome(String nome, int limite) {
    if (nome.length <= limite) {
      return nome;
    }

    return '${nome.substring(0, limite)}...';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
                Text(
          vm.isLogged
              ? 'Olá, ${abreviarNome(vm.user!.nome, 12)}'
              : 'Olá!',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundImage:
              vm.user?.fotoUrl != null ? NetworkImage(vm.user!.fotoUrl!) : null,
          child: vm.user?.fotoUrl == null ? const Icon(Icons.person) : null,
        ),
      ],
    );
  }
}
