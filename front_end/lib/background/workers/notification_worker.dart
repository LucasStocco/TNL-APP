import 'package:crud_flutter/background/services/api_background_service.dart';
import 'package:crud_flutter/background/services/notification_context_builder.dart';
import 'package:crud_flutter/core/utils/notification_dedup.dart';
import 'package:crud_flutter/core/utils/notification_hash.dart';
import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import 'package:crud_flutter/service/notifications/notification_service.dart';
import 'package:crud_flutter/service/notifications/rules/model/notification_context.dart';

class NotificationWorker {
  static const String taskName = "dailyReminderTask";

  @pragma('vm:entry-point')
  static Future<bool> execute(
    String task,
    Map<String, dynamic>? inputData,
  ) async {
    try {
      print("🚀 [WORKER] START task: $task");

      if (task != taskName) {
        print("⛔ [WORKER] task ignorada");
        return true;
      }

      final apiService = ApiBackgroundService();

      final data = await apiService.fetchData();

      if (data == null || data.isEmpty) {
        print("⚠️ [API] sem dados");
        return true;
      }

      // ✅ DTO
      final List<ListaResumoResponseDTO> listas = data;

      // ✅ CONTEXTO
      final NotificationContext context =
          NotificationContextBuilder.build(listas);

      // ✅ HASH
      final hash = NotificationHash.generate(
        context.toString(),
      );

      final isDuplicate = await NotificationDedup.isDuplicate(hash);

      if (isDuplicate) {
        print("⛔ DUPLICADO - ignorando");
        return true;
      }

      // ✅ INIT BACKGROUND SAFE
      await NotificationService.initialize(
        background: true,
      );

      // ✅ ENVIO
      await NotificationService.showNotification(
        context.hasPendingItems
            ? "Você tem itens pendentes 📋"
            : "Tudo certo 🎉",
        "Pendentes: ${context.pendingCount}",
      );

      // ✅ SAVE HASH
      await NotificationDedup.save(hash);

      print("✅ WORKER OK FINALIZADO");

      return true;
    } catch (e) {
      print("❌ WORKER ERROR: $e");
      return false;
    }
  }
}
