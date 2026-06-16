import 'package:flutter/material.dart';

class ConquistaNotificationAnimator extends StatefulWidget {
  final Widget child;
  final VoidCallback onFinish;

  const ConquistaNotificationAnimator({
    super.key,
    required this.child,
    required this.onFinish,
  });

  @override
  State<ConquistaNotificationAnimator> createState() =>
      _ConquistaNotificationAnimatorState();
}

class _ConquistaNotificationAnimatorState
    extends State<ConquistaNotificationAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _fecharAutomaticamente();
  }

  Future<void> _fecharAutomaticamente() async {
    // ⏱ tempo visível da conquista
    await Future.delayed(
      const Duration(seconds: 5),
    );

    if (!mounted) return;

    await _controller.reverse();

    if (mounted) {
      widget.onFinish();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: widget.child,
      ),
    );
  }
}
