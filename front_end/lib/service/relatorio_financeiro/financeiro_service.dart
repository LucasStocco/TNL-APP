import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crud_flutter/core/api/api_config.dart';

import '../../model/relatorio_financeiro/financeiro.dart';
import '../../dto/gasto_total_response_dto.dart';

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
}