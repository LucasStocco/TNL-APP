/// SharedPreferences (permite salvar dados simples no dispositivo)
import 'package:shared_preferences/shared_preferences.dart';
/// Contrato
import 'package:crud_flutter/core/notificacoes_gamificacao/streak_repository.dart';

/// implementa o contrato StreakRepository.
/// Apenas guarda e recupera dados
class StreakRepositoryImpl implements StreakRepository {
  /// Chave usada dentro do SharedPreferences.
  static const String _chaveStreakAtual = 'streak_atual';

  /// Chave usada para armazenar a última data de uso
  /// SharedPreferences não salva DateTime diretamente,
  /// então a data será convertida para String.
  static const String _chaveUltimaDataUso = 'ultima_data_uso';

  @override
  /// Busca o streak atual
  Future<int> obterStreakAtual() async {
    /// Flutter abre acesso ao armzanamento local do dispositivo (SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    /// Bucas valor
    /// Se existir retorna o valor salvo
    /// Se não existir (ex: primeiro uso do app) retorna 0 como padrão
    return prefs.getInt(_chaveStreakAtual) ?? 0;
  }

  @override
  /// Salva o valor atual do streak
  Future<void> salvarStreakAtual(int streak) async {
    /// Obtém SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    /// Salva o valor do streak usando a chave definida
    await prefs.setInt(_chaveStreakAtual, streak);
  }

  @override
  /// Salva a data do último uso
  Future<void> salvarUltimaDataUso(DateTime data) async {
    /// Obtém SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    /// Salva (SharedPreferences não salva DateTime diretamente.)
    await prefs.setString(
      _chaveUltimaDataUso,
      /// Converte DateTime para String no formato ISO 8601 para armazenamento
      data.toIso8601String(),
    );
  }

  @override
  /// Busca a última data de uso
  /// ? = pode exixtir ou não (ex: primeiro uso do app, ou dados limpos)
  Future<DateTime?> obterUltimaDataUso() async {
    /// Obtém SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    /// Busca a data salva como String
    final dataSalva = prefs.getString(_chaveUltimaDataUso);
    /// Verifica se existe uma data salva. Se não existir, retorna null.
    if (dataSalva == null) {
      return null;
    }

    return DateTime.parse(dataSalva);
  }
}
