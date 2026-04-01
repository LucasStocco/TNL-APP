class User {
  final int id;
  final String nome;
  final String email;
  final String? fotoUrl;

  User({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
  });
}
