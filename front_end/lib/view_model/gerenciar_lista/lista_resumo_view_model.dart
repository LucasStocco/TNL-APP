import 'package:flutter/material.dart';

import '../../model/gerenciar_lista/lista.dart';
import '../../model/gerenciar_lista/lista_resumo.dart';
import '../../service/gerenciar_lista/lista_resumo_service.dart';

class ListaResumoViewModel extends ChangeNotifier {
  final ListaResumoService service;

  ListaResumoViewModel(this.service);

  // =========================
  // STATE (RESUMO)
  // =========================
  List<ListaResumo> listas = [];

  // =========================
  // STATE (CRUD)
  // =========================
  List<Lista> listasCrud = [];
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

  String _parseErro(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  Future<T?> _execute<T>({
    required Future<T> Function() action,
    bool useSaving = false,
  }) async {
    erro = null;

    if (useSaving) {
      _setSaving(true);
    } else {
      _setLoading(true);
    }

    try {
      return await action();
    } catch (e) {
      erro = _parseErro(e);
      return null;
    } finally {
      if (useSaving) {
        _setSaving(false);
      } else {
        _setLoading(false);
      }
    }
  }

  // =========================
  // RESUMO
  // =========================
  Future<void> carregarResumo() async {
    final result = await _execute<List<ListaResumo>>(
      action: () => service.getResumo(),
    );

    if (result != null) {
      listas = result;
    }

    notifyListeners();
  }

  // =========================
  // CRUD
  // =========================

  Future<void> listar() async {
    final result = await _execute<List<Lista>>(
      action: () => service.getAll(),
    );

    if (result != null) {
      listasCrud = result;
    }

    notifyListeners();
  }

  Future<Lista?> criar(String nome) async {
    final criada = await _execute<Lista>(
      useSaving: true,
      action: () => service.create(nome),
    );

    if (criada != null) {
      listasCrud.add(criada);
      listaAtual = criada;
    }

    notifyListeners();
    return criada;
  }

  void selecionarLista(Lista lista) {
    listaAtual = lista;
    notifyListeners();
  }

  Future<Lista?> atualizar(Lista lista) async {
    if (lista.id == null) {
      erro = "ID obrigatório";
      notifyListeners();
      return null;
    }

    final atualizada = await _execute<Lista>(
      useSaving: true,
      action: () => service.update(lista),
    );

    if (atualizada != null) {
      final index = listasCrud.indexWhere((l) => l.id == atualizada.id);

      if (index != -1) {
        listasCrud[index] = atualizada;
      }

      if (listaAtual?.id == atualizada.id) {
        listaAtual = atualizada;
      }
    }

    notifyListeners();
    return atualizada;
  }

  Future<void> deletarLista(int id) async {
    await _execute<void>(
      useSaving: true,
      action: () => service.delete(id),
    );

    // remove localmente SEM depender de result
    listas.removeWhere((l) => l.id == id);

    notifyListeners();
  }

  Future<void> finalizar(int id) async {
    await _execute<void>(
      useSaving: true,
      action: () => service.finalizarLista(id),
    );

    if (erro != null) return;

    final index = listasCrud.indexWhere((l) => l.id == id);

    if (index != -1) {
      listasCrud[index] = listasCrud[index].copyWith(
        concluidoEm: DateTime.now(),
      );
    }

    notifyListeners();
  }

  // =========================
  // RENOMEAR (RESUMO)
  // =========================
  Future<void> renomearLista(int id, String novoNome) async {
    final result = await _execute<Lista>(
      useSaving: true,
      action: () => service.update(
        Lista(
          id: id,
          nome: novoNome,
        ),
      ),
    );

    if (result != null) {
      await carregarResumo();
    }
  }

  // =========================
  // RESET
  // =========================
  void resetar() {
    listas = [];
    listasCrud = [];
    listaAtual = null;
    isLoading = false;
    isSaving = false;
    erro = null;

    notifyListeners();
  }
}
