import 'package:crud_flutter/core/api/api_client.dart';

import 'package:crud_flutter/service/auto_cadastro/mock_auth_service.dart';

import 'package:crud_flutter/service/cadastrar_categoria/categoria_service.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';

import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_service.dart';

import 'package:crud_flutter/service/notifications/notification_service.dart';
import 'package:crud_flutter/service/notifications/engine/notification_engine.dart';

import 'package:crud_flutter/view/splash/splash_screen.dart';

import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';

import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

// =========================
// WORKMANAGER
// =========================
import 'package:workmanager/workmanager.dart';

import 'background/workmanager_callback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // =========================
  // INIT NOTIFICAÇÕES
  // =========================
  //
  // Inicializa:
  // - plugin de notificações
  // - timezone
  // - permissões Android
  //
  await NotificationService.initialize();

  // =========================
  // RESET TESTE
  // =========================
  //
  // Remove trava diária para
  // permitir testar várias vezes.
  //
  // ⚠️ REMOVER EM PRODUÇÃO
  //

  // =========================
  // INIT WORKMANAGER
  // =========================
  //
  // Inicializa sistema de tarefas
  // em background do Android.
  //
  await Workmanager().initialize(
    callbackDispatcher,

    // TRUE = mostra logs detalhados
    // FALSE = produção
    isInDebugMode: true,
  );

  // =========================
  // TESTE INSTANTÂNEO
  // =========================
  //
  // Executa UMA task imediatamente
  // para validar:
  //
  // ✔ background
  // ✔ API
  // ✔ notificações
  // ✔ Workmanager
  //
  // ⚠️ REMOVER EM PRODUÇÃO
  //
  await Workmanager().registerOneOffTask(
    "testTask",
    "dailyReminderTask",
  );

  /*
  // =========================
  // TASK REAL DE PRODUÇÃO
  // =========================
  //
  // Executa automaticamente
  // a cada 24h.
  //
  // ⚠️ USAR EM PRODUÇÃO
  //
  await Workmanager().registerPeriodicTask(
    "dailyReminderTaskId",
    "dailyReminderTask",

    frequency: const Duration(hours: 24),

    initialDelay: const Duration(minutes: 15),

    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );
  */

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
          create: (_) => ApiClient(
            http.Client(),
          ),
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
        // VIEW MODELS
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
          create: (_) => UserViewModel(
            MockAuthService(),
          ),
        ),
      ],

      // =========================
      // APP ROOT
      // =========================
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
