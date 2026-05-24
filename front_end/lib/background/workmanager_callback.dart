import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';

import 'package:crud_flutter/service/notifications/notification_context_builder.dart';
import 'package:crud_flutter/service/notifications/engine/notification_engine.dart';

// IMPORT DAS RULES
import 'package:crud_flutter/service/notifications/rules/list/pending_items_rule.dart';
import 'package:crud_flutter/service/notifications/rules/daily/daily_reminder_rule.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("🔥 WORKMANAGER DISPAROU TASK: $task");

    switch (task) {
      case "dailyReminderTask":
        print("🔥 EXECUTANDO DAILY REMINDER");

        // =========================
        // 1. API
        // =========================
        final apiClient = ApiClient(http.Client());
        final listaService = ListaResumoService(apiClient);

        final listas = await listaService.getResumo();

        print("📦 LISTAS RECEBIDAS: ${listas.length}");

        // =========================
        // 2. CONTEXT BUILDER
        // =========================
        final context = NotificationContextBuilder.build(listas);

        // =========================
        // 3. ENGINE + RULES
        // =========================
        final engine = NotificationEngine([
          PendingItemsRule(),
          DailyReminderRule(),
        ]);

        final notifications = engine.evaluate(context);

        // =========================
        // 4. DISPATCH (TEMPORÁRIO)
        // =========================
        for (final n in notifications) {
          print("🔔 ${n.title}");
          print("📝 ${n.body}");

          // FUTURO:
          // NotificationService.show(...)
        }

        break;
    }

    print("✅ WORKMANAGER FINALIZOU TASK");

    return Future.value(true);
  });
}
