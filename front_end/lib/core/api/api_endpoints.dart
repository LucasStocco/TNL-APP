class ApiEndpoints {
  static const categorias = '/categorias';
  static String categoriaPorId(int id) => '/categorias/$id';
  static String categoriaCompleta(int id) => '/categorias/$id/completo';
  static String produtosPorCategoria(int id) => '/categorias/$id/produtos';

  static const String resumo = "/listas/resumo";

  static String subcategorias(int categoriaId) =>
      '/categorias/$categoriaId/subcategorias';

  static String subcategoria(
    int categoriaId,
    int subcategoriaId,
  ) =>
      '/categorias/$categoriaId/subcategorias/$subcategoriaId';

  static const produtos = '/produtos';
  static String produtoPorId(int id) => '/produtos/$id';

  static const listas = '/listas';
  static String listaPorId(int id) => '/listas/$id';
  static String listasResumo = '/listas/resumo';

  static String itens(int listaId) => '/listas/$listaId/itens';
  static String itemPorId(int listaId, int itemId) => '/listas/$listaId/itens/$itemId';
  static String itemComprado(int listaId, int itemId) => '/listas/$listaId/itens/$itemId/comprado';
  static String itemDesmarcar(int listaId, int itemId) => '/listas/$listaId/itens/$itemId/desmarcar';

  static String relatorioMaisComprados(int listaId) => '/relatorios/$listaId/mais-comprados';
  static String relatorioPorCategoria(int listaId) => '/relatorios/$listaId/por-categoria';
  static String relatorioMaisCaros(int listaId) => '/relatorios/$listaId/mais-caros';
  static String relatorioMaisBaratos(int listaId) => '/relatorios/$listaId/mais-baratos';
}