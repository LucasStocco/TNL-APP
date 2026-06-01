import 'package:crud_flutter/background/services/api_background_service.dart';
import 'package:crud_flutter/background/services/notification_background_service.dart';
import 'package:crud_flutter/background/services/notification_context_builder.dart';
import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';

import 'package:crud_flutter/core/utils/notification/notification_cache_manager.dart';
import 'package:crud_flutter/core/utils/notification/notification_cooldown_manager.dart';
import 'package:crud_flutter/core/utils/notification/notification_dedup.dart';
import 'package:crud_flutter/core/utils/notification/notification_hash.dart';
import 'package:crud_flutter/core/utils/notification/rules/notification_engine.dart';
import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_result.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_settings_model.dart';
import 'package:crud_flutter/model/sistema_notifica%C3%A7%C3%B5es/notification_type.dart';

import 'package:crud_flutter/service/notifications/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationWorker {
  static const String taskName = "dailyReminderTask";
  static const bool testMode = true;

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
      if (!testMode) {
        final cooldown = await NotificationCooldownManager.checkCooldown();

        if (!cooldown.canSend) {
          print(
            "⏳ COOLDOWN ativo - faltam: "
            "${cooldown.remaining.inMinutes}m "
            "${cooldown.remaining.inSeconds % 60}s",
          );

          return true;
        }
      }

      /// =========================
      /// 1. FETCH API
      /// =========================
      final apiService = ApiBackgroundService();

      List<ListaResumoResponseDTO> data = [];

      try {
        data = await apiService.fetchData();

        await NotificationCacheManager.saveCache(data);

        print("🌐 [API] dados atualizados");
      } catch (e) {
        print("⚠️ [API] falha ao buscar dados");

        final cached = await NotificationCacheManager.getCache();

        if (cached == null || cached.isEmpty) {
          print("📭 [CACHE] nenhum cache disponível");
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
      /// 3. SETTINGS (TEMPORÁRIO)
      /// =========================
      final settings = NotificationSettingsModel(
        enabled: true,
        typesEnabled: {
          NotificationType.reminder: true,
          NotificationType.context: true,
          NotificationType.incentive: true,
        },
        frequency: FrequenciaNotificacao.normal,
        preferredTime: const TimeOfDay(hour: 9, minute: 0),
      );

      /// =========================
      /// 4. ENGINE
      /// =========================
      final NotificationResult notification = NotificationEngine.evaluate(
        context: context,
        settings: settings,
      );

      if (!notification.shouldNotify) {
        print("🔕 nenhuma notificação necessária");
        return true;
      }

      /// =========================
      /// 5. HASH
      /// =========================
      final hash = NotificationHash.generate(
        "${notification.title}${notification.body}",
      );

      if (!testMode) {
        final isDuplicate = await NotificationDedup.isDuplicate(hash);

        if (isDuplicate) {
          print("⛔ DUPLICADO - ignorando");
          return true;
        }
      }

      /// =========================
      /// 6. INIT NOTIFICATION
      /// =========================
      await NotificationBackgroundService.initialize();

      /// =========================
      /// 7. SEND NOTIFICATION
      /// =========================
      await NotificationService.sendNotificationResult(notification);

      /// =========================
      /// 8. SAVE STATE
      /// =========================
      await NotificationCooldownManager.saveSendData(notification);
      await NotificationDedup.save(hash);

      print("✅ WORKER OK FINALIZADO");

      return true;
    } catch (e) {
      print("❌ WORKER ERROR: $e");
      return false;
    }
  }
}
