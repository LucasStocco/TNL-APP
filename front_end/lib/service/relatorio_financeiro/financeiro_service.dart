import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud_flutter/core/api/api_config.dart';
import '../../model/relatorio_financeiro/financeiro.dart';
import '../../dto/gasto_total_response_dto.dart';
import '../../dto/gasto_por_lista_response_dto.dart';

class FinanceiroService {
  Future<GastoTotalModel> buscarTotalGeral() async {
    final String url =
        '${ApiConfig.baseUrl}/financeiro/total-geral';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final dto = GastoTotalResponseDTO.fromJson(
        json['data'],
      );

      return GastoTotalModel(
        total: dto.total,
      );
    }

    throw Exception(
      'Erro ao buscar total geral',
    );
  }
Future<List<GastoPorListaModel>> buscarTotalPorLista() async {
  final String url =
      '${ApiConfig.baseUrl}/financeiro/total-por-lista';

  final response = await http.get(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final data = json['data'] as List;

    return data.map((item) {
      final dto = GastoPorListaResponseDTO.fromJson(item);

      return GastoPorListaModel(
        lista: dto.lista,
        total: dto.total,
      );
    }).toList();
  }

  throw Exception('Erro ao buscar total por lista');
}
}