// notification_scheduler.dart

import 'dart:async';

import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';
import 'package:crud_flutter/service/notification/engine/notification_engine.dart';

class NotificationScheduler {
  // =========================
  // BUFFER DE LISTAS
  // =========================
  //
  // Guarda o estado mais recente
  // recebido do ViewModel.
  //
  static List<ListaResumo> _buffer = [];

  // =========================
  // TIMER DE DEBOUNCE
  // =========================
  //
  // Evita múltiplas execuções
  // seguidas em pouco tempo.
  //
  static Timer? _timer;

  // =========================
  // CONTROLE DE EXECUÇÃO
  // =========================
  //
  // Evita flush concorrente.
  //
  static bool _rodando = false;

  // =========================
  // PUSH DE DADOS
  // =========================
  //
  // Recebe listas atualizadas
  // vindas do ViewModel.
  //
  // Fluxo:
  //
  // ViewModel
  //    ↓
  // NotificationScheduler.push()
  //    ↓
  // debounce
  //    ↓
  // _flush()
  //
  static void push(
    List<ListaResumo> listas,
  ) {
    // Atualiza buffer interno
    _buffer = listas;

    // Evita múltiplas execuções simultâneas
    if (_rodando) return;

    _rodando = true;

    // Debounce
    _timer?.cancel();

    _timer = Timer(
      const Duration(milliseconds: 800),
      () {
        _flush();

        _rodando = false;
      },
    );
  }

  // =========================
  // FLUSH
  // =========================
  //
  // Executa processamento interno.
  //
  // Hoje o Scheduler apenas
  // mantém o buffer sincronizado.
  //
  static void _flush() {
    if (_buffer.isEmpty) {
      print('📭 BUFFER VAZIO');
      return;
    }

    print(
      '📦 BUFFER ATUALIZADO: ${_buffer.length} listas',
    );
  }

  // =========================
  // EXECUÇÃO MANUAL
  // =========================
  //
  // Permite disparar o lembrete
  // usando os dados atuais
  // do buffer.
  //
  // Útil para:
  //
  // ✔ debug
  // ✔ testes
  // ✔ foreground
  //
  static Future<void> runDailyReminder() async {
    if (_buffer.isEmpty) {
      print('📭 SEM DADOS PARA LEMBRETE');
      return;
    }

    await NotificationEngine.runDailyReminder(
      _buffer,
    );
  }

  // =========================
  // RESET
  // =========================
  //
  // Limpa estados internos.
  //
  static void reset() {
    _timer?.cancel();

    _timer = null;

    _buffer = [];

    _rodando = false;

    print('🧹 NOTIFICATION SCHEDULER RESET');
  }
}
