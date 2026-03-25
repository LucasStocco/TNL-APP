import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/home_screen.dart';

import 'view_model/categoria_view_model.dart';
import 'view_model/lista_view_model.dart';
import 'view_model/produto_view_model.dart';
import 'view_model/item_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriaViewModel()),
        ChangeNotifierProvider(create: (_) => ListaViewModel()),
        ChangeNotifierProvider(create: (_) => ProdutoViewModel()),
        ChangeNotifierProvider(create: (_) => ItemViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista de Compras',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    ),
  );
}
