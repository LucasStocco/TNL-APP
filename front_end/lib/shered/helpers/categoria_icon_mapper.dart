class CategoriaIconMapper {
  CategoriaIconMapper._();

  static String icone({
    required String codigo,
    required bool isUsuario,
  }) {
    // CATEGORIA CRIADA PELO USUÁRIO
    if (isUsuario) {
      return "assets/icons/ic_estrela.png";
    }

    // CATEGORIAS DO SISTEMA (GLOBAIS)
    switch (codigo.toUpperCase()) {
      case 'BEBIDAS':
        return "assets/icons/ic_bebidas.png";

      case 'CARNES':
        return "assets/icons/ic_acougue.png";

      case 'PADARIA':
        return "assets/icons/ic_padaria.png";

      case 'HORTIFRUTI':
        return "assets/icons/ic_hortifrut.png";

      case 'LATICINIOS':
        return "assets/icons/ic_laticinios.png";

      case 'MERCEARIA':
        return "assets/icons/ic_mercearia.png";

      case 'HIGIENE':
        return "assets/icons/ic_higiene.png";

      case 'LIMPEZA':
        return "assets/icons/ic_limpeza.png";

      case 'PETS':
        return "assets/icons/ic_pets.png";

      case 'DOCES':
        return "assets/icons/ic_doces.png";

      case 'UTILIDADES':
        return "assets/icons/ic_custom_category.png";

      case 'BEBES':
        return "assets/icons/ic_bebes.png";

      case 'SAZONAIS':
        return "assets/icons/ic_sazonais.png";

      default:
        return "assets/icons/ic_estrela.png";
    }
  }
}
