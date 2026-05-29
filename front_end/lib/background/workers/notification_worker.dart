import 'package:crud_flutter/background/services/api_background_service.dart';
import 'package:crud_flutter/background/services/notification_background_service.dart';
import 'package:crud_flutter/background/services/notification_context_builder.dart';

import 'package:crud_flutter/core/utils/notification_cache_manager.dart';
import 'package:crud_flutter/core/utils/notification_cooldown_manager.dart';
import 'package:crud_flutter/core/utils/notification_dedup.dart';
import 'package:crud_flutter/core/utils/notification_hash.dart';
import 'package:crud_flutter/core/utils/rules/notification_engine.dart';
import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';

import 'package:crud_flutter/model/sistema_notificações/notification_result.dart';

import 'package:crud_flutter/service/notifications/notification_service.dart';

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
      /// COOLDOWN
      /// =========================
      final canSend = await NotificationCooldownManager.canSend();

      if (!canSend) {
        print(
          "⏳ [COOLDOWN] envio já realizado hoje",
        );

        return true;
      }

      /// =========================
      /// 1. FETCH API
      /// =========================
      final apiService = ApiBackgroundService();

      List<ListaResumoResponseDTO> data = [];

      try {
        data = await apiService.fetchData();

        /// Salva cache se API funcionar
        await NotificationCacheManager.saveCache(
          data,
        );

        print("🌐 [API] dados atualizados");
      } catch (e) {
        print("⚠️ [API] falha ao buscar dados");

        /// Tenta recuperar cache
        final cached = await NotificationCacheManager.getCache();

        if (cached == null || cached.isEmpty) {
          print(
            "📭 [CACHE] nenhum cache disponível",
          );

          return true;
        }

        print("💾 [CACHE] usando dados offline");

        data = cached;
      }

      /// =========================
      /// 2. BUILD CONTEXT
      /// =========================
      final context = NotificationContextBuilder.build(data);

      /// =========================
      /// 3. ENGINE
      /// =========================
      final NotificationResult notification =
          NotificationEngine.evaluate(context);

      if (!notification.shouldNotify) {
        print("🔕 nenhuma notificação necessária");

        return true;
      }

      /// =========================
      /// 4. HASH
      /// =========================
      final hash = NotificationHash.generate(
        "${notification.title}${notification.body}",
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
      /// 6. SEND NOTIFICATION
      /// =========================
      await NotificationService.sendNotificationResult(notification);

      /// Salva data + tipo da notificação
      await NotificationCooldownManager.saveSendData(notification);

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
