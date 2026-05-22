import 'package:crud_flutter/model/auto_cadastro/user.dart';

class UserResponseDTO {
  final int id;
  final String name;
  final String email;
  final String? fotoUrl;

  UserResponseDTO({
    required this.id,
    required this.name,
    required this.email,
    this.fotoUrl,
  });

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) {
    return UserResponseDTO(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      fotoUrl: json['fotoUrl'],
    );
  }

  User toModel() {
    return User(
      id: id,
      nome: name,
      email: email,
      fotoUrl: fotoUrl,
    );
  }
}