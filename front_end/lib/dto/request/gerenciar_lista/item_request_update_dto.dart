class ItemUpdateDTO {
  final int quantidade;
  final double preco;

  ItemUpdateDTO({
    required this.quantidade,
    required this.preco,
  });

  Map<String, dynamic> toJson() => {
        "quantidade": quantidade,
        "preco": preco,
      };
}
