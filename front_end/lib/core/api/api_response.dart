class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  // =========================================================
  // 🧠 FROM JSON (COM LOGS)
  // =========================================================
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    print('\n📦 [ApiResponse] PARSING START');
    print('🟡 RAW JSON: $json');

    final success = json['success'] ?? false;
    final message = json['message'] ?? '';
    final rawData = json['data'];

    print('🟢 success: $success');
    print('💬 message: $message');
    print('📊 data type: ${rawData.runtimeType}');
    print('📊 data raw: $rawData');

    T? parsedData;

    if (rawData != null && fromJson != null) {
      try {
        parsedData = fromJson(rawData);
        print('✅ data parsed successfully: $parsedData');
      } catch (e, stack) {
        print('❌ ERROR parsing data: $e');
        print('📍 STACK: $stack');
      }
    } else {
      parsedData = rawData as T?;
      print('⚠️ data not parsed (no mapper provided)');
    }

    print('📦 [ApiResponse] PARSING END\n');

    return ApiResponse(
      success: success,
      message: message,
      data: parsedData,
    );
  }

  // =========================================================
  // 🔎 DEBUG PRINT (OPCIONAL)
  // =========================================================
  void debug() {
    print('''
🧾 ===== ApiResponse DEBUG =====
success: $success
message: $message
data: $data
===============================
''');
  }
}
