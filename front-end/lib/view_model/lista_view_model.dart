import 'package:flutter/material.dart';
import '../model/lista.dart';
import '../service/lista_service.dart';

class ListaViewModel extends ChangeNotifier {
  final ListaService _service = ListaService();

  List<Lista> listas = [];
  bool isLoading = false;
  String? erro;

  // ---------------------- UTILITÁRIOS ----------------------
  void _startLoading() {
    isLoading = true;
    erro = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ---------------------- LOAD ----------------------
  /// Carrega todas as listas do backend
  Future<void> loadListas() async {
    _startLoading();
    try {
      listas = await _service.getAll();
      notifyListeners();
    } catch (e) {
      listas = [];
      erro = 'Erro ao carregar listas: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- CREATE ----------------------
  /// Cria uma nova lista e adiciona à lista local
  Future<Lista?> addLista(String nome, {DateTime? dataConclusao}) async {
    _startLoading();
    try {
      final novaLista = Lista(nome: nome, dataConclusao: dataConclusao);
      final criada = await _service.create(novaLista);

      if (criada.id != null) {
        listas.add(criada);
        notifyListeners();
      }
      return criada;
    } catch (e) {
      erro = 'Erro ao criar lista: $e';
      notifyListeners();
      return null;
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- UPDATE ----------------------
  /// Atualiza uma lista existente
  Future<Lista?> atualizarLista(Lista listaAtualizada) async {
    if (listaAtualizada.id == null) return null;

    _startLoading();
    try {
      final atualizada = await _service.update(listaAtualizada);
      final index = listas.indexWhere((l) => l.id == atualizada.id);
      if (index != -1) {
        listas[index] = atualizada;
        notifyListeners();
      }
      return atualizada;
    } catch (e) {
      erro = 'Erro ao atualizar lista: $e';
      notifyListeners();
      return null;
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- DELETE ----------------------
  /// Deleta uma lista pelo id
  Future<void> deletarLista(int id) async {
    _startLoading();
    try {
      await _service.delete(id);
      listas.removeWhere((l) => l.id == id);
      notifyListeners();
    } catch (e) {
      erro = 'Erro ao deletar lista: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- FINALIZAR ----------------------
  /// Finaliza uma lista (marca como concluída)
  Future<void> finalizarLista(int listaId) async {
    _startLoading();
    try {
      await _service.finalizarLista(listaId, DateTime.now());
      final index = listas.indexWhere((l) => l.id == listaId);
      if (index != -1) {
        listas[index] = listas[index].concluir();
        notifyListeners();
      }
    } catch (e) {
      erro = 'Erro ao finalizar lista: $e';
      notifyListeners();
    } finally {
      _stopLoading();
    }
  }

  // ---------------------- RESET ----------------------
  /// Reseta o estado
  void resetar() {
    listas = [];
    erro = null;
    isLoading = false;
    notifyListeners();
  }
}
