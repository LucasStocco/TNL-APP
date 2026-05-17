class ListaResumo {
  final int id;
  final String nome;
  final int totalItens;
  final int itensComprados;
  final double progresso;

  ListaResumo({
    required this.id,
    required this.nome,
    required this.totalItens,
    required this.itensComprados,
    required this.progresso,
  });

  factory ListaResumo.fromJson(Map<String, dynamic> json) {
    return ListaResumo(
      id: json['id'],
      nome: json['nome'],
      totalItens: json['totalItens'] ?? 0,
      itensComprados: json['itensComprados'] ?? 0,
      progresso: (json['progresso'] ?? 0).toDouble(),
    );
  }
}

/*
Backend 👉 já calcula progresso
Service 👉 já busca /listas/resumo
Front 👉 ainda usa ListaViewModel.listar() (endpoint antigo) */

/*
Eu escolhi separar Lista e ListaResumo porque na tela “Minhas Listas” eu não preciso carregar todos os itens de cada lista, só as informações resumidas como total, itens comprados e progresso. Como esses dados já vêm prontos do backend, não faz sentido eu tentar recalcular isso no Flutter usando a entidade completa. Essa separação me ajuda a evitar inconsistência de dados, deixa o app mais leve e organiza melhor o código, já que cada modelo representa exatamente o que cada tela precisa. */
