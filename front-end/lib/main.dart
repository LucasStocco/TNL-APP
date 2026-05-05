import 'package:crud_flutter/service/cadastrar_categoria/categoria_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:crud_flutter/core/api/api_client.dart';

import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';

import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';

import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';

import 'package:crud_flutter/service/auto_cadastro/mock_auth_service.dart';
import 'package:crud_flutter/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // =========================
        // CORE
        // =========================
        Provider<ApiClient>(
          create: (_) => ApiClient(http.Client()),
        ),

        // =========================
        // SERVICES
        // =========================
        Provider<ItemService>(
          create: (context) => ItemService(
            context.read<ApiClient>(),
          ),
        ),

        Provider<ProdutoService>(
          create: (context) => ProdutoService(
            context.read<ApiClient>(),
          ),
        ),

        Provider<ListaService>(
          create: (context) => ListaService(
            context.read<ApiClient>(),
          ),
        ),

        Provider<ListaResumoService>(
          create: (context) => ListaResumoService(
            context.read<ApiClient>(),
          ),
        ),

        Provider<CategoriaService>(
          create: (context) => CategoriaService(
            context.read<ApiClient>(),
          ),
        ),

        // =========================
        // VIEWMODELS
        // =========================
        ChangeNotifierProvider(
          create: (context) => ItemViewModel(
            context.read<ItemService>(),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => ListaViewModel(
            context.read<ListaService>(),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => ListaResumoViewModel(
            context.read<ListaResumoService>(),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => CategoriaViewModel(
            context.read<CategoriaService>(),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => UserViewModel(MockAuthService()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
