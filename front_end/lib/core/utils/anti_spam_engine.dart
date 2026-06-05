import 'package:crud_flutter/core/utils/model/notification_history_model.dart';
import 'package:crud_flutter/core/utils/notification_historico_repository.dart';
import '../utils/notification_hash.dart';

class AntiSpamEngine {
  final NotificationHistoricoRepository repository;

  AntiSpamEngine(this.repository);

  /// =========================
  /// 🎯 CONFIGURAÇÃO (DEMO)
  /// =========================
  static const Duration tempoDuplicidade = Duration(minutes: 10);
  static const Duration cooldownGlobal = Duration(minutes: 10);

  /// =========================
  /// 🧠 LIMITE POR TIPO (2.4)
  /// =========================
  static const Map<String, int> limitePorTipo = {
    'daily_reminder': 1,
    'high_urgency': 2,
  };

  /// =========================
  /// 🧠 DECISÃO PRINCIPAL
  /// =========================
  Future<bool> podeEnviar({
    required String conteudo,
    required String tipo,
  }) async {
    final hash = NotificationHash.generate('$tipo:$conteudo');

    final historico = await repository.buscarTodos();
    final agora = DateTime.now();

    /// =========================
    /// 1. DUPLICIDADE (HASH + 10 MIN)
    /// =========================
    final bloqueioDuplicidade = historico.any((item) {
      return item.hash == hash &&
          agora.difference(item.timestamp) < tempoDuplicidade;
    });

    if (bloqueioDuplicidade) return false;

    /// =========================
    /// 2. LIMITE POR TIPO (2.4)
    /// =========================
    final limiteTipo = limitePorTipo[tipo];

    if (limiteTipo != null) {
      final doTipo = historico.where((item) => item.type == tipo).toList();

      if (doTipo.length >= limiteTipo) {
        return false;
      }
    }

    /// =========================
    /// 3. COOLDOWN GLOBAL (2.3)
    /// =========================
    final ultimaNotificacao = historico.isNotEmpty
        ? historico.reduce(
            (a, b) => a.timestamp.isAfter(b.timestamp) ? a : b,
          )
        : null;

    if (ultimaNotificacao != null) {
      final diferenca = agora.difference(ultimaNotificacao.timestamp);

      if (diferenca < cooldownGlobal) {
        return false;
      }
    }

    return true;
  }

  /// =========================
  /// 📦 REGISTRO APÓS ENVIO
  /// =========================
  Future<void> registrarEnvio(NotificationHistoryModel modelo) async {
    await repository.salvar(modelo);
  }
}
