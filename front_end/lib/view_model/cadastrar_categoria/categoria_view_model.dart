import 'package:flutter/material.dart';
import '../../model/cadastrar_categoria/categoria.dart';
import '../../service/cadastrar_categoria/categoria_service.dart';
import '../../dto/categoria_create_dto.dart';
import '../../dto/categoria_update_dto.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service;

  CategoriaViewModel(this._service);
  // =========================
  // STATE
  // =========================
  List<Categoria> categorias = [];

  bool isLoading = false;
  bool isSaving = false;

  String? erro;

  // =========================
  // LOADING HELPERS
  // =========================
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  void _setError(Object e) {
    erro = e.toString().replaceAll('Exception: ', '');
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
  // ATUALIZAR
  // =========================
  Future<Categoria?> atualizar(Categoria categoria) async {
    if (categoria.id == null) {
      erro = "ID obrigatório";
      notifyListeners();
      return null;
    }

    _setSaving(true);
    erro = null;

    try {
      final atualizada = await _service.atualizarCategoria(
        categoria.id!,
        CategoriaUpdateDTO(nome: categoria.nome),
      );

      categorias = categorias.map((c) {
        return c.id == atualizada.id ? atualizada : c;
      }).toList();

      return atualizada;
    } catch (e) {
      _setError(e);
      return null;
    } finally {
      _setSaving(false);
      notifyListeners();
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
  // FILTROS (SE NECESSÁRIO)
  // =========================
  List<Categoria> get categoriasAtivas => categorias;

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
}
