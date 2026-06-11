import 'package:flutter/material.dart';
import 'package:crud_flutter/model/relatorio_item/relatorio_item_model.dart';
import 'package:crud_flutter/service/relatorio_item/relatorio_item_service.dart';

class RelatorioItemViewModel extends ChangeNotifier {
  final RelatorioItemService _service;

  RelatorioItemViewModel(this._service);

  // =========================
  // STATE
  // =========================
  List<ItemMaisComprado> maisComprados = [];
  List<ItemPorCategoria> porCategoria = [];
  List<ItemRankingPreco> maisCaros = [];
  List<ItemRankingPreco> maisBaratos = [];

  bool isLoading = false;
  String? erro;

  // =========================
  // CARREGAR TUDO
  // =========================
  Future<void> carregar(int listaId) async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      maisComprados = await _service.getMaisComprados(listaId);
      porCategoria  = await _service.getPorCategoria(listaId);
      maisCaros     = await _service.getMaisCaros(listaId);
      maisBaratos   = await _service.getMaisBaratos(listaId);
    } catch (e) {
      erro = e.toString().replaceAll('Exception: ', '');
    }

    isLoading = false;
    notifyListeners();
  }

  // =========================
  // RESET
  // =========================
  void resetar() {
    maisComprados = [];
    porCategoria  = [];
    maisCaros     = [];
    maisBaratos   = [];
    isLoading     = false;
    erro          = null;
    notifyListeners();
  }
}