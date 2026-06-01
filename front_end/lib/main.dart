import 'package:crud_flutter/background/workmanager_callback.dart';
import 'package:crud_flutter/background/workers/notification_worker.dart';
import 'package:crud_flutter/core/api/api_client.dart';

import 'package:crud_flutter/service/auto_cadastro/mock_auth_service.dart';
import 'package:crud_flutter/service/cadastrar_categoria/categoria_service.dart';
import 'package:crud_flutter/service/cadastrar_produto/produto_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_service.dart';

import 'package:crud_flutter/service/notifications/notification_service.dart';

import 'package:crud_flutter/view/splash/splash_screen.dart';

import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';

import 'package:crud_flutter/service/auto_cadastro/google_auth_service.dart';
import 'package:crud_flutter/view/home/home_screen.dart';

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
      frequency: const Duration(minutes: 15), // teste rápido
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
      frequency: const Duration(hours: 24), // diário real
      initialDelay: _calculateInitialDelay(), // manhã
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  print("✅ [MAIN] WORKMANAGER READY");
}

/// =========================
/// DEFINE HORÁRIO (09:00 AM)
/// =========================
Duration _calculateInitialDelay() {
  final now = DateTime.now();

  final target = DateTime(
    now.year,
    now.month,
    now.day,
    9, // 9h da manhã
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
          create: (_) => UserViewModel(GoogleAuthService()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
