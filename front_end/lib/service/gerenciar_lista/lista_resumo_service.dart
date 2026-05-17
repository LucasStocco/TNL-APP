import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista.dart';
import 'package:crud_flutter/model/gerenciar_lista/lista_resumo.dart';

class ListaResumoService {
  final ApiClient api;

  ListaResumoService(this.api);

  // =========================
  // RESUMO
  // =========================
  Future<List<ListaResumo>> getResumo() async {
    final response = await api.get(
      '/listas/resumo',
      (data) => data,
    );

    final List list = response.data as List;

    return list.map((e) => ListaResumo.fromJson(e)).toList();
  }

  // =========================
  // CRUD LISTA
  // =========================

  Future<List<Lista>> getAll() async {
    final response = await api.get(
      '/listas',
      (data) => data,
    );

    final List list = response.data as List;

    return list.map((e) => Lista.fromJson(e)).toList();
  }

  Future<Lista> create(String nome) async {
    final response = await api.post(
      '/listas',
      {'nome': nome},
      (data) => data,
    );

    return Lista.fromJson(response.data);
  }

  Future<Lista> update(Lista lista) async {
    final response = await api.put(
      '/listas/${lista.id}',
      lista.toJson(),
      (data) => data,
    );

    return Lista.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await api.delete(
      '/listas/$id',
      (data) => data,
    );
  }

  Future<void> finalizarLista(int id) async {
    await api.put(
      '/listas/$id/finalizar',
      {},
      (data) => data,
    );
  }
}
