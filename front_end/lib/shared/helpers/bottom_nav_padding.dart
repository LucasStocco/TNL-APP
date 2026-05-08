import 'package:flutter/material.dart';

///  Espaçamento inferior padrão para telas com BottomNavigationBar.
///
/// Evita que o último item de listas/grids fique escondido
/// atrás da barra de navegação.
///
/// Também considera a safe area do dispositivo
/// (ex: iPhones com barra inferior).
double bottomNavPadding(BuildContext context) {
  return MediaQuery.of(context).padding.bottom + 100;
}
