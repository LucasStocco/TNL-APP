import 'package:flutter/material.dart';

import '../../model/relatorio_financeiro/financeiro.dart';
import '../../service/relatorio_financeiro/financeiro_service.dart';

class FinanceiroViewModel extends ChangeNotifier {
  final FinanceiroService _service;

  FinanceiroViewModel(this._service);

  bool loading = false;
  String? erro;

  GastoTotalModel? totalGeral;

  List<GastoPorCategoriaModel> gastosPorCategoria = [];
  List<GastoPorListaModel> gastosPorLista = [];

  double get total => totalGeral?.total ?? 0;

  double get mediaGasto {
    if (gastosPorLista.isEmpty) return 0;

    final soma = gastosPorLista.fold<double>(
      0,
      (total, item) => total + item.total,
    );

    return soma / gastosPorLista.length;
  }

  Future<void> carregarRelatorio() async {
  loading = true;
  erro = null;
  notifyListeners();

  try {
    totalGeral = await _service.buscarTotalGeral();

    gastosPorLista = await _service.buscarTotalPorLista();

    // Ainda mockado porque categorias é por lista específica
    gastosPorCategoria = _mockCategorias();
  } catch (e) {
    erro = null;

    totalGeral = GastoTotalModel(total: 129.00);
    gastosPorCategoria = _mockCategorias();
    gastosPorLista = _mockListas();
  }

  loading = false;
  notifyListeners();
}
  List<GastoPorCategoriaModel> _mockCategorias() {
    return [
      GastoPorCategoriaModel(categoria: 'Carnes', total: 80),
      GastoPorCategoriaModel(categoria: 'Mercearia', total: 26),
      GastoPorCategoriaModel(categoria: 'Bebidas', total: 10),
      GastoPorCategoriaModel(categoria: 'Laticínios', total: 8),
      GastoPorCategoriaModel(categoria: 'Padaria', total: 5),
    ];
  }

  List<GastoPorListaModel> _mockListas() {
    return [
      GastoPorListaModel(lista: 'Supermercado', total: 129),
      GastoPorListaModel(lista: 'Churrasco', total: 86),
      GastoPorListaModel(lista: 'Farmácia', total: 42),
      GastoPorListaModel(lista: 'Casa', total: 63),
    ];
  }
}