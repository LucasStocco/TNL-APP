import 'package:flutter/material.dart';

import '../../model/gerenciar_lista/lista.dart';
import '../../service/gerenciar_lista/lista_service.dart';

class ListaViewModel extends ChangeNotifier {
  final ListaService _service;

  ListaViewModel(this._service) {
    print('[LISTA_VM] INSTÂNCIA CRIADA -> ${identityHashCode(this)}');
  }

  // =========================
  // ESTADO
  // =========================
  final List<Lista> _listas = [];
  int? _listaAtualId;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _erro;

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
    _erro = e.toString().replaceAll('Exception: ', '');
  }

  void _clearError() {
    _erro = null;
  }

  // =========================
  // LISTAR
  // =========================
  Future<void> listar() async {
    _setLoading(true);

    try {
      final result = await _service.getAll();

      _listas
        ..clear()
        ..addAll(result);

      notifyListeners();
    } catch (e) {
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Lista?> criar(String nome) async {
    _setSaving(true);
    _clearError();

    try {
      final criada = await _service.create(nome);

      final result = await _service.getAll();

      _listas
        ..clear()
        ..addAll(result);

      _listaAtualId = criada.id;

      // ⚠️ não manda notificação aqui (não tem progresso ainda)
      notifyListeners();

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
      final atualizada = await _service.update(lista);

      final index = _listas.indexWhere((l) => l.id == atualizada.id);

      if (index != -1) {
        _listas[index] = atualizada;
      }

      // 🔥 IMPORTANTE:
      // Aqui NÃO usamos NotificationEngine (porque Lista não tem progresso)
      // Notificação deve vir do ViewModel de RESUMO

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
  // SELECIONAR
  // =========================
  void selecionarLista(Lista lista) {
    _listaAtualId = lista.id;
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
