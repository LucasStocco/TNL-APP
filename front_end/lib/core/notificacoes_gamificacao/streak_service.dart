import 'package:crud_flutter/core/notificacoes_gamificacao/streak_repository.dart';

/// Cérebro do sistema de streak.
/// Contém as regras de negócio responsáveis por calcular
/// e atualizar a sequência de uso do usuário.
///
/// Fluxo:
/// 1. Buscar última data de uso
/// 2. Buscar streak atual
/// 3. Comparar com a data de hoje
/// 4. Atualizar streak
/// 5. Persistir resultado
class StreakService {
  /// Dependência responsável por armazenar e recuperar os dados
  final StreakRepository _repository;

  /// Construtor
  StreakService(this._repository);

  /// Atualiza o streak do usuário e retorna o valor atualizado
  Future<int> atualizarStreak() async {
    final ultimaDataUso = await _repository.obterUltimaDataUso();

    final streakAtual = await _repository.obterStreakAtual();

    final hoje = DateTime.now();

    /// Primeiro acesso do usuário
    if (ultimaDataUso == null) {
      await _repository.salvarStreakAtual(1);
      await _repository.salvarUltimaDataUso(hoje);

      return 1;
    }

    /// Remove horas/minutos para comparar apenas os dias
    final hojeSemHorario = DateTime(
      hoje.year,
      hoje.month,
      hoje.day,
    );

    final ultimaDataSemHorario = DateTime(
      ultimaDataUso.year,
      ultimaDataUso.month,
      ultimaDataUso.day,
    );

    /// Quantos dias se passaram desde o último uso
    final diferencaDias =
        hojeSemHorario.difference(ultimaDataSemHorario).inDays;

    /// Usuário já utilizou o app hoje
    if (diferencaDias == 0) {
      return streakAtual;
    }

    /// Usuário utilizou ontem → aumenta streak
    if (diferencaDias == 1) {
      final novoStreak = streakAtual + 1;

      await _repository.salvarStreakAtual(novoStreak);
      await _repository.salvarUltimaDataUso(hoje);

      return novoStreak;
    }

    /// Usuário perdeu a sequência
    await _repository.salvarStreakAtual(1);
    await _repository.salvarUltimaDataUso(hoje);

    return 1;
  }
}
/// Entendendo o código:
/// Primeiro acesso =  streak começa em 1
/// Abriu novamente no mesmo dia = streak não muda
/// Abriu no dia seguinte = streak aumenta em 1
/// Ficou 2 ou mais dias sem abrir = streak reseta para 1