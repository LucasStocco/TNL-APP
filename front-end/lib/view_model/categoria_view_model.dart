import 'package:flutter/material.dart';
import '../model/categoria.dart';
import '../service/categoria_service.dart';

class CategoriaViewModel extends ChangeNotifier {
  final CategoriaService _service = CategoriaService();

  List<Categoria> categorias = [];
  bool isLoading = false;
  String? erro;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _startLoading() {
    isLoading = true;
    erro = null;
    if (!_isDisposed) notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    if (!_isDisposed) notifyListeners();
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
    if (!_isDisposed) notifyListeners();
  }

  /// Reseta o estado
  void resetar() {
    categorias = [];
    isLoading = false;
    erro = null;
    if (!_isDisposed) notifyListeners();
  }
}
