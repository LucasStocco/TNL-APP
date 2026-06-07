/// Uma forma padronizada de qualquer parte do app ler e salvar informações de streak.

/// Contrato para o repositório de streaks, garantindo que qualquer implementação tenha os métodos necessários para obter e salvar o streak atual e a última data de uso.
abstract class StreakRepository {
  /// Qual o streak salvo atualmente?
  /// Ex: o usuário tem um streak de 5 dias, ou seja, usou o app por 5 dias seguidos. / streak = 5
  Future<int> obterStreakAtual();
  /// Atualiza o valor so streak atual
  Future<void> salvarStreakAtual(int streak);
  /// Identifica quando foi a ultima vez que o usuário abriu o app
  /// DateTime? porque pode ser nulo (ex: primeiro uso do app, ou dados limpos)
  Future<DateTime?> obterUltimaDataUso();
  // Guarda a última data X como acesso
  Future<void> salvarUltimaDataUso(DateTime data);
}