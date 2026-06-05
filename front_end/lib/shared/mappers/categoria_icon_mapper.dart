class CategoriaIconMapper {
  CategoriaIconMapper._();

  static String icone({
    required String codigo,
    required bool isUsuario,
  }) {
    // 🔥 normalização mais segura
    final c = _normalizar(codigo);

    // categoria do usuário
    if (isUsuario) {
      return "assets/icons/categorias/ic_estrela.png";
    }

    switch (c) {
      case 'BEBIDAS':
        return "assets/icons/categorias/ic_bebidas.png";

      case 'CARNES':
        return "assets/icons/categorias/ic_acougue.png";

      case 'PADARIA':
        return "assets/icons/categorias/ic_padaria.png";

      case 'HORTIFRUTI':
        return "assets/icons/categorias/ic_hortifrut.png";

      case 'LATICINIOS':
        return "assets/icons/categorias/ic_laticinios.png";

      case 'MERCEARIA':
        return "assets/icons/categorias/ic_mercearia.png";

      case 'HIGIENE':
        return "assets/icons/categorias/ic_higiene.png";

      case 'LIMPEZA':
        return "assets/icons/categorias/ic_limpeza.png";

      case 'PETS':
        return "assets/icons/categorias/ic_pets.png";

      case 'DOCES':
        return "assets/icons/categorias/ic_doces.png";

      case 'UTILIDADES':
        return "assets/icons/categorias/ic_custom_category.png";

      case 'BEBES':
        return "assets/icons/categorias/ic_bebes.png";

      case 'SAZONAIS':
        return "assets/icons/categorias/ic_sazonais.png";

      default:
        return "assets/icons/categorias/ic_estrela.png";
    }
  }

  // 🔥 função de normalização robusta
  static String _normalizar(String value) {
    return value
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'\s+'), '') // remove qualquer espaço (1 ou vários)
        .replaceAll(RegExp(r'[^A-Z0-9_]'), ''); // remove caracteres inválidos
  }
}
