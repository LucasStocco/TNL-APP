import 'package:crud_flutter/background/services/api_background_service.dart';
import 'package:crud_flutter/background/services/notification_background_service.dart';
import 'package:crud_flutter/background/services/notification_context_builder.dart';
import 'package:crud_flutter/core/utils/notification_dedup.dart';
import 'package:crud_flutter/core/utils/notification_hash.dart';

import 'package:crud_flutter/core/utils/rules/notification_engine.dart';
import 'package:crud_flutter/core/utils/rules/model/notification_decision.dart';

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

      /// =========================
      /// 1. FETCH API
      /// =========================
      final apiService = ApiBackgroundService();

      final data = await apiService.fetchData();

      if (data.isEmpty) {
        print("⚠️ [API] sem dados");

        return true;
      }

      /// =========================
      /// 2. BUILD CONTEXT
      /// =========================
      final context = NotificationContextBuilder.build(data);

      /// =========================
      /// 3. ENGINE DECISION
      /// =========================
      final NotificationDecision decision =
          NotificationEngine.evaluate(context);

      if (!decision.shouldNotify) {
        print("🔕 [ENGINE] decidiu não notificar");

        return true;
      }

      /// =========================
      /// 4. HASH
      /// =========================
      final hash = NotificationHash.generate(
        "${decision.title}${decision.body}",
      );

      final isDuplicate = await NotificationDedup.isDuplicate(hash);

      if (isDuplicate) {
        print("⛔ DUPLICADO - ignorando");

        return true;
      }

      /// =========================
      /// 5. INIT NOTIFICATION
      /// =========================
      await NotificationBackgroundService.initialize();

      /// =========================
      /// 6. SHOW NOTIFICATION
      /// =========================
      await NotificationBackgroundService.show(
        title: decision.title,
        body: decision.body,
      );

      /// =========================
      /// 7. SAVE HASH
      /// =========================
      await NotificationDedup.save(hash);

      print("✅ WORKER OK FINALIZADO");

      return true;
    } catch (e) {
      print("❌ WORKER ERROR: $e");

      return false;
    }
  }
}
