import 'package:workmanager/workmanager.dart';

// Cria cliente HTTP para chamadas da API.
import 'package:http/http.dart' as http;

// Wrapper central de requisições.
import 'package:crud_flutter/core/api/api_client.dart';

// Busca os dados das listas.
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';

// Executa as regras de negócio.
import 'package:crud_flutter/service/notification/engine/notification_engine.dart';

/// =============================================
/// BACKGROUND WORKMANAGER ENTRY POINT
/// =============================================
///
/// Este arquivo é o ponto de entrada do Workmanager.
/// Ele é executado em um isolate separado do Flutter.
///
/// 📌 Função:
/// - Permitir execução de tarefas em background
/// - Rodar notificações mesmo com o app fechado
/// - Ativar o lembrete diário do sistema
///
/// ⚠️ IMPORTANTE:
/// - Este código NÃO roda na UI do Flutter
/// - Não pode acessar contexto de widgets
/// - Deve ser leve e rápido (sem operações pesadas)
///
/// Fluxo:
/// Android Workmanager
///        ↓
/// callbackDispatcher
///        ↓
/// Busca listas na API
///        ↓
/// NotificationEngine
///        ↓
/// NotificationService (notificação local)
///

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("🔥 WORKMANAGER DISPAROU TASK: $task");

    switch (task) {
      case "dailyReminderTask":
        print("🔥 EXECUTANDO DAILY REMINDER");

        // Cria cliente HTTP
        final apiClient = ApiClient(http.Client());

        // Cria service de resumo
        final listaResumoService = ListaResumoService(apiClient);

        // Busca listas reais da API
        final listas = await listaResumoService.getResumo();
        print("📦 LISTAS RECEBIDAS: ${listas.length}");

        // =========================
        // TESTE INSTANTÂNEO
        // =========================
        //
        // Executa imediatamente o lembrete diário
        // usando dados reais da API.
        //
        await NotificationEngine.runDailyReminder(listas);

        break;
    }

    print("✅ WORKMANAGER FINALIZOU TASK");

    return Future.value(true);
  });
}
