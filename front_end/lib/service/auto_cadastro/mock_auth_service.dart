import 'package:crud_flutter/model/auto_cadastro/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:crud_flutter/model/auto_cadastro/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class MockAuthService implements AuthService {

  static const _keyUser = 'user';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<User?> login() async {

    // Login Google
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    // Pega token
    final GoogleSignInAuthentication auth =
        await googleUser.authentication;

    final idToken = auth.idToken;

    // Chama backend
    final response = await http.post(
      Uri.parse("http://192.168.0.10:8080/auth/google"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "idToken": idToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro no backend");
    }

    final data = jsonDecode(response.body);

    final user = User(
      id: data["id"],
      nome: data["nome"],
      email: data["email"],
      fotoUrl: data["fotoUrl"],
    );

    // salva nome localmente
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyUser, user.nome);

    return user;
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