import 'package:crud_flutter/core/utils/notification/messages/notification_frequency.dart';
import 'package:flutter/src/material/time.dart';

class EstadoNotificacao {
  final bool notificacoesAtivadas;
  final bool lembretesAtivados;
  final bool contextoAtivado;
  final bool incentivosAtivados;
  final TimeOfDay horarioPreferido;

  final bool horarioPreferidoAtivado;
  final FrequenciaNotificacao frequencia;

  const EstadoNotificacao({
    required this.notificacoesAtivadas,
    required this.lembretesAtivados,
    required this.contextoAtivado,
    required this.incentivosAtivados,
    required this.horarioPreferidoAtivado,
    required this.frequencia,
    required this.horarioPreferido,
  });

  EstadoNotificacao copyWith({
    bool? notificacoesAtivadas,
    bool? lembretesAtivados,
    bool? contextoAtivado,
    bool? incentivosAtivados,
    bool? horarioPreferidoAtivado,
    FrequenciaNotificacao? frequencia,
    TimeOfDay? horarioPreferido,
  }) {
    return EstadoNotificacao(
      notificacoesAtivadas: notificacoesAtivadas ?? this.notificacoesAtivadas,
      lembretesAtivados: lembretesAtivados ?? this.lembretesAtivados,
      contextoAtivado: contextoAtivado ?? this.contextoAtivado,
      incentivosAtivados: incentivosAtivados ?? this.incentivosAtivados,
      horarioPreferidoAtivado:
          horarioPreferidoAtivado ?? this.horarioPreferidoAtivado,
      frequencia: frequencia ?? this.frequencia,
      horarioPreferido: horarioPreferido ?? this.horarioPreferido,
    );
  }
}
