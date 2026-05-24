import 'dart:convert';
import 'package:crypto/crypto.dart';

class NotificationHash {
  static String generate(String input) {
    print("🔐 [HASH] gerando hash...");
    final bytes = utf8.encode(input);
    return sha1.convert(bytes).toString();
  }
}
