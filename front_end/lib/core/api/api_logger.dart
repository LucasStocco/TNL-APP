class ApiLogger {
  static void request(String method, String url, [dynamic body]) {
    print("🌐 [$method] $url");
    if (body != null) {
      print("📦 BODY REQUEST: $body");
    }
  }

  static void response(String url, int status, dynamic body) {
    print("⬅️ [$status] $url");
    print("📦 BODY RESPONSE: $body");
  }

  static void error(String url, dynamic error, StackTrace? stack) {
    print("❌ ERROR: $url");
    print(error);
    if (stack != null) print(stack);
  }
}
