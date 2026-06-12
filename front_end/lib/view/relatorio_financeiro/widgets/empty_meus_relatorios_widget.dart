'package:flutter/material.dart';

class EmptyMeusRelatoriosWidget extends StatefulWidget {
  const EmptyMeusRelatoriosWidget({super.key});

  @override
  State<EmptyMeusRelatoriosWidget> createState() =>
      _EmptyMeusRelatoriosWidgetState();
}

class _EmptyMeusRelatoriosWidgetState extends State<EmptyMeusRelatoriosWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height * 0.25;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Image.asset(
                "assets/images/squirrel_empty_lists.png",
                height: size,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Você ainda não possui listas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Crie sua primeira lista para visualizar seus relatorios financeiros",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}


