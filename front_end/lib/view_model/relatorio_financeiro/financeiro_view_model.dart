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

  double get total => totalGeral?.total ?? 0;

  double get mediaGasto {
    if (gastosPorCategoria.isEmpty) return 0;

    final soma = gastosPorCategoria.fold<double>(
      0,
      (total, item) => total + item.total,
    );

    return soma / gastosPorCategoria.length;
  }

  Future<void> carregarRelatorio() async {
    loading = true;
    erro = null;
    notifyListeners();

    try {
      totalGeral = await _service.buscarTotalGeral();

      // Temporário até ligar com endpoint real
      gastosPorCategoria = [
        GastoPorCategoriaModel(categoria: 'Carnes', total: 80),
        GastoPorCategoriaModel(categoria: 'Bebidas', total: 10),
        GastoPorCategoriaModel(categoria: 'Padaria', total: 5),
        GastoPorCategoriaModel(categoria: 'Mercearia', total: 26),
        GastoPorCategoriaModel(categoria: 'Laticínios', total: 8),
      ];
    } catch (e) {
      erro = e.toString();
       totalGeral = GastoTotalModel(total: 129.00);

      gastosPorCategoria = [
      GastoPorCategoriaModel(categoria: 'Carnes', total: 80),
      GastoPorCategoriaModel(categoria: 'Mercearia', total: 26),
      GastoPorCategoriaModel(categoria: 'Bebidas', total: 10),
      GastoPorCategoriaModel(categoria: 'Laticínios', total: 8),
      GastoPorCategoriaModel(categoria: 'Padaria', total: 5),
      ];


    }

    loading = false;
    notifyListeners();
  }
}