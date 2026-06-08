import 'package:flutter/material.dart';

import '../../dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../model/gerenciar_lista/lista_resumo.dart';
import '../../service/gerenciar_lista/lista_resumo_service.dart';

import 'package:crud_flutter/service/notifications/scheduler/notification_scheduler.dart';

class ListaResumoViewModel extends ChangeNotifier {
  final ListaResumoService service;

  ListaResumoViewModel(this.service);

  List<ListaResumo> listas = [];

  Lista? listaAtual;

  bool isLoading = false;
  bool isSaving = false;

  String? filtroAtual;
  String? erro;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  void _setError(Object e) {
    erro = e.toString();
    notifyListeners();
  }

  void aplicarFiltro(String? filtro) {
    filtroAtual = filtro;
    notifyListeners();
  }

  // lista filtrada
  List<ListaResumo> get listasFiltradas {
    if (filtroAtual == null) return listas;

    switch (filtroAtual) {
      case 'pendentes':
        return listas.where((l) => l.progresso < 100).toList();

      case 'urgentes':
        return listas.where((l) => l.progresso < 30).toList();

      case 'quase_concluidas':
        return listas
            .where((l) => l.progresso >= 70 && l.progresso < 100)
            .toList();

      default:
        return listas;
    }
  }

  // =========================
  // RESUMO
  // =========================
  Future<void> carregarResumo() async {
    _setLoading(true);

    try {
      print("📡 [RESUMO] INICIANDO carregamento de listas");

      final List<ListaResumoResponseDTO> resultado = await service.getResumo();

      print("📥 [RESUMO] DTO recebido: ${resultado.length} listas");

      listas = resultado
          .map(
            (dto) => ListaResumo(
              id: dto.id,
              nome: dto.nome,
              totalItens: dto.totalItens,
              itensComprados: dto.itensComprados,
              progresso: dto.progresso,
            ),
          )
          .toList();

      print("🧠 [RESUMO] MODEL convertido:");
      for (final l in listas) {
        print(
          "   - Lista ${l.id} | ${l.nome} | "
          "progresso=${l.progresso} | "
          "itens=${l.itensComprados}/${l.totalItens}",
        );
      }

      print("🎯 [RESUMO] Chamando NotificationScheduler...");

      NotificationScheduler.push(listas);

      print("✅ [RESUMO] Scheduler executado");

      notifyListeners();
    } catch (e, stack) {
      print("❌ [RESUMO] ERRO: $e");
      print(stack);

      _setError(e);
    } finally {
      _setLoading(false);
      print("📊 [RESUMO] loading=false finalizado");
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Lista?> criar(String nome) async {
    _setSaving(true);

    try {
      final criada = await service.create(nome);

      await carregarResumo();

      return criada;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Lista?> atualizar(Lista lista) async {
    _setSaving(true);

    try {
      final atualizada = await service.update(lista);

      await carregarResumo();

      return atualizada;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // RENOMEAR
  // =========================
  Future<Lista?> renomearLista(
    int id,
    String novoNome,
  ) async {
    _setSaving(true);

    try {
      final lista = await service.update(
        Lista(
          id: id,
          nome: novoNome,
        ),
      );

      if (listaAtual?.id == id) {
        listaAtual = lista;
      }

      await carregarResumo();

      return lista;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletarLista(int id) async {
    _setSaving(true);

    try {
      await service.delete(id);

      listas.removeWhere((l) => l.id == id);

      if (listaAtual?.id == id) {
        listaAtual = null;
      }

      notifyListeners();

      await carregarResumo();
    } catch (e) {
      _setError(e);
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // FINALIZAR
  // =========================
  Future<void> finalizarLista(int id) async {
    _setSaving(true);

    try {
      await service.finalizarLista(id);

      await carregarResumo();
    } catch (e) {
      _setError(e);
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // SELEÇÃO
  // =========================
  void selecionarLista(Lista lista) {
    listaAtual = lista;

    notifyListeners();
  }

  // =========================
  // RESET
  // =========================
  void resetar() {
    listas = [];

    listaAtual = null;

    erro = null;

    isLoading = false;
    isSaving = false;

    NotificationScheduler.reset();

    notifyListeners();
  }
}
