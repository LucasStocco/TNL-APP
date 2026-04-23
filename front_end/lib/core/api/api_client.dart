import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_response.dart';

class ApiClient {
  final http.Client _client = http.Client();

  // =========================================================
  // 🌐 URL BUILDER
  // =========================================================
  Uri _uri(String path) {
    final fullUrl = '${ApiConfig.baseUrl}$path';
    print('\n🌐 [API] $fullUrl');
    return Uri.parse(fullUrl);
  }

  // =========================================================
  // 🧠 PARSER PADRÃO (SERVER-FIRST)
  // =========================================================
  ApiResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    final decoded = jsonDecode(response.body);

    print('📦 STATUS: ${response.statusCode}');
    print('📦 RAW: ${response.body}');
    print('🧠 DECODED TYPE: ${decoded.runtimeType}');
    print('🧠 DECODED: $decoded');

    final apiResponse = ApiResponse<T>.fromJson(decoded, (data) {
      if (fromJson == null) return data;
      return fromJson(data);
    });

    print('🟢 SUCCESS: ${apiResponse.success}');
    print('💬 MESSAGE: ${apiResponse.message}');
    print('📊 DATA: ${apiResponse.data}');

    return apiResponse;
  }

  // =========================================================
  // 🟦 GET
  // =========================================================
  Future<ApiResponse<T>> get<T>(
    String path,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    print('\n🟦 [GET] $path');

    try {
      final response = await _client.get(uri);
      return _parseResponse<T>(response, fromJson);
    } catch (e, stack) {
      print('❌ [GET ERROR] $e');
      print('📍 STACK: $stack');
      rethrow;
    }
  }

  // =========================================================
  // 🟨 POST
  // =========================================================
  Future<ApiResponse<T>> post<T>(
    String path,
    Object body,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    print('\n🟨 [POST] $path');
    print('📦 BODY: ${jsonEncode(body)}');

    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return _parseResponse<T>(response, fromJson);
    } catch (e, stack) {
      print('❌ [POST ERROR] $e');
      print('📍 STACK: $stack');
      rethrow;
    }
  }

  // =========================================================
  // 🟧 PUT
  // =========================================================
  Future<ApiResponse<T>> put<T>(
    String path,
    Object body,
    T Function(dynamic)? fromJson,
  ) async {
    final uri = _uri(path);

    print('\n🟧 [PUT] $path');
    print('📦 BODY: ${jsonEncode(body)}');

    try {
      final response = await _client.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return _parseResponse<T>(response, fromJson);
    } catch (e, stack) {
      print('❌ [PUT ERROR] $e');
      print('📍 STACK: $stack');
      rethrow;
    }
  }

  // =========================================================
  // 🟥 PATCH
  // =========================================================
  Future<ApiResponse<T>> patch<T>(
    String path,
    Object? body, {
    T Function(dynamic)? fromJson,
  }) async {
    final uri = _uri(path);

    print('\n🟥 [PATCH] $path');
    print('📦 BODY: ${jsonEncode(body)}');

    try {
      final response = await _client.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );

      return _parseResponse<T>(response, fromJson);
    } catch (e, stack) {
      print('❌ [PATCH ERROR] $e');
      print('📍 STACK: $stack');
      rethrow;
    }
  }

  // =========================================================
  // 🗑 DELETE
  // =========================================================
  Future<ApiResponse<T>> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
  }) async {
    final uri = _uri(path);

    print('\n🗑 [DELETE] $path');

    try {
      final response = await _client.delete(uri);
      return _parseResponse<T>(response, fromJson);
    } catch (e, stack) {
      print('❌ [DELETE ERROR] $e');
      print('📍 STACK: $stack');
      rethrow;
    }
  }
}
