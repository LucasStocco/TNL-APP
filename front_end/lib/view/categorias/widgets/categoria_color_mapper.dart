import 'dart:ui';

import 'package:flutter/material.dart';

class CategoriaColorMapper {
  static Color cor(String codigo) {
    switch (codigo.toUpperCase()) {
      case 'BEBIDAS':
        return Colors.blue.shade200;
      case 'CARNES':
        return Colors.red.shade200;
      case 'PADARIA':
        return Colors.orange.shade200;
      case 'HORTIFRUTI':
        return Colors.green.shade200;
      case 'LATICINIOS':
        return Colors.yellow.shade200;
      case 'MERCEARIA':
        return Colors.brown.shade200;
      case 'HIGIENE':
        return Colors.pink.shade100;
      case 'LIMPEZA':
        return Colors.cyan.shade100;
      case 'PETS':
        return Colors.deepPurple.shade100;
      case 'DOCES':
        return Colors.purple.shade100;
      case 'UTILIDADES':
        return Colors.blueGrey.shade100;
      case 'BEBES':
        return Colors.teal.shade100;
      case 'SAZONAIS':
        return Colors.amber.shade200;

      default:
        return Colors.transparent;
    }
  }
}