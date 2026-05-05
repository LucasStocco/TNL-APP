import 'package:intl/intl.dart';

class PriceFormatter {
  static final _formatador = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  static String format(num? valor) {
    if (valor == null) return "Sem preço";

    return _formatador.format(valor);
  }
}
