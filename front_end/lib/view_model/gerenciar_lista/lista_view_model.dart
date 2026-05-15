import 'package:flutter/material.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../service/gerenciar_lista/lista_service.dart';

/* RESPONSABILIDADES DO VIEW MODEL
1. Receber ação da UI
2. Chamar Service
3. Atualizar estado da UI
4. Notificar mudanças
*/

class ListaViewModel extends ChangeNotifier {
  final ListaService _service;

  // dependência injetada
  ListaViewModel(this._service);

  // =========================
  // STATE
  // =========================

  final List<Lista> _listas = [];

  int? _listaAtualId;

  bool _isLoading = false;
  bool _isSaving = false;

  String? _erro;

  static const String TAG = "[LISTA_VM]";

  // =========================
  // GETTERS
  // =========================

  List<Lista> get listas => List.unmodifiable(_listas);

  int? get listaAtualId => _listaAtualId;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get erro => _erro;

  Lista? get listaAtual {
    try {
      return _listas.firstWhere((l) => l.id == _listaAtualId);
    } catch (_) {
      return null;
    }
  }

  // =========================
  // STATE HELPERS
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
    _erro = e.toString().replaceAll('Exception: ', '');
  }

  void _clearError() {
    _erro = null;
  }

  // =========================
  // EXECUTION HELPERS
  // =========================

  Future<T?> _runLoading<T>(
    Future<T> Function() action,
  ) async {
    _clearError();
    _setLoading(true);

    try {
      return await action();
    } catch (e) {
      _setError(e);
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<T?> _runSaving<T>(
    Future<T> Function() action,
  ) async {
    _clearError();
    _setSaving(true);

    try {
      return await action();
    } catch (e) {
      _setError(e);
      notifyListeners();
      return null;
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // LISTAR
  // =========================

  Future<void> listar() async {
    final result = await _runLoading(
      () => _service.getAll(),
    );

    if (result == null) return;

    _listas
      ..clear()
      ..addAll(result);

    notifyListeners();
  }

  // =========================
  // CRIAR
  // =========================

  Future<Lista?> criar(String nome) async {
    final criada = await _runSaving(
      () => _service.create(nome),
    );

    if (criada == null) return null;

    _listas.add(criada);

    _listaAtualId = criada.id;

    notifyListeners();

    return criada;
  }

  // =========================
  // SELECIONAR
  // =========================

  void selecionarLista(Lista lista) {
    _listaAtualId = lista.id;
    notifyListeners();
  }

  // =========================
  // ATUALIZAR
  // =========================

  Future<Lista?> atualizar(Lista lista) async {
    if (lista.id == null) {
      _setError("ID obrigatório");
      notifyListeners();
      return null;
    }

    final atualizada = await _runSaving(
      () => _service.update(lista),
    );

    if (atualizada == null) return null;

    final index = _listas.indexWhere(
      (l) => l.id == atualizada.id,
    );

    if (index != -1) {
      _listas[index] = atualizada;
    }

    notifyListeners();

    return atualizada;
  }

  // =========================
  // SALVAR
  // =========================

  Future<void> salvarLista(
    int? id,
    String nome,
  ) async {
    if (id == null) {
      await criar(nome);
    } else {
      await atualizar(
        Lista(
          id: id,
          nome: nome,
        ),
      );
    }
  }

  // =========================
  // DELETAR
  // =========================

  Future<void> deletar(int id) async {
    await _runSaving(
      () => _service.delete(id),
    );

    if (_erro != null) return;

    _listas.removeWhere((l) => l.id == id);

    if (_listaAtualId == id) {
      _listaAtualId = null;
    }

    notifyListeners();
  }

  // =========================
  // FINALIZAR
  // =========================

  Future<void> finalizar(int id) async {
    await _runSaving(
      () => _service.finalizarLista(id),
    );

    if (_erro != null) return;

    final index = _listas.indexWhere(
      (l) => l.id == id,
    );

    if (index != -1) {
      _listas[index] = _listas[index].copyWith(
        concluidoEm: DateTime.now(),
      );
    }

    notifyListeners();
  }

  // =========================
  // RESET
  // =========================

  void resetar() {
    _listas.clear();

    _listaAtualId = null;
    _isLoading = false;
    _isSaving = false;
    _erro = null;

    notifyListeners();
  }
}

/* OBSERVAÇÕES

Internamente:
- _listas
- _erro
- _listaAtualId

Externamente (UI):
- listas
- erro
- listaAtualId

*/

/*
REFATORAÇÃO REALIZADA

- Estado interno encapsulado
- Exposição segura via getters
- Redução de repetição
- Separação entre loading e saving
- ViewModel focada em orquestração da UI
- Melhor alinhamento com MVVM
*/
