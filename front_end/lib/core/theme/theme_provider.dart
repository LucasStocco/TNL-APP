import 'package:flutter/material.dart';

/// Herança de ChangeNotifier
/// Essa classe pode avisar outras partes do app quando alguma informação mudar
class ThemeProvider extends ChangeNotifier {
  /// guarda o tema atual (claro ou escuro).
  ThemeMode _themeMode = ThemeMode.light;

  /// permite que outros widgets leiam o tema atual.
  ThemeMode get themeMode => _themeMode;

  /// retorna true se o tema for escuro.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// troca entre claro e escuro.
  void toggleTheme() {
  print("TROCANDO TEMA");

  _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

  print(_themeMode);

    /// avisa o Flutter que o tema mudou e faz as telas que usam esse provider se atualizarem automaticamente
    notifyListeners();
  }
}
