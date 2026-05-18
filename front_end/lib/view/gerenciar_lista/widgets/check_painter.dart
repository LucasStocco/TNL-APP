// Desenho do check para itens marcados como comprados
import 'package:flutter/material.dart';

class CheckPainter extends CustomPainter {
  final Animation<double> animation;

  CheckPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // ✔ ponto inicial (esquerda)
    path.moveTo(size.width * 0.15, size.height * 0.55);

    // ✔ descendo (curto)
    path.lineTo(size.width * 0.42, size.height * 0.78);

    // ✔ subindo (direita)
    path.lineTo(size.width * 0.85, size.height * 0.25);

    final metrics = path.computeMetrics().first;

    final extractPath = metrics.extractPath(
      0.0,
      metrics.length * animation.value,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
