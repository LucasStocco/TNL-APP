// notification_engine.dart

import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../notification_service.dart';

class NotificationEngine {
  // =========================
  // LEMBRETE DIÁRIO INTELIGENTE
  // =========================
  //
  // Responsável por:
  // - analisar contexto atual
  // - detectar listas pendentes
  // - evitar spam diário
  // - gerar mensagem dinâmica
  //
  // Este engine NÃO depende da UI.
  // Ele pode rodar:
  //
  // ✔ app aberto
  // ✔ app minimizado
  // ✔ app fechado (Workmanager)
  //
  static Future<void> runDailyReminder(
    List<ListaResumo> listas,
  ) async {
    // =========================
    // FILTRA LISTAS PENDENTES
    // =========================
    //
    // Mantém apenas listas
    // ainda não concluídas.
    //
    final pendentes = listas
        .where(
          (l) => l.progresso < 100,
        )
        .toList();

    // =========================
    // SEM PENDÊNCIAS
    // =========================
    //
    // Se todas as listas estiverem
    // concluídas, não envia nada.
    //
    if (pendentes.isEmpty) {
      print('✅ Nenhuma lista pendente');
      return;
    }

    // =========================
    // CONTROLE DE SPAM
    // =========================
    //
    // Evita disparar múltiplas
    // notificações no mesmo dia.
    //
    final prefs = await SharedPreferences.getInstance();

    // Última data registrada
    final ultimaData = prefs.getString(
      'last_daily_notification',
    );

    // Data atual
    final hoje = DateTime.now().toIso8601String().split('T').first;

    // Já notificou hoje?
    if (ultimaData == hoje) {
      print('🔕 Notificação diária já enviada hoje');
      return;
    }

    // =========================
    // CONTEXTO DAS LISTAS
    // =========================

    // Quantidade total de listas pendentes
    final quantidadePendentes = pendentes.length;

    // Lista principal (primeira pendente)
    final listaPrincipal = pendentes.first;

    // Quantidade de itens restantes
    final faltantes = listaPrincipal.totalItens - listaPrincipal.itensComprados;

    // =========================
    // MENSAGENS INTELIGENTES
    // =========================
    //
    // O texto muda dependendo
    // do contexto atual do usuário.
    //

    String titulo;
    String mensagem;

    // =========================
    // MUITAS LISTAS PENDENTES
    // =========================
    if (quantidadePendentes >= 3) {
      titulo = '📋 Você possui várias listas pendentes';

      mensagem = 'Existem $quantidadePendentes listas aguardando finalização.';
    }

    // =========================
    // LISTA QUASE CONCLUÍDA
    // =========================
    else if (faltantes <= 3) {
      titulo = '🛒 Sua lista está quase pronta';

      mensagem =
          'Faltam apenas $faltantes itens para concluir "${listaPrincipal.nome}".';
    }

    // =========================
    // CENÁRIO PADRÃO
    // =========================
    else {
      titulo = '📋 Você ainda possui itens pendentes';

      mensagem = 'Continue sua lista "${listaPrincipal.nome}" quando puder.';
    }

    // =========================
    // LOGS DEBUG
    // =========================

    print('🔔 ENVIANDO NOTIFICAÇÃO');
    print('📌 TITULO: $titulo');
    print('📝 MENSAGEM: $mensagem');

    // =========================
    // DISPARA NOTIFICAÇÃO
    // =========================

    await NotificationService.showPendingItemsNotification(
      titulo,
      mensagem,
    );

    // =========================
    // SALVA DATA
    // =========================
    //
    // Marca que já notificou hoje.
    //
    await prefs.setString(
      'last_daily_notification',
      hoje,
    );

    print('✅ DATA SALVA');
  }

  // =========================
  // RESET
  // =========================
  //
  // Usado apenas em debug/testes.
  //
  static Future<void> resetDailyNotification() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      'last_daily_notification',
    );

    print('🧹 RESET DAILY NOTIFICATION');
  }
}
