class ApiEndpoints {
  // =========================
  // 📁 CATEGORIAS
  // =========================
  static const categorias = '/categorias';

  static String categoriaPorId(int id) => '/categorias/$id';

  static String categoriaCompleta(int id) => '/categorias/$id/completo';

  static String produtosPorCategoria(int id) => '/categorias/$id/produtos';

  static String subcategorias(int categoriaId) =>
      '/categorias/$categoriaId/subcategorias';

  static String subcategoria(
    int categoriaId,
    int subcategoriaId,
  ) =>
      '/categorias/$categoriaId/subcategorias/$subcategoriaId';

  // =========================
  // 📦 PRODUTOS
  // =========================
  static const produtos = '/produtos';

  static String produtoPorId(int id) => '/produtos/$id';

  // =========================
  // 🛒 LISTAS
  // =========================
  static const listas = '/listas';

  static String listaPorId(int id) => '/listas/$id';

  static String listasResumo = '/listas/resumo';

  // =========================
  // 🧾 ITENS
  // =========================
  static String itens(int listaId) => '/listas/$listaId/itens';

  static String itemPorId(int listaId, int itemId) =>
      '/listas/$listaId/itens/$itemId';

  static String itemComprado(int listaId, int itemId) =>
      '/listas/$listaId/itens/$itemId/comprado';

  static String itemDesmarcar(int listaId, int itemId) =>
      '/listas/$listaId/itens/$itemId/desmarcar';
}
