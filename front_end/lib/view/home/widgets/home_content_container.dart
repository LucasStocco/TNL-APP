/*
Responsável por:
- Container branco com bordas arredondadas que envolve o conteúdo da home
- Corousel
- contepudo da home
*/
import 'package:flutter/material.dart';

class HomeContentContainer extends StatelessWidget {
  final Widget child;

  const HomeContentContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      clipBehavior: Clip.antiAlias, // 🔥 ESSENCIAL
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: child,
      ),
    );
  }
}
