import 'package:flutter/material.dart';

import '../../model/gerenciar_lista/lista.dart';
import '../../model/gerenciar_lista/lista_resumo.dart';
import '../../service/gerenciar_lista/lista_resumo_service.dart';

class ListaResumoViewModel extends ChangeNotifier {
  final ListaResumoService service;

  ListaResumoViewModel(this.service);

  // =========================
  // STATE (ÚNICA FONTE DE VERDADE)
  // =========================
  List<ListaResumo> listas = [];

  Lista? listaAtual;

  bool isLoading = false;
  bool isSaving = false;

  String? erro;

  // =========================
  // HELPERS
  // =========================

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  void _setError(Object e) {
    erro = e.toString().replaceAll('Exception: ', '');
    notifyListeners();
  }

  void _clearError() {
    erro = null;
    notifyListeners();
  }

  Future<T?> _execute<T>({
    required Future<T> Function() action,
    bool useSaving = false,
  }) async {
    try {
      _clearError();

      useSaving ? _setSaving(true) : _setLoading(true);

      return await action();
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      useSaving ? _setSaving(false) : _setLoading(false);
    }
  }

  // =========================
  // RESUMO (ÚNICA FONTE DE LISTA)
  // =========================
  Future<void> carregarResumo() async {
    final result = await _execute<List<ListaResumo>>(
      action: () => service.getResumo(),
    );

    if (result != null) {
      listas = result;
    }
  }

  // =========================
  // CRUD (SEM LISTA DUPLICADA)
  // =========================

  Future<void> listar() async {
    await carregarResumo(); // agora tudo vem do resumo
  }

  Future<Lista?> criar(String nome) async {
    final criada = await _execute<Lista>(
      useSaving: true,
      action: () => service.create(nome),
    );

    if (criada != null) {
      listaAtual = criada;
      await carregarResumo(); // 🔥 source of truth
    }

    return criada;
  }

  void selecionarLista(Lista lista) {
    listaAtual = lista;
    notifyListeners();
  }

  Future<Lista?> atualizar(Lista lista) async {
    if (lista.id == null) {
      _setError("ID obrigatório");
      return null;
    }

    final atualizada = await _execute<Lista>(
      useSaving: true,
      action: () => service.update(lista),
    );

    if (atualizada != null) {
      if (listaAtual?.id == atualizada.id) {
        listaAtual = atualizada;
      }

      await carregarResumo();
    }

    return atualizada;
  }

  /// =========================
  /// RENOMEAR (ESPECIAL PARA NÃO DUPLICAR LISTA)
  /// =========================
  Future<void> renomearLista(int id, String novoNome) async {
    await _execute<void>(
      useSaving: true,
      action: () => service.update(
        Lista(
          id: id,
          nome: novoNome,
        ),
      ),
    );

    await carregarResumo();
  }

  // =========================
  // DELETE
  // =========================
  Future<void> deletarLista(int id) async {
    await _execute<void>(
      useSaving: true,
      action: () => service.delete(id),
    );

    if (erro != null) return;

    if (listaAtual?.id == id) {
      listaAtual = null;
    }

    await carregarResumo();
  }

  // =========================
  // FINALIZAR
  // =========================
  Future<void> finalizar(int id) async {
    await _execute<void>(
      useSaving: true,
      action: () => service.finalizarLista(id),
    );

    if (erro != null) return;

    await carregarResumo();
  }

  // =========================
  // RESET
  // =========================
  void resetar() {
    listas = [];
    listaAtual = null;
    isLoading = false;
    isSaving = false;
    erro = null;

    notifyListeners();
  }
}
