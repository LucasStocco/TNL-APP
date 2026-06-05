import 'package:flutter/material.dart';
import '../../model/cadastrar_categoria/categoria.dart';
import '../../service/cadastrar_categoria/categoria_service.dart';
import '../../dto/request/cadastrar_categoria/categoria_request_create_dto.dart';
import '../../dto/request/cadastrar_categoria/categoria_request_update_dto.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service;

  CategoriaViewModel(this._service);
  // =========================
  // STATE
  // =========================
  List<Categoria> categorias = [];

  bool isLoading = false;
  bool isSaving = false;

  bool _isGrid = true;

  bool get isGrid => _isGrid;

  String? erro;

  // =========================
  // LOADING HELPERS
  // =========================
  void _setLoading(bool value) {
    isLoading = value;
    if (value) erro = null;
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

  // =========================
  // LISTAR
  // =========================
  Future<void> listar() async {
    _setLoading(true);
    erro = null;

    try {
      final result = await _service.buscarCategorias();

      categorias
        ..clear()
        ..addAll(result);
    } catch (e) {
      _setError(e);
    }

    _setLoading(false);
  }

  // =========================
  // CRIAR
  // =========================
  Future<Categoria?> criar(String nome) async {
    _setSaving(true);
    erro = null;

    try {
      final nova = await _service.criarCategoria(
        CategoriaCreateDTO(nome: nome),
      );

      categorias = [...categorias, nova];
      return nova;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
      notifyListeners();
    }
  }

  // =========================
  // RENOMEAR CATEGORIA
  // =========================
  Future<void> renomearCategoria(int id, String novoNome) async {
    _setSaving(true);
    erro = null;

    try {
      final atualizada = await _service.atualizarCategoria(
        id,
        CategoriaUpdateDTO(nome: novoNome),
      );

      categorias = categorias.map((c) {
        return c.id == id ? atualizada : c;
      }).toList();

      notifyListeners();
    } catch (e) {
      _setError(e);
    } finally {
      _setSaving(false);
    }
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletar(int id) async {
    _setSaving(true);
    erro = null;

    try {
      await _service.deletarCategoria(id);
      categorias.removeWhere((c) => c.id == id);
    } catch (e) {
      _setError(e);
    } finally {
      _setSaving(false);
      notifyListeners();
    }
  }

  // =========================
  // RESET
  // =========================
  void resetar() {
    categorias = [];
    isLoading = false;
    isSaving = false;
    erro = null;
    notifyListeners();
  }

  // =========================
// UI STATE (LAYOUT)
// =========================
  void toggleLayout() {
    _isGrid = !_isGrid;
    notifyListeners();
  }
}
