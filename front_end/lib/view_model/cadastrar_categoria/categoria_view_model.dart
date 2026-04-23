import 'package:flutter/material.dart';
import '../../model/cadastrar_categoria/categoria.dart';
import '../../service/cadastrar_categoria/categoria_service.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service = CategoriaService();

  // =========================
  // STATE
  // =========================
  List<Categoria> categorias = [];
  List<Categoria> get categoriasAtivas =>
      categorias.where((c) => !c.deletado).toList();

  bool isLoading = false;
  bool isSaving = false;

  String? erro;

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
    required Future<T> Function() action,
    bool useSaving = false,
  }) async {
    if (useSaving) {
      _setSaving(true);
    } else {
      _setLoading(true);
    }

    erro = null;

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
    final result = await _execute<List<Categoria>>(
      action: () => _service.buscarCategorias(),
    );

    if (result != null) {
      categorias = result;
      notifyListeners();
    }
  }

  // =========================
  // CRIAR
  // =========================
  Future<Categoria?> criar(String nome) async {
    final criada = await _execute<Categoria>(
      useSaving: true,
      action: () => _service.criarCategoria(nome),
    );

    if (criada != null) {
      categorias = [...categorias, criada];
      notifyListeners();
    }

    return criada;
  }

  // =========================
  // ATUALIZAR
  // =========================
  Future<Categoria?> atualizar(Categoria categoria) async {
    // 🔒 validação
    if (categoria.id == null) {
      erro = "ID obrigatório";
      notifyListeners();
      return null;
    }

    // 🔥 chamada padrão com executor
    final atualizada = await _execute<Categoria>(
      useSaving: true,
      action: () => _service.atualizarCategoria(
        categoria.id!,
        categoria.nome,
      ),
    );

    // 🔄 atualiza lista local
    if (atualizada != null) {
      categorias = categorias.map((c) {
        return c.id == atualizada.id ? atualizada : c;
      }).toList();

      notifyListeners();
    }

    return atualizada;
  }

  // =========================
  // DELETAR
  // =========================
  Future<void> deletar(int id) async {
    final categoria = categorias.firstWhere(
      (c) => c.id == id,
      orElse: () => Categoria(nome: ''),
    );

    // regra de negócio
    if (categoria.idUsuario == null) {
      erro = "Categorias globais não podem ser excluídas";
      notifyListeners();
      return;
    }

    final ok = await _execute<void>(
      useSaving: true,
      action: () => _service.deletarCategoria(id),
    );

    if (erro != null) return;

    categorias.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // =========================
  // FILTROS
  // =========================
  List<Categoria> get categoriasUsuario =>
      categorias.where((c) => c.idUsuario != null).toList();

  List<Categoria> get categoriasGlobais =>
      categorias.where((c) => c.idUsuario == null).toList();

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
