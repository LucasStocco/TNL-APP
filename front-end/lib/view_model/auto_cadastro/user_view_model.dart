import 'package:crud_flutter/service/auto_cadastro/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crud_flutter/model/auto_cadastro/user.dart';

class UserViewModel extends ChangeNotifier {
  final AuthService _authService;

  User? user;
  bool isLoading = false;

  /// Verifica se está logado
  bool get isLogged => user != null;

  /// Construtor recebe AuthService (Mock ou real no futuro)
  UserViewModel(this._authService) {
    _init();
  }

  /// Inicializa o usuário logado, se houver
  Future<void> _init() async {
    isLoading = true;
    notifyListeners();

    user = await _authService.getCurrentUser();

    isLoading = false;
    notifyListeners();
  }

  /// =======================
  /// LOGIN
  /// =======================
  Future<void> login() async {
    isLoading = true;
    notifyListeners();

    user = await _authService.login();

    isLoading = false;
    notifyListeners();
  }

  /// =======================
  /// LOGOUT
  /// =======================
  Future<void> logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }
}
