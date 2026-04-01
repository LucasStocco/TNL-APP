// helpers de ícones: O helper vai ser uma classe estática que retorna o caminho do ícone com base no id da categoria.
class CategoriaHelper {
  CategoriaHelper._(); // Construtor privado

  static String iconeParaCategoria(int id) {
    switch (id) {
      case 1:
        return "assets/icons/ic_bebidas.png";
      case 2:
        return "assets/icons/ic_acougue.png";
      case 3:
        return "assets/icons/ic_padaria.png";
      case 4:
        return "assets/icons/ic_hortifrut.png";
      case 5:
        return "assets/icons/ic_laticinios.png";
      case 6:
        return "assets/icons/ic_mercearia.png";
      case 7:
        return "assets/icons/ic_higiene.png";
      case 8:
        return "assets/icons/ic_limpeza.png";
      case 9:
        return "assets/icons/ic_pets.png";
      case 10:
        return "assets/icons/ic_sazonais.png";
      case 11:
        return "assets/icons/ic_bebes.png";
      case 12:
        return "assets/icons/ic_outros.png";
      default:
        return "assets/icons/ic_outros.png";
    }
  }
}

// Um helper é uma classe ou arquivo separado que serve para funções utilitárias, ou seja, tarefas que não pertencem a nenhuma classe de modelo ou ViewModel, mas que são usadas em várias partes do app.
// No nosso caso, o CategoriaHelper tem a função retornar o caminho do ícone com base no id da categoria.
