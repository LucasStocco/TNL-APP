class ApiDecoder {
  static T extract<T>(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    final data = json['data'];

    if (fromJson != null && data != null) {
      return fromJson(data);
    }

    return data;
  }
}
