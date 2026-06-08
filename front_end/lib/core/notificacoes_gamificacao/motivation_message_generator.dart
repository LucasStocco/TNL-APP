import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_motivacional.dart';

/// Tradutor de eventos em mensagens motivacionais.
///
/// Responsável por converter eventos do sistema
/// em feedbacks positivos para o usuário.
class MotivationMessageGenerator {

  /// Entrada (tipo de evento) → Saída (mensagem motivacional)
  String gerarMensagem(TipoEventoMotivacional evento) {
    switch (evento) {
      case TipoEventoMotivacional.listaCriada:
        return "Boa! Você deu o primeiro passo 🔥";

      case TipoEventoMotivacional.listaConcluida:
        return "Incrível! Você finalizou uma lista inteira 🎉";

      case TipoEventoMotivacional.streakAtivo:
        return "Você está criando um ótimo hábito 💪";

      case TipoEventoMotivacional.retornoAoApp:
        return "Que bom te ver de volta 👀 Vamos continuar?";
    }
  }
}