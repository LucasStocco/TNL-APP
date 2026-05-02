import 'package:flutter/material.dart';

import '../../model/gerenciar_lista/lista_resumo.dart';
import '../../service/gerenciar_lista/lista_resumo_service.dart';

class ListaResumoViewModel extends ChangeNotifier {
  final ListaResumoService service;

  ListaResumoViewModel(this.service);

  List<ListaResumo> listas = [];
  bool isLoading = false;
  String? erro;

  Future<void> carregar() async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      listas = await service.getResumo();
    } catch (e) {
      erro = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void resetar() {
    listas = [];
    isLoading = false;
    erro = null;
    notifyListeners();
  }
}
