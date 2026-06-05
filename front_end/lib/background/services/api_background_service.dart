import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';
import 'package:http/http.dart' as http;

class ApiBackgroundService {
  late final ApiClient _client;
  late final ListaResumoService _listaService;

  ApiBackgroundService() {
    final httpClient = http.Client();

    _client = ApiClient(httpClient);
    _listaService = ListaResumoService(_client);
  }

  /// =========================
  /// FETCH DATA (RAW STATE)
  /// =========================
  Future<List<ListaResumoResponseDTO>> fetchData() async {
    print("🌐 [API SERVICE] iniciando chamada...");

    try {
      final response = await _listaService.getResumo();

      print("📥 [API SERVICE] resposta recebida");
      print("📊 [API SERVICE] items: ${response.length}");

      return response;
    } catch (e) {
      print("❌ [API SERVICE ERROR]: $e");

      // background-safe fallback
      return [];
    }
  }
}
/* Buscador de dados (só traz informação)
- chama API
- pega dados do servidor
- não sabe de regra nenhuma
 */
