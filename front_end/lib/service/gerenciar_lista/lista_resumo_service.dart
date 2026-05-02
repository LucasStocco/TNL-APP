import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';

class ListaResumoService {
  final ApiClient api;

  ListaResumoService(this.api);

  Future<List<ListaResumo>> getResumo() async {
    final response = await api.get(
      '/listas/resumo',
      (data) => data, // não transforma ainda
    );

    return (response.data as List).map((e) => ListaResumo.fromJson(e)).toList();
  }
}
