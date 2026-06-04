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

  Future<void> carregarRelatorio({
    int? listaId,
  }) async {
    loading = true;
    erro = null;
    notifyListeners();

    try {
      totalGeral =
          await _service.buscarTotalGeral();

      gastosPorLista =
          await _service.buscarTotalPorLista();

      if (listaId != null) {
        gastosPorCategoria =
            await _service.buscarCategoriasPorLista(
          listaId,
        );
      } else {
        gastosPorCategoria = [];
      }
    } catch (e) {
      erro = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}