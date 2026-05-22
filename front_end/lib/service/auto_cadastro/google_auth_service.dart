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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'profile',
  ],
  serverClientId:
      '605363260040-q8s2e93017d9786n152lk4ufhm9gsibc.apps.googleusercontent.com',
);

  @override
  Future<User?> login() async {

    try {

      // LOGIN GOOGLE
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      print("googleUser: $googleUser");

      if (googleUser == null) {
        print("Usuário cancelou login");
        return null;
      }

      // TOKEN GOOGLE
      final GoogleSignInAuthentication auth =
          await googleUser.authentication;

      print("ID TOKEN: ${auth.idToken}");

      final idToken = auth.idToken;


            // DTO REQUEST
      final requestDTO = GoogleLoginRequestDTO(
        idToken: idToken!,
      );
//
//
//    TROCAR O IP COM BASE NO DISPOSITIVO QUE VAI ACESSAR O BAGULHO, 
//POR EXEMPLO O IP ABAIXO É DO MEU CELULAR, ACREDITO QUE IRA MUDAR QUANTO FOR NA WEB, AI SERIA O IP DA INSTÂNCIA
//
//
      // CHAMADA BACKEND
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/auth/google"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestDTO.toJson()),
      );

      print("STATUS BACKEND: ${response.statusCode}");
      print("BODY BACKEND: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Erro no backend");
      }

  
      final data = jsonDecode(response.body);

      final dto = UserResponseDTO.fromJson(data);

      final user = dto.toModel();

      // SALVA LOCALMENTE
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_keyUser, user.nome);

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

    await prefs.remove(_keyUser);
  }

  @override
  Future<User?> getCurrentUser() async {

    final currentUser =
        await _googleSignIn.signInSilently();

    if (currentUser == null) {
      return null;
    }

    return User(
      id: 1,
      nome: currentUser.displayName ?? "",
      email: currentUser.email,
      fotoUrl: currentUser.photoUrl,
    );
  }
}