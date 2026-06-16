class GoogleLoginRequestDTO {
  final String idToken;

  GoogleLoginRequestDTO({
    required this.idToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "idToken": idToken,
    };
  }
}