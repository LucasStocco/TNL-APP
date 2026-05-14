import 'package:flutter/material.dart';
import '../../model/gerenciar_lista/lista.dart';
import '../../service/gerenciar_lista/lista_service.dart';

/* RESPONSABILIDADES DO VIEW MODEL
1. Receber ação da UI
2. Chamar Service
3. Atualizar estado da UI
4. Notificar mudanças*/

class ListaViewModel extends ChangeNotifier {
  final ListaService _service;
  // Aqui temos uma associação / dependencias injetada
  ListaViewModel(this._service);

  // =========================
  // STATE
  // =========================
  final List<Lista> _listas = [];

  int? _listaAtualId;

  bool _isLoading = false;
  bool _isSaving = false;

  String? _erro;

  // getters públicos
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

  static const String TAG = "[LISTA_VM]";

  // =========================
  // HELPERS
  // =========================

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _setSaving(bool value) {
    _isSaving = value;
  }

  // =========================
  // LISTAR
  // =========================
  Future<void> listar() async {
    final result = await _execute<List<Lista>>(
      action: () => _service.getAll(),
      useLoading: true,
    );

    if (result != null) {
      _listas.clear();
      _listas.addAll(result);

      notifyListeners();
    }
  }

  // =========================
  // CRIAR
  // =========================
  /*removeu repetição de try/catch
  removeu repetição de loading/saving
  removeu repetição de erro
  método ficou focado apenas na regra da feature
  _execute virou responsável pelo fluxo técnico*/

  // Apenas: chamar service, atualizar estado, notificar UI
  Future<Lista?> criar(String nome) async {
    final criada = await _execute<Lista>(
      action: () => _service.create(nome),
    );

    if (criada != null) {
      _listas.add(criada);
      _listaAtualId = criada.id;

      notifyListeners();
    }

    return criada;
  }

  // Helper genérico para execução
  Future<T?> _execute<T>({
    required Future<T> Function() action,
    bool useLoading = false,
  }) async {
    _erro = null;

    if (useLoading) {
      _setLoading(true);
    } else {
      _setSaving(true);
    }

    notifyListeners();

    try {
      return await action();
    } catch (e) {
      _erro = e.toString();
      return null;
    } finally {
      if (useLoading) {
        _setLoading(false);
      } else {
        _setSaving(false);
      }

      notifyListeners();
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
  // ATUALIZAR
  // =========================
  // Reponsavel por: chamar service, atualizar estado, notificar UI
  Future<Lista?> atualizar(Lista lista) async {
    if (lista.id == null) {
      _erro = "ID obrigatório";
      notifyListeners();
      return null;
    }

    final atualizada = await _execute<Lista>(
      action: () => _service.update(lista),
    );

    if (atualizada != null) {
      final index = _listas.indexWhere(
        (l) => l.id == atualizada.id,
      );

      if (index != -1) {
        _listas[index] = atualizada;
        notifyListeners();
      }
    }

    return atualizada;
  }

  // =========================
  // SALVAR
  // =========================
  // temporario
  Future<void> salvarLista(int? id, String nome) async {
    if (id == null) {
      await criar(nome);
    } else {
      await atualizar(Lista(id: id, nome: nome));
    }
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletar(int id) async {
    await _execute<void>(
      action: () => _service.delete(id),
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
  // ficou focado apenas na regra: finalizar no servic, atualizar estado local, notificar UI
  Future<void> finalizar(int id) async {
    await _execute<void>(
      action: () => _service.finalizarLista(id),
    );

    if (_erro != null) return;

    final index = _listas.indexWhere((l) => l.id == id);

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

/*OBSERVAÇÕES
Internamente na VM, usar: _listas, _erro, _listaAtualId 
Externamente(UI): Use getters: listas, erro, listaAtualId
*/

/* 
REFATORAÇÃO REALIZADA

- Estado interno encapsulado com atributos privados (_listas, _erro, etc.)
- Exposição segura de dados via getters públicos
- Redução de repetição de try/catch, loading e tratamento de erro
- Centralização do fluxo técnico no método _execute()
- Métodos focados apenas na responsabilidade da feature
- Melhor separação de responsabilidades seguindo MVVM
- Proteção da lista com List.unmodifiable()
- ViewModel responsável apenas por:
  -> gerenciar estado
  -> chamar services
  -> sincronizar UI
  -> notificar mudanças
*/
