import 'package:flutter/material.dart';

class AnimatedLayoutToggleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isGrid;

  const AnimatedLayoutToggleButton({
    super.key,
    required this.onPressed,
    required this.isGrid,
  });

  @override
  State<AnimatedLayoutToggleButton> createState() =>
      _AnimatedLayoutToggleButtonState();
}

class _AnimatedLayoutToggleButtonState extends State<AnimatedLayoutToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _spreadAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    // 🔥 Distância dos elementos
    _spreadAnimation = Tween<double>(
      begin: 0,
      end: 6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // ✨ Pequeno zoom
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.08,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // 🌀 Rotação suave
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleTap() {
    widget.onPressed();

    _controller.forward(from: 0).then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // =========================
  // 🔲 QUADRADOS DO GRID
  // =========================
  Widget _buildSquare({
    required double top,
    required double left,
    required double spreadX,
    required double spreadY,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: top + spreadY,
          left: left + spreadX,
          child: child!,
        );
      },
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // =========================
  // 📋 LINHAS DO MODO LISTA
  // =========================
  Widget _buildLine(double spread) {
    return Transform.translate(
      offset: Offset(spread * 0.3, 0),
      child: Container(
        width: 18,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final spread = _spreadAnimation.value;

          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox(
                width: 32,
                height: 32,

                // Troca dinâmica do ícone
                child: widget.isGrid

                    // =========================
                    // 📋 ÍCONE LISTA
                    // =========================
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLine(spread),
                          const SizedBox(height: 4),
                          _buildLine(spread),
                          const SizedBox(height: 4),
                          _buildLine(spread),
                        ],
                      )

                    // =========================
                    // 🟦 ÍCONE GRID
                    // =========================
                    : Stack(
                        children: [
                          _buildSquare(
                            top: 6,
                            left: 6,
                            spreadX: -spread,
                            spreadY: -spread,
                          ),
                          _buildSquare(
                            top: 6,
                            left: 18,
                            spreadX: spread,
                            spreadY: -spread,
                          ),
                          _buildSquare(
                            top: 18,
                            left: 6,
                            spreadX: -spread,
                            spreadY: spread,
                          ),
                          _buildSquare(
                            top: 18,
                            left: 18,
                            spreadX: spread,
                            spreadY: spread,
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
