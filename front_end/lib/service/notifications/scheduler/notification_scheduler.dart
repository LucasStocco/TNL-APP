import 'dart:async';

import 'package:crud_flutter/service/notifications/engine/notification_engine.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';
import 'package:crud_flutter/service/notifications/notification_context_builder.dart';
import 'package:crud_flutter/service/notifications/notification_settings_service.dart';
import 'package:crud_flutter/service/notifications/notification_service.dart';

class NotificationScheduler {
  static List<ListaResumo> _buffer = [];
  static Timer? _timer;
  static bool _rodando = false;

  // =========================
  // PUSH DE DADOS
  // =========================
  static Future<void> push(List<ListaResumo> listas) async {
    // 🔥 FASE 7 — fonte única da verdade (settings)
    final settings = await NotificationSettingsService.getSettings();

    // Se notificações estiverem OFF, não processa nada
    if (!settings.enabled) {
      print('🔕 PUSH IGNORADO (NOTIFICAÇÕES OFF)');
      return;
    }

    _buffer = listas;

    if (_rodando) return;

    _rodando = true;

    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 800), () {
      _flush();
      _rodando = false;
    });
  }

  // =========================
  // FLUSH (BUFFER INTERNO)
  // =========================
  static void _flush() {
    if (_buffer.isEmpty) {
      print('📭 BUFFER VAZIO');
      return;
    }

    print('📦 BUFFER ATUALIZADO: ${_buffer.length} listas');
  }

  // =========================
  // REAGENDAMENTO GLOBAL
  // =========================
  static Future<void> rescheduleAll() async {
    print("🔄 REAGENDANDO TODAS AS NOTIFICAÇÕES");

    // 1. cancela tudo que já existe
    await cancelAll();

    // 2. força novo ciclo de agendamento
    // (scheduler vai reconstruir tudo baseado no novo horário)
  }

  // =========================
  // EXECUÇÃO DO SISTEMA DE NOTIFICAÇÕES
  // =========================
  static Future<void> runDailyReminder() async {
    // 🔥 FASE 7 — bloqueio global via settings
    final settings = await NotificationSettingsService.getSettings();

    if (!settings.enabled) {
      print('🔕 NOTIFICAÇÕES DESATIVADAS (SCHEDULER BLOQUEADO)');
      return;
    }

    if (_buffer.isEmpty) {
      print('📭 SEM DADOS PARA LEMBRETE');
      return;
    }

    // 🔥 1. CONVERTE LISTAS → CONTEXT
    final context = NotificationContextBuilder.build(_buffer);

    // 🔥 2. ENGINE DE REGRAS
    final engine = NotificationEngine([
      // PendingItemsRule(),
      // DailyReminderRule(),
    ]);

    // 🔥 3. AVALIA REGRAS
    final notifications = engine.evaluate(context);

    // 🔥 4. DISPARO (TEMPORÁRIO)
    for (final n in notifications) {
      print("🔔 ${n.title}");
      print("📝 ${n.body}");
    }
  }

  // =========================
  // CANCELAMENTO GLOBAL (FASE 7)
  // =========================
  static Future<void> cancelAll() async {
    // Cancela timer interno
    _timer?.cancel();
    _timer = null;

    // Limpa estado interno
    _buffer.clear();
    _rodando = false;

    // 🔥 Cancela notificações reais do sistema
    await NotificationService.cancelAll();

    print('🚫 TODAS AS NOTIFICAÇÕES CANCELADAS (FASE 7)');
  }

  // =========================
  // RESET COMPLETO DO SCHEDULER
  // =========================
  static void reset() {
    _timer?.cancel();
    _timer = null;
    _buffer = [];
    _rodando = false;

    print('🧹 NOTIFICATION SCHEDULER RESET');
  }
}

/// =========================
/// NOTIFICATION DATA
/// =========================
///
/// Esta classe representa o resultado final de uma notificação gerada
/// pelo sistema.
///
/// Ela contém os dados prontos que serão enviados ao usuário,
/// após a avaliação das regras pelo NotificationEngine.
///
/// =========================
/// RESPONSABILIDADE
/// =========================
///
/// ✔ Armazenar os dados finais da notificação
/// ✔ Transportar título, mensagem e tipo
/// ✔ Servir como saída das NotificationRules
///
/// =========================
/// COMO É GERADA
/// =========================
///
/// NotificationContext
///        ↓
/// NotificationEngine
///        ↓
/// NotificationRule.build()
///        ↓
/// NotificationData
///        ↓
/// NotificationService (envio)
///
/// =========================
/// O QUE ESTA CLASSE NÃO FAZ
/// =========================
///
///  Não contém lógica de decisão
///  Não acessa API ou banco de dados
///  Não agenda notificações
///  Não envia notificações diretamente
///
/// Essas responsabilidades ficam em outras camadas:
///
/// - Engine → avalia regras
/// - Rules → definem quando e o que gerar
/// - Scheduler → controla execução
/// - Service → envia notificações
///
/// =========================
/// RESUMO
/// =========================
///
/// Este modelo representa a notificação final pronta para exibição ao usuário.
///
