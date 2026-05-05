class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    final success = json['success'] ?? false;
    final message = json['message'] ?? '';
    final rawData = json['data'];

    final parsedData = fromJson(rawData);

    return ApiResponse(
      success: success,
      message: message,
      data: parsedData,
    );
  }
}
