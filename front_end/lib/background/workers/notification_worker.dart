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
      // =========================
      // 🚀 START
      // =========================
      print("\n==============================");
      print("🚀 [WORKER] START");
      print("🧾 task: $task");
      print("==============================");

      if (task != taskName) {
        print("⛔ [WORKER] TASK IGNORADA: $task");
        return true;
      }

      // =========================
      // 📦 INPUT
      // =========================
      print("📦 [INPUT] $inputData");

      final String? filter = inputData?["filter"];
      print("🎯 [FILTER] $filter");

      // =========================
      // ⏳ COOLDOWN
      // =========================
      print("⏳ [COOLDOWN] checking...");

      if (!testMode) {
        final cooldown = await NotificationCooldownManager.checkCooldown();

        print("⏳ [COOLDOWN] canSend: ${cooldown.canSend}");

        if (!cooldown.canSend) {
          print("⛔ [COOLDOWN] ACTIVE");
          print("⏱️ remaining: ${cooldown.remaining}");

          return true;
        }
      } else {
        print("🧪 [TEST MODE] cooldown bypassed");
      }

      // =========================
      // 🌐 API
      // =========================
      print("🌐 [API] fetching data...");

      final apiService = ApiBackgroundService();
      List<ListaResumoResponseDTO> data = [];

      try {
        data = await apiService.fetchData();

        print("📊 [API] items: ${data.length}");

        await NotificationCacheManager.saveCache(data);
        print("💾 [CACHE] saved");
      } catch (e) {
        print("⚠️ [API ERROR] $e");

        final cached = await NotificationCacheManager.getCache();

        if (cached == null || cached.isEmpty) {
          print("📭 [CACHE] EMPTY → STOP");
          return true;
        }

        print("♻️ [CACHE] fallback activated");
        data = cached;
      }

      // =========================
      // 🧠 CONTEXT
      // =========================
      print("🧠 [CONTEXT] building...");
      print("📦 input size: ${data.length}");
      print("🎯 filter: $filter");

      final context = NotificationContextBuilder.build(
        data,
        filter: filter,
      );

      print("🧠 [CONTEXT READY]");
      print("   total: ${context.totalLists}");
      print("   pending: ${context.pendingLists}");
      print("   completed: ${context.completedLists}");
      print("   urgency: ${context.urgencyLevel}");

      // =========================
      // ⚙️ SETTINGS
      // =========================
      print("⚙️ [SETTINGS] building...");

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

      // =========================
      // 🧠 ENGINE
      // =========================
      print("🧠 [ENGINE] evaluating...");

      final notification = NotificationEngine.evaluate(
        context: context,
        settings: settings,
      );

      print("📨 [ENGINE RESULT]");
      print("   shouldNotify: ${notification.shouldNotify}");
      print("   title: ${notification.title}");
      print("   body: ${notification.body}");

      if (!notification.shouldNotify) {
        print("🔕 [ENGINE] NO NOTIFICATION");
        return true;
      }

      // =========================
      // 🔐 HASH
      // =========================
      final hash = NotificationHash.generate(
        "${notification.title}${notification.body}",
      );

      print("🔐 [HASH] $hash");

      if (!testMode) {
        final isDuplicate = await NotificationDedup.isDuplicate(hash);

        print("🔁 [DEDUP] $isDuplicate");

        if (isDuplicate) {
          print("⛔ DUPLICATE BLOCKED");
          return true;
        }
      }

      // =========================
      // 🔔 NOTIFICATION
      // =========================
      print("🔔 [NOTIFICATION] initializing...");

      await NotificationBackgroundService.initialize();

      print("📤 [NOTIFICATION] sending...");
      await NotificationService.showNotification(
        notification.title ?? '',
        notification.body ?? '',
      );

      // =========================
      // 💾 STATE
      // =========================
      await NotificationCooldownManager.saveSendData(notification);
      await NotificationDedup.save(hash);

      print("✅ [WORKER] DONE SUCCESS");

      return true;
    } catch (e, stack) {
      print("❌ [WORKER ERROR] $e");
      print("📍 STACKTRACE:\n$stack");
      return false;
    }
  }
}
