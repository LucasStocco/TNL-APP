import 'package:flutter/material.dart';

import 'package:crud_flutter/core/notificacoes_gamificacao/armazenamento_conquistas.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/conquista_engine.dart';
import 'package:crud_flutter/core/notificacoes_gamificacao/tipo_evento_conquista.dart';

import 'package:crud_flutter/model/gerenciar_lista/item.dart';
import 'package:crud_flutter/service/gerenciar_lista/item_service.dart';

import 'package:crud_flutter/dto/request/gerenciar_lista/item_request_create_dto.dart';
import 'package:crud_flutter/dto/request/gerenciar_lista/item_request_update_dto.dart';

class ItemViewModel extends ChangeNotifier {
  // =========================
  // DEPENDÊNCIAS
  // =========================
  final ItemService _service;
  final ConquistaEngine _conquistaEngine;
  final ArmazenamentoConquistas _armazenamentoConquistas;

  ItemViewModel(
    this._service,
    this._conquistaEngine,
    this._armazenamentoConquistas,
  );

  // =========================
  // STATE
  // =========================
  final List<Item> _itens = [];
  TipoEventoConquista? _ultimaConquistaDesbloqueada;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _erro;

  // =========================
  // GETTERS
  // =========================
  List<Item> get itens => List.unmodifiable(_itens);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get erro => _erro;

  TipoEventoConquista? get ultimaConquistaDesbloqueada =>
      _ultimaConquistaDesbloqueada;

