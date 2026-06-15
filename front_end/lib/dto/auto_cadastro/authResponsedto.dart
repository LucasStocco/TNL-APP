import 'package:crud_flutter/dto/auto_cadastro/user_response_dto.dart';

class AuthResponseDTO {
  final UserResponseDTO usuario;
  final String token;

  AuthResponseDTO({
    required this.usuario,
    required this.token,
  });

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) {
    return AuthResponseDTO(
      usuario: UserResponseDTO.fromJson(json['usuario']),
      token: json['token'],
    );
  }
}