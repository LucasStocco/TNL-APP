import 'package:flutter/material.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../service/gerenciar_lista/lista_service.dart';

class ListaViewModel extends ChangeNotifier {
  final ListaService _service;

  ListaViewModel(this._service);

  // =========================
  // STATE
  // =========================
  List<Lista> listas = [];
  Lista? listaAtual;

  bool isLoading = false;
  bool isSaving = false;

  String? erro;

  static const String TAG = "[LISTA_VM]";

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
    required String origem,
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
  // LISTAR
  // =========================
  Future<void> listar() async {
    final result = await _execute<List<Lista>>(
      origem: "listar",
      action: () => _service.getAll(),
    );

    if (result != null) {
      listas = result;
      notifyListeners();
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Lista?> criar(String nome) async {
    final criada = await _execute<Lista>(
      origem: "criar",
      useSaving: true,
      action: () => _service.create(nome),
    );

    if (criada != null) {
      listas.add(criada);
      listaAtual = criada;
      notifyListeners();
    }

    return criada;
  }

  // =========================
  // SELECIONAR
  // =========================
  void selecionarLista(Lista lista) {
    listaAtual = lista;
    notifyListeners();
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Lista?> atualizar(Lista lista) async {
    if (lista.id == null) {
      erro = "ID obrigatório";
      notifyListeners();
      return null;
    }

    final atualizada = await _execute<Lista>(
      origem: "atualizar",
      useSaving: true,
      action: () => _service.update(lista),
    );

    if (atualizada != null) {
      final index = listas.indexWhere((l) => l.id == atualizada.id);

      if (index != -1) {
        listas[index] = atualizada;
      }

      if (listaAtual?.id == atualizada.id) {
        listaAtual = atualizada;
      }

      notifyListeners();
    }

    return atualizada;
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletar(int id) async {
    await _execute<void>(
      origem: "deletar",
      useSaving: true,
      action: () => _service.delete(id),
    );

    if (erro != null) return;

    listas.removeWhere((l) => l.id == id);

    if (listaAtual?.id == id) {
      listaAtual = null;
    }

    notifyListeners();
  }

  // =========================
  // FINALIZAR
  // =========================
  Future<void> finalizar(int id) async {
    await _execute<void>(
      origem: "finalizar",
      useSaving: true,
      action: () => _service.finalizarLista(id),
    );

    if (erro != null) return;

    final index = listas.indexWhere((l) => l.id == id);

    if (index != -1) {
      listas[index] = listas[index].copyWith(
        concluidoEm: DateTime.now(),
      );
    }

    notifyListeners();
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
