// Widget de check animado, usado em ListaItemTile
import 'package:crud_flutter/view/gerenciar_lista/widgets/check_painter.dart';
import 'package:flutter/material.dart';

class AnimatedCheck extends StatefulWidget {
  final bool isChecked;

  const AnimatedCheck({
    super.key,
    required this.isChecked,
  });

  @override
  State<AnimatedCheck> createState() => AnimatedCheckState();
}

class AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // estado inicial
    if (widget.isChecked) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCheck oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isChecked && !oldWidget.isChecked) {
      _controller.forward(from: 0);
    } else if (!widget.isChecked && oldWidget.isChecked) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: CheckPainter(_controller),
    );
  }
}
