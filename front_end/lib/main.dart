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
import 'package:crud_flutter/service/relatorio_item/relatorio_item_service.dart';
import 'package:crud_flutter/view/splash/splash_screen.dart';
import 'package:crud_flutter/view_model/auto_cadastro/user_view_model.dart';
import 'package:crud_flutter/view_model/cadastrar_categoria/categoria_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/item_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_resumo_view_model.dart';
import 'package:crud_flutter/view_model/gerenciar_lista/lista_view_model.dart';
import 'package:crud_flutter/view_model/relatorio_item/relatorio_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

const bool isTestMode = true;
const String notificationTaskId = "daily_notification_task";
const String notificationTaskName = "dailyNotificationTask";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initCore();
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

Duration _calculateInitialDelay() {
  final now = DateTime.now();
  final target = DateTime(now.year, now.month, now.day, 9);
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
          create: (context) => ItemViewModel(context.read<ItemService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ListaViewModel(context.read<ListaService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ListaResumoViewModel(context.read<ListaResumoService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoriaViewModel(context.read<CategoriaService>()),
        ),
        ChangeNotifierProvider(
          create: (_) => UserViewModel(MockAuthService()),
        ),
        ChangeNotifierProvider(
          create: (context) => RelatorioItemViewModel(context.read<RelatorioItemService>()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}