import 'package:flutter/material.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../service/gerenciar_lista/lista_service.dart';

class ListaViewModel extends ChangeNotifier {
  final ListaService _service = ListaService();

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
  // LOG HELPERS
  // =========================

  void _log(String msg) {
    print("$TAG $msg");
  }

  void _logErro(String origem, Object e) {
    print("$TAG ❌ ERRO EM $origem");
    print("$TAG $e");
  }

  void _setLoading(bool value, String origem) {
    isLoading = value;
    _log("loading=$value ($origem)");
    notifyListeners();
  }

  void _setSaving(bool value, String origem) {
    isSaving = value;
    _log("saving=$value ($origem)");
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
    _log("▶ INICIO: $origem");

    if (useSaving) {
      _setSaving(true, origem);
    } else {
      _setLoading(true, origem);
    }

    erro = null;

    try {
      final result = await action();

      _log("✔ SUCESSO: $origem");
      return result;
    } catch (e) {
      erro = _parseErro(e);
      _logErro(origem, e);
      return null;
    } finally {
      if (useSaving) {
        _setSaving(false, origem);
      } else {
        _setLoading(false, origem);
      }

      _log("⏹ FIM: $origem");
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

      _log("listas carregadas: ${listas.length}");
      for (var l in listas) {
        _log(" - ${l.id} | ${l.nome}");
      }

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
      listas = [...listas, criada];
      listaAtual = criada;

      _log("lista criada e selecionada: ${criada.id}");

      notifyListeners();
    }

    return criada;
  }

  // =========================
  // SELECIONAR LISTA
  // =========================
  void selecionarLista(Lista lista) {
    listaAtual = lista;

    _log("📌 LISTA SELECIONADA: ${lista.id} | ${lista.nome}");

    notifyListeners();
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Lista?> atualizar(Lista lista) async {
    if (lista.id == null) {
      erro = "ID obrigatório";
      _logErro("atualizar", erro!);
      notifyListeners();
      return null;
    }

    final atualizada = await _execute<Lista>(
      origem: "atualizar",
      useSaving: true,
      action: () => _service.update(lista),
    );

    if (atualizada != null) {
      listas = listas.map((l) {
        return l.id == atualizada.id ? atualizada : l;
      }).toList();

      if (listaAtual?.id == atualizada.id) {
        listaAtual = atualizada;
        _log("listaAtual sincronizada");
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
      _log("listaAtual removida (era deletada)");
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

    listas = listas.map((l) {
      if (l.id == id) {
        return l.copyWith(concluidoEm: DateTime.now());
      }
      return l;
    }).toList();

    _log("lista finalizada: $id");

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

    _log("RESET completo do ViewModel");

    notifyListeners();
  }
}
