import 'package:flutter/material.dart';

class AnimatedDisabledSection extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const AnimatedDisabledSection({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      opacity: enabled ? 1.0 : 0.45,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: !enabled,
          child: ColorFiltered(
            colorFilter: enabled
                ? const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  )
                : const ColorFilter.matrix([
                    0.9,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.9,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0.9,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ]),
            child: child,
          ),
        ),
      ),
    );
  }
}
