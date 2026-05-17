import 'package:flutter/material.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../service/gerenciar_lista/lista_service.dart';

class ListaViewModel extends ChangeNotifier {
  final ListaService _service;

  ListaViewModel(this._service) {
    print('[LISTA_VM] INSTÂNCIA CRIADA -> ${identityHashCode(this)}');
  }

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
    print('$TAG loading -> $value');
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    print('$TAG saving -> $value');
    notifyListeners();
  }

  void _setError(Object e) {
    _erro = e.toString().replaceAll('Exception: ', '');
    print('$TAG ERROR -> $_erro');
  }

  void _clearError() {
    _erro = null;
  }

  // =========================
  // LISTAR
  // =========================

  Future<void> listar() async {
    print('$TAG listar() -> VM ${identityHashCode(this)}');

    final result = await _service.getAll();

    print('$TAG resultado listar -> ${result.length} itens');

    _listas
      ..clear()
      ..addAll(result);

    print('$TAG listas atualizadas -> ${_listas.length}');

    notifyListeners();
  }

  // =========================
  // CRIAR
  // =========================

  Future<Lista?> criar(String nome) async {
    print('$TAG criar() -> VM ${identityHashCode(this)}');

    _setSaving(true);
    _clearError();

    try {
      final criada = await _service.create(nome);

      print('$TAG criada -> ${criada.nome} (id: ${criada.id})');

      // 🔥 MELHOR PRÁTICA: sincroniza com backend
      final result = await _service.getAll();

      _listas
        ..clear()
        ..addAll(result);

      print('$TAG listas sincronizadas -> ${_listas.length}');

      _listaAtualId = criada.id;

      notifyListeners();
      print('$TAG notifyListeners() após criar + sync');

      return criada;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // SALVAR
  // =========================
  Future<void> salvarLista(int? id, String nome) async {
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
  // SELECIONAR
  // =========================

  void selecionarLista(Lista lista) {
    print('$TAG selecionarLista -> ${lista.id}');

    _listaAtualId = lista.id;
    notifyListeners();
  }

  // =========================
  // ATUALIZAR
  // =========================

  Future<Lista?> atualizar(Lista lista) async {
    print('$TAG atualizar -> ${lista.id}');

    if (lista.id == null) {
      _setError("ID obrigatório");
      notifyListeners();
      return null;
    }

    _setSaving(true);

    try {
      final atualizada = await _service.update(lista);

      final index = _listas.indexWhere((l) => l.id == atualizada.id);

      if (index != -1) {
        _listas[index] = atualizada;
      }

      notifyListeners();

      return atualizada;
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

  Future<void> deletar(int id) async {
    print('$TAG deletar -> $id');

    _setSaving(true);

    try {
      await _service.delete(id);

      _listas.removeWhere((l) => l.id == id);

      if (_listaAtualId == id) {
        _listaAtualId = null;
      }

      notifyListeners();
    } catch (e) {
      _setError(e);
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // RESET
  // =========================

  void resetar() {
    print('$TAG resetar()');

    _listas.clear();
    _listaAtualId = null;
    _isLoading = false;
    _isSaving = false;
    _erro = null;

    notifyListeners();
  }
}
