import 'package:crud_flutter/model/auto_cadastro/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  static const _keyUser = 'user';

  @override
  Future<User?> login() async {
    await Future.delayed(const Duration(seconds: 1));

    final user = User(
      id: 1,
      nome: 'Lucas',
      email: 'lucas@email.com',
      fotoUrl: null,
    );

    // salva no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, user.nome);

    return user;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString(_keyUser);

    if (nome != null) {
      return User(
        id: 1,
        nome: nome,
        email: 'lucas@email.com',
        fotoUrl: null,
      );
    }

    return null;
  }
}
