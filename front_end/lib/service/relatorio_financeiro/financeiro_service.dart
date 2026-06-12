import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crud_flutter/core/api/api_config.dart';

import '../../model/relatorio_financeiro/financeiro.dart';
import '../../dto/gasto_total_response_dto.dart';
import '../../dto/gasto_por_lista_response_dto.dart';
import '../../dto/gasto_por_categoria_response_dto.dart';
import 'package:crud_flutter/core/api/api_client.dart';

class FinanceiroService {
  final ApiClient _client;

  FinanceiroService(this._client);

  Future<GastoTotalModel> buscarTotalGeral() async {
    final response = await _client.get(
      '/financeiro/total-geral',
      null,
    );

    final dto = GastoTotalResponseDTO.fromJson(response.data);

    return GastoTotalModel(total: dto.total);
  }

  Future<List<GastoPorListaModel>> buscarTotalPorLista() async {
    final response = await _client.get(
      '/financeiro/total-por-lista',
      null,
    );

    final data = response.data as List;

    return data.map((item) {
      final dto = GastoPorListaResponseDTO.fromJson(item);

      return GastoPorListaModel(
        lista: dto.lista,
        total: dto.total,
      );
    }).toList();
  }

  Future<List<GastoPorCategoriaModel>> buscarCategoriasPorLista(
    int listaId,
  ) async {
    final response = await _client.get(
      '/financeiro/listas/$listaId/categorias',
      null,
    );

    final data = response.data as List;

    return data.map((item) {
      final dto = GastoPorCategoriaResponseDTO.fromJson(item);

      return GastoPorCategoriaModel(
        categoria: dto.categoria,
        total: dto.total,
      );
    }).toList();
  }
}