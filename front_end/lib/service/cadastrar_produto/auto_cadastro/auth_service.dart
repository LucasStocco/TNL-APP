import 'package:crud_flutter/model/auto_cadastro/user.dart';

abstract class AuthService {
  Future<User?> login();
  Future<void> logout();
  Future<User?> getCurrentUser(); // novo método para persistência
}
