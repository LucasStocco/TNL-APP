import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';


class ConquistaLogger {
  static void logProgresso({
    required int total,
    required TipoEventoConquista? conquista,
  }) {
    final proxima = _proximaMeta(total);
    final falta = proxima - total;

    print('''
━━━━━━━━━━━━━━━━━━━━━━━━━━
🏆 PROGRESSO DE CONQUISTAS
━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Concluídas: $total listas
🎯 Próxima meta: $proxima listas
📉 Faltam: $falta listas
⭐ Conquista atual: ${conquista?.name ?? 'nenhuma'}
━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
  }

  static int _proximaMeta(int total) {
    if (total < 1) return 1;
    if (total < 5) return 5;
    if (total < 10) return 10;
    if (total < 20) return 20;
    return total + 10; // progressivo depois disso
  }
}
