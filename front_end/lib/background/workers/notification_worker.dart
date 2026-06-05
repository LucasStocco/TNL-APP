import 'package:crud_flutter/background/services/api_background_service.dart';
import 'package:crud_flutter/background/services/notification_background_service.dart';
import 'package:crud_flutter/background/services/notification_context_builder.dart';
import 'package:crud_flutter/core/utils/anti_spam_engine.dart';
import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';

import 'package:crud_flutter/core/utils/notification/notification_cache_manager.dart';
import 'package:crud_flutter/core/utils/notification/rules/notification_engine.dart';
import 'package:crud_flutter/core/utils/notification_historico_repository.dart';
import 'package:crud_flutter/core/utils/notification_historico_storage.dart';

import 'package:crud_flutter/core/utils/notification_spam_guard.dart';

import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
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
      // =========================================================
      // 🚀 1. ENTRADA DO WORKER
      // =========================================================
      print("🚀 [WORKER] START");

      if (task != taskName) {
        print("⛔ TASK IGNORADA");
        return true;
      }

      // =========================================================
      // 📦 INPUT
      // =========================================================
      final String? filter = inputData?["filter"];
      print("🎯 FILTER: $filter");

      // =========================================================
      // ⏳ COOLDOWN GLOBAL (mantido simples aqui se quiser)
      // =========================================================
      print("⏳ CHECK COOLDOWN");

      // =========================================================
      // 🌐 DADOS (API + CACHE)
      // =========================================================
      print("🌐 BUSCANDO DADOS");

      final apiService = ApiBackgroundService();
      List<ListaResumoResponseDTO> data = [];

      try {
        data = await apiService.fetchData();
        await NotificationCacheManager.saveCache(data);
      } catch (e) {
        print("⚠️ API ERROR");

        final cached = await NotificationCacheManager.getCache();

        if (cached == null || cached.isEmpty) {
          print("📭 SEM DADOS → ENCERRANDO");
          return true;
        }

        data = cached;
      }

      // =========================================================
      // 🧠 CONTEXT BUILDER
      // =========================================================
      print("🧠 CONSTRUINDO CONTEXTO");

      final context = NotificationContextBuilder.build(
        data,
        filter: filter,
      );

      // =========================================================
      // ⚙️ SETTINGS
      // =========================================================
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

      // =========================================================
      // 🧠 ENGINE
      // =========================================================
      print("🧠 EXECUTANDO ENGINE");

      final notification = NotificationEngine.evaluate(
        context: context,
        settings: settings,
      );

      if (!notification.shouldNotify) {
        print("🔕 ENGINE BLOQUEOU");
        return true;
      }

      // =========================================================
      // 🔐 HASH
      // =========================================================
      print("🔐 GERANDO HASH");

      final hash = "${notification.title}${notification.body}";

      // =========================================================
      // 🛡 SPAMGUARD (NOVO FLUXO)
    // =========================================================
      print("🛡 SPAMGUARD VALIDANDO");

      final storage = NotificationHistoricoStorage();
      final repository = NotificationHistoricoRepository(storage);
      final engine = AntiSpamEngine(repository);

      final guard = NotificationSpamGuard(engine);

      final podeEnviar = await guard.podeEnviar(notification, hash);

      if (!podeEnviar) {
        print("⛔ BLOQUEADO PELO SPAMGUARD");
        return true;
      }

      // =========================================================
      // 🔔 ENVIO DA NOTIFICAÇÃO
      // =========================================================
      print("🔔 ENVIANDO NOTIFICAÇÃO");

      await NotificationBackgroundService.initialize();

      await NotificationService.showNotification(
        notification.title ?? '',
        notification.body ?? '',
      );

      // =========================================================
      // 💾 REGISTRO CENTRALIZADO
      // =========================================================
      await guard.registrar(notification, hash);

      print("✅ WORKER FINALIZADO");

      return true;
    } catch (e, stack) {
      print("❌ ERRO NO WORKER: $e");
      print(stack);
      return false;
    }
  }
}

/// =========================================================
/// FLUXO DO SISTEMA DE PROTEÇÃO ANTI-SPAM
/// =========================================================
///
/// WORKER
/// Responsável por orquestrar todo o processo de execução
/// da notificação em background.
///
///   ↓
///
/// SPAMGUARD
/// Primeira camada de proteção.
/// Centraliza a decisão de bloqueio ou permissão da notificação,
/// evitando que regras fiquem espalhadas no Worker.
///
///   ↓
///
/// ANTI-SPAM ENGINE
/// Motor de regras do sistema.
/// Avalia histórico, duplicidade, frequência e limites de envio.
///
///   ↓
///
/// REPOSITORY
/// Camada intermediária que abstrai o acesso aos dados.
/// Permite desacoplamento entre regras e armazenamento.
///
///   ↓
///
/// STORAGE
/// Responsável pela persistência local dos dados de notificações.
/// Faz a leitura e escrita do histórico.
///
///   ↓
///
/// SHARED PREFERENCES
/// Camada de armazenamento físico no dispositivo.
/// Responsável por persistência simples e leve.