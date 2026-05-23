import 'package:crud_flutter/model/gerenciar_lista/item.dart';

/// =========================
/// REGRA: ITENS PENDENTES
/// =========================
/// Verifica se existe pelo menos
/// um item não comprado na lista.

class PendingItemsRule {
  static bool shouldNotify(List<Item> items) {
    return items.any((item) => item.comprado == false);
  }
}
