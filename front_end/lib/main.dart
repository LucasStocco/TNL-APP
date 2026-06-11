import 'package:crud_flutter/background/workers/workmanager_callback.dart';
import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/armazenamento_conquistas.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/armazenamento_conquistas_impl.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/conquista_engine.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/conquista_service.dart';


import 'package:crud_flutter/service/cadastrar_categoria/categoria_service.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_service.dart';

import 'package:crud_flutter/service/notifications/notification_service.dart';
import 'package:crud_flutter/view/gerenciar_lista/minhas_listas_screen.dart';
import 'package:crud_flutter/view/home/home_screen.dart';
import 'package:crud_flutter/view/settings/settings_screen.dart';

import 'package:crud_flutter/view/splash/splash_screen.dart';

import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';

import 'package:crud_flutter/service/auto_cadastro/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'package:crud_flutter/core/theme/theme_provider.dart';
import 'package:crud_flutter/service/relatorio_item/relatorio_item_service.dart';
import 'package:crud_flutter/view_model/relatorio_item/relatorio_item_view_model.dart';

// demais imports...
//remover depois de testar
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

const bool isTestMode = true;

const String notificationTaskId = "notification_task";

const String notificationTaskName = "notification_task";
//termina aqui
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initCore();

  Future.delayed(
    const Duration(seconds: 10),
    () async {
      print("🧪 TESTE MANUAL");
      
      await NotificationService.showTestNotification();
    },
  );

  runApp(const MyApp());
}

Future<void> _initCore() async {
  await NotificationService.initialize();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  if (isTestMode) {
    await Workmanager().registerPeriodicTask(
      notificationTaskId,
      notificationTaskName,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 5),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  } else {
    await Workmanager().registerPeriodicTask(
      notificationTaskId,
      notificationTaskName,
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

/// =========='===============
/// DEFINE HORÁRIO (09:00 AM)
/// =========================
Duration _calculateInitialDelay() {
  final now = DateTime.now();

  final target = DateTime(
    now.year,
    now.month,
    now.day,
    9,
  );

  if (now.isAfter(target)) {
    return const Duration(hours: 24) - now.difference(target);
  }
  return target.difference(now);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ArmazenamentoConquistas>(
          create: (_) => ArmazenamentoConquistasImpl(),
        ),
        Provider<ConquistaService>(
          create: (_) => ConquistaService(),
        ),
        Provider<ConquistaEngine>(
          create: (context) => ConquistaEngine(
            context.read<ConquistaService>(),
          ),
        ),
        Provider<ApiClient>(
          create: (_) => ApiClient(http.Client()),
        ),
        Provider<ItemService>(
          create: (context) => ItemService(context.read<ApiClient>()),
        ),
        Provider<ProdutoService>(
          create: (context) => ProdutoService(context.read<ApiClient>()),
        ),
        Provider<ListaService>(
          create: (context) => ListaService(context.read<ApiClient>()),
        ),
        Provider<ListaResumoService>(
          create: (context) => ListaResumoService(context.read<ApiClient>()),
        ),
        Provider<CategoriaService>(
          create: (context) => CategoriaService(context.read<ApiClient>()),
        ),
        Provider<RelatorioItemService>(
          create: (context) => RelatorioItemService(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ItemViewModel(
            context.read<ItemService>(),
            context.read<ConquistaEngine>(),
            context.read<ArmazenamentoConquistas>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ListaViewModel(
            context.read<ListaService>(),
            context.read<ArmazenamentoConquistas>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ListaResumoViewModel(context.read<ListaResumoService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CategoriaViewModel(context.read<CategoriaService>()),
        ),
              ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(GoogleAuthService()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RelatorioItemViewModel(context.read<RelatorioItemService>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
      print("THEME: ${themeProvider.themeMode}");
      
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,

      themeMode: themeProvider.themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      home: SplashScreen(),

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final filter = settings.arguments as String?;

            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                initialFilter: filter,
              ),
            );

          case '/settings':
            return MaterialPageRoute(
              builder: (_) => const SettingsScreen(),
            );

          case '/listas':
            return MaterialPageRoute(
              builder: (_) => const MinhasListasScreen(),
            );

                    default:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            );
        }
      },
    );
  },
),
    );
  }
}
