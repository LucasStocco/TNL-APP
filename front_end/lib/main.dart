import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/view/home_screen.dart';

import 'package:crud_flutter/service/auto_cadastro/mock_auth_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';

import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ItemService()),
        Provider(create: (_) => ProdutoService()), // ✅ FALTAVA ISSO
        ChangeNotifierProvider(
          create: (context) => ItemViewModel(
            context.read<ItemService>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => CategoriaViewModel()),
        ChangeNotifierProvider(create: (_) => ListaViewModel()),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(MockAuthService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista de Compras',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
