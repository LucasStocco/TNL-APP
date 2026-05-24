import 'package:crud_flutter/core/api/api_client.dart';
import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import 'package:crud_flutter/service/gerenciar_lista/lista_resumo_service.dart';
import 'package:http/http.dart' as http;

class ApiBackgroundService {
  late final ApiClient _client;
  late final ListaResumoService _listaService;

  ApiBackgroundService() {
    _client = ApiClient(http.Client());
    _listaService = ListaResumoService(_client);
  }

  Future<List<ListaResumoResponseDTO>?> fetchData() async {
    print("🌐 [API SERVICE] iniciando chamada...");

    try {
      final response = await _listaService.getResumo();

      print("📥 [API SERVICE] resposta recebida com sucesso");
      print("📊 [API SERVICE] tipo: ${response.runtimeType}");

      return response;
    } catch (e) {
      print("❌ [API SERVICE ERROR]: $e");
      return null;
    }
  }
}
/* Buscador de dados (só traz informação)
- chama API
- pega dados do servidor
- não sabe de regra nenhuma
 */
