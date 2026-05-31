import 'dart:convert';

import 'package:crud_flutter/dto/response/gerenciar_lista/lista_resumo_response_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationCacheManager {
  static const _cacheKey = 'notification_api_cache';

  /// =========================
  /// SAVE CACHE
  /// =========================
  /// Salva resposta da API localmente.
  static Future<void> saveCache(
    List<ListaResumoResponseDTO> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      data.map((e) => e.toJson()).toList(),
    );

    await prefs.setString(_cacheKey, encoded);
  }

  /// =========================
  /// GET CACHE
  /// =========================
  /// Recupera cache salvo localmente.
  static Future<List<ListaResumoResponseDTO>?> getCache() async {
    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getString(_cacheKey);

    if (cached == null) {
      return null;
    }

    final decoded = jsonDecode(cached) as List;

    return decoded
        .map(
          (e) => ListaResumoResponseDTO.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }
}

/* NOTIFICATION CACHE MANAGER (camada de persistência offline) 
- Responsável por criar uma cópia local da última resposta da API
- Quando a API funciona, salva cache
- Quando a API falha, usa cache local

RESPONSABILIDADES:
- Salvar cache da API
- Recuperar cache local
- persistir dados offline
- servir fallback offline

COMO FUNCIONA:
- API manda o json
- SaveCache() -> transforma em JSON string
- Salva localmente notification_api_cache (SharedPreferences)
- Mesmo sem conexão, o app ainda possui os ultimos dados
- Se API falhar, o worker chama -> NotificationCacheManager.getCache()
- Para recuperar dados, lê SharedPreferences, faz JsonDecode e reconstroi a lista original

- SharedPreferences é usado para persistência simples, ideal para cache leve (mini banco local)

*/
