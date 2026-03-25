import 'package:flutter/material.dart';
import '../model/categoria.dart';
import '../service/categoria_service.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service = CategoriaService();

  List<Categoria> categorias = [];
  bool isLoading = false;
  String? erro;

  void _startLoading() {
    isLoading = true;
    erro = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  /// Carrega todas as categorias do backend
  Future<void> carregarCategorias() async {
    _startLoading();
    try {
      categorias = await _service.buscarCategorias();
    } catch (e) {
      categorias = [];
      erro = 'Falha ao carregar categorias: $e';
    } finally {
      _stopLoading();
    }
  }

  /// Atualiza a lista manualmente (ex: após criação ou exclusão)
  void atualizarCategorias(List<Categoria> novaLista) {
    categorias = novaLista;
    notifyListeners();
  }

  /// Reseta o estado
  void resetar() {
    categorias = [];
    isLoading = false;
    erro = null;
    notifyListeners();
  }
}
