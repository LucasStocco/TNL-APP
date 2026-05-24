import 'package:shared_preferences/shared_preferences.dart';

class NotificationDedup {
  static const _key = 'last_notification_hash';

  static Future<bool> isDuplicate(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_key);

    return last == hash;
  }

  static Future<void> save(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, hash);
  }
}
