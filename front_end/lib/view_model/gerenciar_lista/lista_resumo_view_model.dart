import 'package:flutter/material.dart';
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
  String? erro;

  void _setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  void _setSaving(bool v) {
    isSaving = v;
    notifyListeners();
  }

  void _setError(Object e) {
    erro = e.toString();
    notifyListeners();
  }

  // =========================
  // RESUMO
  // =========================
  Future<void> carregarResumo() async {
    _setLoading(true);

    try {
      listas = await service.getResumo();

      NotificationScheduler.push(listas);

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
  // 📝 RENOMEAR LISTA
  // =========================
  Future<Lista?> renomearLista(int id, String novoNome) async {
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
  // 🗑 DELETAR LISTA
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
  // FINALIZAR LISTA
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
