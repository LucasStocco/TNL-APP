import 'package:crud_flutter/background/workmanager_callback.dart';
import 'package:crud_flutter/core/api/api_client.dart';

import 'package:crud_flutter/core/utils/notification_click_handler.dart';
import 'package:crud_flutter/core/utils/notification_navigation_handler.dart';

import 'package:crud_flutter/service/auto_cadastro/mock_auth_service.dart';
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

/// =========================
/// CONFIG
/// =========================
const bool isTestMode = true;

/// TASK IDS
const String notificationTaskId = "daily_notification_task";
const String notificationTaskName = "dailyNotificationTask";

/// =========================
/// NAVIGATOR GLOBAL
/// =========================
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("⚙️ [MAIN] START APP");

  /// Inicializa o handler responsável pelos deep links
  NotificationClickHandler.init(
    NotificationNavigationHandler(
      navigatorKey: navigatorKey,
    ),
  );

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

/// =========================
/// INIT CORE
/// =========================
Future<void> _initCore() async {
  print("⚙️ [MAIN] INIT CORE");

  await NotificationService.initialize();
  print("🔔 [MAIN] NotificationService OK");

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  print("⚙️ [MAIN] WorkManager initialized");

  if (isTestMode) {
    print("🧪 [MAIN] TEST MODE - DAILY JOB (FAST)");

    await Workmanager().registerPeriodicTask(
      notificationTaskId,
      notificationTaskName,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 5),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  } else {
    print("🚀 [MAIN] PRODUCTION MODE - DAILY JOB");

    await Workmanager().registerPeriodicTask(
      notificationTaskId,
      notificationTaskName,
      frequency: const Duration(hours: 24),
      initialDelay: _calculateInitialDelay(),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  print("✅ [MAIN] WORKMANAGER READY");
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

/// =========================
/// APP ROOT
/// =========================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        ChangeNotifierProvider(
          create: (context) => ItemViewModel(context.read<ItemService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ListaViewModel(context.read<ListaService>()),
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
          create: (_) => UserViewModel(MockAuthService()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
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
      ),
    );
  }
}
