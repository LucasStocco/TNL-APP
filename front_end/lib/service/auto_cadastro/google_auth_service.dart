import 'dart:convert';

import 'package:crud_flutter/model/auto_cadastro/user.dart';
import 'package:crud_flutter/service/auto_cadastro/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crud_flutter/dto/auto_cadastro/user_response_dto.dart';
import 'package:crud_flutter/dto/auto_cadastro/google_login_request_dto.dart';
import 'package:crud_flutter/core/api/api_config.dart';

class GoogleAuthService implements AuthService {
  static const _keyUser = 'user';
  static const _keyToken = 'token';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '605363260040-q8s2e93017d9786n152lk4ufhm9gsibc.apps.googleusercontent.com',
  );

 @override
Future<User?> login() async {
  try {
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();

    if (googleUser == null) return null;

    final auth = await googleUser.authentication;

    final idToken = auth.idToken;

    if (idToken == null) {
      throw Exception("ID token nulo");
    }

    final requestDTO = GoogleLoginRequestDTO(idToken: idToken);

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/auth/google"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestDTO.toJson()),
    );

    print("STATUS BACKEND: ${response.statusCode}");
    print("BODY BACKEND: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Erro no backend");
    }

    final data = jsonDecode(response.body);

    if (data is! Map<String, dynamic>) {
      throw Exception("Resposta inválida");
    }

    final usuarioJson = data['usuario'];
    final token = data['token'];

    if (usuarioJson == null || token == null) {
      throw Exception("Dados incompletos do backend");
    }

    final dto = UserResponseDTO.fromJson(usuarioJson);
    final user = dto.toModel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(usuarioJson));
    await prefs.setString('token', token);

    return user;
  } catch (e) {
    print("ERRO GOOGLE LOGIN:");
    print(e);
    rethrow;
  }
}

@override
Future<void> logout() async {
  await _googleSignIn.signOut();

  final prefs = await SharedPreferences.getInstance();

  await Future.wait([
    prefs.remove(_keyUser),
    prefs.remove(_keyToken),
  ]);
}

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = prefs.getString(_keyUser);
    final token = prefs.getString(_keyToken);

    if (userJson == null || token == null) {
      return null;
    }

    final data = jsonDecode(userJson);

    if (data is! Map<String, dynamic>) {
      return null;
    }

    final dto = UserResponseDTO.fromJson(data);
    return dto.toModel();
  }
}
  