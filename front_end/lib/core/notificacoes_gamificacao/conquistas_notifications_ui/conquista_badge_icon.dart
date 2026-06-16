import 'package:flutter/material.dart';

class ConquistaBadgeIcon extends StatefulWidget {
  const ConquistaBadgeIcon({super.key});

  @override
  State<ConquistaBadgeIcon> createState() => _ConquistaBadgeIconState();
}

class _ConquistaBadgeIconState extends State<ConquistaBadgeIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _scale;
  late final Animation<double> _starRotation;
  late final Animation<double> _starOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 20,
      ),
    ]).animate(_controller);

    _starRotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.45,
          0.75,
          curve: Curves.easeOut,
        ),
      ),
    );

    _starOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0, end: 1),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1, end: 0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0),
        weight: 25,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. LADO ESQUERDO (ILUMINADO)
            const Center(
              child: Icon(
                Icons.emoji_events,
                color: Color(0xFFFBC02D),
                size: 40,
              ),
            ),

            // 2. LADO DIREITO (SOMBRA PLANA)
            Center(
              child: ClipRect(
                clipper: _HalfClipper(),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFF57C00),
                  size: 40,
                ),
              ),
            ),

            // 3. EFEITO DA ESTRELA
            Positioned(
              top: -6,
              right: -2,
              child: FadeTransition(
                opacity: _starOpacity,
                child: RotationTransition(
                  turns: _starRotation,
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A CLASSE CLIPPER DEVE FICAR AQUI FORA
class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      size.width / 2,
      0,
      size.width / 2,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
