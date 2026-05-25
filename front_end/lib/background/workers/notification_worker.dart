import 'package:crud_flutter/background/services/api_background_service.dart';
import 'package:crud_flutter/background/services/notification_background_service.dart';
import 'package:crud_flutter/background/services/notification_context_builder.dart';
import 'package:crud_flutter/core/utils/notification_dedup.dart';
import 'package:crud_flutter/core/utils/notification_hash.dart';

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

      // =========================
      // 1. FETCH API
      // =========================
      final apiService = ApiBackgroundService();
      final data = await apiService.fetchData();

      if (data == null || data.isEmpty) {
        print("⚠️ [API] sem dados");
        return true;
      }

      // =========================
      // 2. CONTEXT BUILD
      // =========================
      final context = NotificationContextBuilder.build(data);

      // =========================
      // 3. ANTI DUPLICATE
      // =========================
      final hash = NotificationHash.generate(context.toString());

      final isDuplicate = await NotificationDedup.isDuplicate(hash);
      if (isDuplicate) {
        print("⛔ DUPLICADO - ignorando");
        return true;
      }

      // =========================
      // 4. NOTIFICATION INIT (ONLY ONCE)
      // =========================
      await NotificationBackgroundService.initialize();

      // =========================
      // 5. DECISION MESSAGE
      // =========================
      final title = context.hasPendingItems
          ? "Você tem itens pendentes 📋"
          : "Tudo certo 🎉";

      final body = "Pendentes: ${context.pendingLists}";

      // =========================
      // 6. SEND NOTIFICATION (ONLY ONE SYSTEM)
      // =========================
      await NotificationBackgroundService.show(
        title: title,
        body: body,
      );

      // =========================
      // 7. SAVE HASH
      // =========================
      await NotificationDedup.save(hash);

      print("✅ WORKER OK FINALIZADO");

      return true;
    } catch (e) {
      print("❌ WORKER ERROR: $e");
      return false;
    }
  }
}
