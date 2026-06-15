import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_response.dart';

class ApiClient {
  final http.Client _client;

  ApiClient(this._client);

  // =========================
  // 🌐 URL
  // =========================
  Uri _uri(String path) {
    final url = '${ApiConfig.baseUrl}$path';
    print('\n🌐 [API] $url');
    return Uri.parse(url);
  }

  // =========================
  // 📦 PARSER
  // =========================
  ApiResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    final decoded = jsonDecode(response.body);

    print('📥 [RESPONSE]');
    print('   status: ${response.statusCode}');
    print('   body: ${response.body}');
    print('   type: ${decoded.runtimeType}');

    // 🔥 CASO 1: ApiResponse padrão
    if (decoded is Map<String, dynamic> &&
        decoded.containsKey('success') &&
        decoded.containsKey('data')) {
      return ApiResponse<T>.fromJson(decoded, (data) {
        return fromJson != null ? fromJson(data) : data;
      });
    }

    // 🔥 CASO 2: JSON puro (SEU CASO ATUAL)
    final parsedData =
        fromJson != null ? fromJson(decoded) : decoded;

    return ApiResponse<T>(
      success: true,
      message: 'OK',
      data: parsedData,
    );
  }

  // =========================
  // 🟦 GET
  // =========================
  Future<ApiResponse<T>> get<T>(
    String path,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    final response = await _client.get(uri);
    return _parseResponse(response, fromJson);
  }

  // =========================
  // 🟨 POST
  // =========================
  Future<ApiResponse<T>> post<T>(
    String path,
    Object body,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _parseResponse(response, fromJson);
  }

  // =========================
  // 🟧 PUT
  // =========================
  Future<ApiResponse<T>> put<T>(
    String path,
    Object body,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    final response = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _parseResponse(response, fromJson);
  }

  // =========================
  // 🟪 PATCH
  // =========================
  Future<ApiResponse<T>> patch<T>(
    String path,
    Object? body,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    final response = await _client.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );

    return _parseResponse(response, fromJson);
  }

  // =========================
  // 🟥 DELETE
  // =========================
  Future<ApiResponse<T>> delete<T>(
    String path, [
    T Function(dynamic)? fromJson,
  ]) async {
    final uri = _uri(path);

    final response = await _client.delete(uri);

    return _parseResponse(response, fromJson);
  }
}