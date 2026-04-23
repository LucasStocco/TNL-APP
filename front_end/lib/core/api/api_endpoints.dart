class ApiEndpoints {
  static const categorias = '/categorias';
  static const produtos = '/produtos';
  static const listas = '/listas';

  static String itens(int listaId) => '/listas/$listaId/itens';
}
