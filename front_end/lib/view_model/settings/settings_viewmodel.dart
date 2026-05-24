import 'package:flutter/material.dart';
import 'package:crud_flutter/service/notifications/notification_preferences_service.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  SettingsViewModel() {
    loadNotificationsPreference();
  }

  Future<void> loadNotificationsPreference() async {
    _notificationsEnabled =
        await NotificationPreferencesService.isNotificationsEnabled();

    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;

    await NotificationPreferencesService.setNotificationsEnabled(value);

    notifyListeners();
  }
}
