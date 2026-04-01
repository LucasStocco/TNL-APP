import 'package:crud_flutter/view/settings_screen.dart';
import 'package:crud_flutter/service/auto_cadastro/mock_auth_service.dart';
import 'package:crud_flutter/view/theme_screen.dart';
import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'view/home_screen.dart';
import 'view_model/criar_produto/categoria_view_model.dart';
import 'view_model/gerenciar_lista/lista_view_model.dart';
import 'view_model/criar_produto/item_view_model.dart';
import 'view_model/criar_produto/produto_view_model.dart';

// Services
import 'package:crud_flutter/view/premium_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriaViewModel()),
        ChangeNotifierProvider(create: (_) => ListaViewModel()),
        ChangeNotifierProvider(create: (_) => ItemViewModel()),
        ChangeNotifierProvider(create: (_) => ProdutoViewModel()),

        // Atualizado: UserViewModel recebe MockAuthService
        ChangeNotifierProvider(
          create: (_) => UserViewModel(MockAuthService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista de Compras',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
        routes: {
          '/settings': (_) => const SettingsScreen(),
          '/theme': (_) => const ThemeScreen(),
          '/premium': (_) => const PremiumScreen(),
        },
      ),
    );
  }
}
