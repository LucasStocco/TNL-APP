import 'package:flutter/material.dart';

class ListaLoading extends StatelessWidget {
  const ListaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}