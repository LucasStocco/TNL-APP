import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/img_super_oferta.jpg',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}