class ApiEndpoints {
  static const categorias = '/categorias';
  static const produtos = '/produtos';
  static const listas = '/listas';

  static String itens(int listaId) => '/listas/$listaId/itens';
  
  static String relatorioMaisComprados(int listaId) => '/relatorios/$listaId/mais-comprados';
  static String relatorioPorCategoria(int listaId)  => '/relatorios/$listaId/por-categoria';
  static String relatorioMaisCaros(int listaId)     => '/relatorios/$listaId/mais-caros';
  static String relatorioMaisBaratos(int listaId)   => '/relatorios/$listaId/mais-baratos';
}
