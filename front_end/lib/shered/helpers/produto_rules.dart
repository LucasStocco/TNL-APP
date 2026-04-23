// ================= REGRA DE DOMÍNIO ==============
class ProdutoRules {
  static bool isGlobal(int? idUsuario) {
    return idUsuario == null;
  }

  static bool isOwned(int? idUsuario) {
    return idUsuario != null;
  }
}
