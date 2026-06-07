/// Classificação das motivações do usuário no sistema.
///
/// Define o contexto emocional usado para gerar mensagens motivacionais.
enum TipoClassificacaoMotivacao {

  /// Progresso geral do usuário dentro do app
  /// (avanço em tarefas, evolução contínua)
  progresso,

  /// Usuário concluiu uma lista ou tarefa importante
  /// representa sensação de conquista
  conclusao,

  /// Usuário está construindo hábito de uso contínuo
  /// foco em repetição ao longo do tempo
  streak,

  /// Usuário voltou ao app após período de inatividade
  retornoAoApp,
}