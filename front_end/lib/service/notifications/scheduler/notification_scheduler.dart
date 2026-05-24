import 'dart:async';

import 'package:crud_flutter/service/notifications/engine/notification_engine.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';
import 'package:crud_flutter/service/notifications/notification_context_builder.dart';

class NotificationScheduler {
  static List<ListaResumo> _buffer = [];
  static Timer? _timer;
  static bool _rodando = false;

  // =========================
  // PUSH DE DADOS
  // =========================
  static void push(List<ListaResumo> listas) {
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
  // FLUSH (ATUALIZADO)
  // =========================
  static void _flush() {
    if (_buffer.isEmpty) {
      print('📭 BUFFER VAZIO');
      return;
    }

    print('📦 BUFFER ATUALIZADO: ${_buffer.length} listas');
  }

  // =========================
  // EXECUÇÃO DO SISTEMA NOVO
  // =========================
  static Future<void> runDailyReminder() async {
    if (_buffer.isEmpty) {
      print('📭 SEM DADOS PARA LEMBRETE');
      return;
    }

    // 🔥 1. CONVERTE LISTAS → CONTEXT
    final context = NotificationContextBuilder.build(_buffer);

    // 🔥 2. CRIA ENGINE COM RULES
    final engine = NotificationEngine([
      // aqui entram suas rules
      // PendingItemsRule(),
      // DailyReminderRule(),
    ]);

    // 🔥 3. AVALIA
    final notifications = engine.evaluate(context);

    // 🔥 4. DISPARA (TEMPORÁRIO)
    for (final n in notifications) {
      print("🔔 ${n.title}");
      print("📝 ${n.body}");
    }
  }

  // =========================
  // RESET
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
/// ❌ Não contém lógica de decisão
/// ❌ Não acessa API ou banco de dados
/// ❌ Não agenda notificações
/// ❌ Não envia notificações diretamente
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