  // =========================
  // HELPERS
  // =========================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void _setError(Object e) {
    _erro = e.toString();
    notifyListeners();
  }

  void _clearError() {
    _erro = null;
  }

  Future<T?> _runLoading<T>(Future<T> Function() action) async {
    try {
      _clearError();
      _setLoading(true);
      return await action();
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<T?> _runSaving<T>(Future<T> Function() action) async {
    try {
      _clearError();
      _setSaving(true);
      return await action();
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
    }
  }

  Future<void> resetarConquistas() async {
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔄 RESET GAMIFICAÇÃO INICIADO');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━');

    try {
      // 1. reset contador principal
      await _armazenamentoConquistas.salvarTotalListasConcluidas(0);
      print('✔ total de listas = 0');

      // 2. limpar conquistas salvas
      await _armazenamentoConquistas.limparConquistas();
      print('✔ conquistas limpas');

      // 3. LIMPAR LISTAS JÁ CONTADAS (ESSENCIAL)
      await _armazenamentoConquistas.limparListasConcluidas();
      print('✔ listas concluídas limpas');

      // 4. reset estado UI
      _ultimaConquistaDesbloqueada = null;
      print('✔ estado da UI resetado');

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('✅ RESET COMPLETO FINALIZADO');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
    } catch (e) {
      print('❌ ERRO AO RESETAR GAMIFICAÇÃO: $e');
    }
  }

  // =========================
  // LISTAGEM
  // =========================
  Future<void> carregar(int listaId) async {
    final resultado = await _runLoading(
      () => _service.listar(listaId),
    );

    if (resultado != null) {
      _itens
        ..clear()
        ..addAll(resultado);

      notifyListeners();
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Item?> criar({
    required int listaId,
    required int idProduto,
    required int quantidade,
    required double preco,
  }) async {
    return await _runSaving(() async {
      final dto = ItemCreateDTO(
        produtoId: idProduto,
        quantidade: quantidade,
        preco: preco,
      );

      final novo = await _service.criar(listaId, dto);

      await carregar(listaId);
      return novo;
    });
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Item?> atualizar({
    required int listaId,
    required int idItem,
    required int quantidade,
    required double preco,
  }) async {
    return await _runSaving(() async {
      final dto = ItemUpdateDTO(
        quantidade: quantidade,
        preco: preco,
      );

      final atualizado = await _service.atualizar(
        listaId,
        idItem,
        dto,
      );

      await carregar(listaId);
      return atualizado;
    });
  }

  // =========================
  // TOGGLE + CONQUISTA
  // =========================
  Future<TipoEventoConquista?> marcarComprado(
    int listaId,
    int idItem,
    bool comprado,
  ) async {
    TipoEventoConquista? conquistaResultante;

    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🧩 ITEM FLOW - marcarComprado');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📌 listaId: $listaId | itemId: $idItem | comprado: $comprado');

    await _runSaving(() async {
      try {
        // =========================
        // 1. SERVICE CALL
        // =========================
        print('\n🔄 [STEP 1] SERVICE CALL');

        if (comprado) {
          print('→ marcando como comprado...');
          await _service.marcarComprado(listaId, idItem);
        } else {
          print('→ desmarcando item...');
          await _service.desmarcarComprado(listaId, idItem);
        }

        print('✅ Service call concluído');

        // =========================
        // 2. RELOAD LISTA
        // =========================
        print('\n📥 [STEP 2] RELOAD LISTA');

        final listaAtualizada = await _service.listar(listaId);

        if (listaAtualizada.isEmpty) {
          print('❌ ERRO CRÍTICO: lista veio vazia');
          return;
        }

        _itens
          ..clear()
          ..addAll(listaAtualizada);

        notifyListeners();

        print('📊 Itens carregados: ${_itens.length}');

        for (var i in _itens) {
          print('→ Item ${i.id} | comprado=${i.comprado}');
        }

        // =========================
        // 3. CALCULAR PROGRESSO
        // =========================
        print('\n📊 [STEP 3] PROGRESSO');

        final totalItens = _itens.length;
        final concluidos = _itens.where((i) => i.comprado).length;

        print('Total: $totalItens');
        print('Concluídos: $concluidos');

        if (totalItens == 0) {
          print('❌ ERRO: lista sem itens');
          return;
        }

        final listaFoiConcluida = concluidos == totalItens;

        print('Lista completa: $listaFoiConcluida');

        if (!listaFoiConcluida) {
          print('⏭️ Não completa → encerra gamificação');
          return;
        }

        // =========================
        // 4. GAMIFICATION CHECKPOINT
        // =========================
        print('\n🏆 [STEP 4] GAMIFICATION CHECKPOINT');

        final listasJaContadas =
            await _armazenamentoConquistas.obterListasConcluidas();

        print('Listas já contadas: $listasJaContadas');

        if (listasJaContadas.contains(listaId)) {
          print('⚠️ Lista já foi usada em conquista');
          return;
        }

        print('✔ Lista ainda não usada → pode contar');

        await _armazenamentoConquistas.salvarListaConcluida(listaId);

        final totalAtual =
            await _armazenamentoConquistas.obterTotalListasConcluidas();

        final novoTotal = totalAtual + 1;

        await _armazenamentoConquistas.salvarTotalListasConcluidas(novoTotal);

        print('📦 Total anterior: $totalAtual');
        print('➕ Novo total: $novoTotal');

        // =========================
        // 5. ENGINE DECISION
        // =========================
        print('\n🧠 [STEP 5] ENGINE DECISION');

        final conquista = _conquistaEngine.avaliarConclusaoLista(novoTotal);

        print('🎯 Engine retornou: ${conquista?.name ?? "nenhuma"}');

        if (conquista == null) {
          print('⚠️ Nenhuma conquista desbloqueada');
          return;
        }

        // =========================
        // 6. SAVE RESULT
        // =========================
        print('\n💾 [STEP 6] SAVE CONQUISTA');

        _ultimaConquistaDesbloqueada = conquista;

        await _armazenamentoConquistas.salvarConquista(conquista);

        conquistaResultante = conquista;

        print('✅ Conquista salva com sucesso!');
      } catch (e, stack) {
        print('\n❌ ERRO NO MARCAR COMPRADO');
        print('Erro: $e');
        print('Stack: $stack');
      } finally {
        print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      }
    });

    print('⬅ RETURN: ${conquistaResultante?.name ?? "null"}');

    return conquistaResultante;
  }

  // =========================
  // STATUS
  // =========================
  bool isListCompleted() {
    return _itens.isNotEmpty && _itens.every((i) => i.comprado);
  }

  // =========================
  // DELETE
  // =========================
  Future<void> deletar(
    int listaId,
    int idItem,
  ) async {
    await _runSaving(() async {
      await _service.deletar(listaId, idItem);
      await carregar(listaId);
    });
  }

  // =========================
  // RESET UI
  // =========================
  void limparConquistaDesbloqueada() {
    _ultimaConquistaDesbloqueada = null;
    notifyListeners();
  }
}
