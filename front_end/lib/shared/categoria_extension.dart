import '../../model/cadastrar_categoria/categoria.dart';

extension CategoriaExtension on Categoria {
  String get codigoSeguro => (codigo ?? '').toUpperCase();

  bool get isPadrao {
    const categoriasPadrao = [
      'BEBIDAS',
      'CARNES',
      'PADARIA',
      'HORTIFRUTI',
      'LATICINIOS',
      'MERCEARIA',
      'HIGIENE',
      'LIMPEZA',
      'PETS',
      'DOCES',
      'UTILIDADES',
      'BEBES',
      'SAZONAIS',
    ];

    return categoriasPadrao.contains(codigoSeguro);
  }
}
