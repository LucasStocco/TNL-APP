import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const String notificationsKey = 'notifications_enabled';

  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  SettingsViewModel() {
    loadNotificationsPreference();
  }

  /// CARREGAR PREFERÊNCIA
  Future<void> loadNotificationsPreference() async {
    final prefs = await SharedPreferences.getInstance();

    _notificationsEnabled = prefs.getBool(notificationsKey) ?? true;

    notifyListeners();
  }

  /// ALTERAR + SALVAR
  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      notificationsKey,
      value,
    );

    notifyListeners();
  }
}
